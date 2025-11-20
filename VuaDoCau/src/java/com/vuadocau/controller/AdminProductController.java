package com.vuadocau.controller;

import com.vuadocau.dao.ActivityLogDAO;
import com.vuadocau.dao.ProductDAO;
import com.vuadocau.dao.CategoryDAO;
import com.vuadocau.dao.BrandDAO;
import com.vuadocau.model.Product;
import com.vuadocau.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "AdminProductController", urlPatterns = {"/admin/products"})
public class AdminProductController extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final BrandDAO brandDAO = new BrandDAO();
    private final ActivityLogDAO actDAO = new ActivityLogDAO();

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        if (s == null) return false;
        Object o = s.getAttribute("authUser");
        return (o instanceof User) && ((User) o).getRoleId() == 1;
    }

    private Integer tryParseInt(String s) {
        try {
            return (s == null || s.isBlank()) ? null : Integer.parseInt(s.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private BigDecimal tryParseDecimal(String s) {
        try {
            if (s == null || s.isBlank()) return BigDecimal.ZERO;
            return new BigDecimal(s.replace(",", "").trim());
        } catch (Exception e) {
            return BigDecimal.ZERO;
        }
    }

    private BigDecimal tryParseNullableDecimal(String s) {
        try {
            if (s == null || s.isBlank()) return null;
            return new BigDecimal(s.replace(",", "").trim());
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        User admin = (User) req.getSession().getAttribute("authUser");

        String action = req.getParameter("action");
        if ("detail".equals(action)) {
            Integer id = tryParseInt(req.getParameter("id"));
            if (id == null) {
                req.getSession().setAttribute("flash_error", "Thiếu mã sản phẩm.");
                resp.sendRedirect(req.getContextPath() + "/admin/products");
                return;
            }
            Product p = productDAO.findById(id);
            if (p == null) {
                req.getSession().setAttribute("flash_error", "Không tìm thấy sản phẩm #" + id);
                resp.sendRedirect(req.getContextPath() + "/admin/products");
                return;
            }

            req.setAttribute("p", p);
            req.setAttribute("categories", categoryDAO.findAll());
            req.setAttribute("brands", brandDAO.findAll());
            req.setAttribute("view", "/WEB-INF/views/admin/product-detail.jsp");
            req.setAttribute("pageTitle", "Quản trị · Sản phẩm · #" + id);
            req.getRequestDispatcher("/WEB-INF/views/_layout/main.jsp").forward(req, resp);
            return;
        }

        // ============ Danh sách + filter + sort ============
        String q = req.getParameter("q");
        Integer cat = tryParseInt(req.getParameter("cat"));

        String sort = req.getParameter("sort");
        String dir = req.getParameter("dir");
        if (sort == null) sort = "id";
        if (dir == null) dir = "desc";

        switch (sort) {
            case "id":
            case "name":
            case "price":
            case "oldPrice":
            case "stock":
            case "rating":
            case "purchased":
                break;
            default:
                sort = "id";
        }
        dir = "asc".equalsIgnoreCase(dir) ? "asc" : "desc";

        List<Product> products = productDAO.adminSearch(q, cat, sort, dir);

        // LOG: lọc sản phẩm (chống trùng 2 giây)
        try {
            if (admin != null) {
                String msg = String.format(
                        "Lọc sản phẩm: q='%s', cat=%s, sort='%s', dir='%s', count=%d",
                        q == null ? "" : q,
                        cat == null ? "null" : String.valueOf(cat),
                        sort, dir,
                        (products == null ? 0 : products.size())
                );
                actDAO.logOnce(req, admin, "PRODUCT_LIST", msg, 2000);
            }
        } catch (Exception ignore) {
        }

        req.setAttribute("products", products);
        req.setAttribute("categories", categoryDAO.findAll());
        req.setAttribute("brands", brandDAO.findAll());
        req.setAttribute("q", q);
        req.setAttribute("cat", cat);
        req.setAttribute("sort", sort);
        req.setAttribute("dir", dir);
        req.setAttribute("view", "/WEB-INF/views/admin/products.jsp");
        req.setAttribute("pageTitle", "Quản trị · Sản phẩm");
        req.getRequestDispatcher("/WEB-INF/views/_layout/main.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        User admin = (User) req.getSession().getAttribute("authUser");

        try {
            // ===== CREATE / UPDATE =====
            if ("create".equalsIgnoreCase(action) || "update".equalsIgnoreCase(action)) {
                Product p = new Product();
                if ("update".equalsIgnoreCase(action)) {
                    Integer id = tryParseInt(req.getParameter("id"));
                    if (id == null)
                        throw new IllegalArgumentException("Thiếu mã sản phẩm để cập nhật");
                    p.setId(id);
                }

                p.setName(req.getParameter("name"));

                // BẮT BUỘC phải có categoryId, không default về 0 nữa (tránh lỗi FK)
                Integer catId = tryParseInt(req.getParameter("categoryId"));
                if (catId == null) {
                    throw new IllegalArgumentException("Thiếu danh mục sản phẩm.");
                }
                p.setCategoryId(catId);

                // brandId lấy từ dropdown, có thể null
                p.setBrandId(tryParseInt(req.getParameter("brandId")));
                p.setPrice(tryParseDecimal(req.getParameter("price")));
                p.setOldPrice(tryParseNullableDecimal(req.getParameter("oldPrice")));
                p.setImage(req.getParameter("image"));
                p.setDescription(req.getParameter("description"));

                Integer stock = tryParseInt(req.getParameter("stock"));
                p.setStock(stock == null ? 0 : stock);

                try {
                    String r = req.getParameter("rating");
                    p.setRating((r == null || r.isBlank()) ? 0 : Double.parseDouble(r));
                } catch (Exception ignore) {
                    p.setRating(0);
                }

                Integer purchased = tryParseInt(req.getParameter("purchased"));
                p.setPurchased(purchased == null ? 0 : purchased);

                boolean ok = "create".equalsIgnoreCase(action)
                        ? productDAO.insert(p)
                        : productDAO.update(p);

                if (ok) {
                    req.getSession().setAttribute(
                            "flash_success",
                            ("create".equalsIgnoreCase(action) ? "Đã thêm" : "Đã cập nhật")
                                    + " sản phẩm thành công."
                    );
                    if (admin != null) {
                        try {
                            String type = "create".equalsIgnoreCase(action)
                                    ? "PRODUCT_CREATE"
                                    : "PRODUCT_UPDATE";
                            String msg = ("create".equalsIgnoreCase(action)
                                    ? "Thêm"
                                    : "Cập nhật") + " SP: " + p.getName();
                            actDAO.log(req, admin, type, msg);
                        } catch (Exception ignore) {
                        }
                    }
                } else {
                    req.getSession().setAttribute("flash_error", "Thao tác không thành công.");
                }

                resp.sendRedirect(req.getContextPath() + "/admin/products");
                return;
            }

            // ===== DELETE =====
            if ("delete".equalsIgnoreCase(action)) {
                Integer id = tryParseInt(req.getParameter("id"));
                if (id == null) throw new IllegalArgumentException("Thiếu mã sản phẩm để xóa");

                boolean ok = productDAO.delete(id);
                if (ok) {
                    req.getSession().setAttribute("flash_success", "Đã xóa sản phẩm #" + id);
                    if (admin != null)
                        actDAO.log(req, admin, "PRODUCT_DELETE", "Xóa sản phẩm #" + id);
                } else {
                    req.getSession().setAttribute("flash_error", "Không thể xóa sản phẩm #" + id);
                }

                resp.sendRedirect(req.getContextPath() + "/admin/products");
                return;
            }

            // ===== ACTION KHÁC =====
            req.getSession().setAttribute("flash_error", "Action không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/admin/products");

        } catch (Exception e) {
            e.printStackTrace();
            if (admin != null) {
                try {
                    actDAO.log(req, admin, "ERROR",
                            "AdminProductController: " + e.getMessage());
                } catch (Exception ignore) {
                }
            }
            req.getSession().setAttribute("flash_error", "Lỗi: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/admin/products");
        }
    }
}

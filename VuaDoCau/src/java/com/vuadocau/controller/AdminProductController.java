package com.vuadocau.controller;

import com.vuadocau.dao.ProductDAO;
import com.vuadocau.dao.CategoryDAO;
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

    /* ===== helpers ===== */

    private boolean isAdmin(HttpServletRequest req){
        HttpSession s = req.getSession(false);
        if (s == null) return false;
        Object o = s.getAttribute("authUser");
        return (o instanceof User) && ((User) o).getRoleId() == 1;
    }

    private Integer tryParseInt(String s){
        try { return (s == null || s.isBlank()) ? null : Integer.parseInt(s.trim()); }
        catch (Exception e){ return null; }
    }

    private BigDecimal tryParseDecimal(String s){
        try {
            if (s == null || s.isBlank()) return BigDecimal.ZERO;
            // loại dấu phẩy/thousand separator nếu người dùng gõ
            return new BigDecimal(s.replace(",", "").trim());
        } catch (Exception e){
            return BigDecimal.ZERO;
        }
    }

    /* ===== GET: list + detail ===== */

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) { resp.sendRedirect(req.getContextPath()+"/home"); return; }

        String action = req.getParameter("action");
        if ("detail".equals(action)) {
            // xem chi tiết sản phẩm
            Integer id = tryParseInt(req.getParameter("id"));
            if (id == null) {
                req.getSession().setAttribute("flash_error", "Thiếu mã sản phẩm.");
                resp.sendRedirect(req.getContextPath()+"/admin/products");
                return;
            }
            Product p = productDAO.findById(id);
            if (p == null) {
                req.getSession().setAttribute("flash_error", "Không tìm thấy sản phẩm #" + id);
                resp.sendRedirect(req.getContextPath()+"/admin/products");
                return;
            }
            req.setAttribute("p", p);
            req.getRequestDispatcher("/WEB-INF/views/admin/product-detail.jsp").forward(req, resp);
            return;
        }

        // danh sách + filter
        String q = req.getParameter("q");
        Integer cat = tryParseInt(req.getParameter("cat"));

        List<Product> products;
        if (q != null && !q.isBlank()) {
            products = productDAO.search(q.trim());
        } else if (cat != null) {
            products = productDAO.findByCategory(cat);
        } else {
            products = productDAO.findAll();
        }

        req.setAttribute("products", products);
        req.setAttribute("categories", categoryDAO.findAll());
        req.setAttribute("q", q);
        req.setAttribute("cat", cat);

        req.getRequestDispatcher("/WEB-INF/views/admin/products.jsp").forward(req, resp);
    }

    /* ===== POST: create / update / delete ===== */

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) { resp.sendRedirect(req.getContextPath()+"/home"); return; }

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        try {
            if ("create".equalsIgnoreCase(action) || "update".equalsIgnoreCase(action)) {
                Product p = new Product();

                if ("update".equalsIgnoreCase(action)) {
                    Integer id = tryParseInt(req.getParameter("id"));
                    if (id == null) throw new IllegalArgumentException("Thiếu mã sản phẩm để cập nhật");
                    p.setId(id);
                }

                p.setName(req.getParameter("name"));
                p.setCategoryId(tryParseInt(req.getParameter("categoryId")) == null ? 0
                        : tryParseInt(req.getParameter("categoryId")));
                Integer brandId = tryParseInt(req.getParameter("brandId"));
                p.setBrandId(brandId); // có thể null
                p.setPrice(tryParseDecimal(req.getParameter("price")));
                p.setImage(req.getParameter("image"));
                p.setDescription(req.getParameter("description"));
                p.setStock(tryParseInt(req.getParameter("stock")) == null ? 0
                        : tryParseInt(req.getParameter("stock")));
                try {
                    String r = req.getParameter("rating");
                    p.setRating((r == null || r.isBlank()) ? 0 : Double.parseDouble(r));
                } catch (Exception ignore) { p.setRating(0); }
                p.setPurchased(tryParseInt(req.getParameter("purchased")) == null ? 0
                        : tryParseInt(req.getParameter("purchased")));

                boolean ok = "create".equalsIgnoreCase(action) ? productDAO.insert(p) : productDAO.update(p);
                if (ok) req.getSession().setAttribute("flash_success",
                        ("create".equalsIgnoreCase(action) ? "Đã thêm" : "Đã cập nhật") + " sản phẩm thành công.");
                else    req.getSession().setAttribute("flash_error", "Thao tác không thành công.");
                resp.sendRedirect(req.getContextPath()+"/admin/products");
                return;
            }

            if ("delete".equalsIgnoreCase(action)) {
                Integer id = tryParseInt(req.getParameter("id"));
                if (id == null) throw new IllegalArgumentException("Thiếu mã sản phẩm để xóa");
                boolean ok = productDAO.delete(id);
                if (ok) req.getSession().setAttribute("flash_success", "Đã xóa sản phẩm #" + id);
                else    req.getSession().setAttribute("flash_error", "Không thể xóa sản phẩm #" + id);
                resp.sendRedirect(req.getContextPath()+"/admin/products");
                return;
            }

            // không khớp action
            req.getSession().setAttribute("flash_error", "Action không hợp lệ.");
            resp.sendRedirect(req.getContextPath()+"/admin/products");

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("flash_error", "Lỗi: " + e.getMessage());
            resp.sendRedirect(req.getContextPath()+"/admin/products");
        }
    }
}
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
            return new BigDecimal(s.replace(",", "").trim());
        } catch (Exception e){
            return BigDecimal.ZERO;
        }
    }

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) { resp.sendRedirect(req.getContextPath()+"/home"); return; }

        String action = req.getParameter("action");
        if ("detail".equals(action)) {
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
            req.setAttribute("categories", categoryDAO.findAll());
            req.setAttribute("view", "/WEB-INF/views/admin/product-detail.jsp");
            req.setAttribute("pageTitle", "Quản trị · Sản phẩm · #" + id);
            req.getRequestDispatcher("/WEB-INF/views/_layout/main.jsp").forward(req, resp);
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
        req.setAttribute("view", "/WEB-INF/views/admin/products.jsp");
        req.setAttribute("pageTitle", "Quản trị · Sản phẩm");
        req.getRequestDispatcher("/WEB-INF/views/_layout/main.jsp").forward(req, resp);
    }

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
                Integer catId = tryParseInt(req.getParameter("categoryId"));
                p.setCategoryId(catId == null ? 0 : catId);
                p.setBrandId(tryParseInt(req.getParameter("brandId")));
                p.setPrice(tryParseDecimal(req.getParameter("price")));
                p.setImage(req.getParameter("image"));
                p.setDescription(req.getParameter("description"));
                Integer stock = tryParseInt(req.getParameter("stock"));
                p.setStock(stock == null ? 0 : stock);
                try {
                    String r = req.getParameter("rating");
                    p.setRating((r == null || r.isBlank()) ? 0 : Double.parseDouble(r));
                } catch (Exception ignore) { p.setRating(0); }
                Integer purchased = tryParseInt(req.getParameter("purchased"));
                p.setPurchased(purchased == null ? 0 : purchased);

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

            req.getSession().setAttribute("flash_error", "Action không hợp lệ.");
            resp.sendRedirect(req.getContextPath()+"/admin/products");

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("flash_error", "Lỗi: " + e.getMessage());
            resp.sendRedirect(req.getContextPath()+"/admin/products");
        }
    }
}
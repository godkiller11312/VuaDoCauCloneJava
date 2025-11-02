package com.vuadocau.controller;

import com.vuadocau.dao.CategoryDAO;
import com.vuadocau.dao.ProductDAO;
import com.vuadocau.model.Category;
import com.vuadocau.model.Product;
import com.vuadocau.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name="AdminProductController", urlPatterns={"/admin/products"})
public class AdminProductController extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    private boolean isAdmin(HttpServletRequest req){
        HttpSession s = req.getSession(false);
        if (s == null) return false;
        Object o = s.getAttribute("authUser");
        return (o instanceof User) && ((User) o).getRoleId() == 1;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        String q = req.getParameter("q");
        String catStr = req.getParameter("cat");
        Integer cat = (catStr == null || catStr.isEmpty()) ? null : Integer.valueOf(catStr);

        List<Product> products;
        if (q != null && !q.isBlank()) {
            products = productDAO.search(q.trim());
        } else if (cat != null) {
            products = productDAO.findByCategory(cat);
        } else {
            products = productDAO.findAll();
        }

        List<Category> cats = categoryDAO.findAll();

        req.setAttribute("products", products);
        req.setAttribute("categories", cats);
        req.setAttribute("q", q);
        req.setAttribute("cat", cat);

        req.getRequestDispatcher("/WEB-INF/views/admin/products.jsp").forward(req, resp);
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

        try {
            if ("create".equals(action)) {
                Product p = bindProduct(req, false);
                productDAO.insert(p);
                req.getSession().setAttribute("flash_success", "Đã thêm sản phẩm mới.");
            } else if ("update".equals(action)) {
                Product p = bindProduct(req, true);
                productDAO.update(p);
                req.getSession().setAttribute("flash_success", "Đã cập nhật sản phẩm.");
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                productDAO.delete(id);
                req.getSession().setAttribute("flash_success", "Đã xóa sản phẩm #" + id);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("flash_error", "Lỗi: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/products");
    }

    private Product bindProduct(HttpServletRequest req, boolean withId) {
        Product p = new Product();
        if (withId) p.setId(Integer.parseInt(req.getParameter("id")));
        p.setName(req.getParameter("name"));
        p.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));

        String brandId = req.getParameter("brandId");
        p.setBrandId((brandId == null || brandId.isBlank()) ? null : Integer.valueOf(brandId));

        // Chuẩn hoá giá: bỏ dấu . , nếu có
        String price = req.getParameter("price");
        price = (price == null ? "0" : price.replace(".", "").replace(",", ""));
        p.setPrice(new BigDecimal(price));

        p.setImage(req.getParameter("image"));
        p.setDescription(req.getParameter("description") == null ? "" : req.getParameter("description"));
        p.setStock(Integer.parseInt(req.getParameter("stock")));

        String rating = req.getParameter("rating");
        p.setRating((rating == null || rating.isBlank()) ? 0 : Double.parseDouble(rating));

        String purchased = req.getParameter("purchased");
        p.setPurchased((purchased == null || purchased.isBlank()) ? 0 : Integer.parseInt(purchased));

        return p;
    }
}
package com.vuadocau.controller;

import com.vuadocau.dao.ProductDAO;
import com.vuadocau.dao.ReviewDAO;
import com.vuadocau.model.Product;
import com.vuadocau.model.Review;
import com.vuadocau.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name="ProductDetailController", urlPatterns={"/product"})
public class ProductDetailController extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();
    private final ReviewDAO reviewDAO   = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String sid = req.getParameter("id");
        Product p = null;

        try {
            int id = Integer.parseInt(sid);
            p = productDAO.findById(id);
        } catch (Exception ignored) {}

        if (p == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Lấy list review cho sản phẩm
        List<Review> reviews = reviewDAO.findByProduct(p.getId());

        req.setAttribute("p", p);
        req.setAttribute("reviews", reviews);
        req.setAttribute("pageTitle", p.getName());
        req.setAttribute("view", "/WEB-INF/views/product_detail.jsp");
        req.getRequestDispatcher("/WEB-INF/views/_layout/main.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession ss = req.getSession();

        User u = (User) ss.getAttribute("authUser");
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        if (!"review".equalsIgnoreCase(action)) {
            resp.sendRedirect(req.getContextPath() + "/products?g=all");
            return;
        }

        int productId;
        int rating;

        try {
            productId = Integer.parseInt(req.getParameter("productId"));
            rating    = Integer.parseInt(req.getParameter("rating"));
        } catch (Exception e) {
            ss.setAttribute("flash_error", "Dữ liệu đánh giá không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/product?id=" + req.getParameter("productId"));
            return;
        }

        if (rating < 1) rating = 1;
        if (rating > 5) rating = 5;

        String comment = req.getParameter("comment");
        if (comment != null) comment = comment.trim();

        try {
            boolean ok = reviewDAO.upsert(productId, u.getId(), rating, comment);
            if (ok) {
                ss.setAttribute("flash_success", "Cảm ơn bạn đã đánh giá sản phẩm!");
            } else {
                ss.setAttribute("flash_error", "Không lưu được đánh giá.");
            }
        } catch (Exception e) {
            ss.setAttribute("flash_error", "Lỗi: " + e.getMessage());
        }

        // Giữ lại fromOrder (nếu có) để form vẫn hiện
        String fromOrder = req.getParameter("orderId");
        String url = req.getContextPath() + "/product?id=" + productId;
        if (fromOrder != null && !fromOrder.isBlank()) {
            url += "&fromOrder=" + fromOrder;
        }

        resp.sendRedirect(url);
    }
}

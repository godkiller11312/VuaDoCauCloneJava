package com.vuadocau.controller;

import com.vuadocau.dao.ProductDAO;
import com.vuadocau.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;

@WebServlet(name = "CartController", urlPatterns = {"/cart"})
public class CartController extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    private Cart getCart(HttpSession session) {
        Cart cart = (Cart) session.getAttribute("CART");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("CART", cart);
        }
        return cart;
    }

    private void syncBadge(HttpSession session, Cart cart) {
        session.setAttribute("cartCount", cart.getTotalQty());
    }

    private int parseInt(String s, int def) {
        try { return Integer.parseInt(s); }
        catch (Exception e) { return def; }
    }

    private void json(HttpServletResponse resp, String body) throws IOException {
        resp.setContentType("application/json; charset=UTF-8");
        try (PrintWriter w = resp.getWriter()) { w.write(body); }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Cart cart = getCart(session);

        String action = req.getParameter("action"); // add|remove|clear|null(show)

        if ("add".equals(action)) {
            int id  = parseInt(req.getParameter("id"), -1);
            int qty = parseInt(req.getParameter("qty"), 1);
            Product p = productDAO.findById(id);
            if (p != null) cart.add(p, qty);
            syncBadge(session, cart);
            // flash “đã thêm”
            session.setAttribute("flash_success", "Đã thêm vào giỏ!");
            String back = req.getHeader("Referer");
            resp.sendRedirect(back != null ? back : req.getContextPath() + "/cart");
            return;
        }

        if ("remove".equals(action)) {
            int id = parseInt(req.getParameter("id"), -1);
            cart.remove(id);
            syncBadge(session, cart);
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        if ("clear".equals(action)) {
            cart.clear();
            syncBadge(session, cart);
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        // lấy flash nếu có
        Object flash = session.getAttribute("flash_success");
        if (flash != null) {
            req.setAttribute("message", flash);
            session.removeAttribute("flash_success");
        }

        // show page
        req.setAttribute("cart", cart);
        req.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Cart cart = getCart(session);
        String action = req.getParameter("action");

        // AJAX: đặt số lượng 1 item (khi đổi ô number / bấm "Áp dụng")
        if ("set".equals(action)) {
            int id  = parseInt(req.getParameter("id"), -1);
            int qty = parseInt(req.getParameter("qty"), 1);
            cart.update(id, qty);
            syncBadge(session, cart);

            CartItem it = cart.getItem(id);
            BigDecimal itemSubtotal = it != null ? it.getSubtotal() : BigDecimal.ZERO;
            BigDecimal totalAmount  = cart.getTotalAmount();
            int totalQty            = cart.getTotalQty();

            String json = String.format(
                "{\"ok\":true,\"id\":%d,\"qty\":%d,\"itemSubtotal\":%s,\"totalAmount\":%s,\"totalQty\":%d}",
                id, qty,
                itemSubtotal.toPlainString(),
                totalAmount.toPlainString(),
                totalQty
            );
            json(resp, json);
            return;
        }

        // fallback: cập nhật hàng loạt (ít dùng)
        req.getParameterMap().forEach((name, values) -> {
            if (name.startsWith("qty[")) {
                int id = parseInt(name.substring(4, name.length() - 1), -1);
                int qty = parseInt(values[0], 1);
                cart.update(id, qty);
            }
        });
        syncBadge(session, cart);
        resp.sendRedirect(req.getContextPath() + "/cart");
    }
}
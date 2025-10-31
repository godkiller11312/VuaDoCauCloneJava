package com.vuadocau.controller;

import com.vuadocau.dao.OrderDAO;
import com.vuadocau.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(name = "CheckoutController", urlPatterns = {"/checkout"})
public class CheckoutController extends HttpServlet {
    private static final BigDecimal SHIP_FEE = new BigDecimal("25000");
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Cart cart = (Cart) req.getSession().getAttribute("CART");
        if (cart == null || cart.isEmpty()) { resp.sendRedirect(req.getContextPath() + "/cart"); return; }

        User u = (User) req.getSession().getAttribute("authUser");
        if (u != null) {
            req.setAttribute("prefillName",  u.getName());
            req.setAttribute("prefillEmail", u.getEmail());
        }
        req.setAttribute("cart", cart);
        req.setAttribute("shipFee", SHIP_FEE);
        req.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        Cart cart = (Cart) req.getSession().getAttribute("CART");
        if (cart == null || cart.isEmpty()) { resp.sendRedirect(req.getContextPath() + "/cart"); return; }

        User u = (User) req.getSession().getAttribute("authUser");
        int userId = (u == null) ? 0 : u.getId();

        String fullName = val(req.getParameter("fullName"));
        String phone    = val(req.getParameter("phone"));
        String email    = val(req.getParameter("email"));
        String address  = val(req.getParameter("address"));
        String note     = val(req.getParameter("note"));

        if (fullName.isEmpty() || phone.isEmpty() || address.isEmpty()) {
            req.setAttribute("errors", java.util.List.of("Vui lòng nhập đủ Họ tên / SĐT / Địa chỉ."));
            req.setAttribute("cart", cart);
            req.setAttribute("shipFee", SHIP_FEE);
            req.setAttribute("prefillName", fullName);
            req.setAttribute("prefillEmail", email);
            req.setAttribute("prefillPhone", phone);
            req.setAttribute("prefillAddress", address);
            req.setAttribute("prefillNote", note);
            req.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(req, resp);
            return;
        }

        // Gói thông tin nhận hàng vào GhiChu
        String ghiChu = String.format("Tên: %s | SDT: %s | Email: %s | Địa chỉ: %s | Note: %s",
                fullName, phone, email, address, note);

        Order o = new Order();
        o.setUserId(userId);
        o.setStatus("NEW");
        o.setNote(ghiChu);

        int orderId = orderDAO.create(o, cart);

        cart.clear();
        req.getSession().setAttribute("cartCount", 0);

        resp.sendRedirect(req.getContextPath() + "/order?id=" + orderId);
    }

    private String val(String s) { return s == null ? "" : s.trim(); }
}
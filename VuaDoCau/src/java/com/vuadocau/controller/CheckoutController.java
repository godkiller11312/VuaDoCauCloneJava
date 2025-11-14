package com.vuadocau.controller;

import com.vuadocau.dao.OrderDAO;
import com.vuadocau.model.Cart;
import com.vuadocau.model.Order;
import com.vuadocau.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CheckoutController", urlPatterns = {"/checkout"})
public class CheckoutController extends HttpServlet {

    private static final BigDecimal SHIP_FEE = new BigDecimal("25000");
    private final OrderDAO orderDAO = new OrderDAO();

    private void forwardCheckout(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("view", "/WEB-INF/views/checkout.jsp");
        req.setAttribute("pageTitle", "Thanh toán");
        req.getRequestDispatcher("/WEB-INF/views/_layout/main.jsp").forward(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession ss = req.getSession();
        Cart cart = (Cart) ss.getAttribute("CART");
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        User u = (User) ss.getAttribute("authUser");
        if (u != null) {
            req.setAttribute("prefillName", u.getName());
            req.setAttribute("prefillEmail", u.getEmail());
        }
        req.setAttribute("prefillPhone", "");
        req.setAttribute("prefillAddress", "");
        req.setAttribute("prefillNote", "");

        req.setAttribute("cart", cart);
        req.setAttribute("shipFee", SHIP_FEE);

        forwardCheckout(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession ss = req.getSession();

        Cart cart = (Cart) ss.getAttribute("CART");
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        User u = (User) ss.getAttribute("authUser");
        int userId = (u == null) ? 0 : u.getId();

        String fullName = val(req.getParameter("fullName"));
        String phone    = val(req.getParameter("phone"));
        String email    = val(req.getParameter("email"));
        String address  = val(req.getParameter("address"));
        String note     = val(req.getParameter("note"));

        List<String> errors = new ArrayList<>();
        if (fullName.isEmpty() || phone.isEmpty() || address.isEmpty()) {
            errors.add("Vui lòng nhập đủ Họ tên / SĐT / Địa chỉ.");
        }

        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.setAttribute("cart", cart);
            req.setAttribute("shipFee", SHIP_FEE);

            // giữ lại dữ liệu người dùng đã nhập
            req.setAttribute("prefillName", fullName);
            req.setAttribute("prefillEmail", email);
            req.setAttribute("prefillPhone", phone);
            req.setAttribute("prefillAddress", address);
            req.setAttribute("prefillNote", note);

            // QUAN TRỌNG: luôn đi qua layout
            forwardCheckout(req, resp);
            return;
        }

        // Gói thông tin nhận hàng vào GhiChu
        String ghiChu = String.format(
                "Tên: %s | SDT: %s | Email: %s | Địa chỉ: %s | Note: %s",
                fullName, phone, email, address, note
        );

        Order o = new Order();
        o.setUserId(userId);
        o.setStatus("NEW");
        o.setNote(ghiChu);

        int orderId = orderDAO.create(o, cart);

        cart.clear();
        ss.setAttribute("cartCount", 0);

        resp.sendRedirect(req.getContextPath() + "/order?id=" + orderId);
    }

    private String val(String s) {
        return s == null ? "" : s.trim();
    }
}

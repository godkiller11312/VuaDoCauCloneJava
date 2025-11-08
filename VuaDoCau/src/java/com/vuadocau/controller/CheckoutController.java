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

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession s = req.getSession(false);
        Cart cart = (s != null) ? (Cart) s.getAttribute("CART") : null;

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        User u = (s != null) ? (User) s.getAttribute("authUser") : null;
        if (u != null) {
            req.setAttribute("prefillName", u.getName());
            req.setAttribute("prefillEmail", u.getEmail());
        }

        req.setAttribute("cart", cart);
        req.setAttribute("shipFee", SHIP_FEE);

        // render qua layout
        req.setAttribute("view", "/WEB-INF/views/checkout.jsp");
        req.setAttribute("pageTitle", "Thanh toán");
        req.getRequestDispatcher("/WEB-INF/views/_layout/main.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession s = req.getSession(false);
        Cart cart = (s != null) ? (Cart) s.getAttribute("CART") : null;

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        User u = (s != null) ? (User) s.getAttribute("authUser") : null;
        int userId = (u == null) ? 0 : u.getId();

        String fullName = val(req.getParameter("fullName"));
        String phone    = val(req.getParameter("phone"));
        String email    = val(req.getParameter("email"));
        String address  = val(req.getParameter("address"));
        String note     = val(req.getParameter("note"));

        // validate
        List<String> errors = new ArrayList<>();
        if (fullName.isEmpty()) errors.add("Vui lòng nhập họ tên.");
        if (phone.isEmpty())    errors.add("Vui lòng nhập số điện thoại.");
        if (address.isEmpty())  errors.add("Vui lòng nhập địa chỉ.");

        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.setAttribute("cart", cart);
            req.setAttribute("shipFee", SHIP_FEE);
            req.setAttribute("prefillName", fullName);
            req.setAttribute("prefillEmail", email);
            req.setAttribute("prefillPhone", phone);
            req.setAttribute("prefillAddress", address);
            req.setAttribute("prefillNote", note);

            // render lại qua layout để đồng bộ giao diện
            req.setAttribute("view", "/WEB-INF/views/checkout.jsp");
            req.setAttribute("pageTitle", "Thanh toán");
            req.getRequestDispatcher("/WEB-INF/views/_layout/main.jsp").forward(req, resp);
            return;
        }

        // gói thông tin người nhận vào ghi chú
        String ghiChu = String.format(
                "Tên: %s | SDT: %s | Email: %s | Địa chỉ: %s | Note: %s",
                fullName, phone, email, address, note
        );

        try {
            Order o = new Order();
            o.setUserId(userId);
            o.setStatus("NEW");
            o.setNote(ghiChu);

            int orderId = orderDAO.create(o, cart);

            // clear cart + badge
            cart.clear();
            if (s != null) s.setAttribute("cartCount", 0);

            // về trang chi tiết đơn cho khách
            resp.sendRedirect(req.getContextPath() + "/order?id=" + orderId);

        } catch (Exception ex) {
            ex.printStackTrace();

            req.setAttribute("errors", List.of("Không thể tạo đơn: " + ex.getMessage()));
            req.setAttribute("cart", cart);
            req.setAttribute("shipFee", SHIP_FEE);
            req.setAttribute("prefillName", fullName);
            req.setAttribute("prefillEmail", email);
            req.setAttribute("prefillPhone", phone);
            req.setAttribute("prefillAddress", address);
            req.setAttribute("prefillNote", note);

            req.setAttribute("view", "/WEB-INF/views/checkout.jsp");
            req.setAttribute("pageTitle", "Thanh toán");
            req.getRequestDispatcher("/WEB-INF/views/_layout/main.jsp").forward(req, resp);
        }
    }

    private String val(String s) {
        return (s == null) ? "" : s.trim();
    }
}
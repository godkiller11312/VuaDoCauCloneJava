package com.vuadocau.controller;

import com.vuadocau.model.Cart;
import com.vuadocau.model.CartItem;
import com.vuadocau.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@WebServlet(name = "CheckoutController", urlPatterns = {"/checkout"})
public class CheckoutController extends HttpServlet {

    private static final BigDecimal SHIP_FEE = new BigDecimal("25000"); // ship cố định; tùy bạn thay rule

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Cart cart = (Cart) req.getSession().getAttribute("CART");
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        // Prefill từ user đã login (nếu có)
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
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        String fullName = trim(req.getParameter("fullName"));
        String phone    = trim(req.getParameter("phone"));
        String email    = trim(req.getParameter("email"));
        String address  = trim(req.getParameter("address"));
        String note     = trim(req.getParameter("note"));

        // Validate siêu gọn – đủ để demo
        List<String> errors = new ArrayList<>();
        if (fullName.isEmpty()) errors.add("Vui lòng nhập họ tên.");
        if (phone.isEmpty())    errors.add("Vui lòng nhập số điện thoại.");
        if (address.isEmpty())  errors.add("Vui lòng nhập địa chỉ nhận hàng.");

        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
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

        // Tạo mã đơn & tính tổng
        String orderCode = genOrderCode();
        BigDecimal subtotal = cart.getTotalAmount();
        BigDecimal total    = subtotal.add(SHIP_FEE);

        // TODO: Lưu DB (Order / OrderItem) ở đây nếu bạn muốn
        // Hiện tại: demo -> show trang success, clear cart

        // đóng gói dữ liệu order để hiển thị
        Map<String, Object> order = new HashMap<>();
        order.put("code", orderCode);
        order.put("createdAt", LocalDateTime.now());
        order.put("items", new ArrayList<>(cart.getItems()));
        order.put("subtotal", subtotal);
        order.put("shipFee", SHIP_FEE);
        order.put("total", total);
        order.put("fullName", fullName);
        order.put("phone", phone);
        order.put("email", email);
        order.put("address", address);
        order.put("note", note);

        req.setAttribute("order", order);

        // Clear cart + badge
        cart.clear();
        req.getSession().setAttribute("cartCount", 0);

        req.getRequestDispatcher("/WEB-INF/views/order_success.jsp").forward(req, resp);
    }

    private String trim(String s) { return s == null ? "" : s.trim(); }

    private String genOrderCode() {
        // VD: OD-251031-083045-5R7 (ngày giờ + 3 ký tự random)
        String ts = DateTimeFormatter.ofPattern("yyMMdd-HHmmss").format(LocalDateTime.now());
        String rand = UUID.randomUUID().toString().substring(0, 3).toUpperCase();
        return "OD-" + ts + "-" + rand;
    }
}
package com.vuadocau.controller;

import com.vuadocau.dao.OrderDAO;
import com.vuadocau.model.Order;
import com.vuadocau.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(name = "OrderController", urlPatterns = {"/order"})
public class OrderController extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();
    private static final BigDecimal SHIP_FEE = new BigDecimal("25000");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User u = (User) req.getSession().getAttribute("authUser");
        if (u == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        int id;
        try { id = Integer.parseInt(req.getParameter("id")); }
        catch (Exception e) { resp.sendError(404); return; }

        Order o = orderDAO.findById(id, u.getId());
        if (o == null) { resp.sendError(404); return; }

        o.setShipFee(SHIP_FEE);
        if (o.getSubtotal() != null) o.setTotal(o.getSubtotal().add(SHIP_FEE));

        req.setAttribute("order", o);
        req.setAttribute("view", "/WEB-INF/views/order_detail.jsp");
        req.setAttribute("pageTitle", "Đơn hàng #" + id);
        req.getRequestDispatcher("/WEB-INF/views/_layout/main.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession ss = req.getSession();
        User u = (User) ss.getAttribute("authUser");
        if (u == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String action = req.getParameter("action");
        int id;
        try { id = Integer.parseInt(req.getParameter("id")); }
        catch (Exception ex) { ss.setAttribute("flash_error", "Yêu cầu không hợp lệ."); resp.sendRedirect(req.getContextPath()+"/profile"); return; }

        boolean ok = false;
        try {
            if ("cancel".equalsIgnoreCase(action)) {
                ok = orderDAO.userCancelIfNew(id, u.getId());
                ss.setAttribute(ok ? "flash_success" : "flash_error",
                        ok ? ("Đã hủy đơn #" + id) : ("Không thể hủy đơn #" + id));
            } else if ("received".equalsIgnoreCase(action)) {
                ok = orderDAO.userMarkDoneIfShipping(id, u.getId());
                ss.setAttribute(ok ? "flash_success" : "flash_error",
                        ok ? ("Cảm ơn bạn! Đơn #" + id + " đã hoàn tất.") : ("Không thể xác nhận nhận hàng cho đơn #" + id));
            } else {
                ss.setAttribute("flash_error", "Action không hợp lệ.");
            }
        } catch (Exception e) {
            ss.setAttribute("flash_error", "Lỗi: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/profile");
    }
}

package com.vuadocau.controller;

import com.vuadocau.dao.OrderDAO;
import com.vuadocau.model.Order;
import com.vuadocau.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name="AdminOrderController", urlPatterns={"/admin/orders"})
public class AdminOrderController extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    private boolean isAdmin(HttpServletRequest req){
        HttpSession s = req.getSession(false);
        if (s == null) return false;
        Object o = s.getAttribute("authUser");
        return (o instanceof User) && ((User) o).getRoleId() == 1;
    }

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isAdmin(req)) { resp.sendRedirect(req.getContextPath()+"/home"); return; }

        String q = req.getParameter("q");
        String status = req.getParameter("status");

        List<Order> orders = orderDAO.findAll(q, status);
        req.setAttribute("orders", orders);
        req.setAttribute("q", q);
        req.setAttribute("status", status);

        req.getRequestDispatcher("/WEB-INF/views/admin/orders.jsp").forward(req, resp);
    }

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isAdmin(req)) { resp.sendRedirect(req.getContextPath()+"/home"); return; }

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        try {
            if ("updateStatus".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                String st = req.getParameter("status");
                orderDAO.updateStatus(id, st);
                req.getSession().setAttribute("flash_success", "Đã cập nhật trạng thái đơn #" + id);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("flash_error", "Lỗi: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath()+"/admin/orders");
    }
}
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
        req.getRequestDispatcher("/WEB-INF/views/order_detail.jsp").forward(req, resp);
    }
}
package com.vuadocau.controller;

import com.vuadocau.dao.ActivityLogDAO;
import com.vuadocau.dao.OrderDAO;
import com.vuadocau.model.ActivityLog;
import com.vuadocau.model.Order;
import com.vuadocau.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProfileController", urlPatterns = {"/profile"})
public class ProfileController extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();
    private final ActivityLogDAO activityLogDAO = new ActivityLogDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User u = (User) req.getSession().getAttribute("authUser");
        if (u == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        // Đơn hàng
        List<Order> orders = orderDAO.findByUser(u.getId());

        // Hoạt động gần đây (cho admin)
        List<ActivityLog> activities = activityLogDAO.findRecentByUser(u.getId(), 20);

        req.setAttribute("orders", orders);
        req.setAttribute("activities", activities);
        req.setAttribute("user", u);
        req.setAttribute("view", "/WEB-INF/views/profile.jsp");
        req.setAttribute("pageTitle", "Hồ sơ cá nhân");
        req.getRequestDispatcher("/WEB-INF/views/_layout/main.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User u = (User) req.getSession().getAttribute("authUser");
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");

        // Chỉ ADMIN mới được xoá log
        if ("clearLog".equals(action) && u.getRoleId() == 1) {
            try {
                activityLogDAO.clearAll();
                // redirect kèm flag để JSP hiện thông báo
                resp.sendRedirect(req.getContextPath() + "/profile?logCleared=1");
            } catch (Exception ex) {
                ex.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/profile?logCleared=0");
            }
        } else {
            // fallback
            resp.sendRedirect(req.getContextPath() + "/profile");
        }
    }
}

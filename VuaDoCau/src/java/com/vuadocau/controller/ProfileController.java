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

        // Đơn hàng (nếu còn cần hiển thị đâu đó)
        List<Order> orders = orderDAO.findByUser(u.getId());

        // Hoạt động gần đây
        List<ActivityLog> activities = activityLogDAO.findRecentByUser(u.getId(), 20);

        req.setAttribute("orders", orders);
        req.setAttribute("activities", activities);
        req.setAttribute("user", u);
        req.setAttribute("view", "/WEB-INF/views/profile.jsp");
        req.setAttribute("pageTitle", "Hồ sơ cá nhân");
        req.getRequestDispatcher("/WEB-INF/views/_layout/main.jsp").forward(req, resp);
    }
}

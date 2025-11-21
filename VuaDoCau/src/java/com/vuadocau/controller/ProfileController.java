package com.vuadocau.controller;

import com.vuadocau.dao.ActivityLogDAO;
import com.vuadocau.dao.OrderDAO;
import com.vuadocau.dao.UserDAO;
import com.vuadocau.model.ActivityLog;
import com.vuadocau.model.Order;
import com.vuadocau.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

@MultipartConfig
@WebServlet(name = "ProfileController", urlPatterns = {"/profile"})
public class ProfileController extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();
    private final ActivityLogDAO activityLogDAO = new ActivityLogDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User u = (User) req.getSession().getAttribute("authUser");
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

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
        String cxt = req.getContextPath();

        try {
            // ===== ADMIN xóa log =====
            if ("clearLog".equals(action) && u.getRoleId() == 1) {
                activityLogDAO.clearAll();
                resp.sendRedirect(cxt + "/profile?logCleared=1");
                return;
            }

            // ===== Đổi avatar cho cả admin & user =====
            if ("changeAvatar".equals(action)) {

                Part filePart = req.getPart("avatarFile");
                if (filePart == null || filePart.getSize() == 0) {
                    req.getSession().setAttribute("flash_error", "Vui lòng chọn một file ảnh.");
                    resp.sendRedirect(cxt + "/profile");
                    return;
                }

                // Lấy tên file gốc & extension
                String submittedName = Paths.get(filePart.getSubmittedFileName())
                        .getFileName().toString();
                String ext = "";
                int dot = submittedName.lastIndexOf('.');
                if (dot >= 0) {
                    ext = submittedName.substring(dot); // gồm cả dấu .
                }

                // Đặt tên mới: user-<id>-timestamp.ext
                String fileName = "user-" + u.getId() + "-" + System.currentTimeMillis() + ext;

                // Thư mục lưu: /asset/images/avatars trong webapp
                String uploadDir = getServletContext().getRealPath("/asset/images/avatars");
                File dir = new File(uploadDir);
                if (!dir.exists()) dir.mkdirs();

                // Ghi file lên server
                File dest = new File(dir, fileName);
                filePart.write(dest.getAbsolutePath());

                // Cập nhật DB
                boolean ok = userDAO.updateAvatar(u.getId(), fileName);

                if (ok) {
                    // Cập nhật object trong session để header/profile dùng avatar mới
                    u.setAvatar(fileName);
                    req.getSession().setAttribute("authUser", u);
                    req.getSession().setAttribute("flash_success", "Đã cập nhật ảnh đại diện.");
                } else {
                    req.getSession().setAttribute("flash_error", "Không thể cập nhật ảnh đại diện.");
                }

                resp.sendRedirect(cxt + "/profile");
                return;
            }

            // ===== fallback nếu action khác =====
            resp.sendRedirect(cxt + "/profile");

        } catch (Exception ex) {
            ex.printStackTrace();
            req.getSession().setAttribute("flash_error", "Lỗi: " + ex.getMessage());
            resp.sendRedirect(cxt + "/profile");
        }
    }
}

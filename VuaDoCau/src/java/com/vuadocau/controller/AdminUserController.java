package com.vuadocau.controller;

import com.vuadocau.dao.ActivityLogDAO;
import com.vuadocau.dao.UserDAO;
import com.vuadocau.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminUserController", urlPatterns = {"/admin/users"})
public class AdminUserController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final ActivityLogDAO actDAO = new ActivityLogDAO();

    /* -------------------- helpers -------------------- */

    private boolean isAdmin(HttpServletRequest req){
        HttpSession s = req.getSession(false);
        if (s == null) return false;
        Object o = s.getAttribute("authUser");
        return (o instanceof User) && ((User) o).getRoleId() == 1;
    }

    private Integer tryParseInt(String s){
        try { return (s == null || s.isBlank()) ? null : Integer.parseInt(s.trim()); }
        catch (Exception e){ return null; }
    }

    private Boolean tryParseBool01(String s){
        if (s == null || s.isBlank()) return null;      // cho phép bỏ trống
        if ("1".equals(s)) return true;
        if ("0".equals(s)) return false;
        return null;
    }

    private String safe(String s){
        return (s == null) ? "" : s.trim();
    }

    /* -------------------- GET: danh sách + detail -------------------- */

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) { resp.sendRedirect(req.getContextPath()+"/home"); return; }
        User admin = (User) req.getSession().getAttribute("authUser");

        String action = safe(req.getParameter("action"));
        if ("detail".equalsIgnoreCase(action)) {
            Integer id = tryParseInt(req.getParameter("id"));
            if (id == null) {
                req.getSession().setAttribute("flash_error", "Thiếu mã tài khoản.");
                resp.sendRedirect(req.getContextPath()+"/admin/users");
                return;
            }
            User u = userDAO.findById(id);
            if (u == null) {
                req.getSession().setAttribute("flash_error", "Không tìm thấy tài khoản #" + id);
                resp.sendRedirect(req.getContextPath()+"/admin/users");
                return;
            }
            req.setAttribute("u", u);
            req.setAttribute("pageTitle", "Quản trị · Tài khoản · #" + id);
            req.setAttribute("view", "/WEB-INF/views/admin/user-detail.jsp"); // nếu có trang detail riêng
            req.getRequestDispatcher("/WEB-INF/views/_layout/main.jsp").forward(req, resp);
            return;
        }

        // -------- Danh sách + filter + sort ----------
        String q = safe(req.getParameter("q"));
        Integer roleId = tryParseInt(req.getParameter("role"));      // 1|2|null
        Boolean active = tryParseBool01(req.getParameter("status")); // 1|0|null

        String sort = safe(req.getParameter("sort"));
        String dir  = safe(req.getParameter("dir"));
        if (sort.isEmpty()) sort = "id";
        if (!(sort.equals("id") || sort.equals("name") || sort.equals("email"))) sort = "id";
        dir = "asc".equalsIgnoreCase(dir) ? "asc" : "desc";

        List<User> users = userDAO.adminFindAll(q, roleId, active, sort, dir);

        // log filter (chống trùng 2s)
        try {
            if (admin != null) {
                String msg = String.format("Lọc user: q='%s', role=%s, status=%s, sort='%s', dir='%s', count=%d",
                        q, roleId==null?"null":roleId.toString(), active==null?"null":(active? "1":"0"),
                        sort, dir, users==null?0:users.size());
                actDAO.logOnce(req, admin, "USER_LIST", msg, 2000);
            }
        } catch (Exception ignore){}

        req.setAttribute("users", users);
        req.setAttribute("q", q);
        req.setAttribute("role", roleId);
        req.setAttribute("status", active == null ? null : (active ? "1" : "0"));
        req.setAttribute("sort", sort);
        req.setAttribute("dir", dir);

        req.setAttribute("pageTitle", "Quản trị · Tài khoản");
        req.setAttribute("view", "/WEB-INF/views/admin/users.jsp");
        req.getRequestDispatcher("/WEB-INF/views/_layout/main.jsp").forward(req, resp);
    }

    /* -------------------- POST: create / update / resetPassword / delete -------------------- */

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) { resp.sendRedirect(req.getContextPath()+"/home"); return; }
        req.setCharacterEncoding("UTF-8");
        User admin = (User) req.getSession().getAttribute("authUser");

        String action = safe(req.getParameter("action"));

        try {
            // ====== CREATE ======
            if ("create".equalsIgnoreCase(action)) {
                String name  = safe(req.getParameter("name"));
                String email = safe(req.getParameter("email"));
                String pass  = safe(req.getParameter("password"));
                Integer role = tryParseInt(req.getParameter("roleId"));     // 1|2
                Boolean active = tryParseBool01(req.getParameter("status")); // 1|0

                if (name.isBlank() || email.isBlank() || pass.isBlank()) {
                    throw new IllegalArgumentException("Thiếu tên / email / mật khẩu");
                }
                if (role == null || (role != 1 && role != 2)) role = 2;
                boolean act = (active == null) || active;

                boolean ok = userDAO.adminCreate(name, email, pass, role, act);
                if (ok) {
                    req.getSession().setAttribute("flash_success", "Đã tạo tài khoản mới.");
                    try { if (admin != null) actDAO.log(req, admin, "USER_CREATE", "Tạo user: " + email); } catch (Exception ignore){}
                } else {
                    req.getSession().setAttribute("flash_error", "Email đã tồn tại hoặc tạo tài khoản thất bại.");
                }
                resp.sendRedirect(req.getContextPath() + "/admin/users");
                return;
            }

            // ====== UPDATE ======
            if ("update".equalsIgnoreCase(action)) {
                Integer id = tryParseInt(req.getParameter("id"));
                if (id == null) throw new IllegalArgumentException("Thiếu mã tài khoản để cập nhật");

                String name  = safe(req.getParameter("name"));
                String email = safe(req.getParameter("email"));
                Integer role = tryParseInt(req.getParameter("roleId")); // 1|2
                Boolean active = tryParseBool01(req.getParameter("status"));

                boolean ok = userDAO.updateProfile(id, name, email, role == null ? 2 : role, active == null || active);
                if (ok) {
                    req.getSession().setAttribute("flash_success", "Đã cập nhật tài khoản #" + id);
                    try {
                        if (admin != null) actDAO.log(req, admin, "USER_UPDATE", "Cập nhật user #" + id);
                    } catch (Exception ignore){}
                } else {
                    req.getSession().setAttribute("flash_error", "Không thể cập nhật tài khoản #" + id);
                }
                resp.sendRedirect(req.getContextPath()+"/admin/users");
                return;
            }

            // ====== RESET PASSWORD ======
            if ("resetPassword".equalsIgnoreCase(action)) {
                Integer id = tryParseInt(req.getParameter("id"));
                if (id == null) throw new IllegalArgumentException("Thiếu mã tài khoản để đặt lại mật khẩu");

                String newPass = safe(req.getParameter("newPassword"));
                if (newPass.isEmpty()) newPass = "123456"; // default

                boolean ok = userDAO.updatePassword(id, newPass);
                if (ok) {
                    req.getSession().setAttribute("flash_success", "Đã đặt lại mật khẩu cho user #" + id);
                    try {
                        if (admin != null) actDAO.log(req, admin, "USER_RESET_PASSWORD", "Reset mật khẩu user #" + id);
                    } catch (Exception ignore){}
                } else {
                    req.getSession().setAttribute("flash_error", "Không thể đặt lại mật khẩu cho user #" + id);
                }
                resp.sendRedirect(req.getContextPath()+"/admin/users");
                return;
            }

            // ====== DELETE ======
            if ("delete".equalsIgnoreCase(action)) {
                Integer id = tryParseInt(req.getParameter("id"));
                if (id == null) throw new IllegalArgumentException("Thiếu mã tài khoản để xóa");

                boolean ok = userDAO.delete(id);
                if (ok) {
                    req.getSession().setAttribute("flash_success", "Đã xóa tài khoản #" + id);
                    try {
                        if (admin != null) actDAO.log(req, admin, "USER_DELETE", "Xóa user #" + id);
                    } catch (Exception ignore){}
                } else {
                    req.getSession().setAttribute("flash_error", "Không thể xóa tài khoản #" + id);
                }
                resp.sendRedirect(req.getContextPath()+"/admin/users");
                return;
            }

            // action không hợp lệ
            req.getSession().setAttribute("flash_error", "Action không hợp lệ.");
            resp.sendRedirect(req.getContextPath()+"/admin/users");

        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (admin != null) actDAO.log(req, admin, "ERROR", "AdminUserController: " + e.getMessage());
            } catch (Exception ignore){}
            req.getSession().setAttribute("flash_error", "Lỗi: " + e.getMessage());
            resp.sendRedirect(req.getContextPath()+"/admin/users");
        }
    }
}

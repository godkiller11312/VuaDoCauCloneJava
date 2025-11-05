package com.vuadocau.controller;

import com.vuadocau.dao.UserDAO;
import com.vuadocau.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name="LoginController", urlPatterns={"/login"})
public class LoginController extends HttpServlet {
    private final UserDAO dao = new UserDAO();

    // Hiển thị form login qua layout
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // flash từ register (nếu có)
        Object flash = req.getSession().getAttribute("flash_success");
        if (flash != null) {
            req.setAttribute("message", flash);
            req.getSession().removeAttribute("flash_success");
        }

        // giữ returnUrl nếu có
        String returnUrl = req.getParameter("returnUrl");
        if (returnUrl != null) {
            req.setAttribute("returnUrl", returnUrl);
        }

        // đi qua layout
        req.setAttribute("view", "/WEB-INF/views/auth/login.jsp");
        req.setAttribute("pageTitle", "Đăng nhập");
        req.getRequestDispatcher("/WEB-INF/views/_layout/main.jsp").forward(req, resp);
    }

    // Xử lý login
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");
        String pass  = req.getParameter("password");
        String returnUrl = req.getParameter("returnUrl");
        if (returnUrl == null) returnUrl = "";

        User u = dao.login(email, pass);

        // Sai thông tin
        if (u == null) {
            req.setAttribute("error", "Email hoặc mật khẩu không đúng.");
            req.setAttribute("view", "/WEB-INF/views/auth/login.jsp");
            req.setAttribute("pageTitle", "Đăng nhập");
            req.getRequestDispatcher("/WEB-INF/views/_layout/main.jsp").forward(req, resp);
            return;
        }

        // Bị khóa
        if (!u.isActive()) {
            req.setAttribute("error", "Tài khoản đã bị khóa.");
            req.setAttribute("view", "/WEB-INF/views/auth/login.jsp");
            req.setAttribute("pageTitle", "Đăng nhập");
            req.getRequestDispatcher("/WEB-INF/views/_layout/main.jsp").forward(req, resp);
            return;
        }

        // Thành công -> set session và redirect
        HttpSession session = req.getSession();
        session.setAttribute("authUser", u);

        String cxt = req.getContextPath();
        if (!returnUrl.isBlank() && !returnUrl.contains("/login")) {
            resp.sendRedirect(cxt + returnUrl);
        } else {
            resp.sendRedirect(cxt + "/home");
        }
    }
}
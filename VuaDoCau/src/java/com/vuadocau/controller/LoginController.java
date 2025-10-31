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

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Object flash = req.getSession().getAttribute("flash_success");
        if (flash != null) {
            req.setAttribute("message", flash);
            req.getSession().removeAttribute("flash_success");
        }
        req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
    }

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String email = req.getParameter("email");
        String pass  = req.getParameter("password");

        User u = dao.login(email, pass);
        if (u == null) {
            req.setAttribute("error", "Email hoặc mật khẩu không đúng.");
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
            return;
        }
        if (!u.isActive()) {
            req.setAttribute("error", "Tài khoản đã bị khóa.");
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
            return;
        }

      req.getSession().setAttribute("authUser", u);

String back = (String) req.getSession().getAttribute("redirectAfterLogin");
req.getSession().removeAttribute("redirectAfterLogin");

if (u.isAdmin()) {
    // admin: vào trang admin
    ((HttpServletResponse) resp).sendRedirect(req.getContextPath() + "/admin");
} else {
    ((HttpServletResponse) resp).sendRedirect(
        back != null ? back : req.getContextPath() + "/home");
}
    }
}
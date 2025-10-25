package com.vuadocau.controller;

import com.vuadocau.dao.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name="RegisterController", urlPatterns={"/register"})
public class RegisterController extends HttpServlet {
    private final UserDAO dao = new UserDAO();

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
    }

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String pass = req.getParameter("password");
        String confirm = req.getParameter("confirm");

        if (name==null || name.isBlank() || email==null || email.isBlank()
                || pass==null || pass.isBlank() || confirm==null) {
            req.setAttribute("error", "Vui lòng nhập đủ thông tin.");
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
            return;
        }
        if (!pass.equals(confirm)) {
            req.setAttribute("error", "Mật khẩu nhập lại không khớp.");
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
            return;
        }
        if (dao.emailExists(email)) {
            req.setAttribute("error", "Email đã tồn tại.");
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
            return;
        }
        boolean ok = dao.create(name.trim(), email.trim(), pass);
        if (ok) {
            req.getSession().setAttribute("flash_success", "Đăng ký thành công! Đăng nhập để tiếp tục.");
            resp.sendRedirect(req.getContextPath() + "/login");
        } else {
            req.setAttribute("error", "Không thể tạo tài khoản. Vui lòng thử lại.");
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
        }
    }
}
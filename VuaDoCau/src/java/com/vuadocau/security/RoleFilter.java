package com.vuadocau.security;

import com.vuadocau.model.User;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class RoleFilter implements Filter {
    private String requiredRole; // lấy từ <init-param> trong web.xml

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        requiredRole = filterConfig.getInitParameter("requiredRole");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req   = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        User u = (session != null) ? (User) session.getAttribute("authUser") : null;

        if (u == null) {
            // chưa đăng nhập → đưa tới trang login
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Lấy role của user (ưu tiên tên role, fallback theo roleId 1=ADMIN, 2=USER)
        String userRole = (u.getRole() != null && !u.getRole().isEmpty())
                ? u.getRole()
                : (u.getRoleId() == 1 ? "ADMIN" : "USER");

        boolean allowed = requiredRole == null
                || requiredRole.equalsIgnoreCase(userRole)
                || ("ADMIN".equalsIgnoreCase(userRole) && "ADMIN".equalsIgnoreCase(requiredRole));

        if (!allowed) {
            // Không tạo trang 403 theo yêu cầu của bạn: trả về HTTP 403 mặc định
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // không cần giải phóng gì
    }
}
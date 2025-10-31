package com.vuadocau.security;

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

public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // không cần cấu hình gì thêm
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req  = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        Object authUser = (session != null) ? session.getAttribute("authUser") : null;

        if (authUser == null) {
            // lưu URL đang vào để đăng nhập xong quay lại (tuỳ chọn)
            String qs  = (req.getQueryString() == null) ? "" : "?" + req.getQueryString();
            String uri = req.getRequestURI() + qs;
            req.getSession(true).setAttribute("redirectAfterLogin", uri);

            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // không cần giải phóng gì
    }
}
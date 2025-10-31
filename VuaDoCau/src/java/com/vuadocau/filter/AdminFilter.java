package com.vuadocau.filter;

import com.vuadocau.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class AdminFilter implements Filter {

  @Override
  public void init(FilterConfig filterConfig) throws ServletException {
    // không cần cấu hình gì, để trống
  }

  @Override
  public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
      throws IOException, ServletException {
    HttpServletRequest req  = (HttpServletRequest) request;
    HttpServletResponse resp = (HttpServletResponse) response;

    HttpSession s = req.getSession(false);
    User auth = (s == null) ? null : (User) s.getAttribute("authUser");

    if (auth == null || auth.getRoleId() != 1 || !auth.isActive()) {
      resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập khu vực này.");
      return;
    }
    chain.doFilter(request, response);
  }

  @Override
  public void destroy() {
    // không cần giải phóng tài nguyên, để trống
  }
}
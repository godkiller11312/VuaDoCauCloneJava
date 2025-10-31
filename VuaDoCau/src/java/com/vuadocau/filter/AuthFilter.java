package com.vuadocau.filter;

import com.vuadocau.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;

public class AuthFilter implements Filter {

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
    if (auth == null) {
      String q = req.getQueryString();
      String returnUrl = req.getRequestURI() + (q != null ? ("?" + q) : "");
      resp.sendRedirect(req.getContextPath() + "/login?returnUrl=" + URLEncoder.encode(returnUrl, "UTF-8"));
      return;
    }
    chain.doFilter(request, response);
  }

  @Override
  public void destroy() {
    // không cần giải phóng tài nguyên, để trống
  }
}
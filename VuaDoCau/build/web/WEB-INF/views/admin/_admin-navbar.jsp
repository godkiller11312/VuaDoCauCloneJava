<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
  .admin-navbar{display:flex;align-items:center;gap:24px;padding:10px 16px;border-bottom:1px solid #e5e7eb}
  .admin-brand{font-weight:800}
  .admin-links a{margin-right:16px;text-decoration:none}
</style>
<div class="admin-navbar">
  <div class="admin-brand">VuaĐồCâu • Admin</div>
  <div class="admin-links">
    <a href="${pageContext.request.contextPath}/admin/orders">Quản lý đơn hàng</a>
    <a href="${pageContext.request.contextPath}/admin/products">Quản lý sản phẩm</a>
  </div>
  <div style="margin-left:auto">
    <span>${sessionScope.authUser.email}</span>
    &nbsp;|&nbsp;
    <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
  </div>
</div>
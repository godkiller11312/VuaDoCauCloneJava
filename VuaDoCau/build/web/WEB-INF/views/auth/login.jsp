<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Đăng nhập - VuaĐồCâu</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
<div class="container py-5" style="max-width: 480px;">
  <div class="card shadow-sm border-0">
    <div class="card-body p-4">
      <h4 class="mb-3 text-center">Đăng nhập</h4>

      <c:if test="${not empty message}">
        <div class="alert alert-success">${message}</div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
      </c:if>

      <form method="post" action="${pageContext.request.contextPath}/login">
        <div class="mb-3">
          <label class="form-label">Email</label>
          <input class="form-control" type="email" name="email" required>
        </div>
        <div class="mb-3">
          <label class="form-label">Mật khẩu</label>
          <input class="form-control" type="password" name="password" required>
        </div>
        <button class="btn btn-success w-100">Đăng nhập</button>
      </form>

      <div class="text-center mt-3">
        Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký</a>
      </div>
    </div>
  </div>
</div>
</body>
</html>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Đăng ký - VuaĐồCâu</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
<div class="container py-5" style="max-width: 520px;">
  <div class="card shadow-sm border-0">
    <div class="card-body p-4">
      <h4 class="mb-3 text-center">Tạo tài khoản</h4>

      <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
      </c:if>

      <form method="post" action="${pageContext.request.contextPath}/register">
        <div class="mb-3">
          <label class="form-label">Họ và tên</label>
          <input class="form-control" type="text" name="name" required>
        </div>
        <div class="mb-3">
          <label class="form-label">Email</label>
          <input class="form-control" type="email" name="email" required>
        </div>
        <div class="mb-3">
          <label class="form-label">Mật khẩu</label>
          <input class="form-control" type="password" name="password" minlength="6" required>
        </div>
        <div class="mb-3">
          <label class="form-label">Nhập lại mật khẩu</label>
          <input class="form-control" type="password" name="confirm" minlength="6" required>
        </div>
        <button class="btn btn-success w-100">Đăng ký</button>
      </form>

      <div class="text-center mt-3">
        Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
      </div>
    </div>
  </div>
</div>
</body>
</html>
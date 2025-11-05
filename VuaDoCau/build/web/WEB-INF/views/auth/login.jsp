<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cxt" value="${pageContext.request.contextPath}" />

<div class="row justify-content-center">
  <div class="col-md-6 col-lg-5">
    <div class="card card-body">
      <h3 class="mb-3 text-center">Đăng nhập</h3>

      <c:if test="${not empty message}">
        <div class="alert alert-success">${message}</div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
      </c:if>

      <form action="${cxt}/login" method="post" class="vstack gap-3">
        <input type="hidden" name="returnUrl" value="${param.returnUrl}"/>
        <div>
          <label class="form-label">Email</label>
          <input class="form-control" type="email" name="email" required/>
        </div>
        <div>
          <label class="form-label">Mật khẩu</label>
          <input class="form-control" type="password" name="password" required/>
        </div>
        <button class="btn btn-teal w-100">Đăng nhập</button>
      </form>

      <div class="text-center mt-3 small">
        Chưa có tài khoản? <a href="${cxt}/register">Đăng ký</a>
      </div>
    </div>
  </div>
</div>
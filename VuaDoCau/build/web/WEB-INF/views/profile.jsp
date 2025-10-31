<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <title>Hồ sơ cá nhân - VuaĐồCâu</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <style>
    :root{ --teal:#22b8a7 }
    .bg-soft{
      background:
        radial-gradient(1200px 600px at 10% 0%, #eaf6ff 0, rgba(255,255,255,.9) 60%),
        radial-gradient(1200px 600px at 90% 100%, #eafff9 0, rgba(255,255,255,.9) 60%);
    }
    .btn-teal{ background:var(--teal); color:#fff }
    .btn-teal:hover{ filter:brightness(.95); color:#fff }
    .navbar .nav-link { padding-left:.75rem; padding-right:.75rem }
  </style>
</head>
<body class="bg-soft">

<c:set var="cxt" value="${pageContext.request.contextPath}" />
<c:set var="auth" value="${sessionScope.authUser}" />
<c:set var="isAdmin" value="${not empty auth and auth.roleId == 1}" />

<nav class="navbar navbar-expand-lg bg-white shadow-sm">
  <div class="container">
    <a class="navbar-brand fw-bold" href="${cxt}/home">VuaĐồCâu</a>

    <ul class="navbar-nav me-3 align-items-center">
      <!-- Người dùng thường -->
      <c:if test="${!isAdmin}">
        <li class="nav-item"><a class="nav-link" href="${cxt}/home">Trang chủ</a></li>
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">Danh mục</a>
          <ul class="dropdown-menu">
            <li><a class="dropdown-item" href="${cxt}/products?g=all">Tất cả sản phẩm</a></li>
            <li><a class="dropdown-item" href="${cxt}/products?g=can">Cần câu</a></li>
            <li><a class="dropdown-item" href="${cxt}/products?g=may">Máy câu</a></li>
            <li><a class="dropdown-item" href="${cxt}/products?g=khac">Dây, Mồi, Phụ kiện</a></li>
          </ul>
        </li>
      </c:if>

      <!-- ADMIN -->
      <c:if test="${isAdmin}">
        <li class="nav-item"><span class="nav-link text-danger fw-bold">Quản trị:</span></li>
        <li class="nav-item"><a class="nav-link text-danger fw-semibold" href="${cxt}/admin/products">Quản Lý Sản phẩm</a></li>
        <li class="nav-item"><a class="nav-link text-danger fw-semibold" href="${cxt}/admin/orders">Quản Lý Đơn hàng</a></li>
      </c:if>
    </ul>

    <!-- Search -->
    <form class="d-flex ms-auto me-2 flex-grow-1" style="max-width:520px" method="get" action="${cxt}/products">
      <input class="form-control me-2" type="search" name="q" placeholder="Tìm sản phẩm...">
      <button class="btn btn-teal">Tìm</button>
    </form>

    <!-- Tài khoản -->
    <c:choose>
      <c:when test="${not empty sessionScope.authUser}">
        <div class="dropdown">
          <button class="btn btn-outline-secondary rounded-pill dropdown-toggle px-3" type="button" data-bs-toggle="dropdown">
            ${sessionScope.authUser.email}
          </button>
          <ul class="dropdown-menu dropdown-menu-end shadow">
            <!-- Ẩn giỏ hàng với admin -->
            <c:if test="${!isAdmin}">
              <li>
                <a class="dropdown-item d-flex justify-content-between align-items-center" href="${cxt}/cart">
                  Giỏ hàng
                  <span class="badge text-bg-primary">${empty sessionScope.cartCount ? 0 : sessionScope.cartCount}</span>
                </a>
              </li>
            </c:if>
            <li><a class="dropdown-item" href="${cxt}/profile">Hồ sơ cá nhân</a></li>
            <li><hr class="dropdown-divider"></li>
            <li><a class="dropdown-item text-danger" href="${cxt}/logout">Đăng xuất</a></li>
          </ul>
        </div>
      </c:when>
      <c:otherwise>
        <div class="ms-2 d-flex gap-2">
          <a class="btn btn-outline-success" href="${cxt}/login">Đăng nhập</a>
          <a class="btn btn-success" href="${cxt}/register">Đăng ký</a>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</nav>

<div class="container py-4">
  <h2 class="fw-bold mb-4">Hồ sơ cá nhân</h2>

  <div class="row g-4">
    <div class="col-lg-4">
      <div class="card shadow-sm rounded-4">
        <div class="card-body">
          <p><strong>Họ tên:</strong> ${user.name}</p>
          <p><strong>Email:</strong> ${user.email}</p>
          <c:if test="${!isAdmin}">
            <a href="${cxt}/cart" class="btn btn-outline-secondary">Giỏ hàng</a>
          </c:if>
        </div>
      </div>
    </div>

    <div class="col-lg-8">
      <h5 class="fw-bold mb-3">Lịch sử đơn hàng</h5>
      <div class="table-responsive bg-white rounded-3 shadow-sm">
        <table class="table align-middle mb-0">
          <thead class="table-light">
          <tr>
            <th style="width:15%">Mã đơn</th>
            <th style="width:25%">Ngày</th>
            <th style="width:25%">Trạng thái</th>
            <th class="text-end" style="width:20%">Tổng</th>
            <th style="width:15%"></th>
          </tr>
          </thead>
          <tbody>
          <c:choose>
            <c:when test="${empty orders}">
              <tr><td colspan="5" class="text-center text-muted py-4">Chưa có đơn hàng.</td></tr>
            </c:when>
            <c:otherwise>
              <c:forEach var="o" items="${orders}">
                <tr>
                  <td>#${o.id}</td>
                  <td><fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                  <td><span class="badge bg-secondary">${o.status}</span></td>
                  <td class="text-end"><fmt:formatNumber value="${o.total}" type="number" groupingUsed="true"/> đ</td>
                  <td class="text-end">
                    <a class="btn btn-sm btn-outline-primary" href="${cxt}/order?id=${o.id}">Xem</a>
                  </td>
                </tr>
              </c:forEach>
            </c:otherwise>
          </c:choose>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<footer class="border-top mt-5">
  <div class="container py-4 text-muted small">© 2025 Vua Đồ Câu</div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<jsp:include page="/WEB-INF/views/partials/mini-cart.jsp" />

</body>
</html>
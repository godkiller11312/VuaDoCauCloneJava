<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <title>Chi tiết sản phẩm #${p.id}</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <style>
    :root{ --teal:#22b8a7 }
    .bg-soft{
      background:
        radial-gradient(1200px 600px at 10% 0%, #eaf6ff 0, rgba(255,255,255,.9) 60%),
        radial-gradient(1200px 600px at 90% 100%, #eafff9 0, rgba(255,255,255,.9) 60%);
    }
    .nav-admin .navbar-nav{flex-direction:row;margin-left:0!important}
    .nav-admin .navbar-brand{margin-right:.75rem}
    .nav-admin .nav-link{padding-left:.75rem;padding-right:.75rem}
    .thumb-xl{width:280px;height:280px;object-fit:cover;border-radius:12px;background:#f6f7ff}
    .stat{min-width:140px}
  </style>
</head>
<body class="bg-soft">
<c:set var="cxt" value="${pageContext.request.contextPath}" />
<c:set var="auth" value="${sessionScope.authUser}" />
<c:set var="isAdmin" value="${not empty auth and auth.roleId == 1}" />

<!-- NAVBAR admin (giống trang products.jsp) -->
<nav class="navbar navbar-expand-lg bg-white shadow-sm nav-admin">
  <div class="container">
    <a class="navbar-brand fw-bold me-2" href="${cxt}/home">VuaĐồCâu</a>
    <ul class="navbar-nav flex-row gap-3 align-items-center">
      <li class="nav-item"><a class="nav-link text-danger fw-semibold" href="${cxt}/admin/products">Quản Lý Sản phẩm</a></li>
      <li class="nav-item"><a class="nav-link" href="${cxt}/admin/orders">Quản Lý Đơn hàng</a></li>
    </ul>
    <div class="flex-grow-1"></div>
    <div class="dropdown">
      <button class="btn btn-outline-secondary rounded-pill dropdown-toggle px-3" data-bs-toggle="dropdown">
        ${sessionScope.authUser.email}
      </button>
      <ul class="dropdown-menu dropdown-menu-end shadow">
        <li><a class="dropdown-item" href="${cxt}/profile">Hồ sơ cá nhân</a></li>
        <li><hr class="dropdown-divider"></li>
        <li><a class="dropdown-item text-danger" href="${cxt}/logout">Đăng xuất</a></li>
      </ul>
    </div>
  </div>
</nav>

<div class="container py-4">
  <div class="d-flex align-items-center mb-3">
    <h3 class="fw-bold me-auto">Chi tiết sản phẩm #${p.id}</h3>
    <a class="btn btn-outline-secondary me-2" href="${cxt}/admin/products">← Quay lại danh sách</a>
    <a class="btn btn-success" style="background:var(--teal);border-color:var(--teal)"
       href="${cxt}/admin/products?action=detail&id=${p.id}">Refresh</a>
  </div>

  <div class="row g-4">
    <!-- Ảnh -->
    <div class="col-lg-4">
      <div class="bg-white p-3 rounded-3 shadow-sm text-center">
        <img class="thumb-xl"
             src="${cxt}/asset/images/${p.image}"
             onerror="this.src='${cxt}/asset/images/no-image.png'">
        <div class="mt-2 small text-muted">Tệp ảnh: ${p.image}</div>
      </div>
    </div>

    <!-- Thông tin -->
    <div class="col-lg-8">
      <div class="bg-white p-3 rounded-3 shadow-sm">
        <h4 class="mb-1">${p.name}</h4>
        <div class="text-muted mb-3">
          Danh mục: <span class="fw-semibold">${p.categoryName}</span>
          <c:if test="${not empty p.brandName}"> · Thương hiệu: <span class="fw-semibold">${p.brandName}</span></c:if>
          <c:if test="${empty p.brandName && not empty p.brandId}"> · Mã TH: <span class="fw-semibold">${p.brandId}</span></c:if>
        </div>

        <div class="d-flex flex-wrap gap-2 mb-3">
          <div class="stat bg-light rounded-3 p-3">
            <div class="text-muted small">Giá</div>
            <div class="fw-bold"><fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/> đ</div>
          </div>
          <div class="stat bg-light rounded-3 p-3">
            <div class="text-muted small">Tồn kho</div>
            <div class="fw-bold">${p.stock}</div>
          </div>
          <div class="stat bg-light rounded-3 p-3">
            <div class="text-muted small">Rating</div>
            <div class="fw-bold"><fmt:formatNumber value="${p.rating}" type="number" maxFractionDigits="1"/></div>
          </div>
          <div class="stat bg-light rounded-3 p-3">
            <div class="text-muted small">Đã mua</div>
            <div class="fw-bold">${p.purchased}</div>
          </div>
        </div>

        <div>
          <div class="text-muted mb-1">Mô tả</div>
          <div>${empty p.description ? '<em>(Chưa có mô tả)</em>' : p.description}</div>
        </div>

        <hr>
        <div class="d-flex gap-2">
          <a class="btn btn-outline-secondary"
             href="${cxt}/admin/products#row-${p.id}"
             onclick="history.back();return false;">Quay lại</a>

          <!-- Mở modal Sửa giống trang danh sách: đẩy data-* qua URL nếu bạn muốn dùng lại modal -->
          <a class="btn btn-primary"
             href="${cxt}/admin/products?action=detail&id=${p.id}"
             data-bs-toggle="modal" data-bs-target="#modalEdit"
             style="pointer-events:none;opacity:.6"
             title="(Tùy chọn) Có thể tái sử dụng modal Sửa từ trang danh sách">Sửa (modal)</a>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
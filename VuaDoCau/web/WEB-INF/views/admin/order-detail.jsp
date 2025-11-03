<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <title>Chi tiết đơn #${order.id}</title>
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
    .thumb{width:56px;height:56px;object-fit:cover;border-radius:8px;background:#f6f7ff}
  </style>
</head>
<body class="bg-soft">
<c:set var="cxt" value="${pageContext.request.contextPath}" />

<nav class="navbar navbar-expand-lg bg-white shadow-sm nav-admin">
  <div class="container">
    <a class="navbar-brand fw-bold me-2" href="${cxt}/home">VuaĐồCâu</a>
    <ul class="navbar-nav flex-row gap-3 align-items-center">
      <li class="nav-item"><a class="nav-link text-danger fw-semibold" href="${cxt}/admin/products">Quản Lý Sản phẩm</a></li>
      <li class="nav-item"><a class="nav-link text-danger fw-semibold" href="${cxt}/admin/orders">Quản Lý Đơn hàng</a></li>
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
    <h3 class="fw-bold me-auto">Chi tiết đơn hàng #${order.id}</h3>
    <a class="btn btn-outline-secondary" href="${cxt}/admin/orders">← Quay lại danh sách</a>
  </div>

  <!-- Thông tin đơn -->
  <div class="bg-white rounded-3 shadow-sm p-3 mb-3">
    <div class="row g-3">
      <div class="col-md-3">
        <div class="text-muted small">Ngày đặt</div>
        <div class="fw-semibold"><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div>
      </div>
      <div class="col-md-3">
        <div class="text-muted small">Trạng thái</div>
        <span class="badge bg-secondary">${order.status}</span>
      </div>
      <div class="col-md-3">
        <div class="text-muted small">Khách hàng</div>
        <div class="fw-semibold">${order.fullName}</div>
        <div class="small text-muted">${order.email}</div>
      </div>
      <div class="col-md-3">
        <div class="text-muted small">Ghi chú</div>
        <div>${empty order.note ? '<em>(không)</em>' : order.note}</div>
      </div>
    </div>
  </div>

  <!-- Bảng chi tiết sp -->
  <div class="bg-white rounded-3 shadow-sm p-3">
    <div class="table-responsive">
      <table class="table align-middle mb-0">
        <thead class="table-light">
        <tr>
          <th>#</th>
          <th></th>
          <th>Sản phẩm</th>
          <th class="text-end">Đơn giá</th>
          <th class="text-center">SL</th>
          <th class="text-end">Thành tiền</th>
        </tr>
        </thead>
        <tbody>
        <c:set var="i" value="0"/>
        <c:forEach var="it" items="${order.items}">
          <c:set var="i" value="${i+1}"/>
          <tr>
            <td>${i}</td>
            <td><img class="thumb" src="${cxt}/asset/images/${it.image}" onerror="this.src='${cxt}/asset/images/no-image.png'"></td>
            <td>${it.name}</td>
            <td class="text-end"><fmt:formatNumber value="${it.price}" type="number" groupingUsed="true"/> đ</td>
            <td class="text-center">${it.quantity}</td>
            <td class="text-end"><fmt:formatNumber value="${it.subtotal}" type="number" groupingUsed="true"/> đ</td>
          </tr>
        </c:forEach>
        </tbody>
        <tfoot>
        <tr>
          <th colspan="5" class="text-end">Tạm tính</th>
          <th class="text-end"><fmt:formatNumber value="${order.subtotal}" type="number" groupingUsed="true"/> đ</th>
        </tr>
        <tr>
          <th colspan="5" class="text-end">Phí vận chuyển</th>
          <th class="text-end"><fmt:formatNumber value="${order.shipFee}" type="number" groupingUsed="true"/> đ</th>
        </tr>
        <tr>
          <th colspan="5" class="text-end">Tổng cộng</th>
          <th class="text-end text-primary"><fmt:formatNumber value="${order.total}" type="number" groupingUsed="true"/> đ</th>
        </tr>
        </tfoot>
      </table>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
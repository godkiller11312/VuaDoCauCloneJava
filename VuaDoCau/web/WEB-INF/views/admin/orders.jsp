<%@ page contentType="text/html; charset=UTF-8" %> 
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <title>Quản Lý Đơn hàng</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <style>
    :root{ --teal:#22b8a7 }
    .bg-soft{
      background: radial-gradient(1200px 600px at 10% 0%, #eaf6ff 0, rgba(255,255,255,.9) 60%),
                  radial-gradient(1200px 600px at 90% 100%, #eafff9 0, rgba(255,255,255,.9) 60%);
    }
    .nav-admin .navbar-nav{flex-direction:row;margin-left:0!important}
    .nav-admin .navbar-brand{margin-right:.75rem}
    .nav-admin .nav-link{padding-left:.75rem;padding-right:.75rem}
  </style>
</head>
<body class="bg-soft">
<c:set var="cxt" value="${pageContext.request.contextPath}" />

<!-- NAVBAR gọn cho admin -->
<nav class="navbar navbar-expand-lg bg-white shadow-sm nav-admin">
  <div class="container">
    <div class="d-flex align-items-center w-100">
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
  </div>
</nav>

<div class="container py-4">
  <div class="d-flex align-items-center mb-3">
    <h3 class="fw-bold me-auto">Quản Lý Đơn hàng</h3>
  </div>

  <c:if test="${not empty sessionScope.flash_success}">
    <div class="alert alert-success">${sessionScope.flash_success}</div>
    <c:remove var="flash_success" scope="session"/>
  </c:if>
  <c:if test="${not empty sessionScope.flash_error}">
    <div class="alert alert-danger">${sessionScope.flash_error}</div>
    <c:remove var="flash_error" scope="session"/>
  </c:if>

  <!-- Bộ lọc -->
  <form class="row g-2 mb-3" method="get" action="${cxt}/admin/orders">
    <div class="col-md-4">
      <input class="form-control" type="text" name="q" value="${q}" placeholder="Tìm: mã đơn / email / tên KH">
    </div>
    <div class="col-md-3">
      <select class="form-select" name="status">
        <option value="">Tất cả trạng thái</option>
        <c:forEach var="st" items="${['NEW','CONFIRMED','SHIPPING','DONE','CANCELED']}">
          <option value="${st}" ${status==st?'selected':''}>${st}</option>
        </c:forEach>
      </select>
    </div>
    <div class="col-md-2">
      <button class="btn btn-outline-primary w-100">Lọc</button>
    </div>
  </form>

  <div class="table-responsive bg-white rounded-3 shadow-sm">
    <table class="table align-middle mb-0">
      <thead class="table-light">
      <tr>
        <th>Mã</th>
        <th>Ngày</th>
        <th>Khách</th>
        <th>Trạng thái</th>
        <th class="text-end">Tổng</th>
        <th class="text-end">Thao tác</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach var="o" items="${orders}">
        <tr>
          <td>#${o.id}</td>
          <td><fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
          <td>
            <div class="small fw-semibold">${o.fullName}</div>
            <div class="small text-muted">${o.email}</div>
          </td>
          <td><span class="badge bg-secondary">${o.status}</span></td>
          <td class="text-end"><fmt:formatNumber value="${o.total}" type="number" groupingUsed="true"/> đ</td>
          <td class="text-end">
            <!-- Nút Xem chi tiết -->
            <a class="btn btn-sm btn-outline-primary me-2"
               href="${cxt}/admin/orders?action=detail&id=${o.id}">
              Xem
            </a>

            <!-- Cập nhật trạng thái -->
            <form method="post" action="${cxt}/admin/orders" class="d-inline">
              <input type="hidden" name="action" value="updateStatus">
              <input type="hidden" name="id" value="${o.id}">
              <select name="status" class="form-select form-select-sm d-inline-block" style="width:auto">
                <c:forEach var="st" items="${['NEW','CONFIRMED','SHIPPING','DONE','CANCELED']}">
                  <option value="${st}" ${o.status==st?'selected':''}>${st}</option>
                </c:forEach>
              </select>
              <button class="btn btn-sm btn-outline-primary">Cập nhật</button>
            </form>
          </td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
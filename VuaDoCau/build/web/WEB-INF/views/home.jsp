<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>VuaĐồCâu - Trang chủ</title>
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
    .thumb{ background:#f6f7ff }
    .card-title{ white-space:nowrap; overflow:hidden; text-overflow:ellipsis }
    .nav-admin .navbar-nav{flex-direction:row;margin-left:0!important}
    .nav-admin .navbar-brand{margin-right:.75rem}
    .nav-admin .nav-link{padding-left:.75rem;padding-right:.75rem}
  </style>
</head>
<body class="bg-soft">
<c:set var="cxt" value="${pageContext.request.contextPath}" />
<c:set var="auth" value="${sessionScope.authUser}" />
<c:set var="isAdmin" value="${not empty auth and auth.roleId == 1}" />

<nav class="navbar navbar-expand-lg bg-white shadow-sm nav-admin">
  <div class="container">
    <div class="d-flex align-items-center w-100">

      <a class="navbar-brand fw-bold me-2" href="${cxt}/home">VuaĐồCâu</a>

      <ul class="navbar-nav flex-row gap-3 align-items-center">
        <c:if test="${isAdmin}">
          <li class="nav-item">
            <a class="nav-link text-danger fw-semibold" href="${cxt}/admin/products">Quản Lý Sản phẩm</a>
          </li>
          <li class="nav-item">
            <a class="nav-link text-danger fw-semibold" href="${cxt}/admin/orders">Quản Lý Đơn hàng</a>
          </li>
        </c:if>

        <c:if test="${!isAdmin}">
          <li class="nav-item"><a class="nav-link" href="${cxt}/home">Trang chủ</a></li>
          <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">Danh mục</a>
            <ul class="dropdown-menu">
              <li><a class="dropdown-item" href="${cxt}/products?g=all">Tất cả sản phẩm</a></li>
              <li><a class="dropdown-item" href="${cxt}/products?g=can">Cần câu</a></li>
              <li><a class="dropdown-item" href="${cxt}/products?g=may">Máy câu</a></li>
              <li><a class="dropdown-item" href="${cxt}/products?g=khac">Dây, Mồi, Phụ kiện</a></li>
            </ul>
          </li>
        </c:if>
      </ul>

      <div class="flex-grow-1"></div>

      <c:if test="${!isAdmin}">
        <form class="d-none d-lg-flex me-2" style="max-width:520px" method="get" action="${cxt}/products">
          <input class="form-control me-2" type="search" name="q" placeholder="Tìm sản phẩm...">
          <button class="btn btn-teal">Tìm</button>
        </form>
      </c:if>

      <c:choose>
        <c:when test="${not empty sessionScope.authUser}">
          <div class="dropdown">
            <button class="btn btn-outline-secondary rounded-pill dropdown-toggle px-3" type="button" data-bs-toggle="dropdown">
              ${sessionScope.authUser.email}
            </button>
            <ul class="dropdown-menu dropdown-menu-end shadow">
              <c:if test="${!isAdmin}">
                <li>
                  <a class="dropdown-item d-flex justify-content-between align-items-center" href="${cxt}/cart">
                    Giỏ hàng
                    <span class="badge text-bg-primary">
                      ${empty sessionScope.cartCount ? 0 : sessionScope.cartCount}
                    </span>
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
  </div>
</nav>

<div class="container py-4">
  <c:if test="${isAdmin}">
    <div class="row justify-content-center">
      <div class="col-12 col-lg-10">
        <div class="p-4 p-lg-5 bg-white border rounded-4 shadow-sm">
          <h3 class="fw-bold mb-1">Bảng điều khiển</h3>
          <p class="text-muted mb-4">Chọn khu vực quản trị để tiếp tục.</p>

          <div class="row g-3 g-md-4">
            <div class="col-12 col-md-6">
              <a class="text-decoration-none" href="${cxt}/admin/products">
                <div class="border rounded-4 p-4 h-100 shadow-sm">
                  <div class="fs-5 fw-semibold mb-1 text-danger">Quản lý Sản phẩm</div>
                  <div class="text-muted">Thêm/sửa/xóa, lọc & tìm kiếm sản phẩm.</div>
                </div>
              </a>
            </div>
            <div class="col-12 col-md-6">
              <a class="text-decoration-none" href="${cxt}/admin/orders">
                <div class="border rounded-4 p-4 h-100 shadow-sm">
                  <div class="fs-5 fw-semibold mb-1 text-danger">Quản lý Đơn hàng</div>
                  <div class="text-muted">Duyệt đơn, trạng thái & chi tiết đặt hàng.</div>
                </div>
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </c:if>

  <c:if test="${!isAdmin}">
    <c:forEach var="entry" items="${sections}">
      <c:set var="cat"  value="${entry.key}"/>
      <c:set var="list" value="${entry.value}"/>

      <div class="d-flex align-items-baseline mb-2 mt-4">
        <h4 class="me-auto fw-bold">${cat.name}</h4>
        <a class="text-decoration-none" href="${cxt}/products?cat=${cat.id}">Xem tất cả →</a>
      </div>

      <c:choose>
        <c:when test="${empty list}">
          <div class="alert alert-light border">Chưa có sản phẩm.</div>
        </c:when>
        <c:otherwise>
          <div class="row g-4">
            <c:forEach items="${list}" var="p">
              <div class="col-12 col-sm-6 col-md-4 col-lg-3">
                <div class="card h-100 shadow-sm rounded-4 border-0">
                  <div class="ratio ratio-1x1 rounded-top-4 d-flex align-items-center justify-content-center thumb">
                    <img class="p-4"
                         src="${cxt}/asset/images/${p.image != null ? p.image : 'no-image.png'}"
                         alt="${p.name}"
                         onerror="this.src='${cxt}/asset/images/no-image.png'">
                  </div>
                  <div class="card-body">
                    <span class="badge bg-light text-dark mb-2">${p.categoryName}</span>
                    <h6 class="card-title">${p.name}</h6>
                    <div class="small text-muted">
                      ★ <fmt:formatNumber value="${p.rating}" type="number" maxFractionDigits="1"/> ·
                      Đã mua: ${p.purchased}
                    </div>
                    <div class="mt-2 fw-bold text-danger">
                      <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/> đ
                    </div>
                    <div class="mt-3 d-grid">
                      <a class="btn btn-teal rounded-pill" href="${cxt}/cart?action=add&id=${p.id}">Thêm vào giỏ</a>
                    </div>
                  </div>
                </div>
              </div>
            </c:forEach>
          </div>
        </c:otherwise>
      </c:choose>
    </c:forEach>
  </c:if>
</div>

<footer class="border-top mt-5">
  <div class="container py-4 text-muted small">© 2025 Vua Đồ Câu</div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<c:if test="${!isAdmin}">
  <jsp:include page="/WEB-INF/views/partials/mini-cart.jsp" />
</c:if>
</body>
</html>
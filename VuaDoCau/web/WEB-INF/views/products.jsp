<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Trang chủ - VuaĐồCâu</title>

  <!-- Bootstrap (CDN) -->
  <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css"/>
</head>
<body class="bg-soft">

<nav class="navbar navbar-expand-lg bg-white shadow-sm">
  <div class="container">
    <a class="navbar-brand fw-bold d-flex align-items-center"
       href="${pageContext.request.contextPath}/products">
      <img src="${pageContext.request.contextPath}/assets/images/no-image.png"
           alt="" height="28" class="me-2"/>
      VuaĐồCâu
    </a>
    <form class="d-flex ms-auto" role="search">
      <input class="form-control me-2" type="search" placeholder="Tìm sản phẩm, thương hiệu">
      <button class="btn btn-teal" type="button">Tìm</button>
    </form>
    <div class="dropdown ms-3">
      <button class="btn btn-outline-secondary dropdown-toggle" data-bs-toggle="dropdown">
        thson16023@gmail.com
      </button>
      <ul class="dropdown-menu">
        <li><a class="dropdown-item" href="#">Đơn hàng</a></li>
        <li><a class="dropdown-item" href="#">Đăng xuất</a></li>
      </ul>
    </div>
  </div>
</nav>

<section class="container py-4">
  <h3 class="mb-3 fw-bold">Sản phẩm</h3>

  <div class="row g-4">
    <c:forEach items="${products}" var="p">
      <div class="col-12 col-sm-6 col-md-4 col-lg-3">
        <div class="card h-100 shadow-sm rounded-4 border-0">
          <div class="ratio ratio-1x1 rounded-top-4 d-flex align-items-center justify-content-center thumb">
            <img class="p-4"
                 src="${pageContext.request.contextPath}/assets/images/${p.image}"
                 alt="${p.name}"
                 onerror="this.src='${pageContext.request.contextPath}/assets/images/no-image.png'">
          </div>
          <div class="card-body">
            <span class="badge bg-soft-gray text-dark mb-2">${p.tag}</span>
            <h6 class="card-title">${p.name}</h6>
            <div class="small text-muted">
              <span class="text-warning">
                <c:set var="round" value="${(p.rating + 0.5) - (p.rating + 0.5) % 1}" />
                <c:forEach var="i" begin="1" end="5">
                  <c:choose>
                    <c:when test="${i <= round}">★</c:when>
                    <c:otherwise>☆</c:otherwise>
                  </c:choose>
                </c:forEach>
              </span>
              <span class="ms-1">(${p.rating})</span>
              <span class="ms-2">Đã mua: ${p.purchased}</span>
            </div>
            <div class="mt-2 fw-bold text-danger">
              <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/> đ
            </div>
            <div class="mt-3 d-grid">
              <a class="btn btn-teal rounded-pill" href="#">Thêm vào giỏ</a>
            </div>
          </div>
        </div>
      </div>
    </c:forEach>
  </div>
</section>

<footer class="border-top mt-5">
  <div class="container py-4 d-flex flex-wrap gap-3">
    <div class="me-auto">
      <div class="fw-bold">VuaĐồCâu</div>
      <div class="text-muted small">Shop đồ câu & phụ kiện – chọn lọc, giá tốt, giao nhanh.</div>
      <div class="small">📧 thson16023@gmail.com · 📞 0886 214 922</div>
    </div>
    <form class="d-flex gap-2">
      <input type="email" class="form-control" placeholder="Email của bạn">
      <button class="btn btn-primary">Đăng ký</button>
    </form>
  </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
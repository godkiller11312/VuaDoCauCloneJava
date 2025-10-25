<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>VuaĐồCâu - Trang chủ</title>
  <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <style>
    :root { --teal:#22b8a7; }
    .bg-soft{background:radial-gradient(1200px 600px at 10% 0%,#eaf6ff 0,rgba(255,255,255,.9) 60%),
                             radial-gradient(1200px 600px at 90% 100%,#eafff9 0,rgba(255,255,255,.9) 60%);}
    .btn-teal{background:var(--teal);color:#fff;}
    .btn-teal:hover{filter:brightness(.95);color:#fff;}
    .thumb{background:#f6f7ff;}
    .card-title{white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}
  </style>
</head>
<body class="bg-soft">
<nav class="navbar navbar-expand-lg bg-white shadow-sm">
  <div class="container">
    <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/home">VuaĐồCâu</a>
    <ul class="navbar-nav me-3">
      <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
      <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">Danh mục</a>
        <ul class="dropdown-menu">
          <li><a class="dropdown-item" href="${pageContext.request.contextPath}/products?g=all">Tất cả sản phẩm</a></li>
          <c:forEach items="${sections.keySet()}" var="cat">
            <li><a class="dropdown-item"
                   href="${pageContext.request.contextPath}/products?cat=${cat.id}">${cat.name}</a></li>
          </c:forEach>
        </ul>
      </li>
    </ul>
    <form class="d-flex ms-auto" method="get" action="${pageContext.request.contextPath}/products">
      <input class="form-control me-2" type="search" name="q" placeholder="Tìm sản phẩm...">
      <button class="btn btn-teal">Tìm</button>
    </form>
  </div>
</nav>

<div class="container py-4">
  <c:forEach var="entry" items="${sections}">
    <c:set var="cat" value="${entry.key}"/>
    <c:set var="list" value="${entry.value}"/>

    <div class="d-flex align-items-baseline mb-2 mt-4">
      <h4 class="me-auto fw-bold">${cat.name}</h4>
      <a class="text-decoration-none"
         href="${pageContext.request.contextPath}/products?cat=${cat.id}">Xem tất cả →</a>
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
                       src="${pageContext.request.contextPath}/assets/images/${p.image != null ? p.image : 'no-image.png'}"
                       alt="${p.name}"
                       onerror="this.src='${pageContext.request.contextPath}/assets/images/no-image.png'">
                </div>

                <!-- 🟩 Giữ nguyên card-body giống products.jsp -->
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
                    <a class="btn btn-teal rounded-pill" href="#">Thêm vào giỏ</a>
                  </div>
                </div>
              </div>
            </div>
          </c:forEach>
        </div>
      </c:otherwise>
    </c:choose>
  </c:forEach>
</div>

<footer class="border-top mt-5">
  <div class="container py-4 text-muted small">© 2025 Vua Đồ Câu</div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
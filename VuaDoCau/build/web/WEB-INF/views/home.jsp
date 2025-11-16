<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="cxt" value="${pageContext.request.contextPath}" />
<c:set var="auth" value="${sessionScope.authUser}" />
<c:set var="isAdmin" value="${not empty auth and auth.roleId == 1}" />

<c:choose>
  <c:when test="${isAdmin}">
    <div class="container py-4">
      <h4 class="fw-bold mb-4">Bảng điều khiển Admin</h4>

      <div class="row g-4">
        <div class="col-12 col-md-6">
          <a href="${cxt}/admin/products" class="text-decoration-none">
            <div class="card shadow-sm border-0 rounded-4 p-3 d-flex flex-row align-items-center">
              <div class="me-3 rounded-circle d-flex align-items-center justify-content-center"
                   style="width:56px;height:56px;background:#e8f7f1">
                <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" fill="#16a085" viewBox="0 0 16 16">
                  <path d="M6 2a1 1 0 0 0-1 1v1H3.5A1.5 1.5 0 0 0 2 5.5v6A1.5 1.5 0 0 0 3.5 13h9A1.5 1.5 0 0 0 14 11.5v-6A1.5 1.5 0 0 0 12.5 4H11V3a1 1 0 0 0-1-1H6z"/>
                </svg>
              </div>
              <div class="flex-grow-1">
                <div class="fw-semibold text-dark">Quản lý sản phẩm</div>
                <div class="text-muted small">Thêm / sửa / xoá</div>
              </div>
            </div>
          </a>
        </div>

        <div class="col-12 col-md-6">
          <a href="${cxt}/admin/orders" class="text-decoration-none">
            <div class="card shadow-sm border-0 rounded-4 p-3 d-flex flex-row align-items-center">
              <div class="me-3 rounded-circle d-flex align-items-center justify-content-center"
                   style="width:56px;height:56px;background:#eef5ff">
                <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" fill="#2563eb" viewBox="0 0 16 16">
                  <path d="M0 1.5A.5.5 0 0 1 .5 1H2a.5.5 0 0 1 .485.379L2.89 3H14.5a.5.5 0 0 1 .491.592l-1.5 8A.5.5 0 0 1 13 12H4a.5.5 0 0 1-.491-.408L2.01 3.607 1.61 2H.5a.5.5 0 0 1-.5-.5z"/>
                </svg>
              </div>
              <div class="flex-grow-1">
                <div class="fw-semibold text-dark">Quản lý đơn hàng</div>
                <div class="text-muted small">Cập nhật trạng thái</div>
              </div>
            </div>
          </a>
        </div>

        <div class="col-12 col-md-6">
          <a href="${cxt}/admin/users" class="text-decoration-none">
            <div class="card shadow-sm border-0 rounded-4 p-3 d-flex flex-row align-items-center">
              <div class="me-3 rounded-circle d-flex align-items-center justify-content-center"
                   style="width:56px;height:56px;background:#fff4e5">
                <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" fill="#f59e0b" viewBox="0 0 16 16">
                  <path d="M3 14s-1 0-1-1 1-4 6-4 6 3 6 4-1 1-1 1H3z"/>
                  <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6z"/>
                </svg>
              </div>
              <div class="flex-grow-1">
                <div class="fw-semibold text-dark">Quản lý tài khoản</div>
                <div class="text-muted small">Sửa / đổi mật khẩu</div>
              </div>
            </div>
          </a>
        </div>
      </div>
    </div>
  </c:when>

  <c:otherwise>

    <div class="banner-wrapper mb-4">
      <div class="banner-slides">
        <div class="banner-slide active" style="background-image:url('${cxt}/asset/images/banner1.jpg')"></div>
        <div class="banner-slide" style="background-image:url('${cxt}/asset/images/banner2.jpg')"></div>
        <div class="banner-slide" style="background-image:url('${cxt}/asset/images/banner3.jpg')"></div>
      </div>

      <div class="banner-content">
        <h1 class="banner-title">KHÁM PHÁ THẾ GIỚI ĐỒ CÂU</h1>
        <p class="banner-subtitle">
          Cần câu – Máy câu – Phụ kiện chính hãng – đồng hành mọi chuyến đi câu của bạn.
        </p>
       
      </div>
    </div>

    <script>
      (function () {
        var slides = document.querySelectorAll('.banner-slide');
        if (!slides.length) return;
        var index = 0;
        setInterval(function () {
          slides[index].classList.remove('active');
          index = (index + 1) % slides.length;
          slides[index].classList.add('active');
        }, 8000); // đổi ảnh mỗi 8 giây
      })();
    </script>

    <c:forEach var="entry" items="${sections}">
      <c:set var="cat"  value="${entry.key}" />
      <c:set var="list" value="${entry.value}" />

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
                    <a href="${cxt}/product?id=${p.id}" class="d-block">
                      <img class="p-4"
                           src="${cxt}/asset/images/${p.image != null ? p.image : 'no-image.png'}"
                           alt="${p.name}"
                           onerror="this.src='${cxt}/asset/images/no-image.png'">
                    </a>
                  </div>
                  <div class="card-body">
                    <span class="badge bg-light text-dark mb-2">${p.categoryName}</span>

                    <h6 class="card-title" style="white-space:nowrap;overflow:hidden;text-overflow:ellipsis">
                      <a class="text-decoration-none text-dark" href="${cxt}/product?id=${p.id}">
                        ${p.name}
                      </a>
                    </h6>

                    <c:set var="r" value="${p.rating}" />
                    <div class="small text-muted d-flex align-items-center gap-2">
                      <span class="stars-outer">
                        <span class="stars-inner" style="width:${r * 20}%"></span>
                      </span>
                      <small>
                        <fmt:formatNumber value="${r}" minFractionDigits="1" maxFractionDigits="1"/>
                      </small>
                      · Đã mua: ${p.purchased}
                    </div>

                    <div class="small mt-1">
                      <c:choose>
                        <c:when test="${p.stock <= 0}">
                          <span class="text-danger">Hết hàng</span>
                        </c:when>
                        <c:otherwise>
                          Còn: <strong>${p.stock}</strong>
                        </c:otherwise>
                      </c:choose>
                    </div>

                    <div class="mt-2">
                      <c:if test="${p.oldPrice != null && p.oldPrice > 0 && p.oldPrice > p.price}">
                        <span class="price-old">
                          <fmt:formatNumber value="${p.oldPrice}" type="number" groupingUsed="true"/> đ
                        </span>
                      </c:if>
                      <span class="fw-bold text-danger">
                        <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/> đ
                      </span>
                    </div>

                    <div class="mt-3 d-grid">
                      <c:choose>
                        <c:when test="${p.stock <= 0}">
                          <button class="btn btn-secondary rounded-pill" disabled>Hết hàng</button>
                        </c:when>
                        <c:otherwise>
                          <a class="btn btn-teal rounded-pill btn-add-to-cart"
                             href="${cxt}/cart?action=add&id=${p.id}"
                             data-id="${p.id}" data-qty="1">
                            Thêm vào giỏ
                          </a>
                        </c:otherwise>
                      </c:choose>
                    </div>

                  </div>
                </div>
              </div>
            </c:forEach>
          </div>
        </c:otherwise>
      </c:choose>
    </c:forEach>

  </c:otherwise>
</c:choose>

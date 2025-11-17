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

    <%-- ================= USER HOME ================= --%>

    <!-- BANNER FULL SCREEN -->
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
        <a href="${cxt}/products"
           class="btn btn-outline-light rounded-pill px-4 py-2 mt-2 fw-semibold"
           style="border-width:2px; box-shadow:0 3px 12px rgba(0,0,0,.4);">
          Khám phá
        </a>
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
        }, 8000);
      })();
    </script>

    <%-- ====== TÌM THEO THỂ LOẠI ====== --%>
    <div class="browse-wrapper">
      <div class="container-xxl">
        <div class="row align-items-start g-4">

          <!-- Cột tiêu đề bên trái -->
          <div class="col-12 col-lg-3">
            <div class="browse-left">
              <h3 class="browse-title">Tìm theo thể loại</h3>
              <a href="${cxt}/products"
                 class="browse-view-all">
                Xem tất cả sản phẩm →
              </a>
            </div>
          </div>

          <!-- Cột các thẻ thể loại bên phải -->
          <div class="col-12 col-lg-9">
            <div class="row g-4 browse-grid">

              <div class="col-6 col-md-4 col-lg">
                <a href="${cxt}/products?q=Cần câu" class="browse-card text-decoration-none">
                  <div class="browse-thumb">
                    <img src="${cxt}/asset/images/browse-rod.jpg" alt="Cần câu">
                  </div>
                  <div class="browse-name">Cần câu</div>
                </a>
              </div>

              <div class="col-6 col-md-4 col-lg">
                <a href="${cxt}/products?q=Máy câu" class="browse-card text-decoration-none">
                  <div class="browse-thumb">
                    <img src="${cxt}/asset/images/browse-reel.jpg" alt="Máy câu">
                  </div>
                  <div class="browse-name">Máy câu</div>
                </a>
              </div>

              <div class="col-6 col-md-4 col-lg">
                <a href="${cxt}/products?q=Dây câu" class="browse-card text-decoration-none">
                  <div class="browse-thumb">
                    <img src="${cxt}/asset/images/browse-line.jpg" alt="Dây câu">
                  </div>
                  <div class="browse-name">Dây câu</div>
                </a>
              </div>

              <div class="col-6 col-md-4 col-lg">
                <a href="${cxt}/products?q=Mồi câu" class="browse-card text-decoration-none">
                  <div class="browse-thumb">
                    <img src="${cxt}/asset/images/browse-bait.jpg" alt="Mồi câu">
                  </div>
                  <div class="browse-name">Mồi câu</div>
                </a>
              </div>

              <div class="col-6 col-md-4 col-lg">
                <a href="${cxt}/products?q=Phụ kiện câu" class="browse-card text-decoration-none">
                  <div class="browse-thumb">
                    <img src="${cxt}/asset/images/browse-accessories.jpg" alt="Phụ kiện">
                  </div>
                  <div class="browse-name">Phụ kiện</div>
                </a>
              </div>

            </div>
          </div>

        </div>
      </div>
    </div>

    <%-- ====== 2 BANNER NGANG LỚN ====== --%>
    <div class="two-banner-wrapper" style="padding:0 3vw">
      <div class="container-xxl">
        <div class="row g-4">

          <div class="col-12 col-lg-6">
            <div class="home-promo-card home-promo-left">
              <div class="home-promo-content">
                <p class="home-promo-tag">COMBO HOT</p>
                <h2 class="home-promo-title">Bộ Đồ Câu<br>Cho Người Mới</h2>
                <p class="home-promo-text">Full set cần – máy – dây sẵn sàng đi câu!</p>
                <a href="${cxt}/products"
                   class="btn btn-outline-light rounded-pill px-4 py-2 fw-semibold home-promo-btn">
                  Khám phá →
                </a>
              </div>
            </div>
          </div>

          <div class="col-12 col-lg-6">
            <div class="home-promo-card home-promo-right">
              <div class="home-promo-content">
                <p class="home-promo-tag">GIẢM 25%</p>
                <h2 class="home-promo-title">Phụ kiện câu cá</h2>
                <p class="home-promo-text">Phao – lưỡi – chì – hộp phụ kiện giảm SỐC</p>
                <a href="${cxt}/products"
                   class="btn btn-outline-light rounded-pill px-4 py-2 fw-semibold home-promo-btn">
                  Xem ngay →
                </a>
              </div>
            </div>
          </div>

        </div>
      </div>
    </div>
    <%-- ====== END 2 BANNER ====== --%>

    <%-- ====== TOP SELLER (sau 2 banner) ====== --%>
    <c:set var="topList" value="${null}" />
    <c:forEach var="entry" items="${sections}" varStatus="stTop">
      <c:if test="${stTop.first}">
        <c:set var="topList" value="${entry.value}" />
      </c:if>
    </c:forEach>

    <c:if test="${not empty topList}">
      <div class="container top-seller-section mb-4">
        <div class="d-flex align-items-center mb-3">
          <h3 class="fw-bold mb-0 d-flex align-items-center">
            <span class="top-seller-fire me-2">🔥</span>
            TOP Seller
          </h3>
          <a href="${cxt}/products"
             class="text-decoration-none fw-semibold ms-auto">
            Xem tất cả sản phẩm →
          </a>
        </div>

        <div class="row flex-nowrap overflow-auto top-seller-row g-4">
          <c:forEach var="p" items="${topList}" varStatus="ts">
            <c:if test="${ts.index < 8}">
              <div class="col-8 col-sm-5 col-md-4 col-lg-3 top-seller-item">
               <div class="card h-100 shadow-sm rounded-4 border-0 product-card-hover">
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
            </c:if>
          </c:forEach>
        </div>
      </div>

      <script>
        (function () {
          var row = document.querySelector('.top-seller-row');
          if (!row) return;
          var firstItem = row.querySelector('.top-seller-item');
          if (!firstItem) return;

          function getStep() {
            var rect = firstItem.getBoundingClientRect();
            return rect.width + 20;
          }

          setInterval(function () {
            if (row.scrollWidth <= row.clientWidth) return;

            var step = getStep();
            var maxScroll = row.scrollWidth - row.clientWidth;
            var next = row.scrollLeft + step;

            if (next >= maxScroll + 4) {
              row.scrollTo({ left: 0, behavior: 'smooth' });
            } else {
              row.scrollBy({ left: step, behavior: 'smooth' });
            }
          }, 7000);
        })();
      </script>
    </c:if>
        <%-- ====== BANNER LỚN DƯỚI TOP SELLER ====== --%>
<div class="container single-promo-section">
  <div class="single-promo-card">
    <div class="single-promo-content">
      <p class="single-promo-tag">ƯU ĐÃI MÙA CÂU</p>
      <h2 class="single-promo-title">Combo Đồ Câu<br>Mùa Lễ Hội</h2>
      <p class="single-promo-text">
        Bộ cần – máy – phụ kiện đồng bộ, thiết kế riêng cho những chuyến đi câu dài ngày.
      </p>
      <a href="${cxt}/products"
         class="btn btn-outline-light rounded-pill px-4 py-2 fw-semibold home-promo-btn">
        Xem combo →
      </a>
    </div>
  </div>
</div>


    <%-- ====== END BANNER LỚN ====== --%>
    <%-- ====== CÁC SECTION THEO DANH MỤC ====== --%>
    <c:forEach var="entry" items="${sections}">
      <c:set var="cat"  value="${entry.key}" />
      <c:set var="list" value="${entry.value}" />

      <div class="container">
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

                      <c:set var="r2" value="${p.rating}" />
                      <div class="small text-muted d-flex align-items-center gap-2">
                        <span class="stars-outer">
                          <span class="stars-inner" style="width:${r2 * 20}%"></span>
                        </span>
                        <small>
                          <fmt:formatNumber value="${r2}" minFractionDigits="1" maxFractionDigits="1"/>
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
      </div>
    </c:forEach>

  </c:otherwise>
</c:choose>

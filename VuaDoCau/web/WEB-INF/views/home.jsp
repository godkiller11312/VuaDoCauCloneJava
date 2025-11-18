<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="cxt" value="${pageContext.request.contextPath}" />
<c:set var="auth" value="${sessionScope.authUser}" />
<c:set var="isAdmin" value="${not empty auth and auth.roleId == 1}" />

<c:choose>
  <%-- ================== ADMIN HOME ================== --%>
<c:when test="${isAdmin}">
  <div class="container py-4">
    <h4 class="fw-bold mb-4">Bảng điều khiển Admin</h4>

    <!-- GRID, KHÔNG CÒN SCROLL NGANG -->
    <div class="row row-cols-1 row-cols-md-2 row-cols-xl-3 g-4">

      <!-- QUẢN LÝ SẢN PHẨM -->
      <div class="col">
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

      <!-- QUẢN LÝ ĐƠN HÀNG -->
      <div class="col">
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

      <!-- QUẢN LÝ TÀI KHOẢN -->
      <div class="col">
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

    </div> <!-- END ROW -->
  </div>
</c:when>


  <%-- ================== USER HOME ================== --%>
  <c:otherwise>

    <%-- ===== HERO BANNER FULL WIDTH ===== --%>
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

    <%-- ===== TÌM THEO THỂ LOẠI ===== --%>
    <div class="browse-wrapper">
      <div class="container-xxl">
        <div class="row align-items-start g-4">

          <%-- Cột tiêu đề bên trái --%>
          <div class="col-12 col-lg-3">
            <div class="browse-left">
              <h3 class="browse-title">Tìm theo thể loại</h3>
              <a href="${cxt}/products" class="section-view-all">
                Xem tất cả sản phẩm →
              </a>
            </div>
          </div>

          <%-- Cột thẻ thể loại bên phải --%>
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

    <%-- ===== 2 BANNER NGANG LỚN ===== --%>
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
    <%-- ===== END 2 BANNER ===== --%>

    <%-- Lấy list đầu tiên từ sections làm TOP / NEW demo --%>
    <c:set var="topList" value="${null}" />
    <c:forEach var="entry" items="${sections}" varStatus="stTop">
      <c:if test="${stTop.first}">
        <c:set var="topList" value="${entry.value}" />
      </c:if>
    </c:forEach>

    <%-- ===== TOP SELLER (sau 2 banner) ===== --%>
    <c:if test="${not empty topList}">
      <div class="container top-seller-section mb-4">
        <div class="d-flex align-items-center mb-3">
          <h2 class="section-title mb-0">
            <span class="sec-ico">🔥</span> TOP Seller
          </h2>
          <a href="${cxt}/products" class="section-view-all ms-auto">
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

    <%-- ===== BANNER LỚN DƯỚI TOP SELLER ===== --%>
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
    <%-- ===== END BANNER LỚN ===== --%>

<%-- ===== SẢN PHẨM MỚI (dùng lại card chuẩn) ===== --%>
<div class="container new-products-section my-5">

  <div class="text-center mb-4">
    <h2 class="section-title">
      <span class="sec-ico">🔥</span> Sản phẩm mới
    </h2>
  </div>

  <%-- Hàng ngang, cuộn giống TOP Seller --%>
  <div class="row flex-nowrap overflow-auto g-4 new-products-row">
    <c:forEach var="p" items="${topList}" varStatus="st">
      <c:if test="${st.index < 8}"> <%-- cho nhiều hơn 4 nếu muốn --%>
        <div class="col-8 col-sm-5 col-md-4 col-lg-3 np-item">
          <div class="card h-100 shadow-sm rounded-4 border-0 product-card-hover np-card-wrapper">

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

              <c:set var="rNew" value="${p.rating}" />
              <div class="small text-muted d-flex align-items-center gap-2 mb-1">
                <span class="stars-outer">
                  <span class="stars-inner" style="width:${rNew * 20}%"></span>
                </span>
                <small>
                  <fmt:formatNumber value="${rNew}" minFractionDigits="1" maxFractionDigits="1"/>
                </small>
                · Đã mua: ${p.purchased}
              </div>

              <div class="small">
                <c:choose>
                  <c:when test="${p.stock <= 0}">
                    <span class="text-danger">Hết hàng</span>
                  </c:when>
                  <c:otherwise>
                    Còn: <strong>${p.stock}</strong>
                  </c:otherwise>
                </c:choose>
              </div>

              <div class="mt-2 mb-3">
                <c:if test="${p.oldPrice != null && p.oldPrice > 0 && p.oldPrice > p.price}">
                  <span class="price-old">
                    <fmt:formatNumber value="${p.oldPrice}" type="number" groupingUsed="true"/> đ
                  </span>
                </c:if>
                <span class="fw-bold text-danger">
                  <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/> đ
                </span>
              </div>

              <div class="mt-1 d-grid">
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

  <div class="text-center mt-4">
    <a href="${cxt}/products" class="section-view-all">
      Xem tất cả sản phẩm →
    </a>
  </div>
</div>
<%-- ===== END SẢN PHẨM MỚI ===== --%>

<!-- ================= VIP LEGENDARY ROD BANNER ================= -->
<div class="container my-5">
  <div class="legend-banner">

    <div class="legend-text">
      <p class="legend-tag">
        100% ĐẲNG CẤP – CHÍNH HÃNG
      </p>

  <h2 class="legend-title">
  Cần Câu Huyền Thoại<br>
  VIP & Chất Lượng Cao
</h2>

      <p class="legend-sub">
        Những mẫu cần cao cấp – độ bền tuyệt đối, thiết kế sang trọng, hiệu năng vượt trội.
        Lựa chọn số 1 của các cần thủ chuyên nghiệp.
      </p>

      <a href="${cxt}/products?vip=1"
         class="btn btn-outline-light legend-btn rounded-pill px-4 py-2 fw-semibold">
        Xem bộ sưu tập VIP →
      </a>
    </div>

  </div>
</div>
<!-- ================= END VIP LEGENDARY ROD BANNER ============= -->



<!-- ============= CUSTOMER REVIEWS SECTION ============= -->
<div class="container my-5 review-section">

  <div class="text-center mb-4">
    <h2 class="review-heading">
      3.000+ Cần thủ tin dùng VuaĐồCâu!
    </h2>
    <p class="review-sub">
      Hơn 200.000+ đánh giá (4.9/5 sao). Dưới đây là vài cảm nhận tiêu biểu của anh em cần thủ.
    </p>
  </div>

  <div class="row g-4 align-items-stretch position-relative">

    <!-- Card 1 -->
    <div class="col-12 col-md-4">
      <div class="review-card h-100">
        <div class="review-avatar">
          <img src="${cxt}/asset/images/review-angler-1.jpg" alt="Cần thủ 1">
        </div>
        <div class="review-body">
          <div class="review-stars">★★★★★</div>
          <p class="review-text">
            “Cần và máy rất chắc chắn, đóng cá lớn vẫn tự tin. Giao hàng nhanh,
            đóng gói kỹ càng, mình sẽ tiếp tục ủng hộ.”
          </p>
          <p class="review-name mb-0">Nguyễn Minh Anh</p>
          <p class="review-tag mb-0">Verified Purchaser</p>
        </div>
      </div>
    </div>

    <!-- Card 2 -->
    <div class="col-12 col-md-4">
      <div class="review-card h-100">
        <div class="review-avatar">
          <img src="${cxt}/asset/images/review-angler-2.jpg" alt="Cần thủ 2">
        </div>
        <div class="review-body">
          <div class="review-stars">★★★★★</div>
          <p class="review-text">
            “Combo đồ câu cho người mới quá ổn so với giá. Tư vấn nhiệt tình,
            đi chuyến đầu tiên đã có cá mang về rồi!”
          </p>
          <p class="review-name mb-0">Trần Hoàng Phúc</p>
          <p class="review-tag mb-0">Khách hàng thân thiết</p>
        </div>
      </div>
    </div>

    <!-- Card 3 -->
    <div class="col-12 col-md-4">
      <div class="review-card h-100">
        <div class="review-avatar">
          <img src="${cxt}/asset/images/review-angler-3.jpg" alt="Cần thủ 3">
        </div>
        <div class="review-body">
          <div class="review-stars">★★★★★</div>
          <p class="review-text">
            “Shop có nhiều phụ kiện hiếm, giá mềm. Đặt online nhưng nhận hàng
            đúng như hình, rất hài lòng.”
          </p>
          <p class="review-name mb-0">Lê Hữu Tài</p>
          <p class="review-tag mb-0">Verified Purchaser</p>
        </div>
      </div>
    </div>

  </div>

  <!-- Hàng logo hãng cần câu / phụ kiện -->
  <div class="review-logo-row mt-5 d-flex flex-wrap justify-content-center align-items-center gap-4 gap-md-5">
    <div class="review-logo-wrap">
      <img src="${cxt}/asset/images/logo-shimano.png" alt="Shimano" class="review-logo">
    </div>
    <div class="review-logo-wrap">
      <img src="${cxt}/asset/images/logo-daiwa.png" alt="Daiwa" class="review-logo">
    </div>
    <div class="review-logo-wrap">
      <img src="${cxt}/asset/images/logo-abu-garcia.png" alt="Abu Garcia" class="review-logo">
    </div>
    <div class="review-logo-wrap">
      <img src="${cxt}/asset/images/logo-rapala.png" alt="Rapala" class="review-logo">
    </div>
    <div class="review-logo-wrap">
      <img src="${cxt}/asset/images/logo-owner.png" alt="Owner" class="review-logo">
    </div>
  </div>
</div>
<!-- =========== END CUSTOMER REVIEWS SECTION =========== -->

<!-- ============= FISHING BLOG / NEWS SECTION ============= -->
<div class="container blog-section my-5">

  <div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="blog-heading mb-0">Tin tức & Kinh nghiệm câu cá</h2>
    <a href="#" class="blog-view-all">Xem tất cả bài viết →</a>
  </div>

  <div class="row g-4">
    <!-- Card 1 -->
    <div class="col-12 col-md-6 col-lg-3">
      <article class="blog-card h-100">
        <div class="blog-thumb">
          <img src="${cxt}/asset/images/blog-fishing-1.jpg" alt="Đi câu sớm bình minh">
          <div class="blog-badge">
            <span class="blog-day">22</span>
            <span class="blog-month">THÁNG 5</span>
          </div>
        </div>
        <div class="blog-body">
          <div class="blog-meta">
            MẸO CÂU CÁ · POST BY ADMIN
          </div>
          <h3 class="blog-title">
            5 mẹo đơn giản để tăng tỉ lệ dính cá mỗi buổi sáng
          </h3>
          <a href="#" class="blog-link">Đọc tiếp →</a>
        </div>
      </article>
    </div>

    <!-- Card 2 -->
    <div class="col-12 col-md-6 col-lg-3">
      <article class="blog-card h-100">
        <div class="blog-thumb">
          <img src="${cxt}/asset/images/blog-fishing-2.jpg" alt="Chọn cần câu cho người mới">
          <div class="blog-badge">
            <span class="blog-day">19</span>
            <span class="blog-month">THÁNG 6</span>
          </div>
        </div>
        <div class="blog-body">
          <div class="blog-meta">
            HƯỚNG DẪN · POST BY ADMIN
          </div>
          <h3 class="blog-title">
            Cách chọn cần & máy câu phù hợp cho người mới bắt đầu
          </h3>
          <a href="#" class="blog-link">Đọc tiếp →</a>
        </div>
      </article>
    </div>

    <!-- Card 3 -->
    <div class="col-12 col-md-6 col-lg-3">
      <article class="blog-card h-100">
        <div class="blog-thumb">
          <img src="${cxt}/asset/images/blog-fishing-3.jpg" alt="Mồi câu tự trộn">
          <div class="blog-badge">
            <span class="blog-day">18</span>
            <span class="blog-month">THÁNG 7</span>
          </div>
        </div>
        <div class="blog-body">
          <div class="blog-meta">
            MỒI CÂU · POST BY ADMIN
          </div>
          <h3 class="blog-title">
            3 công thức mồi câu tự trộn siêu thơm, cá chép mê tít
          </h3>
          <a href="#" class="blog-link">Đọc tiếp →</a>
        </div>
      </article>
    </div>

    <!-- Card 4 -->
    <div class="col-12 col-md-6 col-lg-3">
      <article class="blog-card h-100">
        <div class="blog-thumb">
          <img src="${cxt}/asset/images/blog-fishing-4.jpg" alt="Chuyến câu hồ dịch vụ">
          <div class="blog-badge">
            <span class="blog-day">14</span>
            <span class="blog-month">THÁNG 8</span>
          </div>
        </div>
        <div class="blog-body">
          <div class="blog-meta">
            TRẢI NGHIỆM · POST BY ADMIN
          </div>
          <h3 class="blog-title">
            Nhật ký một ngày câu hồ dịch vụ: set đồ, chiến thuật & cảm xúc
          </h3>
          <a href="#" class="blog-link">Đọc tiếp →</a>
        </div>
      </article>
    </div>
  </div>
</div>
<!-- =========== END FISHING BLOG / NEWS SECTION =========== -->




  </c:otherwise>
</c:choose>


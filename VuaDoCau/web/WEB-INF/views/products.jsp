<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="cxt" value="${pageContext.request.contextPath}" />

<!-- Sao vàng: inline, không phụ thuộc site.css -->
<style>
  .stars{display:inline-flex;align-items:center;gap:2px}
  .stars .star{font-size:.95rem;line-height:1;color:#e5e7eb}   /* xám */
  .stars .star.filled{color:#f59e0b}                           /* vàng */
  .stars .star.half{
    background:linear-gradient(90deg,#f59e0b 50%,#e5e7eb 50%);
    -webkit-background-clip:text;background-clip:text;color:transparent
  }
</style>

<h3 class="mb-4">Sản phẩm</h3>

<div class="row g-4">
  <c:forEach var="p" items="${products}">
    <div class="col-12 col-sm-6 col-md-4 col-lg-3">
      <div class="card h-100 shadow-sm rounded-4 border-0">

        <!-- Ảnh sản phẩm -->
        <div class="ratio ratio-1x1 rounded-top-4 d-flex align-items-center justify-content-center thumb" style="background:#f6f7ff">
          <img class="p-4"
               src="${cxt}/asset/images/${p.image != null ? p.image : 'no-image.png'}"
               alt="${p.name}"
               onerror="this.src='${cxt}/asset/images/no-image.png'">
        </div>

        <div class="card-body">
          <!-- Danh mục -->
          <span class="badge bg-light text-dark mb-2">${p.categoryName}</span>

          <!-- Tên -->
          <h6 class="card-title" style="white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
            ${p.name}
          </h6>

          <!-- Sao vàng + đã mua (không cần CSS ngoài) -->
          <div class="small text-muted d-flex align-items-center gap-1">
            <c:set var="r" value="${p.rating}" />
            <span class="stars" aria-label="Đánh giá ${r}/5">
              <c:forEach var="i" begin="1" end="5">
                <c:choose>
                  <c:when test="${r >= i}">
                    <span class="star filled">★</span>
                  </c:when>
                  <c:when test="${r > (i - 1) && r < i}">
                    <span class="star half">★</span>
                  </c:when>
                  <c:otherwise>
                    <span class="star">★</span>
                  </c:otherwise>
                </c:choose>
              </c:forEach>
            </span>
            <span class="ms-1">· Đã mua: ${p.purchased}</span>
          </div>

          <!-- Giá -->
          <div class="mt-2 fw-bold text-danger">
            <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true" /> đ
          </div>

          <!-- Nút thêm vào giỏ (giữ nguyên để mini-cart hoạt động) -->
          <div class="mt-3 d-grid">
            <a class="btn btn-teal rounded-pill btn-add-to-cart"
               href="${cxt}/cart?action=add&id=${p.id}"
               data-id="${p.id}" data-qty="1">
              Thêm vào giỏ
            </a>
          </div>
        </div>

      </div>
    </div>
  </c:forEach>

  <c:if test="${empty products}">
    <div class="col-12">
      <div class="alert alert-light border text-center">Không có sản phẩm nào.</div>
    </div>
  </c:if>
</div>
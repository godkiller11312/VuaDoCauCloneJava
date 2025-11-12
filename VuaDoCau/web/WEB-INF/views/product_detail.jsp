<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="cxt" value="${pageContext.request.contextPath}" />
<c:set var="p" value="${requestScope.p}" />

<div class="row g-4">
  <div class="col-12 col-md-5">
    <div class="ratio ratio-1x1 rounded-4 d-flex align-items-center justify-content-center thumb">
      <img class="p-4 w-100 h-100"
           src="${cxt}/asset/images/${p.image != null ? p.image : 'no-image.png'}"
           alt="${p.name}"
           onerror="this.src='${cxt}/asset/images/no-image.png'">
    </div>
  </div>

  <div class="col-12 col-md-7">
    <span class="badge bg-light text-dark mb-2">${p.categoryName}</span>
    <h3 class="fw-bold mb-2">${p.name}</h3>

    <div class="small text-muted mb-2 d-flex align-items-center gap-2">
      <span class="stars-outer"><span class="stars-inner" style="width:${p.rating * 20}%"></span></span>
      <small><fmt:formatNumber value="${p.rating}" minFractionDigits="1" maxFractionDigits="1"/></small>
      · Đã mua: ${p.purchased}
    </div>

    <div class="mb-3">
      <c:if test="${p.oldPrice != null && p.oldPrice > 0 && p.oldPrice > p.price}">
        <span class="text-muted text-decoration-line-through me-2">
          <fmt:formatNumber value="${p.oldPrice}" type="number" groupingUsed="true"/> đ
        </span>
      </c:if>
      <span class="fw-bold text-danger fs-4">
        <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/> đ
      </span>
    </div>

    <div class="mb-3">
      <c:choose>
        <c:when test="${p.stock <= 0}">
          <span class="badge bg-danger">Hết hàng</span>
        </c:when>
        <c:otherwise>
          Còn: <strong>${p.stock}</strong>
        </c:otherwise>
      </c:choose>
    </div>

    <div class="mb-4">
      <c:out value="${p.description}" />
    </div>

    <div class="d-flex gap-2">
      <c:choose>
        <c:when test="${p.stock <= 0}">
          <button class="btn btn-secondary rounded-pill" disabled>Hết hàng</button>
        </c:when>
        <c:otherwise>
          <a class="btn btn-teal rounded-pill btn-add-to-cart"
             href="${cxt}/cart?action=add&id=${p.id}"
             data-id="${p.id}" data-qty="1">Thêm vào giỏ</a>
        </c:otherwise>
      </c:choose>
      <a class="btn btn-outline-secondary rounded-pill" href="${cxt}/products?g=all">← Tiếp tục mua sắm</a>
    </div>
  </div>
</div>

<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="cxt" value="${pageContext.request.contextPath}" />

<h3 class="mb-3 fw-bold">Sản phẩm</h3>

<c:choose>
  <c:when test="${empty products}">
    <div class="alert alert-info">Không có sản phẩm phù hợp.</div>
  </c:when>

  <c:otherwise>
    <div class="row g-4">
      <c:forEach items="${products}" var="p">
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

             <c:set var="r" value="${p.rating}" />
<div class="small text-muted d-flex align-items-center gap-2">
  <span class="stars-outer">
    <span class="stars-inner" style="width:${r * 20}%"></span>
  </span>
  <small><fmt:formatNumber value="${r}" minFractionDigits="1" maxFractionDigits="1"/></small>
  · Đã mua: ${p.purchased}
</div>

              <div class="mt-2 fw-bold text-danger">
                <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/> đ
              </div>

              <div class="mt-3 d-grid">
                <a class="btn btn-teal rounded-pill"
                   href="${cxt}/cart?action=add&id=${p.id}">Thêm vào giỏ</a>
              </div>
            </div>
          </div>
        </div>
      </c:forEach>
    </div>
  </c:otherwise>
</c:choose>
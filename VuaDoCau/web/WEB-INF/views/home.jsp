<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:forEach var="entry" items="${sections}">
  <c:set var="cat"  value="${entry.key}"/>
  <c:set var="list" value="${entry.value}"/>

  <div class="d-flex align-items-baseline mb-2 mt-4">
    <h4 class="me-auto fw-bold">${cat.name}</h4>
    <a class="text-decoration-none" href="${pageContext.request.contextPath}/products?cat=${cat.id}">
      Xem tất cả →
    </a>
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
              <div class="ratio ratio-1x1 rounded-top-4 d-flex align-items-center justify-content-center thumb" style="background:#f6f7ff">
                <img class="p-4"
                     src="${pageContext.request.contextPath}/asset/images/${p.image != null ? p.image : 'no-image.png'}"
                     alt="${p.name}"
                     onerror="this.src='${pageContext.request.contextPath}/asset/images/no-image.png'">
              </div>
              <div class="card-body">
                <span class="badge bg-light text-dark mb-2">${p.categoryName}</span>
                <h6 class="card-title" style="white-space:nowrap;overflow:hidden;text-overflow:ellipsis">${p.name}</h6>
                <div class="small text-muted">
                  ★ <fmt:formatNumber value="${p.rating}" type="number" maxFractionDigits="1"/> ·
                  Đã mua: ${p.purchased}
                </div>
                <div class="mt-2 fw-bold text-danger">
                  <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/> đ
                </div>
                <div class="mt-3 d-grid">
                  <a class="btn btn-teal rounded-pill"
                     href="${pageContext.request.contextPath}/cart?action=add&id=${p.id}">
                    Thêm vào giỏ
                  </a>
                </div>
              </div>
            </div>
          </div>
        </c:forEach>
      </div>
    </c:otherwise>
  </c:choose>
</c:forEach>
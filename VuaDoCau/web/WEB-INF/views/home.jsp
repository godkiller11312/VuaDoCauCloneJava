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
          <div class="card h-100 shadow-sm rounded-4 border-0 p-3 d-flex flex-row align-items-center">
            <div class="me-3 d-flex align-items-center justify-content-center rounded-circle"
                 style="width:56px;height:56px;background:#e8f7f1;">
              <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" fill="#16a085" viewBox="0 0 16 16">
                <path d="M6 2a1 1 0 0 0-1 1v1H3.5A1.5 1.5 0 0 0 2 5.5v6A1.5 1.5 0 0 0 3.5 13h9A1.5 1.5 0 0 0 14 11.5v-6A1.5 1.5 0 0 0 12.5 4H11V3a1 1 0 0 0-1-1H6zM5 4V3a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v1h1.5A2.5 2.5 0 0 1 15 5.5v6A2.5 2.5 0 0 1 12.5 14h-9A2.5 2.5 0 0 1 1 11.5v-6A2.5 2.5 0 0 1 3.5 3H5z"/>
              </svg>
            </div>
            <div class="flex-grow-1">
              <div class="fw-semibold text-dark">Quản lý sản phẩm</div>
              <div class="text-muted small">Thêm / sửa / xoá sản phẩm, danh mục…</div>
            </div>
          </div>
        </a>
      </div>

      <div class="col-12 col-md-6">
        <a href="${cxt}/admin/orders" class="text-decoration-none">
          <div class="card h-100 shadow-sm rounded-4 border-0 p-3 d-flex flex-row align-items-center">
            <div class="me-3 d-flex align-items-center justify-content-center rounded-circle"
                 style="width:56px;height:56px;background:#eef5ff;">
              <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" fill="#2563eb" viewBox="0 0 16 16">
                <path d="M0 1.5A.5.5 0 0 1 .5 1H2a.5.5 0 0 1 .485.379L2.89 3H14.5a.5.5 0 0 1 .491.592l-1.5 8A.5.5 0 0 1 13 12H4a.5.5 0 0 1-.491-.408L2.01 3.607 1.61 2H.5a.5.5 0 0 1-.5-.5z"/>
                <path d="M5 12a2 2 0 1 0 0 4 2 2 0 0 0 0-4zm7 0a2 2 0 1 0 0 4 2 2 0 0 0 0-4z"/>
              </svg>
            </div>
            <div class="flex-grow-1">
              <div class="fw-semibold text-dark">Quản lý đơn hàng</div>
              <div class="text-muted small">Xem / cập nhật trạng thái đơn</div>
            </div>
          </div>
        </a>
      </div>
    </div>
  </div>
</c:when>

  <c:otherwise>
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
                  <div class="ratio ratio-1x1 rounded-top-4 d-flex align-items-center justify-content-center thumb" style="background:#f6f7ff">
                    <img class="p-4"
                         src="${cxt}/asset/images/${p.image != null ? p.image : 'no-image.png'}"
                         alt="${p.name}"
                         onerror="this.src='${cxt}/asset/images/no-image.png'">
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
          </div>
        </c:otherwise>
      </c:choose>
    </c:forEach>
  </c:otherwise>
</c:choose>
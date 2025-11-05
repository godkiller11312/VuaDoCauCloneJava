<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="cxt" value="${pageContext.request.contextPath}" />
<c:set var="cart" value="${sessionScope.CART}" />
<c:set var="cartCount" value="${empty sessionScope.cartCount ? 0 : sessionScope.cartCount}" />

<%-- ✅ Chỉ cần có param fragment (bất cứ giá trị nào) hoặc requestScope.fragment là true => render FRAGMENT --%>
<c:set var="isFragment" value="${requestScope.fragment or not empty param.fragment}" />

<c:choose>

  <%-- ============ FRAGMENT: chỉ render phần body để JS thay vào #miniCartBody ============ --%>
  <c:when test="${isFragment}">
    <c:choose>
      <c:when test="${cart == null or empty cart.items}">
        <div class="text-center text-muted py-4">Giỏ hàng trống.</div>
      </c:when>
      <c:otherwise>
        <c:forEach var="it" items="${cart.items}">
          <div class="d-flex align-items-center border-bottom py-2">
            <img
              src="${empty it.image ? (cxt.concat('/asset/images/no-image.png')) : (cxt.concat('/asset/images/').concat(it.image))}"
              class="me-2 rounded" style="width:48px;height:48px;object-fit:cover" alt="">
            <div class="flex-grow-1 small">
              <div class="fw-semibold text-truncate"><c:out value="${it.name}"/></div>
              <div class="text-muted">SL: <c:out value="${it.quantity}"/></div>
            </div>
            <div class="text-end small fw-bold text-danger">
              <fmt:formatNumber value="${it.subtotal}" type="number" groupingUsed="true"/> đ
            </div>
          </div>
        </c:forEach>
        <div class="d-flex justify-content-between pt-2">
          <span class="fw-semibold">Tạm tính</span>
          <span class="fw-bold text-success">
            <fmt:formatNumber value="${cart.totalAmount}" type="number" groupingUsed="true"/> đ
          </span>
        </div>
      </c:otherwise>
    </c:choose>
  </c:when>

  <%-- ============ FULL WIDGET: nút nổi + offcanvas + container #miniCartBody ============ --%>
  <c:otherwise>
    <!-- Nút bay bay -->
    <button type="button" class="cart-fab" data-bs-toggle="offcanvas" data-bs-target="#miniCart"
            aria-controls="miniCart" title="Giỏ hàng">
      <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 16 16" width="22" height="22">
        <path d="M8 1a2.5 2.5 0 0 0-2.5 2.5V4h1v-.5a1.5 1.5 0 1 1 3 0V4h1v-.5A2.5 2.5 0 0 0 8 1"/>
        <path d="M3.5 4h9a.5.5 0 0 1 .5.5V14a2 2 0 0 1-2 2h-6a2 2 0 0 1-2-2V4.5a.5.5 0 0 1 .5-.5"/>
      </svg>
      <span class="cart-badge" id="miniCartCount"><c:out value="${cartCount}"/></span>
    </button>

    <!-- Offcanvas -->
    <div class="offcanvas offcanvas-end offcanvas-cart" tabindex="-1" id="miniCart" aria-labelledby="miniCartLabel">
      <div class="offcanvas-header">
        <h5 class="offcanvas-title fw-bold" id="miniCartLabel">
          Giỏ hàng (<span id="miniCartQty"><c:out value="${cartCount}"/></span>)
        </h5>
        <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Đóng"></button>
      </div>

      <div class="offcanvas-body" id="miniCartBody">
        <c:choose>
          <c:when test="${cart == null or empty cart.items}">
            <div class="text-center text-muted py-4">Giỏ hàng trống.</div>
          </c:when>
          <c:otherwise>
            <c:forEach var="it" items="${cart.items}">
              <div class="d-flex align-items-center border-bottom py-2">
                <img
                  src="${empty it.image ? (cxt.concat('/asset/images/no-image.png')) : (cxt.concat('/asset/images/').concat(it.image))}"
                  class="me-2 rounded" style="width:48px;height:48px;object-fit:cover" alt="">
                <div class="flex-grow-1 small">
                  <div class="fw-semibold text-truncate"><c:out value="${it.name}"/></div>
                  <div class="text-muted">SL: <c:out value="${it.quantity}"/></div>
                </div>
                <div class="text-end small fw-bold text-danger">
                  <fmt:formatNumber value="${it.subtotal}" type="number" groupingUsed="true"/> đ
                </div>
              </div>
            </c:forEach>
            <div class="d-flex justify-content-between pt-2">
              <span class="fw-semibold">Tạm tính</span>
              <span class="fw-bold text-success">
                <fmt:formatNumber value="${cart.totalAmount}" type="number" groupingUsed="true"/> đ
              </span>
            </div>
          </c:otherwise>
        </c:choose>
      </div>

      <div class="offcanvas-footer p-3 border-top">
        <a class="btn btn-success w-100 mb-2" href="${cxt}/checkout">Thanh toán</a>
        <a class="btn btn-outline-secondary w-100" href="${cxt}/cart" data-bs-dismiss="offcanvas">Xem giỏ hàng</a>
      </div>
    </div>

    <script>
      // cập nhật badge/qty (được scripts.jspf gọi)
      window.setMiniCartCount = function(n){
        const b = document.getElementById('miniCartCount');
        if (b) b.textContent = n;
        const q = document.getElementById('miniCartQty');
        if (q) q.textContent = n;
      };
    </script>
  </c:otherwise>

</c:choose>
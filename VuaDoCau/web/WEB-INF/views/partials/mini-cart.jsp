<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="cxt" value="${pageContext.request.contextPath}" />
<c:set var="cart" value="${sessionScope.CART}" />
<c:set var="cartCount" value="${empty sessionScope.cartCount ? 0 : sessionScope.cartCount}" />

<style>
  .cart-fab{position:fixed;right:20px;bottom:20px;z-index:1055;width:56px;height:56px;border-radius:50%;
    display:flex;align-items:center;justify-content:center;box-shadow:0 10px 20px rgba(0,0,0,.15)}
  .cart-fab .badge{position:absolute;top:-6px;right:-6px;border-radius:999px;padding:.3rem .45rem}
  .offcanvas-cart{width:360px;max-width:92vw}
  .cart-item-thumb{width:56px;height:56px;border-radius:.5rem;object-fit:cover;background:#f6f7ff}
  .cart-item{border-bottom:1px solid rgba(0,0,0,.06);padding:.75rem 0}
</style>

<button type="button" class="btn btn-success cart-fab"
        data-bs-toggle="offcanvas" data-bs-target="#miniCart"
        aria-controls="miniCart" title="Giỏ hàng">
  <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" fill="currentColor" class="bi bi-bag" viewBox="0 0 16 16">
    <path d="M8 1a2.5 2.5 0 0 0-2.5 2.5V4h1v-.5a1.5 1.5 0 1 1 3 0V4h1v-.5A2.5 2.5 0 0 0 8 1"/>
    <path d="M3.5 4h9a.5.5 0 0 1 .5.5V14a2 2 0 0 1-2 2h-6a2 2 0 0 1-2-2V4.5a.5.5 0 0 1 .5-.5"/>
  </svg>
  <span class="badge text-bg-danger" id="miniCartCount"><c:out value="${cartCount}"/></span>
</button>

<div class="offcanvas offcanvas-end offcanvas-cart" tabindex="-1" id="miniCart" aria-labelledby="miniCartLabel">
  <div class="offcanvas-header">
    <h5 class="offcanvas-title fw-bold" id="miniCartLabel">
      Giỏ hàng (<c:out value="${cartCount}"/>)
    </h5>
    <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Đóng"></button>
  </div>

  <div class="offcanvas-body">
    <c:choose>
      <c:when test="${cart == null or empty cart.items}">
        <div class="text-center text-muted py-4">Giỏ hàng trống.</div>
      </c:when>

      <c:otherwise>
        <c:forEach var="it" items="${cart.items}">
          <div class="cart-item d-flex align-items-center gap-3">
            <c:choose>
              <c:when test="${not empty it.image}">
                <img class="cart-item-thumb"
                     src="${cxt}/asset/images/${it.image}"
                     onerror="this.src='${cxt}/asset/images/no-image.png'"
                     alt="<c:out value='${it.name}'/>">
              </c:when>
              <c:otherwise>
                <img class="cart-item-thumb"
                     src="${cxt}/asset/images/no-image.png"
                     alt="no-image">
              </c:otherwise>
            </c:choose>

            <div class="flex-grow-1">
              <div class="fw-semibold small text-truncate" title="<c:out value='${it.name}'/>">
                <c:out value="${it.name}"/>
              </div>
              <div class="text-muted small">SL: <c:out value="${it.quantity}"/></div>
            </div>
            <div class="text-end small fw-semibold">
              <fmt:formatNumber value="${it.subtotal}" type="number" groupingUsed="true"/> đ
            </div>
          </div>
        </c:forEach>

        <div class="d-flex justify-content-between mt-3">
          <div class="fw-semibold">Tạm tính</div>
          <div class="fw-bold text-success">
            <fmt:formatNumber value="${cart.totalAmount}" type="number" groupingUsed="true"/> đ
          </div>
        </div>
      </c:otherwise>
    </c:choose>
  </div>

  <div class="offcanvas-footer p-3 border-top">
    <div class="d-grid gap-2">
      <a class="btn btn-success" href="${cxt}/checkout">Thanh toán</a>
      <a class="btn btn-outline-secondary" href="${cxt}/cart" data-bs-dismiss="offcanvas">Xem giỏ hàng</a>
    </div>
  </div>
</div>

<script>
  window.setMiniCartCount = function (n) {
    document.getElementById('miniCartCount').textContent = n;
    const qty = document.getElementById('miniCartQty');
    if (qty) qty.textContent = n;
  };
  window.openMiniCart = function () {
    const el = document.getElementById('miniCart');
    if (!el) return;
    const off = bootstrap.Offcanvas.getOrCreateInstance(el);
    off.show();
  };
</script>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="cart" value="${sessionScope.CART}" />
<c:set var="cartCount" value="${empty sessionScope.cartCount ? 0 : sessionScope.cartCount}" />
<c:set var="isFragment" value="${requestScope.fragment or not empty param.fragment}" />

<c:choose>

  <%-- ===== FRAGMENT (để refresh) ===== --%>
  <c:when test="${isFragment}">
    <c:choose>
      <c:when test="${cart == null or empty cart.items}">
        <div class="text-center text-muted py-4">Giỏ hàng trống.</div>
      </c:when>
      <c:otherwise>
        <c:forEach var="it" items="${cart.items}">
          <div class="d-flex align-items-center border-bottom py-2">
            <c:choose>
              <c:when test="${not empty it.image and (fn:startsWith(it.image,'http') or fn:startsWith(it.image,'/'))}">
                <img src="${it.image}"
                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/asset/images/no-image.png';"
                     class="me-2 rounded" style="width:48px;height:48px;object-fit:cover" alt="">
              </c:when>
              <c:otherwise>
                <c:url value="/asset/images/${empty it.image ? 'no-image.png' : it.image}" var="imgUrl"/>
                <img src="${imgUrl}"
                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/asset/images/no-image.png';"
                     class="me-2 rounded" style="width:48px;height:48px;object-fit:cover" alt="">
              </c:otherwise>
            </c:choose>

            <div class="flex-grow-1 small">
              <div class="fw-semibold text-truncate"><c:out value="${it.name}"/></div>

              <!-- tồn kho -->
              <div class="text-muted">Còn: <strong>${it.stock}</strong></div>

              <!-- controls -->
              <div class="qty-actions d-inline-flex align-items-center mt-1" data-id="${it.productId}">
                <button class="btn btn-sm btn-outline-secondary mc-minus" type="button" aria-label="Giảm">−</button>
                <input class="form-control form-control-sm mc-qty mx-1" type="number" min="0"
                       value="${it.quantity}" style="width:60px;text-align:center">
                <button class="btn btn-sm btn-outline-secondary mc-plus" type="button"
                        aria-label="Tăng" <c:if test="${it.quantity >= it.stock}">disabled</c:if>>+</button>

                <!-- Xóa -->
                <button class="btn btn-sm btn-link text-danger mc-remove ms-2" type="button" aria-label="Xóa">
                  Xóa
                </button>

                <!-- Đặt nhanh 1 sản phẩm (style giống nút Xóa, text "Đặt") -->
                <button class="btn btn-sm btn-link text-success mc-only ms-1" type="button"
                        aria-label="Đặt nhanh">
                  Đặt
                </button>
              </div>
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

  <%-- ===== FULL WIDGET ===== --%>
  <c:otherwise>
    <button type="button" class="cart-fab" data-bs-toggle="offcanvas" data-bs-target="#miniCart"
            aria-controls="miniCart" title="Giỏ hàng">
      <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 16 16" width="22" height="22">
        <path d="M8 1a2.5 2.5 0 0 0-2.5 2.5V4h1v-.5a1.5 1.5 0 1 1 3 0V4h1v-.5A2.5 2.5 0 0 0 8 1"/>
        <path d="M3.5 4h9a.5.5 0 0 1 .5.5V14a2 2 0 0 1-2 2h-6a2 2 0 0 1-2-2V4.5a.5.5 0 0 1 .5-.5"/>
      </svg>
      <span class="cart-badge" id="miniCartCount"><c:out value="${cartCount}"/></span>
    </button>

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
                <c:choose>
                  <c:when test="${not empty it.image and (fn:startsWith(it.image,'http') or fn:startsWith(it.image,'/'))}">
                    <img src="${it.image}"
                         onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/asset/images/no-image.png';"
                         class="me-2 rounded" style="width:48px;height:48px;object-fit:cover" alt="">
                  </c:when>
                  <c:otherwise>
                    <c:url value="/asset/images/${empty it.image ? 'no-image.png' : it.image}" var="imgUrl"/>
                    <img src="${imgUrl}"
                         onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/asset/images/no-image.png';"
                         class="me-2 rounded" style="width:48px;height:48px;object-fit:cover" alt="">
                  </c:otherwise>
                </c:choose>

                <div class="flex-grow-1 small">
                  <div class="fw-semibold text-truncate"><c:out value="${it.name}"/></div>
                  <div class="text-muted">Còn: <strong>${it.stock}</strong></div>

                  <div class="qty-actions d-inline-flex align-items-center mt-1" data-id="${it.productId}">
                    <button class="btn btn-sm btn-outline-secondary mc-minus" type="button" aria-label="Giảm">−</button>
                    <input class="form-control form-control-sm mc-qty mx-1" type="number" min="0"
                           value="${it.quantity}" style="width:60px;text-align:center">
                    <button class="btn btn-sm btn-outline-secondary mc-plus" type="button"
                            aria-label="Tăng" <c:if test="${it.quantity >= it.stock}">disabled</c:if>>+</button>

                    <!-- Xóa -->
                    <button class="btn btn-sm btn-link text-danger mc-remove ms-2" type="button" aria-label="Xóa">
                      Xóa
                    </button>

                    <!-- Đặt nhanh 1 sản phẩm (style giống nút Xóa, text "Đặt") -->
                    <button class="btn btn-sm btn-link text-success mc-only ms-1" type="button"
                            aria-label="Đặt nhanh">
                      Đặt
                    </button>
                  </div>
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
        <a id="btnMiniCheckout"
           class="btn btn-success w-100 mb-2"
           href="${pageContext.request.contextPath}/checkout">
          Thanh toán
        </a>

        <a id="btnGoCart"
           class="btn btn-outline-secondary w-100"
           href="${pageContext.request.contextPath}/cart">
          Xem giỏ hàng
        </a>
      </div>
    </div>

    <script>
      window.setMiniCartCount = function(n){
        const b = document.getElementById('miniCartCount');
        if (b) b.textContent = n;
        const q = document.getElementById('miniCartQty');
        if (q) q.textContent = n;
      };
    </script>
  </c:otherwise>
</c:choose>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="cxt" value="${pageContext.request.contextPath}" />
<c:set var="cart" value="${requestScope.cart}" />

<h3 class="mb-3">Thanh toán</h3>

<c:if test="${not empty errors}">
  <div class="alert alert-danger">
    <ul class="mb-0">
      <c:forEach var="e" items="${errors}"><li><c:out value="${e}"/></li></c:forEach>
    </ul>
  </div>
</c:if>

<div class="row g-4">
  <div class="col-lg-7">
    <!-- GỬI ĐƠN NGAY -->
    <form class="card card-body" action="${cxt}/checkout" method="post" id="placeOrderForm">
      <input type="hidden" name="action" value="create"/>
      <input type="hidden" name="shipFee" value="${shipFee}"/>

      <div class="row g-3">
        <div class="col-md-6">
          <label class="form-label">Họ tên <span class="text-danger">*</span></label>
          <input class="form-control" name="fullName" value="${prefillName}" required/>
        </div>
        <div class="col-md-6">
          <label class="form-label">Số điện thoại <span class="text-danger">*</span></label>
          <input class="form-control" name="phone" value="${prefillPhone}" required/>
        </div>
        <div class="col-md-6">
          <label class="form-label">Email</label>
          <input class="form-control" name="email" value="${prefillEmail}"/>
        </div>
        <div class="col-12">
          <label class="form-label">Địa chỉ <span class="text-danger">*</span></label>
          <input class="form-control" name="address" value="${prefillAddress}" required/>
        </div>
        <div class="col-12">
          <label class="form-label">Ghi chú</label>
          <textarea class="form-control" rows="3" name="note"><c:out value="${prefillNote}"/></textarea>
        </div>
      </div>

      <div class="d-flex gap-2 mt-3">
        <a class="btn btn-outline-secondary" href="${cxt}/cart">Quay lại giỏ</a>
        <button class="btn btn-teal ms-auto" id="btnPlaceOrder">Đặt hàng</button>
      </div>
    </form>
  </div>

  <div class="col-lg-5">
    <div class="card">
      <div class="card-body">
        <h5 class="card-title mb-3">Đơn hàng</h5>
        <ul class="list-group mb-3">
          <c:forEach var="it" items="${cart.items}">
            <li class="list-group-item d-flex justify-content-between">
              <div>
                <div class="fw-semibold"><c:out value="${it.name}"/></div>
                <small class="text-muted">x<c:out value="${it.quantity}"/></small>
              </div>
              <div>
                <fmt:formatNumber value="${it.subtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
              </div>
            </li>
          </c:forEach>
        </ul>

        <div class="d-flex justify-content-between">
          <span>Tạm tính</span>
          <strong>
            <fmt:formatNumber value="${cart.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
          </strong>
        </div>
        <div class="d-flex justify-content-between">
          <span>Phí vận chuyển</span>
          <strong>
            <fmt:formatNumber value="${shipFee}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
          </strong>
        </div>
        <hr/>
        <div class="d-flex justify-content-between fs-5">
          <span>Tổng thanh toán</span>
          <strong>
            <fmt:formatNumber value="${cart.totalAmount + shipFee}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
          </strong>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  // chống bấm đúp nút
  document.getElementById('placeOrderForm')?.addEventListener('submit', function() {
    const btn = document.getElementById('btnPlaceOrder');
    if (btn) { btn.disabled = true; btn.textContent = 'Đang tạo đơn…'; }
  });
</script>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="cxt" value="${pageContext.request.contextPath}" />
<c:set var="cart" value="${requestScope.cart}" />

<h3 class="mb-3">Giỏ hàng</h3>

<c:if test="${empty cart or empty cart.items}">
  <div class="alert alert-info">Giỏ của bạn đang trống.</div>
  <a class="btn btn-teal" href="${cxt}/products">Tiếp tục mua sắm</a>
</c:if>

<c:if test="${not empty cart and not empty cart.items}">
  <div class="table-responsive">
    <table class="table align-middle">
      <thead class="table-light">
        <tr>
          <th>SP</th>
          <th>Tên</th>
          <th class="text-end">Đơn giá</th>
          <th class="text-center" style="width:140px">SL</th>
          <th class="text-end">Tạm tính</th>
          <th></th>
        </tr>
      </thead>
      <tbody id="cartBody">
        <c:forEach var="it" items="${cart.items}">
          <tr data-id="${it.productId}">
            <td style="width:64px">
              <img src="${it.image}" class="img-thumbnail" style="width:56px;height:56px;object-fit:cover">
            </td>
            <td class="fw-semibold">${it.name}</td>
            <td class="text-end">
              <fmt:formatNumber value="${it.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
            </td>
            <td class="text-center">
              <div class="input-group input-group-sm">
                <input type="number" min="0" class="form-control text-center qty" value="${it.quantity}">
                <button class="btn btn-outline-secondary btnApply">Áp dụng</button>
              </div>
            </td>
            <td class="text-end item-subtotal">
              <fmt:formatNumber value="${it.subtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
            </td>
            <td class="text-end">
              <a class="btn btn-sm btn-outline-danger" href="${cxt}/cart?action=remove&id=${it.productId}">Xóa</a>
            </td>
          </tr>
        </c:forEach>
      </tbody>
      <tfoot>
        <tr>
          <th colspan="4" class="text-end">Tổng:</th>
          <th class="text-end" id="totalAmount">
            <fmt:formatNumber value="${cart.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
          </th>
          <th></th>
        </tr>
      </tfoot>
    </table>
  </div>

  <div class="d-flex gap-2">
    <a class="btn btn-outline-secondary" href="${cxt}/cart?action=clear"
       onclick="return confirm('Xóa toàn bộ giỏ?')">Xóa giỏ</a>
    <a class="btn btn-teal ms-auto" href="${cxt}/checkout">Tiến hành thanh toán</a>
  </div>
</c:if>

<script>
(function(){
  const tbody = document.getElementById('cartBody');
  if(!tbody) return;

  tbody.querySelectorAll('tr').forEach(function(row){
    const id = row.dataset.id;
    row.querySelector('.btnApply').addEventListener('click', function(){
      const qty = row.querySelector('.qty').value || 0;
      fetch('${cxt}/cart', {
        method: 'POST',
        headers: {'Content-Type':'application/x-www-form-urlencoded; charset=UTF-8'},
        body: new URLSearchParams({action:'set', id:id, qty:qty})
      }).then(r => r.json()).then(d => {
        if(d && d.ok){
          row.querySelector('.qty').value = d.qty;
          row.querySelector('.item-subtotal').textContent =
            new Intl.NumberFormat('vi-VN').format(parseInt(d.itemSubtotal)) + ' ₫';
          document.getElementById('totalAmount').textContent =
            new Intl.NumberFormat('vi-VN').format(parseInt(d.totalAmount)) + ' ₫';
        }
      }).catch(()=>{ /* ignore */ });
    });
  });
})();
</script>
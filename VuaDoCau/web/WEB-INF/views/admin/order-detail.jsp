<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="cxt" value="${pageContext.request.contextPath}" />
<c:set var="o" value="${order}" />

<div class="d-flex align-items-center justify-content-between mb-3">
  <h3 class="mb-0">Đơn hàng #${o.id}</h3>
  <a class="btn btn-outline-secondary" href="${cxt}/profile">Lịch sử mua</a>
</div>

<div class="row g-4">
  <div class="col-lg-8">
    <div class="card">
      <div class="table-responsive">
        <table class="table align-middle mb-0">
          <thead class="table-light">
            <tr>
              <th>SP</th><th>Tên</th><th class="text-end">Đơn giá</th>
              <th class="text-center">SL</th><th class="text-end">Thành tiền</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="it" items="${o.items}">
              <tr>
                <td style="width:64px">
                  <img src="${it.image}" class="img-thumbnail" style="width:56px;height:56px;object-fit:cover">
                </td>
                <td class="fw-semibold">${it.name}</td>
                <td class="text-end">
                  <fmt:formatNumber value="${it.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                </td>
                <td class="text-center">${it.quantity}</td>
                <td class="text-end">
                  <fmt:formatNumber value="${it.subtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                </td>
              </tr>
            </c:forEach>
          </tbody>
          <tfoot>
            <tr>
              <th colspan="4" class="text-end">Tạm tính</th>
              <th class="text-end">
                <fmt:formatNumber value="${o.subtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
              </th>
            </tr>
            <tr>
              <th colspan="4" class="text-end">Phí vận chuyển</th>
              <th class="text-end">
                <fmt:formatNumber value="${o.shipFee}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
              </th>
            </tr>
            <tr>
              <th colspan="4" class="text-end">Tổng</th>
              <th class="text-end">
                <fmt:formatNumber value="${o.total}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
              </th>
            </tr>
          </tfoot>
        </table>
      </div>
    </div>
  </div>

  <div class="col-lg-4">
    <div class="card card-body">
      <div class="mb-2">Trạng thái:
        <span class="badge bg-soft-gray">${o.status}</span>
      </div>
      <div class="text-muted small">
        Ngày đặt:
        <fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
      </div>
      <hr/>
      <div class="small">
        <div class="text-muted">Ghi chú</div>
        <div><c:out value="${o.note}"/></div>
      </div>
    </div>
  </div>
</div>
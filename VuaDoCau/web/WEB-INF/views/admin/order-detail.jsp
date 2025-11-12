<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="cxt" value="${pageContext.request.contextPath}" />
<c:set var="o"   value="${order}" />

<c:set var="hoTen" value=""/>
<c:set var="mail"  value=""/>
<c:catch><c:set var="hoTen" value="${empty o.customerName ? (empty o.name ? o.fullName : o.name) : o.customerName}"/></c:catch>
<c:catch><c:set var="mail"  value="${empty o.customerEmail ? (empty o.email ? o.userEmail : o.email) : o.customerEmail}"/></c:catch>

<c:set var="statusClass"
       value="${o.status=='NEW'       ? 'stt-new' :
               o.status=='CONFIRMED' ? 'stt-confirmed' :
               o.status=='SHIPPING'  ? 'stt-shipping'  :
               o.status=='DONE'      ? 'stt-done'      :
               o.status=='CANCELED'  ? 'stt-canceled'  : 'bg-secondary'}"/>

<style>
  .order-card{background:#fff;border:1px solid #eee;border-radius:12px;overflow:hidden}
  .order-card th,.order-card td{vertical-align:middle}
  .order-total{font-weight:800;color:#159d7f}

  .stt-new{background:#ffc107;color:#000;}
  .stt-confirmed{background:#0d6efd;}
  .stt-shipping{background:#17a2b8;}
  .stt-done{background:#198754;}
  .stt-canceled{background:#dc3545;}
</style>

<div class="container py-4">
  <div class="d-flex align-items-center mb-3">
    <h3 class="fw-bold me-auto">Đơn hàng #${o.id}</h3>
    <a class="btn btn-outline-secondary" href="${cxt}/admin/orders">Quay về danh sách</a>
  </div>

  <div class="row g-4">
    <!-- BẢNG SẢN PHẨM -->
    <div class="col-lg-8">
      <div class="order-card">
        <table class="table align-middle mb-0">
          <thead class="table-light">
          <tr>
            <th style="width:64px">Sản phẩm</th>
            <th></th>
            <th class="text-end">Giá</th>
            <th class="text-center">SL</th>
            <th class="text-end">Tạm tính</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="it" items="${o.items}">
            <tr>
              <td>
                <c:choose>
                  <c:when test="${not empty it.image and (fn:startsWith(it.image,'http') or fn:startsWith(it.image,'/'))}">
                    <img src="${it.image}" class="img-thumbnail" style="width:56px;height:56px;object-fit:cover"
                         onerror="this.src='${cxt}/asset/images/no-image.png'">
                  </c:when>
                  <c:otherwise>
                    <img src="${cxt}/asset/images/${empty it.image ? 'no-image.png' : it.image}"
                         class="img-thumbnail" style="width:56px;height:56px;object-fit:cover"
                         onerror="this.src='${cxt}/asset/images/no-image.png'">
                  </c:otherwise>
                </c:choose>
              </td>
              <td class="fw-semibold"><c:out value="${it.name}"/></td>
              <td class="text-end"><fmt:formatNumber value="${it.price}" type="number" groupingUsed="true"/> đ</td>
              <td class="text-center">${it.quantity}</td>
              <td class="text-end"><fmt:formatNumber value="${it.subtotal}" type="number" groupingUsed="true"/> đ</td>
            </tr>
          </c:forEach>
          </tbody>
          <tfoot>
          <tr>
            <th colspan="4" class="text-end">Tạm tính</th>
            <th class="text-end">
              <fmt:formatNumber value="${o.subtotal}" type="number" groupingUsed="true"/> đ
            </th>
          </tr>
          <tr>
            <th colspan="4" class="text-end">Phí ship</th>
            <th class="text-end">
              <fmt:formatNumber value="${empty o.shipFee ? 0 : o.shipFee}" type="number" groupingUsed="true"/> đ
            </th>
          </tr>
          <tr>
            <th colspan="4" class="text-end">Tổng cộng</th>
            <th class="text-end order-total">
              <fmt:formatNumber value="${o.total}" type="number" groupingUsed="true"/> đ
            </th>
          </tr>
          </tfoot>
        </table>
      </div>
    </div>

    <!-- THÔNG TIN NHẬN HÀNG -->
    <div class="col-lg-4">
      <div class="order-card p-3">
        <h5 class="fw-bold mb-3">Thông tin nhận hàng</h5>
        <div class="mb-2">
          <strong>Trạng thái: </strong>
          <span class="badge ${statusClass}">
            <c:out value="${o.status}"/>
          </span>
        </div>
        <div class="text-muted small mb-3">
          <strong>Ngày đặt: </strong>
          <fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
        </div>
        <div class="mb-2"><strong>Họ tên: </strong><c:out value="${hoTen}"/></div>
        <div class="mb-3"><strong>Email: </strong><c:out value="${mail}"/></div>
        <hr/>
        <div class="small text-muted">
          <strong>Thông tin (ghi chú):</strong>
          <div><c:out value="${o.note}"/></div>
        </div>
      </div>
    </div>
  </div>
</div>

<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="cxt" value="${pageContext.request.contextPath}" />
<c:set var="o"   value="${order}" />

<div class="container py-4">
  <div class="d-flex align-items-center mb-3">
    <h3 class="fw-bold me-auto">Đơn hàng #${o.id} đã đặt thành công!</h3>

    <div class="d-flex gap-2">
      <a class="btn btn-outline-primary" href="${cxt}/home">Về trang chủ</a>
      <a class="btn btn-outline-secondary" href="${cxt}/profile">Về hồ sơ</a>
    </div>
  </div>

  <div class="row g-4 mt-1">
    <div class="col-lg-7">
      <div class="table-responsive bg-white rounded-3 shadow-sm">
        <table class="table align-middle mb-0">
          <thead class="table-light">
          <tr>
            <th>Sản phẩm</th>
            <th class="text-end">Giá</th>
            <th class="text-center">SL</th>
            <th class="text-end">Tạm tính</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="it" items="${o.items}">
            <tr>
              <td>
                <div class="d-flex align-items-center gap-3">
                  <img src="${cxt}/asset/images/${it.image != null ? it.image : 'no-image.png'}"
                       alt="${it.name}" style="width:56px;height:56px;object-fit:cover"
                       onerror="this.src='${cxt}/asset/images/no-image.png'">
                  <div class="fw-semibold">${it.name}</div>
                </div>
              </td>
              <td class="text-end"><fmt:formatNumber value="${it.price}" type="number" groupingUsed="true"/> đ</td>
              <td class="text-center">${it.quantity}</td>
              <td class="text-end"><fmt:formatNumber value="${it.subtotal}" type="number" groupingUsed="true"/> đ</td>
            </tr>
          </c:forEach>
          <tr>
            <td colspan="3" class="text-end fw-semibold">Tạm tính</td>
            <td class="text-end"><fmt:formatNumber value="${o.subtotal}" type="number" groupingUsed="true"/> đ</td>
          </tr>
          <tr>
            <td colspan="3" class="text-end fw-semibold">Phí ship</td>
            <td class="text-end"><fmt:formatNumber value="${o.shipFee}" type="number" groupingUsed="true"/> đ</td>
          </tr>
          <tr>
            <td colspan="3" class="text-end fs-5 fw-bold">Tổng cộng</td>
            <td class="text-end fs-5 fw-bold text-success">
              <fmt:formatNumber value="${o.total}" type="number" groupingUsed="true"/> đ
            </td>
          </tr>
          </tbody>
        </table>
      </div>
    </div>

    <div class="col-lg-5">
      <div class="card shadow-sm">
        <div class="card-body">
          <h5 class="fw-bold mb-3">Thông tin nhận hàng</h5>
          <p><strong>Trạng thái:</strong> <span class="badge bg-secondary">${o.status}</span></p>
          <p><strong>Ngày đặt:</strong> <fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/></p>
          <hr/>
          <p><strong>Họ tên:</strong> ${o.fullName}</p>
          <p><strong>Email:</strong> ${o.email}</p>
          <p><strong>Thông tin (ghi chú):</strong> <em>${o.note}</em></p>
        </div>
      </div>
    </div>
  </div>
</div>

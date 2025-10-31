<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <title>Chi tiết đơn #${order.id}</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
</head>
<body class="bg-light">
<nav class="navbar navbar-expand-lg bg-white shadow-sm">
  <div class="container">
    <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/home">VuaĐồCâu</a>
    <a class="btn btn-outline-secondary ms-auto" href="${pageContext.request.contextPath}/profile">Về hồ sơ</a>
  </div>
</nav>

<div class="container py-4">
  <h3 class="fw-bold">Đơn hàng #${order.id}</h3>
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
          <c:forEach var="it" items="${order.items}">
            <tr>
              <td>
                <div class="d-flex align-items-center gap-3">
                  <img src="${pageContext.request.contextPath}/asset/images/${it.image != null ? it.image : 'no-image.png'}"
                       alt="${it.name}" style="width:56px;height:56px;object-fit:cover"
                       onerror="this.src='${pageContext.request.contextPath}/asset/images/no-image.png'">
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
            <td class="text-end"><fmt:formatNumber value="${order.subtotal}" type="number" groupingUsed="true"/> đ</td>
          </tr>
          <tr>
            <td colspan="3" class="text-end fw-semibold">Phí ship</td>
            <td class="text-end"><fmt:formatNumber value="${order.shipFee}" type="number" groupingUsed="true"/> đ</td>
          </tr>
          <tr>
            <td colspan="3" class="text-end fs-5 fw-bold">Tổng cộng</td>
            <td class="text-end fs-5 fw-bold text-success">
              <fmt:formatNumber value="${order.total}" type="number" groupingUsed="true"/> đ
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
          <p><strong>Trạng thái:</strong> <span class="badge bg-secondary">${order.status}</span></p>
          <p><strong>Ngày đặt:</strong> <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/></p>
          <hr/>
          <p><strong>Họ tên:</strong> ${order.fullName}</p>
          <p><strong>Email:</strong> ${order.email}</p>
          <p><strong>Thông tin (ghi chú):</strong> <em>${order.note}</em></p>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
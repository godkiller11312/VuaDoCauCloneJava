<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <title>Đặt hàng thành công</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
</head>
<body class="bg-light">
<nav class="navbar navbar-expand-lg bg-white shadow-sm">
  <div class="container">
    <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/home">VuaĐồCâu</a>
  </div>
</nav>

<div class="container py-5">
  <div class="row justify-content-center">
    <div class="col-lg-8">
      <div class="card shadow-sm rounded-4">
        <div class="card-body p-4">
          <h3 class="fw-bold text-success">Đặt hàng thành công!</h3>
          <p class="mb-1">Mã đơn: <strong>${order.code}</strong></p>
          <p class="text-muted">Chúng tôi đã nhận đơn của bạn và sẽ liên hệ sớm.</p>

          <h5 class="mt-4">Tóm tắt đơn hàng</h5>
          <div class="table-responsive">
            <table class="table align-middle">
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
                  <td>${it.name}</td>
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

          <h5 class="mt-4">Thông tin nhận hàng</h5>
          <div class="row">
            <div class="col-md-6">
              <div>Họ tên: <strong>${order.fullName}</strong></div>
              <div>SDT: <strong>${order.phone}</strong></div>
              <div>Email: <strong>${order.email}</strong></div>
            </div>
            <div class="col-md-6">
              <div>Địa chỉ: <strong>${order.address}</strong></div>
              <div>Ghi chú: <em>${order.note}</em></div>
            </div>
          </div>

          <div class="d-flex gap-2 mt-4">
            <a class="btn btn-primary" href="${pageContext.request.contextPath}/products">Tiếp tục mua sắm</a>
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/home">Về trang chủ</a>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <title>Xác nhận đơn hàng</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <style>
    .bg-soft{background:
      radial-gradient(1200px 600px at 10% 0%, #eaf6ff 0, rgba(255,255,255,.9) 60%),
      radial-gradient(1200px 600px at 90% 100%, #eafff9 0, rgba(255,255,255,.9) 60%)}
  </style>
</head>
<body class="bg-soft">
<nav class="navbar navbar-expand-lg bg-white shadow-sm">
  <div class="container">
    <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/home">VuaĐồCâu</a>
    <a class="btn btn-outline-secondary ms-auto" href="${pageContext.request.contextPath}/cart">Quay lại giỏ</a>
  </div>
</nav>

<div class="container py-4">
  <h2 class="fw-bold mb-3">Xác nhận đơn hàng</h2>

  <c:if test="${not empty errors}">
    <div class="alert alert-danger">
      <ul class="mb-0">
        <c:forEach items="${errors}" var="e"><li>${e}</li></c:forEach>
      </ul>
    </div>
  </c:if>

  <div class="row g-4">
    <!-- LEFT: bảng tóm tắt -->
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
          <c:forEach var="it" items="${cart.items}">
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
            <td class="text-end">
              <fmt:formatNumber value="${cart.totalAmount}" type="number" groupingUsed="true"/> đ
            </td>
          </tr>
          <tr>
            <td colspan="3" class="text-end fw-semibold">Phí ship</td>
            <td class="text-end">
              <fmt:formatNumber value="${shipFee}" type="number" groupingUsed="true"/> đ
            </td>
          </tr>
          <tr>
            <td colspan="3" class="text-end fs-5 fw-bold">Tổng cộng</td>
            <td class="text-end fs-5 fw-bold text-success">
              <fmt:formatNumber value="${cart.totalAmount + shipFee}" type="number" groupingUsed="true"/> đ
            </td>
          </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- RIGHT: form nhận hàng -->
    <div class="col-lg-5">
      <div class="card shadow-sm rounded-4">
        <div class="card-body">
          <h5 class="card-title fw-bold mb-3">Thông tin nhận hàng</h5>
          <form method="post" action="${pageContext.request.contextPath}/checkout" class="vstack gap-3">
            <div>
              <label class="form-label">Họ tên</label>
              <input name="fullName" type="text" class="form-control"
                     value="${empty prefillName ? prefillName : prefillName}">
            </div>
            <div>
              <label class="form-label">SDT</label>
              <input name="phone" type="text" class="form-control"
                     value="${prefillPhone}">
            </div>
            <div>
              <label class="form-label">Email</label>
              <input name="email" type="email" class="form-control"
                     value="${empty prefillEmail ? '' : prefillEmail}">
            </div>
            <div>
              <label class="form-label">Địa chỉ</label>
              <textarea name="address" rows="3" class="form-control">${prefillAddress}</textarea>
            </div>
            <div>
              <label class="form-label">Note</label>
              <textarea name="note" rows="2" class="form-control" placeholder="Ghi chú (tuỳ chọn)">${prefillNote}</textarea>
            </div>
            <div class="d-grid gap-2">
              <button class="btn btn-success">Đặt hàng</button>
              <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/cart">Quay lại giỏ</a>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
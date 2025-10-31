<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <title>Hồ sơ cá nhân</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <style>.bg-soft{background:
    radial-gradient(1200px 600px at 10% 0%, #eaf6ff 0, rgba(255,255,255,.9) 60%),
    radial-gradient(1200px 600px at 90% 100%, #eafff9 0, rgba(255,255,255,.9) 60%)}
  </style>
</head>
<body class="bg-soft">
<nav class="navbar navbar-expand-lg bg-white shadow-sm">
  <div class="container">
    <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/home">VuaĐồCâu</a>
  </div>
</nav>

<div class="container py-4">
  <h2 class="fw-bold mb-4">Hồ sơ cá nhân</h2>

  <div class="row g-4">
    <div class="col-lg-4">
      <div class="card shadow-sm">
        <div class="card-body">
          <p><strong>Họ tên:</strong> ${user.name}</p>
          <p><strong>Email:</strong> ${user.email}</p>
          <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-secondary">Giỏ hàng</a>
        </div>
      </div>
    </div>

    <div class="col-lg-8">
      <h5 class="fw-bold mb-3">Lịch sử đơn hàng</h5>
      <div class="table-responsive bg-white rounded-3 shadow-sm">
        <table class="table align-middle mb-0">
          <thead class="table-light">
          <tr>
            <th style="width:15%">Mã đơn</th>
            <th style="width:25%">Ngày</th>
            <th style="width:25%">Trạng thái</th>
            <th class="text-end" style="width:20%">Tổng</th>
            <th style="width:15%"></th>
          </tr>
          </thead>
          <tbody>
          <c:choose>
            <c:when test="${empty orders}">
              <tr><td colspan="5" class="text-center text-muted py-4">Chưa có đơn hàng.</td></tr>
            </c:when>
            <c:otherwise>
              <c:forEach var="o" items="${orders}">
                <tr>
                  <td>#${o.id}</td>
                  <td><fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                  <td><span class="badge bg-secondary">${o.status}</span></td>
                  <td class="text-end"><fmt:formatNumber value="${o.total}" type="number" groupingUsed="true"/> đ</td>
                  <td class="text-end">
                    <a class="btn btn-sm btn-outline-primary"
                       href="${pageContext.request.contextPath}/order?id=${o.id}">Xem</a>
                  </td>
                </tr>
              </c:forEach>
            </c:otherwise>
          </c:choose>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <title>Đơn hàng</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <style>
    :root{ --teal:#22b8a7 }
    .bg-soft{
      background: radial-gradient(1200px 600px at 10% 0%, #eaf6ff 0, rgba(255,255,255,.9) 60%),
                  radial-gradient(1200px 600px at 90% 100%, #eafff9 0, rgba(255,255,255,.9) 60%);
    }
    .nav-admin .navbar-nav{flex-direction:row;margin-left:0!important}
    .nav-admin .navbar-brand{margin-right:.75rem}
    .nav-admin .nav-link{padding-left:.75rem;padding-right:.75rem}

    .order-card{background:#fff;border:1px solid #eee;border-radius:12px;overflow:hidden}
    .order-card th,.order-card td{vertical-align:middle}
    .order-total{font-weight:800;color:#159d7f}

    /* Badge trạng thái */
    .stt-new{background:#ffc107;color:#000;}
    .stt-confirmed{background:#0d6efd;}
    .stt-shipping{background:#17a2b8;}
    .stt-done{background:#198754;}
    .stt-canceled{background:#dc3545;}
  </style>
</head>
<body class="bg-soft">
<%
  // không làm gì thêm ở scriptlet
%>
<c:set var="cxt" value="${pageContext.request.contextPath}" />
<c:set var="o"   value="${order}" />

<%-- Lấy an toàn tên và email khách --%>
<c:set var="hoTen" value=""/>
<c:set var="mail"  value=""/>
<c:catch><c:set var="hoTen" value="${empty o.customerName ? (empty o.name ? o.fullName : o.name) : o.customerName}"/></c:catch>
<c:catch><c:set var="mail"  value="${empty o.customerEmail ? (empty o.email ? o.userEmail : o.email) : o.customerEmail}"/></c:catch>

<%-- Class badge theo trạng thái --%>
<c:set var="statusClass"
       value="${o.status=='NEW'       ? 'stt-new' :
               o.status=='CONFIRMED' ? 'stt-confirmed' :
               o.status=='SHIPPING'  ? 'stt-shipping'  :
               o.status=='DONE'      ? 'stt-done'      :
               o.status=='CANCELED'  ? 'stt-canceled'  : 'bg-secondary'}"/>

<nav class="navbar navbar-expand-lg bg-white shadow-sm nav-admin">
  <div class="container">
    <div class="d-flex align-items-center w-100">
      <a class="navbar-brand fw-bold me-2" href="${cxt}/home">VuaĐồCâu</a>
      <ul class="navbar-nav flex-row gap-3 align-items-center">
        <li class="nav-item"><a class="nav-link text-danger fw-semibold" href="${cxt}/admin/products">Quản Lý Sản phẩm</a></li>
        <li class="nav-item"><a class="nav-link text-danger fw-semibold" href="${cxt}/admin/orders">Quản Lý Đơn hàng</a></li>
      </ul>
      <div class="flex-grow-1"></div>
      <div class="dropdown">
        <button class="btn btn-outline-secondary rounded-pill dropdown-toggle px-3" data-bs-toggle="dropdown">
          <c:out value="${sessionScope.authUser.email}"/>
        </button>
        <ul class="dropdown-menu dropdown-menu-end shadow">
          <li><a class="dropdown-item" href="${cxt}/profile">Hồ sơ cá nhân</a></li>
          <li><hr class="dropdown-divider"></li>
          <li><a class="dropdown-item text-danger" href="${cxt}/logout">Đăng xuất</a></li>
        </ul>
      </div>
    </div>
  </div>
</nav>

<div class="container py-4">
  <div class="d-flex align-items-center mb-3">
    <h3 class="fw-bold me-auto">Đơn hàng #${o.id}</h3>
    <a class="btn btn-outline-secondary" href="${cxt}/admin/orders">Quay về danh sách</a>
  </div>

  <div class="row g-4">
    <!-- BẢNG SẢN PHẨM (bên trái) -->
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
                <td class="text-end">
                  <fmt:formatNumber value="${it.price}" type="number" groupingUsed="true"/> đ
                </td>
                <td class="text-center">${it.quantity}</td>
                <td class="text-end">
                  <fmt:formatNumber value="${it.subtotal}" type="number" groupingUsed="true"/> đ
                </td>
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

    <!-- THÔNG TIN NHẬN HÀNG (bên phải) -->
    <div class="col-lg-4">
      <div class="order-card p-3">
        <h5 class="fw-bold mb-3">Thông tin nhận hàng</h5>

        <div class="mb-2">
          <strong>Trạng thái: </strong>
          <span class="badge ${statusClass}">
            <c:choose>
              <c:when test="${o.status=='NEW'}">NEW</c:when>
              <c:when test="${o.status=='CONFIRMED'}">CONFIRMED</c:when>
              <c:when test="${o.status=='SHIPPING'}">SHIPPING</c:when>
              <c:when test="${o.status=='DONE'}">DONE</c:when>
              <c:when test="${o.status=='CANCELED'}">CANCELED</c:when>
              <c:otherwise>${o.status}</c:otherwise>
            </c:choose>
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

<footer class="py-4 text-center small text-muted">
  © 2025 Vua Đồ Câu · All rights reserved
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
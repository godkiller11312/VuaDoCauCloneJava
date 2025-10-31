<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <title>Giỏ hàng - VuaĐồCâu</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <style>
    :root{ --teal:#22b8a7 }
    .bg-soft{
      background:
        radial-gradient(1200px 600px at 10% 0%, #eaf6ff 0, rgba(255,255,255,.9) 60%),
        radial-gradient(1200px 600px at 90% 100%, #eafff9 0, rgba(255,255,255,.9) 60%);
    }
    .navbar .nav-link{ padding-left:.75rem; padding-right:.75rem }
    .table-cart tbody tr td { vertical-align: middle; }
    .qty-wrap{ display:flex; gap:.5rem; align-items:center; }
    .btn-apply{ white-space:nowrap; }
    .alert-soft{ background:#e8fff0; border:1px solid #c9f3d6; color:#137b36; }
    .summary-row{ background:#fafcff; }
  </style>
</head>
<body class="bg-soft">

<c:set var="cxt" value="${pageContext.request.contextPath}" />
<c:set var="auth" value="${sessionScope.authUser}" />
<c:set var="isAdmin" value="${not empty auth and auth.roleId == 1}" />

<nav class="navbar navbar-expand-lg bg-white shadow-sm">
  <div class="container">
    <a class="navbar-brand fw-bold" href="${cxt}/home">VuaĐồCâu</a>

    <ul class="navbar-nav me-3 align-items-center">
      <!-- User thường -->
      <c:if test="${!isAdmin}">
        <li class="nav-item"><a class="nav-link" href="${cxt}/home">Trang chủ</a></li>
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">Danh mục</a>
          <ul class="dropdown-menu">
            <li><a class="dropdown-item" href="${cxt}/products?g=all">Tất cả sản phẩm</a></li>
            <li><a class="dropdown-item" href="${cxt}/products?g=can">Cần câu</a></li>
            <li><a class="dropdown-item" href="${cxt}/products?g=may">Máy câu</a></li>
            <li><a class="dropdown-item" href="${cxt}/products?g=khac">Dây, Mồi, Phụ kiện</a></li>
          </ul>
        </li>
      </c:if>

      <!-- Admin: link ngang, màu đỏ -->
      <c:if test="${isAdmin}">
        <li class="nav-item"><span class="nav-link text-danger fw-bold">Quản trị:</span></li>
        <li class="nav-item"><a class="nav-link text-danger fw-semibold" href="${cxt}/admin/products">Quản Lý Sản phẩm</a></li>
        <li class="nav-item"><a class="nav-link text-danger fw-semibold" href="${cxt}/admin/orders">Quản Lý Đơn hàng</a></li>
      </c:if>
    </ul>

    <!-- Search -->
    <form class="d-flex ms-auto me-2 flex-grow-1" style="max-width:520px" method="get" action="${cxt}/products">
      <input class="form-control me-2" type="search" name="q" placeholder="Tìm sản phẩm...">
      <button class="btn btn-success" style="background:var(--teal);border-color:var(--teal)">Tìm</button>
    </form>

    <!-- Tài khoản -->
    <c:choose>
      <c:when test="${not empty sessionScope.authUser}">
        <div class="dropdown">
          <button class="btn btn-outline-secondary rounded-pill dropdown-toggle px-3" type="button" data-bs-toggle="dropdown">
            ${sessionScope.authUser.email}
          </button>
          <ul class="dropdown-menu dropdown-menu-end shadow">
            <!-- Ẩn Giỏ hàng với Admin -->
            <c:if test="${!isAdmin}">
              <li>
                <a class="dropdown-item d-flex justify-content-between align-items-center" href="${cxt}/cart">
                  Giỏ hàng
                  <span class="badge text-bg-primary">${empty sessionScope.cartCount ? 0 : sessionScope.cartCount}</span>
                </a>
              </li>
            </c:if>
            <li><a class="dropdown-item" href="${cxt}/profile">Hồ sơ cá nhân</a></li>
            <li><hr class="dropdown-divider"></li>
            <li><a class="dropdown-item text-danger" href="${cxt}/logout">Đăng xuất</a></li>
          </ul>
        </div>
      </c:when>
      <c:otherwise>
        <div class="ms-2 d-flex gap-2">
          <a class="btn btn-outline-success" href="${cxt}/login">Đăng nhập</a>
          <a class="btn btn-success" href="${cxt}/register">Đăng ký</a>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</nav>

<div class="container py-4">
  <h2 class="fw-bold mb-3">Giỏ hàng</h2>

  <c:if test="${not empty message}">
    <div class="alert alert-soft rounded-3 mb-3">${message}</div>
  </c:if>

  <c:if test="${empty cart.items}">
    <div class="alert alert-info">
      Giỏ hàng trống. <a href="${cxt}/products">Tiếp tục mua sắm</a>.
    </div>
  </c:if>

  <c:if test="${not empty cart.items}">
    <div class="table-responsive bg-white rounded-3 shadow-sm">
      <table class="table table-cart align-middle mb-0">
        <thead class="table-light">
        <tr>
          <th style="width:60%">Sản phẩm</th>
          <th class="text-end" style="width:10%">Giá</th>
          <th class="text-center" style="width:18%">Số lượng</th>
          <th class="text-end" style="width:12%">Tạm tính</th>
        </tr>
        </thead>
        <tbody id="cart-body">
        <c:forEach var="it" items="${cart.items}">
          <tr data-row="${it.productId}">
            <td>
              <div class="d-flex align-items-center gap-3">
                <img src="${cxt}/asset/images/${it.image != null ? it.image : 'no-image.png'}"
                     alt="${it.name}" style="width:56px;height:56px;object-fit:cover"
                     onerror="this.src='${cxt}/asset/images/no-image.png'">
                <div>
                  <div class="fw-semibold">${it.name}</div>
                  <a class="text-danger small" href="${cxt}/cart?action=remove&id=${it.productId}">Xoá</a>
                </div>
              </div>
            </td>
            <td class="text-end">
              <span class="u-price" data-value="${it.price}">
                <fmt:formatNumber value="${it.price}" type="number" groupingUsed="true"/>
              </span> đ
            </td>
            <td class="text-center">
              <div class="qty-wrap justify-content-center">
                <input type="number" class="form-control w-auto text-center qty-input"
                       min="0" step="1" style="max-width:100px"
                       data-id="${it.productId}"
                       value="${it.quantity}">
                <button type="button" class="btn btn-outline-primary btn-apply"
                        data-id="${it.productId}">Áp dụng</button>
              </div>
            </td>
            <td class="text-end">
              <span class="u-subtotal" data-id="${it.productId}">
                <fmt:formatNumber value="${it.subtotal}" type="number" groupingUsed="true"/>
              </span> đ
            </td>
          </tr>
        </c:forEach>
        </tbody>
        <tfoot>
        <tr class="summary-row">
          <td colspan="3" class="text-end fw-semibold">Tạm tính:</td>
          <td class="text-end">
            <span id="subtotal">
              <fmt:formatNumber value="${cart.totalAmount}" type="number" groupingUsed="true"/>
            </span> đ
          </td>
        </tr>
        <%
          // phí ship cố định 25,000đ (có thể đổi thành rule free-ship sau)
          java.math.BigDecimal ship = ((com.vuadocau.model.Cart)request.getAttribute("cart")).isEmpty()
                  ? java.math.BigDecimal.ZERO
                  : new java.math.BigDecimal("25000");
          request.setAttribute("shipFee", ship);
        %>
        <tr class="summary-row">
          <td colspan="3" class="text-end fw-semibold">Phí vận chuyển:</td>
          <td class="text-end">
            <span id="shipFee"><fmt:formatNumber value="${shipFee}" type="number" groupingUsed="true"/></span> đ
          </td>
        </tr>
        <tr class="summary-row">
          <td colspan="3" class="text-end fs-5 fw-bold">Tổng cộng:</td>
          <td class="text-end fs-5 fw-bold text-success">
            <span id="grandTotal">
              <fmt:formatNumber value="${cart.totalAmount + shipFee}" type="number" groupingUsed="true"/>
            </span> đ
          </td>
        </tr>
        </tfoot>
      </table>
    </div>

    <div class="d-flex justify-content-between align-items-center mt-3">
      <div class="d-flex gap-2">
        <a class="btn btn-outline-danger" href="${cxt}/cart?action=clear">Xoá toàn bộ</a>
        <a class="btn btn-outline-secondary" href="${cxt}/products">Tiếp tục mua sắm</a>
      </div>
      <a class="btn btn-success px-4" href="${cxt}/checkout">Đặt hàng</a>
    </div>
  </c:if>
</div>

<script>
const nf  = new Intl.NumberFormat('vi-VN');
const cxt = '${cxt}';

function updateBadge(qty){
  const el1 = document.querySelector('[data-cart-badge]');
  const el2 = document.getElementById('cart-badge');
  if (el1) el1.textContent = qty;
  if (el2) el2.textContent = qty;
}
function recomputeGrand() {
  const subtotalEl = document.getElementById('subtotal');
  const shipEl = document.getElementById('shipFee');
  const subtotal = subtotalEl.dataset.raw ? parseFloat(subtotalEl.dataset.raw) : 0;
  const ship = shipEl.dataset.raw ? parseFloat(shipEl.dataset.raw) : 0;
  document.getElementById('grandTotal').textContent = nf.format(subtotal + ship);
}
document.querySelectorAll('.btn-apply').forEach(btn => {
  btn.addEventListener('click', () => {
    const id  = btn.dataset.id;
    const inp = document.querySelector(`.qty-input[data-id="${id}"]`);
    if (!inp) return;
    sendSetQty(id, inp.value);
  });
});
let typingTimer;
document.querySelectorAll('.qty-input').forEach(input => {
  input.addEventListener('input', () => {
    clearTimeout(typingTimer);
    typingTimer = setTimeout(() => sendSetQty(input.dataset.id, input.value), 400);
  });
});
async function sendSetQty(id, qty){
  try{
    const res = await fetch(`${cxt}/cart`, {
      method: 'POST',
      headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'},
      body: new URLSearchParams({ action:'set', id, qty })
    });
    const data = await res.json();
    if (!data.ok) return;

    const cell = document.querySelector(`.u-subtotal[data-id="${id}"]`);
    if (cell) cell.textContent = nf.format(parseFloat(data.itemSubtotal));

    const subtotalEl = document.getElementById('subtotal');
    subtotalEl.textContent = nf.format(parseFloat(data.totalAmount));
    subtotalEl.dataset.raw = parseFloat(data.totalAmount);

    recomputeGrand();
    updateBadge(data.totalQty);

    if (parseInt(qty, 10) === 0) {
      const row = document.querySelector(`tr[data-row="${id}"]`);
      if (row) row.remove();
      if (!document.querySelector('#cart-body tr')) location.reload();
    }
  }catch(e){ console.error(e); }
}
(function initRaw(){
  const ship = document.getElementById('shipFee');
  if (ship) {
    const text = ship.textContent.replace(/\./g,'').replace(/,/g,'').replace(/\D/g,'');
    ship.dataset.raw = parseFloat(text || '0');
  }
})();
</script>

<!-- Bootstrap bundle (Popper included) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- Mini-cart floating button + offcanvas (nếu cần) -->
<jsp:include page="/WEB-INF/views/partials/mini-cart.jsp" />
</body>
</html>
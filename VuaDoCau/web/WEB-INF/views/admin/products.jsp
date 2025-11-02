<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <title>Quản Lý Sản phẩm</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <style>
    :root{ --teal:#22b8a7 }
    .bg-soft{
      background:
        radial-gradient(1200px 600px at 10% 0%, #eaf6ff 0, rgba(255,255,255,.9) 60%),
        radial-gradient(1200px 600px at 90% 100%, #eafff9 0, rgba(255,255,255,.9) 60%);
    }
    /* Navbar admin sát logo, không có search */
    .nav-admin .navbar-nav{flex-direction:row;margin-left:0!important}
    .nav-admin .navbar-brand{margin-right:.75rem}
    .nav-admin .nav-link{padding-left:.75rem;padding-right:.75rem}
    .thumb{ width:48px;height:48px;object-fit:cover;border-radius:8px;background:#f6f7ff }
  </style>
</head>
<body class="bg-soft">
<c:set var="cxt" value="${pageContext.request.contextPath}" />
<c:set var="auth" value="${sessionScope.authUser}" />
<c:set var="isAdmin" value="${not empty auth and auth.roleId == 1}" />

<!-- NAVBAR: KHÔNG có ô tìm kiếm cho admin -->
<nav class="navbar navbar-expand-lg bg-white shadow-sm nav-admin">
  <div class="container">
    <div class="d-flex align-items-center w-100">

      <!-- Logo -->
      <a class="navbar-brand fw-bold me-2" href="${cxt}/home">VuaĐồCâu</a>

      <!-- Menu trái -->
      <ul class="navbar-nav flex-row gap-3 align-items-center">
        <!-- ADMIN: chỉ 2 mục quản trị -->
        <c:if test="${isAdmin}">
          <li class="nav-item">
            <a class="nav-link text-danger fw-semibold" href="${cxt}/admin/products">Quản Lý Sản phẩm</a>
          </li>
          <li class="nav-item">
            <a class="nav-link text-danger fw-semibold" href="${cxt}/admin/orders">Quản Lý Đơn hàng</a>
          </li>
        </c:if>

        <!-- USER: menu thông thường (trường hợp mở trang này khi không phải admin) -->
        <c:if test="${!isAdmin}">
          <li class="nav-item"><a class="nav-link" href="${cxt}/home">Trang chủ</a></li>
          <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">Danh mục</a>
            <ul class="dropdown-menu">
              <li><a class="dropdown-item" href="${cxt}/products?g=all">Tất cả sản phẩm</a></li>
              <li><a class="dropdown-item" href="${cxt}/products?g=can">Cần câu</a></li>
              <li><a class="dropdown-item" href="${cxt}/products?g=may">Máy câu</a></li>
              <li><a class="dropdown-item" href="${cxt}/products?g=khac">Dây, Mồi, Phụ kiện</a></li>
            </ul>
          </li>
        </c:if>
      </ul>

      <!-- Đẩy dropdown sang phải -->
      <div class="flex-grow-1"></div>

      <!-- Search CHỈ hiện với user (admin không có search) -->
      <c:if test="${!isAdmin}">
        <form class="d-none d-lg-flex me-2" style="max-width:520px" method="get" action="${cxt}/products">
          <input class="form-control me-2" type="search" name="q" placeholder="Tìm sản phẩm...">
          <button class="btn btn-teal">Tìm</button>
        </form>
      </c:if>

      <!-- Dropdown tài khoản -->
      <div class="dropdown">
        <button class="btn btn-outline-secondary rounded-pill dropdown-toggle px-3" type="button" data-bs-toggle="dropdown">
          ${sessionScope.authUser.email}
        </button>
        <ul class="dropdown-menu dropdown-menu-end shadow">
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

    </div>
  </div>
</nav>

<div class="container py-4">
  <div class="d-flex align-items-center mb-3">
    <h3 class="fw-bold me-auto">Quản Lý Sản phẩm</h3>
    <button class="btn btn-success" style="background:var(--teal);border-color:var(--teal)"
            data-bs-toggle="modal" data-bs-target="#modalForm"
            onclick="openCreate()">+ Thêm sản phẩm</button>
  </div>

  <c:if test="${not empty sessionScope.flash_success}">
    <div class="alert alert-success">${sessionScope.flash_success}</div>
    <c:remove var="flash_success" scope="session"/>
  </c:if>
  <c:if test="${not empty sessionScope.flash_error}">
    <div class="alert alert-danger">${sessionScope.flash_error}</div>
    <c:remove var="flash_error" scope="session"/>
  </c:if>

  <!-- Bộ lọc trong trang -->
  <form class="row g-2 mb-3" method="get" action="${cxt}/admin/products">
    <div class="col-md-4">
      <input class="form-control" type="text" name="q" value="${q}" placeholder="Tìm theo tên sản phẩm">
    </div>
    <div class="col-md-3">
      <select class="form-select" name="cat">
        <option value="">Tất cả danh mục</option>
        <c:forEach var="c" items="${categories}">
          <option value="${c.id}" ${cat==c.id ? 'selected' : ''}>${c.name}</option>
        </c:forEach>
      </select>
    </div>
    <div class="col-md-2">
      <button class="btn btn-outline-primary w-100">Lọc</button>
    </div>
  </form>

  <div class="table-responsive bg-white rounded-3 shadow-sm">
    <table class="table align-middle mb-0">
      <thead class="table-light">
      <tr>
        <th>#</th>
        <th></th>
        <th>Tên sản phẩm</th>
        <th>Danh mục</th>
        <th class="text-end">Giá</th>
        <th class="text-center">Tồn kho</th>
        <th class="text-center">Rating</th>
        <th class="text-center">Đã mua</th>
        <th class="text-end">Thao tác</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach var="p" items="${products}">
        <tr>
          <td>${p.id}</td>
          <td><img class="thumb" src="${cxt}/asset/images/${p.image}" onerror="this.src='${cxt}/asset/images/no-image.png'"></td>
          <td>${p.name}</td>
          <td>${p.categoryName}</td>
          <td class="text-end"><fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/> đ</td>
          <td class="text-center">${p.stock}</td>
          <td class="text-center"><fmt:formatNumber value="${p.rating}" type="number" maxFractionDigits="1"/></td>
          <td class="text-center">${p.purchased}</td>
          <td class="text-end">
            <button class="btn btn-sm btn-outline-secondary"
                    data-bs-toggle="modal" data-bs-target="#modalForm"
                    data-id="${p.id}"
                    data-name="${fn:escapeXml(p.name)}"
                    data-cat="${p.categoryId}"
                    data-image="${p.image}"
                    data-desc="${fn:escapeXml(p.description)}"
                    data-stock="${p.stock}"
                    data-price="${p.price}"
                    data-brand="${p.brandId}"
                    data-rating="${p.rating}"
                    data-purchased="${p.purchased}"
                    onclick="openEditFrom(this)">
              Sửa
            </button>

            <form method="post" action="${cxt}/admin/products" class="d-inline"
                  onsubmit="return confirm('Xóa sản phẩm #${p.id}?')">
              <input type="hidden" name="action" value="delete"/>
              <input type="hidden" name="id" value="${p.id}"/>
              <button class="btn btn-sm btn-outline-danger">Xóa</button>
            </form>
          </td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </div>
</div>

<!-- Modal Thêm/Sửa -->
<div class="modal fade" id="modalForm" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-scrollable">
    <div class="modal-content">
      <form method="post" action="${cxt}/admin/products">
        <div class="modal-header">
          <h5 class="modal-title" id="modalTitle">Thêm sản phẩm</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <input type="hidden" name="action" id="f-action" value="create">
          <input type="hidden" name="id" id="f-id">

          <div class="row g-3">
            <div class="col-md-6">
              <label class="form-label">Tên sản phẩm</label>
              <input class="form-control" name="name" id="f-name" required>
            </div>
            <div class="col-md-3">
              <label class="form-label">Danh mục</label>
              <select class="form-select" name="categoryId" id="f-cat" required>
                <c:forEach var="c" items="${categories}">
                  <option value="${c.id}">${c.name}</option>
                </c:forEach>
              </select>
            </div>
            <div class="col-md-3">
              <label class="form-label">Thương hiệu (MaTH)</label>
              <input class="form-control" name="brandId" id="f-brand" placeholder="vd: 1 (Shimano)">
            </div>

            <div class="col-md-3">
              <label class="form-label">Giá (đ)</label>
              <input class="form-control" name="price" id="f-price" required>
            </div>
            <div class="col-md-3">
              <label class="form-label">Tồn kho</label>
              <input class="form-control" name="stock" id="f-stock" type="number" min="0" value="0" required>
            </div>
            <div class="col-md-3">
              <label class="form-label">Rating</label>
              <input class="form-control" name="rating" id="f-rating" type="number" step="0.1" min="0" max="5" value="0">
            </div>
            <div class="col-md-3">
              <label class="form-label">Đã mua</label>
              <input class="form-control" name="purchased" id="f-purchased" type="number" min="0" value="0">
            </div>

            <div class="col-md-6">
              <label class="form-label">Ảnh (tên file)</label>
              <input class="form-control" name="image" id="f-image" placeholder="vd: can1.jpg">
            </div>
            <div class="col-md-12">
              <label class="form-label">Mô tả</label>
              <textarea class="form-control" rows="3" name="description" id="f-desc"></textarea>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
          <button class="btn btn-success" type="submit">Lưu</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- JS -->
<script>
function openCreate(){
  document.getElementById('modalTitle').textContent = 'Thêm sản phẩm';
  document.getElementById('f-action').value = 'create';
  document.getElementById('f-id').value = '';
  document.getElementById('f-name').value = '';
  document.getElementById('f-cat').value = '';
  document.getElementById('f-brand').value = '';
  document.getElementById('f-price').value = '';
  document.getElementById('f-image').value = '';
  document.getElementById('f-desc').value = '';
  document.getElementById('f-stock').value = 0;
  document.getElementById('f-rating').value = 0;
  document.getElementById('f-purchased').value = 0;
}

function openEditFrom(btn){
  const d = btn.dataset;
  document.getElementById('modalTitle').textContent = 'Sửa sản phẩm #' + d.id;
  document.getElementById('f-action').value = 'update';
  document.getElementById('f-id').value = d.id;
  document.getElementById('f-name').value = d.name || '';
  document.getElementById('f-cat').value = d.cat || '';
  document.getElementById('f-brand').value = (d.brand && d.brand !== 'null') ? d.brand : '';
  document.getElementById('f-price').value = d.price || '';
  document.getElementById('f-image').value = d.image || '';
  document.getElementById('f-desc').value = d.desc || '';
  document.getElementById('f-stock').value = d.stock || 0;
  document.getElementById('f-rating').value = d.rating || 0;
  document.getElementById('f-purchased').value = d.purchased || 0;
}
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
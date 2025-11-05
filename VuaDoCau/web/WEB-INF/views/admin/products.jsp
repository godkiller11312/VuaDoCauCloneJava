<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cxt" value="${pageContext.request.contextPath}" />

<div class="d-flex align-items-center justify-content-between mb-3">
  <h3 class="mb-0">Quản trị · Sản phẩm</h3>
  <button class="btn btn-teal" data-bs-toggle="modal" data-bs-target="#modalCreate">Thêm sản phẩm</button>
</div>

<!-- Flash -->
<c:if test="${not empty sessionScope.flash_success}">
  <div class="alert alert-success">${sessionScope.flash_success}</div>
  <c:remove var="flash_success" scope="session"/>
</c:if>
<c:if test="${not empty sessionScope.flash_error}">
  <div class="alert alert-danger">${sessionScope.flash_error}</div>
  <c:remove var="flash_error" scope="session"/>
</c:if>

<!-- Filter -->
<form class="row g-2 mb-3" method="get" action="${cxt}/admin/products">
  <div class="col-sm-4">
    <input class="form-control" name="q" value="${q}" placeholder="Từ khóa tên sản phẩm..."/>
  </div>
  <div class="col-sm-3">
    <select class="form-select" name="cat">
      <option value="">-- Tất cả danh mục --</option>
      <c:forEach var="c" items="${categories}">
        <option value="${c.id}" <c:if test="${c.id == cat}">selected</c:if>>
          ${c.name}
        </option>
      </c:forEach>
    </select>
  </div>
  <div class="col-sm-2">
    <button class="btn btn-outline-secondary w-100">Lọc</button>
  </div>
</form>

<!-- Table -->
<div class="table-responsive">
  <table class="table align-middle">
    <thead class="table-light">
      <tr>
        <th>#</th>
        <th>Ảnh</th>
        <th>Tên</th>
        <th>Danh mục</th>
        <th class="text-end">Giá</th>
        <th class="text-center">Tồn</th>
        <th class="text-center">Đánh giá</th>
        <th class="text-center">Đã mua</th>
        <th class="text-end">Thao tác</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="p" items="${products}">
        <tr>
          <td>${p.id}</td>
          <td style="width:64px">
            <img src="${p.image}" alt="${p.name}" class="img-thumbnail" style="width:56px;height:56px;object-fit:cover"/>
          </td>
          <td class="fw-semibold">${p.name}</td>
          <td>${p.categoryName}</td>
          <td class="text-end">
            <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
          </td>
          <td class="text-center">${p.stock}</td>
          <td class="text-center">${p.rating}</td>
          <td class="text-center">${p.purchased}</td>
          <td class="text-end">
            <a class="btn btn-sm btn-outline-primary" href="${cxt}/admin/products?action=detail&id=${p.id}">Sửa</a>
            <form action="${cxt}/admin/products" method="post" class="d-inline"
                  onsubmit="return confirm('Xóa sản phẩm #${p.id}?');">
              <input type="hidden" name="action" value="delete"/>
              <input type="hidden" name="id" value="${p.id}"/>
              <button class="btn btn-sm btn-outline-danger">Xóa</button>
            </form>
          </td>
        </tr>
      </c:forEach>
      <c:if test="${empty products}">
        <tr><td colspan="9" class="text-center text-muted">Không có sản phẩm</td></tr>
      </c:if>
    </tbody>
  </table>
</div>

<!-- Modal: Create -->
<div class="modal fade" id="modalCreate" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-scrollable">
    <form class="modal-content" action="${cxt}/admin/products" method="post">
      <input type="hidden" name="action" value="create"/>
      <div class="modal-header">
        <h5 class="modal-title">Thêm sản phẩm</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <div class="row g-3">
          <div class="col-md-8">
            <label class="form-label">Tên</label>
            <input class="form-control" name="name" required/>
          </div>
          <div class="col-md-4">
            <label class="form-label">Danh mục</label>
            <select class="form-select" name="categoryId" required>
              <c:forEach var="c" items="${categories}">
                <option value="${c.id}">${c.name}</option>
              </c:forEach>
            </select>
          </div>
          <div class="col-md-4">
            <label class="form-label">Thương hiệu (mã)</label>
            <input class="form-control" name="brandId" placeholder="Có thể để trống"/>
          </div>
          <div class="col-md-4">
            <label class="form-label">Giá</label>
            <input class="form-control" name="price" required/>
          </div>
          <div class="col-md-4">
            <label class="form-label">Tồn kho</label>
            <input class="form-control" name="stock" value="0" required/>
          </div>
          <div class="col-md-6">
            <label class="form-label">Ảnh (URL)</label>
            <input class="form-control" name="image"/>
          </div>
          <div class="col-md-6">
            <label class="form-label">Rating</label>
            <input class="form-control" name="rating" value="0"/>
          </div>
          <div class="col-12">
            <label class="form-label">Mô tả</label>
            <textarea class="form-control" name="description" rows="3"></textarea>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" data-bs-dismiss="modal" type="button">Hủy</button>
        <button class="btn btn-teal">Lưu</button>
      </div>
    </form>
  </div>
</div>
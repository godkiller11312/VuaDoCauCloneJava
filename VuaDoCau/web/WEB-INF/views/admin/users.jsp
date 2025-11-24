<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="cxt" value="${pageContext.request.contextPath}" />
<c:set var="curSort" value="${empty sort ? 'id' : sort}" />
<c:set var="curDir"  value="${empty dir  ? 'desc' : dir}" />

<c:set var="baseLink" value="${cxt}/admin/users?q=${q}&role=${role}&status=${status}" />
<c:set var="nextIdDir"    value="${curSort eq 'id'    and curDir eq 'asc' ? 'desc' : 'asc'}" />
<c:set var="nextNameDir"  value="${curSort eq 'name'  and curDir eq 'asc' ? 'desc' : 'asc'}" />
<c:set var="nextEmailDir" value="${curSort eq 'email' and curDir eq 'asc' ? 'desc' : 'asc'}" />

<style>
.table thead a.th-sort {
  color: inherit;
  text-decoration: none;
  font-weight: 600;
}
.table thead a.th-sort:hover {
  color: #000;
  text-decoration: underline;
}
.sort-icon { font-size: 0.8rem; margin-left: 3px; }

/* Badge vai trò nhỏ nhẹ, đậm chữ */
.badge-role {
  display: inline-block;
  font-size: 0.75rem;
  font-weight: 700;
  border-radius: 0.4rem;
  padding: 0.25em 0.5em;
  background-color: rgba(0,0,0,0.05);
  color: #333;
}
.badge-role.admin { background-color: rgba(13,110,253,0.12); color: #0d6efd; }
.badge-role.user  { background-color: rgba(108,117,125,0.12); color: #495057; }
</style>

<div class="d-flex align-items-center mb-3">
  <h3 class="fw-bold me-auto">Quản Lý Tài Khoản</h3>
  <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#modalCreate">
    Thêm tài khoản
  </button>
</div>

<c:if test="${not empty sessionScope.flash_success}">
  <div class="alert alert-success">${sessionScope.flash_success}</div>
  <c:remove var="flash_success" scope="session"/>
</c:if>
<c:if test="${not empty sessionScope.flash_error}">
  <div class="alert alert-danger">${sessionScope.flash_error}</div>
  <c:remove var="flash_error" scope="session"/>
</c:if>

<form class="row g-2 mb-3" method="get" action="${cxt}/admin/users">
  <input type="hidden" name="sort" value="${curSort}">
  <input type="hidden" name="dir"  value="${curDir}">
  <div class="col-md-5">
    <input class="form-control" type="text" name="q" value="${q}" placeholder="Tìm: tên hoặc email">
  </div>
  <div class="col-md-3">
    <select name="role" class="form-select">
      <option value="">Tất cả vai trò</option>
      <option value="1" <c:if test="${role == 1}">selected</c:if>>Admin</option>
      <option value="2" <c:if test="${role == 2}">selected</c:if>>User</option>
    </select>
  </div>
  <div class="col-md-2">
    <select name="status" class="form-select">
      <option value="">Tất cả trạng thái</option>
      <option value="1" <c:if test="${status == '1'}">selected</c:if>>Hoạt động</option>
      <option value="0" <c:if test="${status == '0'}">selected</c:if>>Khóa</option>
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
      <th>
        <a class="th-sort" href="${baseLink}&sort=id&dir=${nextIdDir}">
          Mã <span class="sort-icon">
            <c:choose><c:when test="${curSort eq 'id'}">${curDir eq 'asc' ? '▲' : '▼'}</c:when><c:otherwise>↕</c:otherwise></c:choose>
          </span>
        </a>
      </th>
      <th>
        <a class="th-sort" href="${baseLink}&sort=name&dir=${nextNameDir}">
          Tên <span class="sort-icon">
            <c:choose><c:when test="${curSort eq 'name'}">${curDir eq 'asc' ? '▲' : '▼'}</c:when><c:otherwise>↕</c:otherwise></c:choose>
          </span>
        </a>
      </th>
      <th>
        <a class="th-sort" href="${baseLink}&sort=email&dir=${nextEmailDir}">
          Email <span class="sort-icon">
            <c:choose><c:when test="${curSort eq 'email'}">${curDir eq 'asc' ? '▲' : '▼'}</c:when><c:otherwise>↕</c:otherwise></c:choose>
          </span>
        </a>
      </th>
      <th>Vai trò</th>
      <th>Trạng thái</th>
      <th class="text-end">Thao tác</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="u" items="${users}">
      <tr>
        <td>#${u.id}</td>
        <td>${u.name}</td>
        <td>${u.email}</td>
        <td>
          <c:choose>
            <c:when test="${u.roleId == 1}">
              <span class="badge-role admin">ADMIN</span>
            </c:when>
            <c:otherwise>
              <span class="badge-role user">USER</span>
            </c:otherwise>
          </c:choose>
        </td>
        <td>
          <c:choose>
            <c:when test="${u.active}">
              <span class="badge bg-success">Hoạt động</span>
            </c:when>
            <c:otherwise>
              <span class="badge bg-secondary">Khóa</span>
            </c:otherwise>
          </c:choose>
        </td>
        <td class="text-end">
          <a class="btn btn-sm btn-outline-primary me-1"
             href="${cxt}/admin/users?action=detail&id=${u.id}">Xem</a>
          <button class="btn btn-sm btn-outline-secondary me-1"
                  data-bs-toggle="modal" data-bs-target="#modalEdit"
                  data-id="${u.id}" data-name="${u.name}" data-email="${u.email}"
                  data-role="${u.roleId}" data-status="${u.active ? '1' : '0'}">Sửa</button>
          <button class="btn btn-sm btn-outline-warning me-1"
                  data-bs-toggle="modal" data-bs-target="#modalReset"
                  data-id="${u.id}" data-name="${u.name}">Đặt lại MK</button>
          <form method="post" action="${cxt}/admin/users" class="d-inline"
                onsubmit="return confirm('Xóa tài khoản #${u.id}?')">
            <input type="hidden" name="action" value="delete"/>
            <input type="hidden" name="id" value="${u.id}"/>
            <button class="btn btn-sm btn-outline-danger">Xóa</button>
          </form>
        </td>
      </tr>
    </c:forEach>
    <c:if test="${empty users}">
      <tr><td colspan="6" class="text-center text-muted py-4">Không có tài khoản</td></tr>
    </c:if>
    </tbody>
  </table>
</div>

<!-- Modal thêm -->
<div class="modal fade" id="modalCreate" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog"><div class="modal-content">
    <form method="post" action="${cxt}/admin/users">
      <div class="modal-header">
        <h5 class="modal-title">Thêm tài khoản</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <input type="hidden" name="action" value="create">
        <div class="mb-2">
          <label class="form-label">Tên</label>
          <input class="form-control" name="name" required>
        </div>
        <div class="mb-2">
  <label class="form-label">Email</label>
  <input class="form-control"
         id="e-email"
         name="email"
         type="email"
         required
         pattern="^[\\w.+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
         title="Vui lòng nhập email hợp lệ, ví dụ: ten@gmail.com">
</div>

        <div class="mb-2">
          <label class="form-label">Mật khẩu</label>
          <input class="form-control" name="password" type="password" required>
        </div>
        <div class="row">
          <div class="col-md-6 mb-2">
            <label class="form-label">Vai trò</label>
            <select name="roleId" class="form-select">
              <option value="1">Admin</option>
              <option value="2" selected>User</option>
            </select>
          </div>
          <div class="col-md-6 mb-2">
            <label class="form-label">Trạng thái</label>
            <select name="status" class="form-select">
              <option value="1">Hoạt động</option>
              <option value="0">Khóa</option>
            </select>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" data-bs-dismiss="modal" type="button">Hủy</button>
        <button class="btn btn-success" type="submit">Thêm</button>
      </div>
    </form>
  </div></div>
</div>

<!-- Modal sửa -->
<div class="modal fade" id="modalEdit" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog"><div class="modal-content">
    <form method="post" action="${cxt}/admin/users">
      <div class="modal-header">
        <h5 class="modal-title">Sửa tài khoản</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="id" id="e-id">
        <div class="mb-2">
          <label class="form-label">Tên</label>
          <input class="form-control" id="e-name" name="name" required>
        </div>
        <div class="mb-2">
          <label class="form-label">Email</label>
          <input class="form-control" id="e-email" name="email" required>
        </div>
        <div class="row">
          <div class="col-md-6 mb-2">
            <label class="form-label">Vai trò</label>
            <select name="roleId" id="e-role" class="form-select">
              <option value="1">Admin</option>
              <option value="2">User</option>
            </select>
          </div>
          <div class="col-md-6 mb-2">
            <label class="form-label">Trạng thái</label>
            <select name="status" id="e-status" class="form-select">
              <option value="1">Hoạt động</option>
              <option value="0">Khóa</option>
            </select>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" data-bs-dismiss="modal" type="button">Hủy</button>
        <button class="btn btn-primary" type="submit">Lưu</button>
      </div>
    </form>
  </div></div>
</div>

<!-- Modal reset mật khẩu -->
<div class="modal fade" id="modalReset" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog"><div class="modal-content">
    <form method="post" action="${cxt}/admin/users">
      <div class="modal-header">
        <h5 class="modal-title">Đặt lại mật khẩu</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <input type="hidden" name="action" value="resetPassword">
        <input type="hidden" name="id" id="r-id">
        <div class="mb-2">
          <label class="form-label">Tài khoản</label>
          <input class="form-control" id="r-name" disabled>
        </div>
        <div class="mb-2">
          <label class="form-label">Mật khẩu mới</label>
          <input class="form-control" name="newPassword" placeholder="Nhập mật khẩu mới" required>
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" data-bs-dismiss="modal" type="button">Hủy</button>
        <button class="btn btn-warning" type="submit">Đặt lại</button>
      </div>
    </form>
  </div></div>
</div>

<script>
const editModal = document.getElementById('modalEdit');
if (editModal) {
  editModal.addEventListener('show.bs.modal', e => {
    const b = e.relatedTarget;
    document.getElementById('e-id').value = b.dataset.id;
    document.getElementById('e-name').value = b.dataset.name || '';
    document.getElementById('e-email').value = b.dataset.email || '';
    document.getElementById('e-role').value = b.dataset.role || '2';
    document.getElementById('e-status').value = b.dataset.status || '1';
  });
}
const resetModal = document.getElementById('modalReset');
if (resetModal) {
  resetModal.addEventListener('show.bs.modal', e => {
    const b = e.relatedTarget;
    document.getElementById('r-id').value = b.dataset.id;
    document.getElementById('r-name').value = b.dataset.name || '';
  });
}
</script>

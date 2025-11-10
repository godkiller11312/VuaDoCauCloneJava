<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="cxt" value="${pageContext.request.contextPath}" />

<div class="d-flex align-items-center justify-content-between mb-3">
  <h3 class="mb-0">Tài khoản #${u.id}</h3>
  <a class="btn btn-outline-secondary" href="${cxt}/admin/users">← Quay lại danh sách</a>
</div>

<div class="row g-4">
  <div class="col-lg-8">
    <form action="${cxt}/admin/users" method="post" class="card card-body">
      <input type="hidden" name="action" value="update"/>
      <input type="hidden" name="id" value="${u.id}"/>

      <div class="row g-3">
        <div class="col-md-6">
          <label class="form-label">Tên</label>
          <input class="form-control" name="name" value="${u.name}" required/>
        </div>
        <div class="col-md-6">
          <label class="form-label">Email</label>
          <input class="form-control" name="email" value="${u.email}" required/>
        </div>

        <div class="col-md-4">
          <label class="form-label">Quyền</label>
          <select class="form-select" name="roleId">
            <option value="1" ${u.roleId == 1 ? 'selected' : ''}>ADMIN</option>
            <option value="2" ${u.roleId != 1 ? 'selected' : ''}>USER</option>
          </select>
        </div>

        <div class="col-md-4">
          <label class="form-label">Trạng thái</label>
          <select class="form-select" name="status">
            <!-- u.active là boolean -> dùng trực tiếp -->
            <option value="1" ${u.active ? 'selected' : ''}>Hoạt động</option>
            <option value="0" ${!u.active ? 'selected' : ''}>Khoá</option>
          </select>
        </div>

        <div class="col-md-4">
          <label class="form-label">Ngày tạo</label>
          <fmt:formatDate value="${u.createdAt}" pattern="dd/MM/yyyy HH:mm" var="createdFmt"/>
          <input class="form-control" value="${empty createdFmt ? '' : createdFmt}" disabled/>
        </div>
      </div>

      <div class="d-flex gap-2 mt-3">
        <button class="btn btn-teal">Lưu thay đổi</button>
        <a class="btn btn-outline-secondary" href="${cxt}/admin/users">Hủy</a>
      </div>
    </form>
  </div>

  <div class="col-lg-4">
    <div class="card">
      <div class="card-body">
        <div class="mb-3"><strong>Email:</strong> ${u.email}</div>
        <div class="mb-3"><strong>Quyền:</strong> ${u.roleId == 1 ? 'ADMIN' : 'USER'}</div>
        <hr/>
        <form action="${cxt}/admin/users" method="post"
              onsubmit="return confirm('Xoá tài khoản #${u.id}?');">
          <input type="hidden" name="action" value="delete"/>
          <input type="hidden" name="id" value="${u.id}"/>
          <button class="btn btn-outline-danger w-100">Xoá tài khoản</button>
        </form>
      </div>
    </div>

    <div class="card mt-3">
      <div class="card-body">
        <h6 class="mb-2">Đổi mật khẩu</h6>
        <form action="${cxt}/admin/users" method="post"
              onsubmit="return this.newPassword.value.trim().length>=6 || (alert('Mật khẩu tối thiểu 6 ký tự'), false);">
          <!-- Controller nhận resetPassword -->
          <input type="hidden" name="action" value="resetPassword"/>
          <input type="hidden" name="id" value="${u.id}"/>
          <div class="input-group">
            <input class="form-control" type="password" name="newPassword" placeholder="Mật khẩu mới (≥ 6 ký tự)" required/>
            <button class="btn btn-primary">Đổi</button>
          </div>
        </form>
      </div>
    </div>

  </div>
</div>

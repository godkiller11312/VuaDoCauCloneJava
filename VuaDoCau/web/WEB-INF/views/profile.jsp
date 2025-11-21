<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="cxt" value="${pageContext.request.contextPath}" />
<c:set var="u"   value="${user}" />

<!-- Tính đường dẫn avatar cho profile -->
<c:set var="avatarSrc" value="${cxt}/asset/images/avatars/default-avatar.png" />
<c:if test="${not empty u and not empty u.avatar}">
  <c:choose>
    <c:when test="${fn:startsWith(u.avatar,'http') or fn:startsWith(u.avatar,'/')}">
      <c:set var="avatarSrc" value="${u.avatar}" />
    </c:when>
    <c:otherwise>
      <c:set var="avatarSrc" value="${cxt}/asset/images/avatars/${u.avatar}" />
    </c:otherwise>
  </c:choose>
</c:if>

<h3 class="mb-3">Hồ sơ cá nhân</h3>

<c:if test="${param.logCleared == '1'}">
  <div class="alert alert-success">Đã xoá toàn bộ nhật ký hoạt động.</div>
</c:if>
<c:if test="${param.logCleared == '0'}">
  <div class="alert alert-danger">Xoá nhật ký hoạt động thất bại. Vui lòng thử lại.</div>
</c:if>

<div class="row g-4">
  <!-- Thông tin tài khoản -->
  <div class="col-lg-4">
    <div class="card card-body text-center">

      <!-- FORM đổi avatar -->
      <form id="avatarForm"
            method="post"
            action="${cxt}/profile"
            enctype="multipart/form-data"
            class="mb-3">
        <input type="hidden" name="action" value="changeAvatar"/>

        <!-- input file ẩn -->
        <input type="file"
               id="avatarFile"
               name="avatarFile"
               accept="image/*"
               class="d-none"
               onchange="document.getElementById('avatarForm').submit();"/>

        <!-- Avatar có overlay ĐỔI ẢNH -->
        <button type="button"
                class="btn p-0 border-0 bg-transparent profile-avatar-btn"
                onclick="document.getElementById('avatarFile').click();">
          <div class="profile-avatar-wrapper">
            <img src="${avatarSrc}"
                 alt="avatar"
                 class="rounded-circle"
                 style="width:96px;height:96px;object-fit:cover">
            <div class="profile-avatar-overlay">
              <span>ĐỔI ẢNH</span>
            </div>
          </div>
        </button>
      </form>

      <div class="fs-5 fw-semibold mb-1">${u.name}</div>
      <div class="text-muted mb-3">${u.email}</div>
      <a class="btn btn-outline-secondary w-100" href="${cxt}/logout">Đăng xuất</a>
    </div>
  </div>

  <!-- Nếu là USER (roleId == 2) -> hiển thị ĐƠN HÀNG -->
  <c:if test="${u.roleId == 2}">
    <div class="col-lg-8">
      <div class="card">
        <div class="card-body">
          <h5 class="card-title mb-3">Đơn hàng của tôi</h5>
          <div class="table-responsive">
            <table class="table align-middle">
              <thead class="table-light">
                <tr>
                  <th>Mã đơn</th>
                  <th>Ngày đặt</th>
                  <th>Trạng thái</th>
                  <th class="text-end">Tổng tiền</th>
                  <th class="text-end">Thao tác</th>
                </tr>
              </thead>
              <tbody>
              <c:forEach var="o" items="${orders}">
                <tr>
                  <td>#${o.id}</td>
                  <td><fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                  <td>
                    <c:choose>
                      <c:when test="${o.status == 'NEW'}"><span class="badge bg-secondary">NEW</span></c:when>
                      <c:when test="${o.status == 'CONFIRMED'}"><span class="badge bg-info text-dark">CONFIRMED</span></c:when>
                      <c:when test="${o.status == 'SHIPPING'}"><span class="badge bg-warning text-dark">SHIPPING</span></c:when>
                      <c:when test="${o.status == 'DONE'}"><span class="badge bg-success">DONE</span></c:when>
                      <c:when test="${o.status == 'CANCELED'}"><span class="badge bg-danger">CANCELED</span></c:when>
                      <c:otherwise><span class="badge bg-light text-dark">${o.status}</span></c:otherwise>
                    </c:choose>
                  </td>
                  <td class="text-end">
                    <fmt:formatNumber value="${o.total}" type="number" groupingUsed="true"/> đ
                  </td>
                  <td class="text-end">
                    <!-- Xem chi tiết luôn luôn có -->
                    <a class="btn btn-sm btn-outline-primary mb-1" href="${cxt}/order?id=${o.id}">
                      Xem chi tiết
                    </a>

                    <!-- Nếu đơn đang NEW -> cho hủy -->
                    <c:if test="${o.status == 'NEW'}">
                      <form action="${cxt}/order" method="post" class="d-inline">
                        <input type="hidden" name="id" value="${o.id}" />
                        <input type="hidden" name="action" value="cancel" />
                        <button type="submit"
                                class="btn btn-sm btn-outline-danger mb-1"
                                onclick="return confirm('Bạn chắc chắn muốn hủy đơn #${o.id}?');">
                          Hủy đơn
                        </button>
                      </form>
                    </c:if>

                    <!-- Nếu đơn đang SHIPPING -> cho xác nhận đã nhận hàng -->
                    <c:if test="${o.status == 'SHIPPING'}">
                      <form action="${cxt}/order" method="post" class="d-inline">
                        <input type="hidden" name="id" value="${o.id}" />
                        <input type="hidden" name="action" value="received" />
                        <button type="submit"
                                class="btn btn-sm btn-outline-success mb-1"
                                onclick="return confirm('Xác nhận bạn đã nhận đủ hàng của đơn #${o.id}?');">
                          Đã nhận hàng
                        </button>
                      </form>
                    </c:if>
                  </td>
                </tr>
              </c:forEach>

              <c:if test="${empty orders}">
                <tr>
                  <td colspan="5" class="text-center text-muted">Bạn chưa có đơn hàng nào.</td>
                </tr>
              </c:if>
              </tbody>
            </table>
          </div>
          <div class="text-muted small">Danh sách được sắp xếp mới nhất trước.</div>
        </div>
      </div>
    </div>
  </c:if>

  <!-- Nếu là ADMIN (roleId == 1) -> hiển thị HOẠT ĐỘNG GẦN ĐÂY -->
  <c:if test="${u.roleId == 1}">
    <div class="col-lg-8">
      <div class="card">
        <div class="card-body">
          <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="card-title mb-0">Hoạt động gần đây</h5>

            <!-- Nút xoá toàn bộ activity log -->
            <form action="${cxt}/profile" method="post"
                  onsubmit="return confirm('Bạn có chắc chắn muốn xoá toàn bộ nhật ký hoạt động?');">
              <input type="hidden" name="action" value="clearLog" />
              <button type="submit" class="btn btn-sm btn-outline-danger">
                Xóa log
              </button>
            </form>
          </div>

          <div class="table-responsive">
            <table class="table align-middle">
              <thead class="table-light">
                <tr>
                  <th>Thời gian</th>
                  <th>Loại</th>
                  <th>Nội dung</th>
                  <th>IP</th>
                </tr>
              </thead>
              <tbody>
              <c:forEach var="a" items="${activities}">
                <tr>
                  <td><fmt:formatDate value="${a.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                  <td><span class="badge bg-soft-gray text-dark">${a.type}</span></td>
                  <td>${a.message}</td>
                  <td class="text-muted small">${a.ip}</td>
                </tr>
              </c:forEach>
              <c:if test="${empty activities}">
                <tr><td colspan="4" class="text-center text-muted">Chưa có hoạt động nào.</td></tr>
              </c:if>
              </tbody>
            </table>
          </div>
          <div class="text-muted small">Hiển thị tối đa 20 hoạt động gần nhất.</div>
        </div>
      </div>
    </div>
  </c:if>
</div>

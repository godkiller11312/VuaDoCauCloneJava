<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="cxt" value="${pageContext.request.contextPath}" />
<c:set var="u" value="${user}" />

<h3 class="mb-3">Hồ sơ cá nhân</h3>

<div class="row g-4">
  <!-- Thông tin tài khoản -->
  <div class="col-lg-4">
    <div class="card card-body">
      <div class="fs-5 fw-semibold mb-1">${u.name}</div>
      <div class="text-muted">${u.email}</div>
      <hr/>
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
                    <a class="btn btn-sm btn-outline-primary" href="${cxt}/order?id=${o.id}">Xem chi tiết</a>
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
          <h5 class="card-title mb-3">Hoạt động gần đây</h5>
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

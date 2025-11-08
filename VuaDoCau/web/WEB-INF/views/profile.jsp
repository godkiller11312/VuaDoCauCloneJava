<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="cxt" value="${pageContext.request.contextPath}" />
<c:set var="u"   value="${user}" />
<c:set var="isAdmin" value="${u.roleId == 1}" />

<h3 class="mb-3">Hồ sơ cá nhân</h3>

<div class="row g-4">
  <!-- Thông tin người dùng -->
  <div class="col-lg-4">
    <div class="card card-body">
      <div class="fs-5 fw-semibold mb-1">
        <c:out value="${u.name}" />
      </div>
      <div class="text-muted">
        <c:out value="${u.email}" />
      </div>
      <hr/>
      <a class="btn btn-outline-secondary w-100" href="${cxt}/logout">Đăng xuất</a>
    </div>
  </div>

  <!-- Đơn hàng của bạn: CHỈ hiện với user thường -->
  <c:if test="${not isAdmin}">
    <div class="col-lg-8">
      <div class="card">
        <div class="card-body">
          <h5 class="card-title mb-3">Đơn hàng của bạn</h5>
          <div class="table-responsive">
            <table class="table align-middle">
              <thead class="table-light">
                <tr>
                  <th>#</th>
                  <th>Ngày</th>
                  <th>Trạng thái</th>
                  <th class="text-end">Tổng</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="o" items="${orders}">
                  <tr>
                    <td><c:out value="${o.id}" /></td>
                    <td><fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                    <td><span class="badge bg-soft-gray"><c:out value="${o.status}" /></span></td>
                    <td class="text-end">
                      <fmt:formatNumber value="${o.total}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                    </td>
                    <td class="text-end">
                      <a class="btn btn-sm btn-outline-primary" href="${cxt}/order?id=${o.id}">Xem</a>
                    </td>
                  </tr>
                </c:forEach>

                <c:if test="${empty orders}">
                  <tr>
                    <td colspan="5" class="text-center text-muted">Chưa có đơn hàng nào</td>
                  </tr>
                </c:if>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </c:if>
</div>
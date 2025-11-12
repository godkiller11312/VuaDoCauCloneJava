<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Quản Lý Đơn hàng"/>
<c:set var="cxt" value="${pageContext.request.contextPath}" />
<c:set var="curSort" value="${empty sort ? 'id' : sort}" />
<c:set var="curDir"  value="${empty dir  ? 'desc' : dir}" />

<c:set var="baseLink" value="${cxt}/admin/orders?q=${q}&status=${status}" />
<c:set var="nextIdDir"    value="${curSort eq 'id'    and curDir eq 'asc' ? 'desc' : 'asc'}" />
<c:set var="nextDateDir"  value="${curSort eq 'date'  and curDir eq 'asc' ? 'desc' : 'asc'}" />
<c:set var="nextTotalDir" value="${curSort eq 'total' and curDir eq 'asc' ? 'desc' : 'asc'}" />

<h3 class="fw-bold mb-3">Quản Lý Đơn hàng</h3>

<c:if test="${not empty sessionScope.flash_success}">
  <div class="alert alert-success">${sessionScope.flash_success}</div>
  <c:remove var="flash_success" scope="session"/>
</c:if>
<c:if test="${not empty sessionScope.flash_error}">
  <div class="alert alert-danger">${sessionScope.flash_error}</div>
  <c:remove var="flash_error" scope="session"/>
</c:if>

<form class="row g-2 mb-3" method="get" action="${cxt}/admin/orders">
  <input type="hidden" name="sort" value="${curSort}">
  <input type="hidden" name="dir"  value="${curDir}">
  <div class="col-md-4">
    <input class="form-control" type="text" name="q" value="${q}" placeholder="Tìm: mã đơn / email / tên KH">
  </div>
  <div class="col-md-3">
    <select class="form-select" name="status">
      <option value="">Tất cả trạng thái</option>
      <option value="NEW"       ${status=='NEW'      ?'selected':''}>Mới đặt</option>
      <option value="CONFIRMED" ${status=='CONFIRMED'?'selected':''}>Đã xác nhận</option>
      <option value="SHIPPING"  ${status=='SHIPPING' ?'selected':''}>Đang giao hàng</option>
      <option value="DONE"      ${status=='DONE'     ?'selected':''}>Hoàn tất</option>
      <option value="CANCELED"  ${status=='CANCELED' ?'selected':''}>Đã hủy</option>
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
        <th style="white-space:nowrap">
          <a class="th-sort ${curSort eq 'id' ? 'sorted' : ''}" href="${baseLink}&sort=id&dir=${nextIdDir}">
            Mã <span class="sort-icon"><c:choose><c:when test="${curSort eq 'id'}">${curDir eq 'asc' ? '▲' : '▼'}</c:when><c:otherwise>↕</c:otherwise></c:choose></span>
          </a>
        </th>
        <th style="white-space:nowrap">
          <a class="th-sort ${curSort eq 'date' ? 'sorted' : ''}" href="${baseLink}&sort=date&dir=${nextDateDir}">
            Ngày <span class="sort-icon"><c:choose><c:when test="${curSort eq 'date'}">${curDir eq 'asc' ? '▲' : '▼'}</c:when><c:otherwise>↕</c:otherwise></c:choose></span>
          </a>
        </th>
        <th>Khách</th>
        <th>Trạng thái</th>
        <th class="text-end" style="white-space:nowrap">
          <a class="th-sort ${curSort eq 'total' ? 'sorted' : ''}" href="${baseLink}&sort=total&dir=${nextTotalDir}">
            Tổng <span class="sort-icon"><c:choose><c:when test="${curSort eq 'total'}">${curDir eq 'asc' ? '▲' : '▼'}</c:when><c:otherwise>↕</c:otherwise></c:choose></span>
          </a>
        </th>
        <th class="text-end">Thao tác</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="o" items="${orders}">
        <tr>
          <td>#${o.id}</td>
          <td><fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
          <td>
            <div class="small fw-semibold">${o.fullName}</div>
            <div class="small text-muted">${o.email}</div>
          </td>
          <td>
            <c:choose>
              <c:when test="${o.status=='NEW'}"><span class="badge bg-secondary">Mới đặt</span></c:when>
              <c:when test="${o.status=='CONFIRMED'}"><span class="badge bg-info text-dark">Đã xác nhận</span></c:when>
              <c:when test="${o.status=='SHIPPING'}"><span class="badge bg-warning text-dark">Đang giao</span></c:when>
              <c:when test="${o.status=='DONE'}"><span class="badge bg-success">Hoàn tất</span></c:when>
              <c:when test="${o.status=='CANCELED'}"><span class="badge bg-danger">Đã hủy</span></c:when>
              <c:otherwise><span class="badge bg-light text-dark">${o.status}</span></c:otherwise>
            </c:choose>
          </td>
          <td class="text-end"><fmt:formatNumber value="${o.total}" type="number" groupingUsed="true"/> đ</td>
          <td class="text-end">
            <a class="btn btn-sm btn-outline-primary me-1" href="${cxt}/admin/orders?action=detail&id=${o.id}">Xem</a>

            <!-- Hành động theo trạng thái -->
            <c:if test="${o.status=='NEW'}">
              <form method="post" action="${cxt}/admin/orders" class="d-inline">
                <input type="hidden" name="action" value="confirm"/>
                <input type="hidden" name="id" value="${o.id}"/>
                <button class="btn btn-sm btn-success">Xác nhận</button>
              </form>
              <form method="post" action="${cxt}/admin/orders" class="d-inline" onsubmit="return confirm('Từ chối đơn #${o.id}?');">
                <input type="hidden" name="action" value="reject"/>
                <input type="hidden" name="id" value="${o.id}"/>
                <button class="btn btn-sm btn-outline-danger">Từ chối</button>
              </form>
            </c:if>

            <c:if test="${o.status=='CONFIRMED'}">
              <form method="post" action="${cxt}/admin/orders" class="d-inline">
                <input type="hidden" name="action" value="startShipping"/>
                <input type="hidden" name="id" value="${o.id}"/>
                <button class="btn btn-sm btn-warning">Bắt đầu giao</button>
              </form>
            </c:if>

            <form method="post" action="${cxt}/admin/orders" class="d-inline" onsubmit="return confirm('Xóa đơn #${o.id}? Hành động không thể hoàn tác.');">
              <input type="hidden" name="action" value="delete"/>
              <input type="hidden" name="id" value="${o.id}"/>
              <button class="btn btn-sm btn-outline-secondary">Xóa</button>
            </form>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
</div>

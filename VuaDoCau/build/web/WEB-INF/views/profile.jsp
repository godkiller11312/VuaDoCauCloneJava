<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="cxt" value="${pageContext.request.contextPath}" />
<c:set var="u" value="${user}" />

<h3 class="mb-3">Hồ sơ cá nhân</h3>

<div class="row g-4">
  <div class="col-lg-4">
    <div class="card card-body">
      <div class="fs-5 fw-semibold mb-1">${u.name}</div>
      <div class="text-muted">${u.email}</div>
      <hr/>
      <a class="btn btn-outline-secondary w-100" href="${cxt}/logout">Đăng xuất</a>
    </div>
  </div>

  <div class="col-lg-8">
    <div class="card">
      <div class="card-body">
        <h5 class="card-title mb-3">Hoạt động gần đây</h5>
        <div class="table-responsive">
          <table class="table align-middle">
            <thead class="table-light">
              <tr>
                <th>#</th>
                <th>Thời gian</th>
                <th>Loại</th>
                <th>Nội dung</th>
                <th>IP</th>
              </tr>
            </thead>
            <tbody>
            <c:forEach var="a" items="${activities}" varStatus="st">
              <tr>
                <td>${st.index + 1}</td>
                <td><fmt:formatDate value="${a.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
               <td>
  <span class="badge bg-secondary">${a.type}</span>
</td>

                <td>${a.message}</td>
                <td>${a.ip}</td>
              </tr>
            </c:forEach>
            <c:if test="${empty activities}">
              <tr>
                <td colspan="5" class="text-center text-muted">Chưa có hoạt động nào</td>
              </tr>
            </c:if>
            </tbody>
          </table>
        </div>
        <div class="text-muted small">
          Hiển thị tối đa 20 hoạt động gần nhất.
        </div>
      </div>
    </div>
  </div>
</div>

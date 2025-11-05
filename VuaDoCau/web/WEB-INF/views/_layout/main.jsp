<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="cxt" value="${pageContext.request.contextPath}" />
<c:set var="auth" value="${sessionScope.authUser}" />
<c:set var="isAdmin" value="${not empty auth and auth.roleId == 1}" />

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <title><c:out value="${empty pageTitle ? 'Vua Đồ Câu' : pageTitle}"/></title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>

  <!-- CSS -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <!-- Đường dẫn đúng trong project -->
  <link rel="stylesheet" href="${cxt}/asset/css/site.css"/>


</head>
<body class="bg-soft">

  <!-- Header dùng chung -->
<%@ include file="/WEB-INF/views/partials/header.jspf" %>

  <!-- Nội dung riêng -->
  <main class="container py-4">
    <jsp:include page="${view}"/>
  </main>

  <!-- Footer + scripts dùng chung -->
<%@ include file="/WEB-INF/views/partials/footer.jspf" %>
<%@ include file="/WEB-INF/views/partials/scripts.jspf" %>

  <!-- Mini-cart chỉ hiện cho user (không phải admin) -->
  <c:if test="${!isAdmin}">
    <jsp:include page="/WEB-INF/views/partials/mini-cart.jsp"/>
  </c:if>

  <!-- scripts phụ theo trang (tuỳ chọn) -->
  <c:if test="${not empty scriptExtra}">
    <jsp:include page="${scriptExtra}"/>
  </c:if>
</body>
</html>
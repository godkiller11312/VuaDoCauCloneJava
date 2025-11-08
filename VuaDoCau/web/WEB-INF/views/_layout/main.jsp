<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="cxt" value="${pageContext.request.contextPath}" />
<c:set var="auth" value="${sessionScope.authUser}" />
<c:set var="isAdmin" value="${not empty auth and auth.roleId == 1}" />

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title><c:out value="${empty pageTitle ? 'Vua Đồ Câu' : pageTitle}"/></title>

  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <link rel="stylesheet" href="${cxt}/asset/css/site.css"/>
</head>
<body class="bg-soft">
  <%@ include file="/WEB-INF/views/partials/header.jspf" %>

  <main class="container py-4">
    <jsp:include page="${view}"/>
  </main>

  <%@ include file="/WEB-INF/views/partials/footer.jspf" %>

  <%-- ✅ Mini-cart: include MỘT LẦN, ngay TRƯỚC scripts --%>
  <jsp:include page="/WEB-INF/views/partials/mini-cart.jsp"/>

  <%@ include file="/WEB-INF/views/partials/scripts.jspf" %>
</body>
</html>
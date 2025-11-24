<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="cxt" value="${pageContext.request.contextPath}" />

<%-- ======================= BUILD URL MỚI NHẤT ======================= --%>
<c:url var="urlNewest" value="/products">
    <c:if test="${not empty q}">
        <c:param name="q" value="${q}" />
    </c:if>
    <c:if test="${not empty g}">
        <c:param name="g" value="${g}" />
    </c:if>
    <c:param name="sortNew" value="1" />
</c:url>

<%-- ======================= BUILD URL BÁN CHẠY ======================= --%>
<c:url var="urlTop" value="/products">
    <c:if test="${not empty q}">
        <c:param name="q" value="${q}" />
    </c:if>
    <c:if test="${not empty g}">
        <c:param name="g" value="${g}" />
    </c:if>
    <c:param name="sortTop" value="1" />
</c:url>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h3 class="mb-0 fw-bold">Sản phẩm</h3>

    <div class="btn-group btn-group-sm">
        <a href="${urlNewest}"
           class="btn btn-outline-secondary ${empty sortTop ? 'active' : ''}">
            Mới nhất
        </a>

        <a href="${urlTop}"
           class="btn btn-outline-secondary ${not empty sortTop ? 'active' : ''}">
            Bán chạy
        </a>
    </div>
</div>

<c:choose>
    <c:when test="${empty products}">
        <div class="alert alert-info">Không có sản phẩm phù hợp.</div>
    </c:when>

    <c:otherwise>

        <div class="row g-4">

            <c:forEach items="${products}" var="p">
                <div class="col-12 col-sm-6 col-md-4 col-lg-3">
                    <div class="card h-100 shadow-sm rounded-4 border-0">

                        <div class="ratio ratio-1x1 rounded-top-4 d-flex align-items-center justify-content-center thumb">
                            <a href="${cxt}/product?id=${p.id}" class="d-block">
                                <img class="p-4"
                                     src="${cxt}/asset/images/${p.image != null ? p.image : 'no-image.png'}"
                                     alt="${p.name}"
                                     onerror="this.src='${cxt}/asset/images/no-image.png'">
                            </a>
                        </div>

                        <div class="card-body">

                            <span class="badge bg-light text-dark mb-2">${p.categoryName}</span>

                            <h6 class="card-title">
                                <a class="text-decoration-none text-dark" href="${cxt}/product?id=${p.id}">
                                    ${p.name}
                                </a>
                            </h6>

                            <c:set var="r" value="${p.rating}" />
                            <div class="small text-muted d-flex align-items-center gap-2">
                                <span class="stars-outer">
                                    <span class="stars-inner" style="width:${r * 20}%"></span>
                                </span>

                                <small>
                                    <fmt:formatNumber value="${r}"
                                                      minFractionDigits="1"
                                                      maxFractionDigits="1"/>
                                </small>

                                · Đã mua: ${p.purchased}
                            </div>

                            <div class="small mt-1">
                                <c:choose>
                                    <c:when test="${p.stock <= 0}">
                                        <span class="text-danger">Hết hàng</span>
                                    </c:when>
                                    <c:otherwise>
                                        Còn: <strong>${p.stock}</strong>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="mt-2">
                                <c:if test="${p.oldPrice != null && p.oldPrice > 0 && p.oldPrice > p.price}">
                                    <span class="text-muted text-decoration-line-through me-2">
                                        <fmt:formatNumber value="${p.oldPrice}" type="number" groupingUsed="true" /> đ
                                    </span>
                                </c:if>

                                <span class="fw-bold text-danger">
                                    <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/> đ
                                </span>
                            </div>

                            <div class="mt-3 d-grid">
                                <c:choose>
                                    <c:when test="${p.stock <= 0}">
                                        <button class="btn btn-secondary rounded-pill" disabled>Hết hàng</button>
                                    </c:when>
                                    <c:otherwise>
                                        <a class="btn btn-teal rounded-pill btn-add-to-cart"
                                           href="${cxt}/cart?action=add&id=${p.id}"
                                           data-id="${p.id}" data-qty="1">
                                            Thêm vào giỏ
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                        </div>
                    </div>
                </div>
            </c:forEach>

        </div>

    </c:otherwise>
</c:choose>

<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="cxt" value="${pageContext.request.contextPath}" />
<c:set var="p" value="${requestScope.p}" />

<div class="row g-4">
  <!-- ẢNH SẢN PHẨM -->
  <div class="col-12 col-md-5">
    <div class="ratio ratio-1x1 rounded-4 d-flex align-items-center justify-content-center thumb">
      <img class="p-4 w-100 h-100"
           src="${cxt}/asset/images/${p.image != null ? p.image : 'no-image.png'}"
           alt="${p.name}"
           onerror="this.src='${cxt}/asset/images/no-image.png'">
    </div>
  </div>

  <!-- THÔNG TIN SẢN PHẨM -->
  <div class="col-12 col-md-7">
    <span class="badge bg-light text-dark mb-2">${p.categoryName}</span>
    <h3 class="fw-bold mb-2">${p.name}</h3>

    <div class="small text-muted mb-2 d-flex align-items-center gap-2">
      <span class="stars-outer">
        <span class="stars-inner" style="width:${p.rating * 20}%"></span>
      </span>
      <small><fmt:formatNumber value="${p.rating}" minFractionDigits="1" maxFractionDigits="1"/></small>
      · Đã mua: ${p.purchased}
    </div>

    <div class="mb-3">
      <c:if test="${p.oldPrice != null && p.oldPrice > 0 && p.oldPrice > p.price}">
        <span class="text-muted text-decoration-line-through me-2">
          <fmt:formatNumber value="${p.oldPrice}" type="number" groupingUsed="true"/> đ
        </span>
      </c:if>
      <span class="fw-bold text-danger fs-4">
        <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/> đ
      </span>
    </div>

    <div class="mb-3">
      <c:choose>
        <c:when test="${p.stock <= 0}">
          <span class="badge bg-danger">Hết hàng</span>
        </c:when>
        <c:otherwise>
          Còn: <strong>${p.stock}</strong>
        </c:otherwise>
      </c:choose>
    </div>

    <div class="mb-4">
      <c:out value="${p.description}" />
    </div>

    <div class="d-flex gap-2">
      <c:choose>
        <c:when test="${p.stock <= 0}">
          <button class="btn btn-secondary rounded-pill" disabled>Hết hàng</button>
        </c:when>
        <c:otherwise>
          <a class="btn btn-teal rounded-pill btn-add-to-cart"
             href="${cxt}/cart?action=add&id=${p.id}"
             data-id="${p.id}" data-qty="1">Thêm vào giỏ</a>
        </c:otherwise>
      </c:choose>
      <a class="btn btn-outline-secondary rounded-pill" href="${cxt}/products?g=all">← Tiếp tục mua sắm</a>
    </div>
  </div>

  <!-- FORM ĐÁNH GIÁ: chỉ hiện nếu từ đơn hàng DONE (có fromOrder) -->
  <c:if test="${not empty param.fromOrder}">
    <div class="col-12 mt-4">
      <div class="card">
        <div class="card-body">
          <h5 class="fw-bold mb-3">Đánh giá sản phẩm</h5>
          <p class="text-muted small mb-3">
            Cảm ơn bạn đã mua hàng. Hãy để lại đánh giá của bạn về sản phẩm.
          </p>

          <form action="${cxt}/product" method="post" class="vstack gap-3">
            <input type="hidden" name="action" value="review"/>
            <input type="hidden" name="productId" value="${p.id}"/>
            <input type="hidden" name="orderId" value="${param.fromOrder}"/>

            <div>
              <label class="form-label">Chọn số sao:</label>
              <div class="d-flex gap-2">
                <c:forEach begin="1" end="5" var="star">
                  <div class="form-check">
                    <input class="form-check-input" type="radio"
                           name="rating" id="rate${star}" value="${star}"
                           <c:if test="${star == 5}">checked</c:if> />
                    <label class="form-check-label" for="rate${star}">
                      ${star} ★
                    </label>
                  </div>
                </c:forEach>
              </div>
            </div>

            <div>
              <label for="cmt" class="form-label">Nhận xét của bạn</label>
              <textarea id="cmt" name="comment" rows="3"
                        class="form-control"
                        placeholder="Sản phẩm có tốt không, đóng gói, giao hàng..."></textarea>
            </div>

            <div>
              <button type="submit" class="btn btn-teal rounded-pill">
                Gửi đánh giá
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </c:if>

  <!-- DANH SÁCH ĐÁNH GIÁ -->
  <div class="col-12 mt-4">
    <div class="card">
      <div class="card-body">
        <h5 class="fw-bold mb-3">Đánh giá từ người mua</h5>

        <c:if test="${empty reviews}">
          <p class="text-muted mb-0">Chưa có đánh giá nào cho sản phẩm này.</p>
        </c:if>

        <c:forEach var="rv" items="${reviews}">
          <div class="mb-3 border-bottom pb-2">
            <div class="d-flex justify-content-between">
              <strong>${rv.userName}</strong>
              <small class="text-muted">
                <fmt:formatDate value="${rv.createdAt}" pattern="dd/MM/yyyy HH:mm" />
              </small>
            </div>

            <div class="small mb-1">
              <c:forEach begin="1" end="5" var="i">
                <c:choose>
                  <c:when test="${i <= rv.rating}">★</c:when>
                  <c:otherwise>☆</c:otherwise>
                </c:choose>
              </c:forEach>
            </div>

            <div>${rv.comment}</div>
          </div>
        </c:forEach>

      </div>
    </div>
  </div>
</div>

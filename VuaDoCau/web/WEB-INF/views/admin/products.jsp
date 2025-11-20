<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="cxt" value="${pageContext.request.contextPath}" />
<c:set var="curSort" value="${empty sort ? 'id' : sort}" />
<c:set var="curDir"  value="${empty dir  ? 'desc' : dir}" />
<c:set var="baseLink" value="${cxt}/admin/products?q=${q}&cat=${cat}" />

<c:set var="nextIdDir"        value="${curSort eq 'id'        and curDir eq 'asc' ? 'desc' : 'asc'}" />
<c:set var="nextNameDir"      value="${curSort eq 'name'      and curDir eq 'asc' ? 'desc' : 'asc'}" />
<c:set var="nextOldPriceDir"  value="${curSort eq 'oldPrice'  and curDir eq 'asc' ? 'desc' : 'asc'}" />
<c:set var="nextPriceDir"     value="${curSort eq 'price'     and curDir eq 'asc' ? 'desc' : 'asc'}" />
<c:set var="nextStockDir"     value="${curSort eq 'stock'     and curDir eq 'asc' ? 'desc' : 'asc'}" />
<c:set var="nextRatingDir"    value="${curSort eq 'rating'    and curDir eq 'asc' ? 'desc' : 'asc'}" />
<c:set var="nextPurchasedDir" value="${curSort eq 'purchased' and curDir eq 'asc' ? 'desc' : 'asc'}" />

<style>
  .th-sort{color:inherit;text-decoration:none;display:inline-flex;align-items:center;gap:.35rem}
  .th-sort:hover{color:inherit;text-decoration:none}
  .sort-icon{font-size:.9rem;opacity:.55}
  .sorted .sort-icon{opacity:.9}
</style>

<!-- ======= Thanh tìm kiếm + lọc + nút Thêm ======= -->
<div class="row g-2 align-items-center mb-3">
  <div class="col-12 col-lg-9">
    <form class="row g-2 align-items-center" method="get" action="${cxt}/admin/products">
      <input type="hidden" name="sort" value="${curSort}">
      <input type="hidden" name="dir"  value="${curDir}">

      <div class="col-12 col-md-6">
        <input class="form-control" name="q" value="${fn:escapeXml(q)}"
               placeholder="Tìm theo tên sản phẩm...">
      </div>

      <div class="col-8 col-md-4">
        <select class="form-select" name="cat">
          <option value="">-- Tất cả danh mục --</option>
          <c:forEach var="c" items="${categories}">
            <option value="${c.id}" <c:if test="${cat == c.id}">selected</c:if>>
              ${c.name}
            </option>
          </c:forEach>
        </select>
      </div>

      <div class="col-4 col-md-2">
        <button class="btn btn-outline-secondary w-100">Lọc</button>
      </div>
    </form>
  </div>

  <div class="col-12 col-lg-3 text-lg-end">
    <button class="btn btn-teal btn-success" data-bs-toggle="modal" data-bs-target="#modalCreate">
      Thêm sản phẩm
    </button>
  </div>
</div>

<!-- Thống kê nhỏ -->
<div class="mb-2 small text-muted">
  Kết quả: <strong>${fn:length(products)}</strong>
  <c:if test="${not empty q}"> · Từ khóa: “${fn:escapeXml(q)}”</c:if>
  <c:if test="${not empty cat}">
    · Danh mục:
    <c:forEach var="c" items="${categories}">
      <c:if test="${c.id == cat}"><strong>${c.name}</strong></c:if>
    </c:forEach>
  </c:if>
</div>

<!-- ======= BẢNG DANH SÁCH ======= -->
<div class="table-responsive">
  <table class="table align-middle">
    <thead class="table-light">
      <tr>
        <th style="white-space:nowrap;">
          <a class="th-sort ${curSort eq 'id' ? 'sorted' : ''}"
             href="${baseLink}&sort=id&dir=${nextIdDir}">
            # <span class="sort-icon">
                <c:choose>
                  <c:when test="${curSort eq 'id'}">${curDir eq 'asc' ? '▲' : '▼'}</c:when>
                  <c:otherwise>↕</c:otherwise>
                </c:choose>
              </span>
          </a>
        </th>

        <th>Ảnh</th>

        <th style="white-space:nowrap;">
          <a class="th-sort ${curSort eq 'name' ? 'sorted' : ''}"
             href="${baseLink}&sort=name&dir=${nextNameDir}">
            Tên <span class="sort-icon">
                  <c:choose>
                    <c:when test="${curSort eq 'name'}">${curDir eq 'asc' ? '▲' : '▼'}</c:when>
                    <c:otherwise>↕</c:otherwise>
                  </c:choose>
                </span>
          </a>
        </th>

        <th>Danh mục</th>

        <th class="text-end" style="white-space:nowrap;">
          <a class="th-sort ${curSort eq 'oldPrice' ? 'sorted' : ''}"
             href="${baseLink}&sort=oldPrice&dir=${nextOldPriceDir}">
            Giá cũ
            <span class="sort-icon">
              <c:choose>
                <c:when test="${curSort eq 'oldPrice'}">${curDir eq 'asc' ? '▲' : '▼'}</c:when>
                <c:otherwise>↕</c:otherwise>
              </c:choose>
            </span>
          </a>
        </th>

        <th class="text-end" style="white-space:nowrap;">
          <a class="th-sort ${curSort eq 'price' ? 'sorted' : ''}"
             href="${baseLink}&sort=price&dir=${nextPriceDir}">
            Giá
            <span class="sort-icon">
              <c:choose>
                <c:when test="${curSort eq 'price'}">${curDir eq 'asc' ? '▲' : '▼'}</c:when>
                <c:otherwise>↕</c:otherwise>
              </c:choose>
            </span>
          </a>
        </th>

        <th class="text-center" style="white-space:nowrap;">
          <a class="th-sort ${curSort eq 'stock' ? 'sorted' : ''}"
             href="${baseLink}&sort=stock&dir=${nextStockDir}">
            Tồn <span class="sort-icon">
                  <c:choose>
                    <c:when test="${curSort eq 'stock'}">${curDir eq 'asc' ? '▲' : '▼'}</c:when>
                    <c:otherwise>↕</c:otherwise>
                  </c:choose>
                </span>
          </a>
        </th>

        <th class="text-center" style="white-space:nowrap;">
          <a class="th-sort ${curSort eq 'rating' ? 'sorted' : ''}"
             href="${baseLink}&sort=rating&dir=${nextRatingDir}">
            Đánh giá <span class="sort-icon">
                       <c:choose>
                         <c:when test="${curSort eq 'rating'}">${curDir eq 'asc' ? '▲' : '▼'}</c:when>
                         <c:otherwise>↕</c:otherwise>
                       </c:choose>
                     </span>
          </a>
        </th>

        <th class="text-center" style="white-space:nowrap;">
          <a class="th-sort ${curSort eq 'purchased' ? 'sorted' : ''}"
             href="${baseLink}&sort=purchased&dir=${nextPurchasedDir}">
            Đã mua <span class="sort-icon">
                     <c:choose>
                       <c:when test="${curSort eq 'purchased'}">${curDir eq 'asc' ? '▲' : '▼'}</c:when>
                       <c:otherwise>↕</c:otherwise>
                     </c:choose>
                   </span>
          </a>
        </th>

        <th class="text-end">Thao tác</th>
      </tr>
    </thead>

    <tbody>
      <c:forEach var="p" items="${products}">
        <tr>
          <td>${p.id}</td>

          <td style="width:64px">
            <c:choose>
              <c:when test="${not empty p.image and (fn:startsWith(p.image,'http') or fn:startsWith(p.image,'/'))}">
                <img src="${p.image}" class="img-thumbnail"
                     style="width:56px;height:56px;object-fit:cover"
                     onerror="this.src='${cxt}/asset/images/no-image.png'">
              </c:when>
              <c:otherwise>
                <img src="${cxt}/asset/images/${empty p.image ? 'no-image.png' : p.image}"
                     class="img-thumbnail"
                     style="width:56px;height:56px;object-fit:cover"
                     onerror="this.src='${cxt}/asset/images/no-image.png'">
              </c:otherwise>
            </c:choose>
          </td>

          <td class="fw-semibold">${p.name}</td>
          <td>${p.categoryName}</td>

          <!-- Giá cũ -->
          <td class="text-end text-muted" style="min-width:120px">
            <c:choose>
              <c:when test="${p.oldPrice != null && p.oldPrice > 0}">
                <fmt:formatNumber value="${p.oldPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
              </c:when>
              <c:otherwise>—</c:otherwise>
            </c:choose>
          </td>

          <!-- Giá -->
          <td class="text-end fw-semibold" style="min-width:120px">
            <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
          </td>

          <td class="text-center">${p.stock}</td>
          <td class="text-center">${p.rating}</td>
          <td class="text-center">${p.purchased}</td>

          <td class="text-end">
            <a class="btn btn-sm btn-outline-secondary" href="${cxt}/admin/products?action=detail&id=${p.id}">Xem</a>
            <a class="btn btn-sm btn-outline-primary"   href="${cxt}/admin/products?action=detail&id=${p.id}">Sửa</a>
            <form action="${cxt}/admin/products" method="post" class="d-inline"
                  onsubmit="return confirm('Xóa sản phẩm #${p.id}?');">
              <input type="hidden" name="action" value="delete"/>
              <input type="hidden" name="id"     value="${p.id}"/>
              <button class="btn btn-sm btn-outline-danger">Xóa</button>
            </form>
          </td>
        </tr>
      </c:forEach>

      <c:if test="${empty products}">
        <tr><td colspan="10" class="text-center text-muted">Không có sản phẩm</td></tr>
      </c:if>
    </tbody>
  </table>
</div>

<!-- ============== Modal: Thêm sản phẩm ============== -->
<div class="modal fade" id="modalCreate" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-scrollable">
    <form class="modal-content" action="${cxt}/admin/products" method="post" enctype="multipart/form-data">
      <input type="hidden" name="action" value="create"/>
      <div class="modal-header">
        <h5 class="modal-title">Thêm sản phẩm</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <div class="row g-3">
          <div class="col-md-8">
            <label class="form-label">Tên</label>
            <input class="form-control" name="name" required/>
          </div>
          <div class="col-md-4">
            <label class="form-label">Danh mục</label>
            <select class="form-select" name="categoryId" required>
              <c:forEach var="c" items="${categories}">
                <option value="${c.id}">${c.name}</option>
              </c:forEach>
            </select>
          </div>

          <div class="col-md-4">
            <label class="form-label">Thương hiệu</label>
            <select class="form-select" name="brandId">
              <option value="">Không chọn</option>
              <c:forEach var="b" items="${brands}">
                <option value="${b.id}">${b.name}</option>
              </c:forEach>
            </select>
            <div class="form-text">Có thể để trống nếu không thuộc thương hiệu nào.</div>
          </div>
          <div class="col-md-4">
            <label class="form-label">Giá</label>
            <input class="form-control" name="price" required/>
          </div>
          <div class="col-md-4">
            <label class="form-label">Giá cũ (tuỳ chọn)</label>
            <input class="form-control" name="oldPrice" placeholder="VD: 1,990,000"/>
          </div>

          <div class="col-md-4">
            <label class="form-label">Tồn kho</label>
            <input class="form-control" name="stock" value="0" required/>
          </div>

         <div class="col-md-6">
  <label class="form-label">Ảnh sản phẩm</label>
  <input type="file" class="form-control" name="imageFile" accept="image/*"/>
  <div class="form-text">Chọn file ảnh, hệ thống sẽ tự lưu vào /asset/images.</div>
</div>
          <div class="col-md-6">
            <label class="form-label">Rating</label>
            <input class="form-control" name="rating" value="0"/>
          </div>
          <div class="col-12">
            <label class="form-label">Mô tả</label>
            <textarea class="form-control" name="description" rows="3"></textarea>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" data-bs-dismiss="modal" type="button">Hủy</button>
        <button class="btn btn-success">Lưu</button>
      </div>
    </form>
  </div>
</div>

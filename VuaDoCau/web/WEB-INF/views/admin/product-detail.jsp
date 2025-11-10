<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="cxt" value="${pageContext.request.contextPath}" />

<div class="d-flex align-items-center justify-content-between mb-3">
  <h3 class="mb-0">Sửa sản phẩm #${p.id}</h3>
  <a class="btn btn-outline-secondary" href="${cxt}/admin/products">← Quay lại danh sách</a>
</div>

<div class="row g-4">
  <div class="col-lg-8">
    <form action="${cxt}/admin/products" method="post" class="card card-body">
      <input type="hidden" name="action" value="update"/>
      <input type="hidden" name="id" value="${p.id}"/>

      <div class="row g-3">
        <div class="col-md-8">
          <label class="form-label">Tên</label>
          <input class="form-control" name="name" value="${p.name}" required/>
        </div>
        <div class="col-md-4">
  <label class="form-label">Giá</label>
  <input class="form-control" name="price" value="${p.price}"/>
</div>
<div class="col-md-4">
  <label class="form-label">Giá cũ (tuỳ chọn)</label>
  <input class="form-control" name="oldPrice" value="${p.oldPrice}"/>
</div>
<div class="col-md-4">
  <label class="form-label">Tồn kho</label>
  <input class="form-control" name="stock" value="${p.stock}"/>
</div>

        <div class="col-md-4">
          <label class="form-label">Thương hiệu (mã)</label>
          <input class="form-control" name="brandId" value="${p.brandId}"/>
        </div>
        <div class="col-md-4">
          <label class="form-label">Giá</label>
          <input class="form-control" name="price" value="${p.price}"/>
        </div>
        <div class="col-md-4">
          <label class="form-label">Tồn kho</label>
          <input class="form-control" name="stock" value="${p.stock}"/>
        </div>

        <div class="col-md-6">
          <label class="form-label">Ảnh (URL hoặc tên file trong /asset/images)</label>
          <input id="imgInput" class="form-control" name="image" value="${p.image}"/>
        </div>
        <div class="col-md-3">
          <label class="form-label">Rating</label>
          <input class="form-control" name="rating" value="${p.rating}"/>
        </div>
        <div class="col-md-3">
          <label class="form-label">Đã mua</label>
          <input class="form-control" name="purchased" value="${p.purchased}"/>
        </div>

        <div class="col-12">
          <label class="form-label">Mô tả</label>
          <textarea class="form-control" name="description" rows="4">${p.description}</textarea>
        </div>
      </div>

      <div class="d-flex gap-2 mt-3">
        <button class="btn btn-teal">Lưu thay đổi</button>
        <a class="btn btn-outline-secondary" href="${cxt}/admin/products">Hủy</a>
      </div>
    </form>
  </div>

  <div class="col-lg-4">
    <div class="card">
      <div class="card-body">
        <div class="ratio ratio-1x1 mb-3" style="max-width:320px">
          <img id="imgPreview"
               src="${
                 (not empty p.image and (fn:startsWith(p.image,'http') or fn:startsWith(p.image,'/')))
                   ? p.image
                   : (empty p.image
                        ? cxt.concat('/asset/images/no-image.png')
                        : cxt.concat('/asset/images/').concat(p.image))
               }"
               class="img-fluid rounded"
               alt="${p.name}"
               style="object-fit:cover"
               onerror="this.src='${cxt}/asset/images/no-image.png'">
        </div>

        <div class="text-muted small">
          ID: <strong>${p.id}</strong><br/>
          Danh mục: <strong>${p.categoryName}</strong><br/>
          Thương hiệu: <strong><c:out value="${p.brandName}"/></strong>
        </div>
        <hr/>
        <form action="${cxt}/admin/products" method="post"
              onsubmit="return confirm('Xóa sản phẩm #${p.id}?');">
          <input type="hidden" name="action" value="delete"/>
          <input type="hidden" name="id" value="${p.id}"/>
          <button class="btn btn-outline-danger w-100">Xóa sản phẩm</button>
        </form>
      </div>
    </div>
  </div>
</div>

<script>
  // Live preview khi sửa ô Ảnh
  (function () {
    var input = document.getElementById('imgInput');
    var img   = document.getElementById('imgPreview');
    if (!input || !img) return;

    input.addEventListener('input', function () {
      var v = (input.value || '').trim();
      var cxt = '<c:out value="${cxt}"/>';
      var src;
      if (!v) {
        src = cxt + '/asset/images/no-image.png';
      } else if (v.startsWith('http') || v.startsWith('/')) {
        src = v;
      } else {
        src = cxt + '/asset/images/' + v;
      }
      img.src = src;
    });
  })();
</script>
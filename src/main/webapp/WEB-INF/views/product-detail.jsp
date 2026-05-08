<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${product.name} – ShopWave</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
  <div class="navbar-inner">
    <a href="${pageContext.request.contextPath}/" class="brand">Shop<span>Wave</span></a>
    <ul class="nav-links">
      <li><a href="${pageContext.request.contextPath}/">Products</a></li>
      <li><a href="${pageContext.request.contextPath}/cart" class="cart-btn">
        🛒 Cart <span class="cart-badge" id="cart-badge" style="display:none">0</span>
      </a></li>
    </ul>
  </div>
</nav>

<div class="container">
  <!-- Breadcrumb -->
  <div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/">Home</a>
    <span>›</span>
    <a href="${pageContext.request.contextPath}/products?category=${product.category}">${product.category}</a>
    <span>›</span>
    <span>${product.name}</span>
  </div>

  <!-- Product Detail -->
  <div class="product-detail-wrap">
    <div>
      <img class="product-detail-image"
           src="${product.imageUrl}"
           alt="${product.name}"
           onerror="this.src='https://via.placeholder.com/600x500?text=Product'">
    </div>

    <div class="product-detail-info">
      <div class="product-detail-category">${product.category}</div>
      <h1 class="product-detail-title">${product.name}</h1>

      <div class="product-rating" style="margin-bottom:1rem; font-size:1.1rem;">
        <span class="stars">
          <c:forEach begin="1" end="5" var="star">
            <c:choose>
              <c:when test="${star <= product.rating}">★</c:when>
              <c:otherwise>☆</c:otherwise>
            </c:choose>
          </c:forEach>
        </span>
        <span class="rating-count" style="font-size:0.95rem;">${product.rating} / 5.0</span>
      </div>

      <div class="product-detail-price">$<fmt:formatNumber value="${product.price}" pattern="0.00"/></div>

      <p class="product-detail-desc">${product.description}</p>

      <div class="stock-badge">
        ✓ In Stock (${product.stock} available)
      </div>

      <div class="qty-wrapper">
        <span class="qty-label">Quantity:</span>
        <div class="qty-control">
          <button class="qty-btn" onclick="changeQty(-1)">−</button>
          <input type="number" id="qty-input" class="qty-input" value="1" min="1" max="${product.stock}">
          <button class="qty-btn" onclick="changeQty(1)">+</button>
        </div>
      </div>

      <button class="btn-primary" onclick="addToCartFromDetail()" style="margin-bottom:1rem;">
        🛒 Add to Cart
      </button>

      <a href="${pageContext.request.contextPath}/cart" class="btn-secondary" style="display:block;text-align:center;margin-bottom:1rem;">
        View Cart
      </a>
    </div>
  </div>

  <!-- Related Products -->
  <c:if test="${not empty relatedProducts}">
    <h2 class="related-title">More in ${product.category}</h2>
    <div class="products-grid">
      <c:forEach var="rp" items="${relatedProducts}">
        <div class="product-card">
          <div class="product-card-img-wrap">
            <img class="product-card-image" src="${rp.imageUrl}" alt="${rp.name}"
                 onerror="this.src='https://via.placeholder.com/400x200?text=Product'">
          </div>
          <div class="product-card-body">
            <a href="${pageContext.request.contextPath}/product/${rp.id}" class="product-name">${rp.name}</a>
            <div class="product-footer">
              <span class="product-price">$<fmt:formatNumber value="${rp.price}" pattern="0.00"/></span>
              <button class="add-to-cart-sm"
                      onclick="Cart.addItem({id:${rp.id},name:'${fn:escapeXml(rp.name)}',price:${rp.price},imageUrl:'${rp.imageUrl}',category:'${rp.category}',quantity:1}); Toast.show('${fn:escapeXml(rp.name)} added!','success')">
                🛒 Add
              </button>
            </div>
          </div>
        </div>
      </c:forEach>
    </div>
  </c:if>
</div>

<footer>
  <p>Built with ❤️ using <strong>Spring MVC + Spring JDBC</strong> | E-Commerce Project</p>
</footer>

<script src="${pageContext.request.contextPath}/static/js/cart.js"></script>
<script>
  const PRODUCT = {
    id: ${product.id},
    name: '${fn:escapeXml(product.name)}',
    price: ${product.price},
    imageUrl: '${product.imageUrl}',
    category: '${product.category}'
  };

  function changeQty(delta) {
    const input = document.getElementById('qty-input');
    const newVal = Math.max(1, Math.min(${product.stock}, parseInt(input.value) + delta));
    input.value = newVal;
  }

  function addToCartFromDetail() {
    const qty = parseInt(document.getElementById('qty-input').value) || 1;
    Cart.addItem({ ...PRODUCT, quantity: qty });
    Toast.show(`${fn:escapeXml(product.name)} (×\${qty}) added to cart! 🛒`, 'success');
  }
</script>
</body>
</html>

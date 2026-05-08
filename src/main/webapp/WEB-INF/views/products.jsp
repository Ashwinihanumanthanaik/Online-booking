<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ShopWave – Browse Products</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
  <div class="navbar-inner">
    <a href="${pageContext.request.contextPath}/" class="brand">Shop<span>Wave</span></a>

    <!-- Search -->
    <form class="search-bar-wrap" action="${pageContext.request.contextPath}/products" method="get">
      <div class="search-bar">
        <input type="text" name="search" placeholder="Search products..."
               value="${search}" autocomplete="off">
        <input type="hidden" name="category" value="${selectedCategory}">
        <input type="hidden" name="sort" value="${selectedSort}">
        <button type="submit">🔍</button>
      </div>
    </form>

    <ul class="nav-links">
      <li><a href="${pageContext.request.contextPath}/" class="active">Products</a></li>
      <li><a href="${pageContext.request.contextPath}/cart" class="cart-btn">
        🛒 Cart <span class="cart-badge" id="cart-badge" style="display:none">0</span>
      </a></li>
    </ul>
  </div>
</nav>

<!-- FILTERS -->
<div class="filters-section">
  <div class="filters-inner">
    <span class="filter-label">Category:</span>
    <div class="filter-chips">
      <a href="${pageContext.request.contextPath}/products?search=${search}&sort=${selectedSort}"
         class="chip ${empty selectedCategory || selectedCategory == 'All' ? 'active' : ''}">All</a>
      <c:forEach var="cat" items="${categories}">
        <a href="${pageContext.request.contextPath}/products?search=${search}&category=${cat}&sort=${selectedSort}"
           class="chip ${selectedCategory == cat ? 'active' : ''}">${cat}</a>
      </c:forEach>
    </div>

    <form class="sort-form" style="margin-left:auto;" action="${pageContext.request.contextPath}/products" method="get">
      <input type="hidden" name="search" value="${search}">
      <input type="hidden" name="category" value="${selectedCategory}">
      <select name="sort" class="sort-select" onchange="this.form.submit()">
        <option value="" ${empty selectedSort ? 'selected' : ''}>Sort: Featured</option>
        <option value="price_asc" ${selectedSort == 'price_asc' ? 'selected' : ''}>Price: Low → High</option>
        <option value="price_desc" ${selectedSort == 'price_desc' ? 'selected' : ''}>Price: High → Low</option>
        <option value="rating" ${selectedSort == 'rating' ? 'selected' : ''}>Top Rated</option>
      </select>
    </form>
  </div>
</div>

<!-- MAIN CONTENT -->
<div class="container">
  <div class="page-header">
    <h1 class="page-title">
      <c:choose>
        <c:when test="${not empty search}">Results for "${search}"</c:when>
        <c:when test="${not empty selectedCategory && selectedCategory != 'All'}">${selectedCategory}</c:when>
        <c:otherwise>All Products</c:otherwise>
      </c:choose>
    </h1>
    <p class="page-subtitle">${totalProducts} product${totalProducts != 1 ? 's' : ''} found</p>
  </div>

  <div class="products-grid">
    <c:choose>
      <c:when test="${empty products}">
        <div class="no-results">
          <div class="no-results-icon">🔍</div>
          <h3>No products found</h3>
          <p>Try a different search term or clear filters.</p>
        </div>
      </c:when>
      <c:otherwise>
        <c:forEach var="product" items="${products}">
          <div class="product-card">
            <div class="product-card-img-wrap">
              <img class="product-card-image"
                   src="${product.imageUrl}"
                   alt="${product.name}"
                   onerror="this.src='https://via.placeholder.com/400x200?text=Product'">
              <span class="product-badge">${product.category}</span>
              <button class="quick-add-btn"
                      onclick="quickAddToCart(${product.id}, '${product.name}', ${product.price}, '${product.imageUrl}', '${product.category}')">
                + Add
              </button>
            </div>
            <div class="product-card-body">
              <div class="product-category">${product.category}</div>
              <a href="${pageContext.request.contextPath}/product/${product.id}" class="product-name">${product.name}</a>
              <div class="product-rating">
                <span class="stars">
                  <c:forEach begin="1" end="5" var="star">
                    <c:choose>
                      <c:when test="${star <= product.rating}">★</c:when>
                      <c:otherwise>☆</c:otherwise>
                    </c:choose>
                  </c:forEach>
                </span>
                <span class="rating-count">(${product.rating})</span>
              </div>
              <div class="product-footer">
                <span class="product-price">$<fmt:formatNumber value="${product.price}" pattern="0.00" /></span>
                <button class="add-to-cart-sm"
                        onclick="quickAddToCart(${product.id}, '${fn:escapeXml(product.name)}', ${product.price}, '${product.imageUrl}', '${product.category}')">
                  🛒 Add
                </button>
              </div>
            </div>
          </div>
        </c:forEach>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<footer>
  <p>Built with ❤️ using <strong>Spring MVC + Spring JDBC</strong> | E-Commerce Project</p>
</footer>

<script src="${pageContext.request.contextPath}/static/js/cart.js"></script>
<script>
  function quickAddToCart(id, name, price, imageUrl, category) {
    Cart.addItem({ id, name, price, imageUrl, category, quantity: 1 });
    Toast.show(`\${name} added to cart! 🛒`, 'success');
  }
</script>
</body>
</html>

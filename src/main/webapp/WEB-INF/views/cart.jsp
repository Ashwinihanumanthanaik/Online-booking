<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Your Cart – ShopWave</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
  <div class="navbar-inner">
    <a href="${pageContext.request.contextPath}/" class="brand">Shop<span>Wave</span></a>
    <ul class="nav-links">
      <li><a href="${pageContext.request.contextPath}/">Products</a></li>
      <li><a href="${pageContext.request.contextPath}/cart" class="cart-btn active">
        🛒 Cart <span class="cart-badge" id="cart-badge" style="display:none">0</span>
      </a></li>
    </ul>
  </div>
</nav>

<div class="container">
  <div class="page-header">
    <h1 class="page-title">Shopping Cart</h1>
    <p class="page-subtitle" id="cart-count-label">Loading...</p>
  </div>

  <!-- Empty State -->
  <div id="empty-cart" class="empty-cart" style="display:none">
    <div class="empty-cart-icon">🛒</div>
    <h2>Your cart is empty</h2>
    <p>Looks like you haven't added anything yet.</p>
    <a href="${pageContext.request.contextPath}/" class="btn-primary" style="display:inline-block;width:auto;padding:0.8rem 2rem;">
      Start Shopping
    </a>
  </div>

  <!-- Cart Content -->
  <div id="cart-content" class="cart-layout" style="display:none">
    <div>
      <div class="cart-items-list" id="cart-items-list"></div>
    </div>

    <div class="cart-summary">
      <h3 class="summary-title">Order Summary</h3>
      <div class="summary-row">
        <span>Subtotal</span>
        <span id="summary-subtotal">$0.00</span>
      </div>
      <div class="summary-row">
        <span>Shipping</span>
        <span id="summary-shipping">$0.00</span>
      </div>
      <div class="summary-row">
        <span>Tax (8%)</span>
        <span id="summary-tax">$0.00</span>
      </div>
      <div class="summary-row total">
        <span>Total</span>
        <span id="summary-total">$0.00</span>
      </div>
      <a href="${pageContext.request.contextPath}/checkout" class="btn-primary" id="checkout-btn"
         style="display:block;margin-top:1.2rem;text-align:center;">
        Proceed to Checkout →
      </a>
      <button onclick="Cart.clear(); renderCart();"
              style="width:100%;margin-top:0.7rem;background:none;border:none;color:var(--text-muted);cursor:pointer;font-size:0.875rem;padding:0.4rem;">
        🗑 Clear Cart
      </button>
    </div>
  </div>
</div>

<footer>
  <p>Built with ❤️ using <strong>Spring MVC + Spring JDBC</strong> | E-Commerce Project</p>
</footer>

<script src="${pageContext.request.contextPath}/static/js/cart.js"></script>
<script>
  function renderCart() {
    const items = Cart.getItems();
    const countLabel = document.getElementById('cart-count-label');
    const emptyCart = document.getElementById('empty-cart');
    const cartContent = document.getElementById('cart-content');
    const itemsList = document.getElementById('cart-items-list');

    countLabel.textContent = `\${items.length} item\${items.length !== 1 ? 's' : ''} in your cart`;

    if (items.length === 0) {
      emptyCart.style.display = 'block';
      cartContent.style.display = 'none';
      return;
    }

    emptyCart.style.display = 'none';
    cartContent.style.display = 'grid';

    // Render items
    itemsList.innerHTML = items.map(item => `
      <div class="cart-item" id="item-\${item.id}">
        <img class="cart-item-image" src="\${item.imageUrl || 'https://via.placeholder.com/90?text=Product'}"
             alt="\${item.name}" onerror="this.src='https://via.placeholder.com/90?text=P'">
        <div class="cart-item-info">
          <div class="cart-item-name">\${item.name}</div>
          <div class="cart-item-category">\${item.category}</div>
          <div class="cart-item-price">$\${(item.price * item.quantity).toFixed(2)}</div>
        </div>
        <div class="cart-item-actions">
          <button class="remove-btn" onclick="removeItem(\${item.id})">✕</button>
          <div class="qty-control">
            <button class="qty-btn" onclick="updateQty(\${item.id}, \${item.quantity - 1})">−</button>
            <input class="qty-input" type="number" value="\${item.quantity}" min="1"
                   onchange="updateQty(\${item.id}, parseInt(this.value))">
            <button class="qty-btn" onclick="updateQty(\${item.id}, \${item.quantity + 1})">+</button>
          </div>
          <span style="font-size:0.8rem;color:var(--text-muted);">$\${item.price.toFixed(2)} each</span>
        </div>
      </div>
    `).join('');

    // Update summary
    const subtotal = Cart.getSubtotal();
    const shipping = subtotal > 50 ? 0 : 4.99;
    const tax = subtotal * 0.08;
    const total = subtotal + shipping + tax;

    document.getElementById('summary-subtotal').textContent = '$' + subtotal.toFixed(2);
    document.getElementById('summary-shipping').textContent = shipping === 0 ? 'FREE' : '$' + shipping.toFixed(2);
    document.getElementById('summary-tax').textContent = '$' + tax.toFixed(2);
    document.getElementById('summary-total').textContent = '$' + total.toFixed(2);
  }

  function removeItem(id) {
    Cart.removeItem(id);
    renderCart();
    Toast.show('Item removed from cart', 'success');
  }

  function updateQty(id, qty) {
    if (qty <= 0) {
      removeItem(id);
      return;
    }
    Cart.updateQuantity(id, qty);
    renderCart();
  }

  // Initial render
  renderCart();
</script>
</body>
</html>

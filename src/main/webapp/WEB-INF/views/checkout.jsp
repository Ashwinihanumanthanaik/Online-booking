<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Checkout – ShopWave</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>

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
  <div class="page-header">
    <h1 class="page-title">Checkout</h1>
    <p class="page-subtitle">Complete your order</p>
  </div>

  <div class="checkout-layout">
    <!-- Checkout Form -->
    <div class="checkout-form-card">
      <!-- Contact Info -->
      <div class="checkout-section-title">01 — Contact Information</div>
      <div class="form-group">
        <label class="form-label" for="fullName">Full Name *</label>
        <input class="form-control" type="text" id="fullName" placeholder="John Doe">
        <div class="error-msg" id="err-name">Please enter your full name.</div>
      </div>
      <div class="form-row">
        <div class="form-group">
          <label class="form-label" for="email">Email *</label>
          <input class="form-control" type="email" id="email" placeholder="john@example.com">
          <div class="error-msg" id="err-email">Please enter a valid email.</div>
        </div>
        <div class="form-group">
          <label class="form-label" for="phone">Phone</label>
          <input class="form-control" type="tel" id="phone" placeholder="+1 (555) 000-0000">
        </div>
      </div>

      <!-- Shipping Address -->
      <div class="checkout-section-title" style="margin-top:1.5rem;">02 — Shipping Address</div>
      <div class="form-group">
        <label class="form-label" for="address">Street Address *</label>
        <input class="form-control" type="text" id="address" placeholder="123 Main Street">
        <div class="error-msg" id="err-address">Please enter your street address.</div>
      </div>
      <div class="form-row">
        <div class="form-group">
          <label class="form-label" for="city">City *</label>
          <input class="form-control" type="text" id="city" placeholder="New York">
          <div class="error-msg" id="err-city">Please enter your city.</div>
        </div>
        <div class="form-group">
          <label class="form-label" for="zip">ZIP Code *</label>
          <input class="form-control" type="text" id="zip" placeholder="10001">
          <div class="error-msg" id="err-zip">Please enter a valid ZIP code.</div>
        </div>
      </div>

      <!-- Payment -->
      <div class="checkout-section-title" style="margin-top:1.5rem;">03 — Payment (Simulated)</div>
      <div class="form-group">
        <label class="form-label" for="cardNumber">Card Number *</label>
        <input class="form-control" type="text" id="cardNumber"
               placeholder="4242 4242 4242 4242" maxlength="19">
        <div class="error-msg" id="err-card">Please enter a valid card number.</div>
      </div>
      <div class="form-row">
        <div class="form-group">
          <label class="form-label" for="expiry">Expiry *</label>
          <input class="form-control" type="text" id="expiry" placeholder="MM/YY" maxlength="5">
          <div class="error-msg" id="err-expiry">Invalid expiry date.</div>
        </div>
        <div class="form-group">
          <label class="form-label" for="cvv">CVV *</label>
          <input class="form-control" type="text" id="cvv" placeholder="123" maxlength="3">
          <div class="error-msg" id="err-cvv">Invalid CVV.</div>
        </div>
      </div>

      <div style="background:#fef3c7;border:1px solid #f59e0b;border-radius:8px;padding:0.85rem;margin:1rem 0;font-size:0.85rem;">
        ⚠️ <strong>Demo Mode:</strong> This is a simulated checkout. No real payment is processed.
        Use any card number for testing.
      </div>

      <button class="btn-primary" id="place-order-btn" onclick="placeOrder()">
        Place Order →
      </button>
    </div>

    <!-- Order Summary -->
    <div class="cart-summary">
      <h3 class="summary-title">Order Summary</h3>
      <div id="checkout-items" style="margin-bottom:1rem;"></div>
      <div class="summary-row">
        <span>Subtotal</span>
        <span id="co-subtotal">$0.00</span>
      </div>
      <div class="summary-row">
        <span>Shipping</span>
        <span id="co-shipping">$0.00</span>
      </div>
      <div class="summary-row">
        <span>Tax (8%)</span>
        <span id="co-tax">$0.00</span>
      </div>
      <div class="summary-row total">
        <span>Total</span>
        <span id="co-total">$0.00</span>
      </div>
    </div>
  </div>
</div>

<footer>
  <p>Built with ❤️ using <strong>Spring MVC + Spring JDBC</strong> | E-Commerce Project</p>
</footer>

<script src="${pageContext.request.contextPath}/static/js/cart.js"></script>
<script>
  // Render order summary
  function renderSummary() {
    const items = Cart.getItems();
    const subtotal = Cart.getSubtotal();
    const shipping = subtotal > 50 ? 0 : 4.99;
    const tax = subtotal * 0.08;
    const total = subtotal + shipping + tax;

    document.getElementById('checkout-items').innerHTML = items.map(item =>
      `<div style="display:flex;justify-content:space-between;margin-bottom:0.5rem;font-size:0.9rem;">
        <span>\${item.name} × \${item.quantity}</span>
        <span>$\${(item.price * item.quantity).toFixed(2)}</span>
      </div>`
    ).join('');

    document.getElementById('co-subtotal').textContent = '$' + subtotal.toFixed(2);
    document.getElementById('co-shipping').textContent = shipping === 0 ? 'FREE' : '$' + shipping.toFixed(2);
    document.getElementById('co-tax').textContent = '$' + tax.toFixed(2);
    document.getElementById('co-total').textContent = '$' + total.toFixed(2);
  }

  // Form validation helpers
  function validate(id, errId, fn) {
    const val = document.getElementById(id).value.trim();
    const err = document.getElementById(errId);
    const ctrl = document.getElementById(id);
    if (!fn(val)) {
      ctrl.classList.add('error');
      err.classList.add('visible');
      return false;
    }
    ctrl.classList.remove('error');
    err.classList.remove('visible');
    return true;
  }

  // Card number formatting
  document.getElementById('cardNumber').addEventListener('input', function() {
    let v = this.value.replace(/\D/g, '').substring(0,16);
    this.value = v.replace(/(.{4})/g, '$1 ').trim();
  });

  // Expiry formatting
  document.getElementById('expiry').addEventListener('input', function() {
    let v = this.value.replace(/\D/g,'');
    if (v.length >= 2) v = v.substring(0,2) + '/' + v.substring(2,4);
    this.value = v;
  });

  async function placeOrder() {
    const items = Cart.getItems();
    if (items.length === 0) {
      Toast.show('Your cart is empty!', 'error');
      return;
    }

    // Validate all fields
    const valid = [
      validate('fullName', 'err-name', v => v.length >= 2),
      validate('email', 'err-email', v => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v)),
      validate('address', 'err-address', v => v.length >= 5),
      validate('city', 'err-city', v => v.length >= 2),
      validate('zip', 'err-zip', v => /^\d{5}(-\d{4})?$/.test(v)),
      validate('cardNumber', 'err-card', v => v.replace(/\s/g,'').length === 16),
      validate('expiry', 'err-expiry', v => /^\d{2}\/\d{2}$/.test(v)),
      validate('cvv', 'err-cvv', v => /^\d{3}$/.test(v)),
    ];

    if (valid.includes(false)) {
      Toast.show('Please fix the form errors.', 'error');
      return;
    }

    const btn = document.getElementById('place-order-btn');
    btn.textContent = 'Placing Order...';
    btn.disabled = true;

    const subtotal = Cart.getSubtotal();
    const shipping = subtotal > 50 ? 0 : 4.99;
    const tax = subtotal * 0.08;
    const total = subtotal + shipping + tax;

    const payload = {
      name: document.getElementById('fullName').value.trim(),
      email: document.getElementById('email').value.trim(),
      address: document.getElementById('address').value + ', ' +
               document.getElementById('city').value + ', ' +
               document.getElementById('zip').value,
      total: total.toFixed(2),
      items: items
    };

    try {
      const res = await fetch('${pageContext.request.contextPath}/api/checkout', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      });
      const data = await res.json();

      if (data.success) {
        Cart.clear();
        window.location.href = '${pageContext.request.contextPath}/order-confirmation?orderId=' + data.orderId;
      } else {
        Toast.show('Order failed: ' + data.message, 'error');
        btn.textContent = 'Place Order →';
        btn.disabled = false;
      }
    } catch (e) {
      Toast.show('Network error. Please try again.', 'error');
      btn.textContent = 'Place Order →';
      btn.disabled = false;
    }
  }

  renderSummary();
</script>
</body>
</html>

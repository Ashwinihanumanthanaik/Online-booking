<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Order Confirmed – ShopWave</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>

<nav class="navbar">
  <div class="navbar-inner">
    <a href="${pageContext.request.contextPath}/" class="brand">Shop<span>Wave</span></a>
    <ul class="nav-links">
      <li><a href="${pageContext.request.contextPath}/">Products</a></li>
      <li><a href="${pageContext.request.contextPath}/cart" class="cart-btn">🛒 Cart</a></li>
    </ul>
  </div>
</nav>

<div class="container">
  <div class="confirmation-card">
    <div class="confirmation-icon">✓</div>
    <h1 class="confirmation-title">Order Confirmed!</h1>
    <p class="confirmation-subtitle">Thank you for your purchase. Your order has been placed successfully.</p>

    <c:if test="${not empty order}">
      <div class="order-meta">
        <p><span>Order ID</span> <strong>#${order.id}</strong></p>
        <p><span>Customer</span> <strong>${order.customerName}</strong></p>
        <p><span>Email</span> <strong>${order.customerEmail}</strong></p>
        <p><span>Total Paid</span>
          <strong>
            $<fmt:formatNumber value="${order.totalAmount}" pattern="0.00"/>
          </strong>
        </p>
        <p><span>Status</span>
          <strong style="color:var(--success)">✓ ${order.status}</strong>
        </p>
      </div>
    </c:if>

    <p style="color:var(--text-muted);font-size:0.9rem;margin-bottom:1.5rem;">
      A confirmation email has been sent to ${order.customerEmail}.<br>
      <em>(This is a demo — no real email was sent.)</em>
    </p>

    <a href="${pageContext.request.contextPath}/" class="btn-primary" style="display:inline-block;width:auto;padding:0.85rem 2rem;">
      Continue Shopping
    </a>
  </div>
</div>

<footer>
  <p>Built with ❤️ using <strong>Spring MVC + Spring JDBC</strong> | E-Commerce Project</p>
</footer>

<script src="${pageContext.request.contextPath}/static/js/cart.js"></script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Payment Form - Swimming Pool</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    html, body {
      height: 100%;
      font-family: Arial, sans-serif;
      scroll-behavior: smooth;
    }

    body {
      background-image: url('https://images.pexels.com/photos/221457/pexels-photo-221457.jpeg');
      background-size: cover;
      background-position: center;
      background-repeat: no-repeat;
      color: white;
    }

    .navbar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      background: rgba(0, 92, 170, 0.9);
      padding: 15px 30px;
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      z-index: 999;
      backdrop-filter: blur(4px);
    }

    .logo {
      font-size: 26px;
      font-weight: bold;
    }

    .nav-links a {
      color: white;
      text-decoration: none;
      margin: 0 15px;
      font-weight: 500;
    }

    .nav-links a:hover {
      text-decoration: underline;
    }

    .auth {
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .auth a.login-btn,
    .auth a.register-btn,
    .auth form input[type="submit"] {
      padding: 8px 16px;
      background-color: #ffffff;
      color: #005caa;
      border: none;
      border-radius: 4px;
      font-weight: bold;
      cursor: pointer;
      text-decoration: none;
    }

    .auth a.login-btn:hover,
    .auth a.register-btn:hover,
    .auth form input[type="submit"]:hover {
      background-color: #e6e6e6;
    }

    .content {
      padding: 100px 5% 50px;
      background: rgba(255, 255, 255, 0.95);
      color: #333;
      min-height: calc(100vh - 150px);
    }

    .page-header {
      text-align: center;
      margin-bottom: 40px;
    }

    .page-header h1 {
      color: #005caa;
      font-size: 36px;
      margin-bottom: 10px;
    }

    .breadcrumb {
      background: #f8f9fa;
      padding: 10px 20px;
      border-radius: 4px;
      margin-bottom: 30px;
    }

    .breadcrumb a {
      color: #005caa;
      text-decoration: none;
    }

    .breadcrumb a:hover {
      text-decoration: underline;
    }

    .payment-container {
      max-width: 800px;
      margin: 0 auto;
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 30px;
    }

    .card {
      background: white;
      padding: 25px;
      border-radius: 8px;
      box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    }

    .card h3 {
      color: #005caa;
      margin-bottom: 20px;
      padding-bottom: 10px;
      border-bottom: 2px solid #e9ecef;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .info-item {
      display: flex;
      justify-content: space-between;
      padding: 10px 0;
      border-bottom: 1px solid #f8f9fa;
    }

    .info-item:last-child {
      border-bottom: none;
    }

    .info-item strong {
      color: #495057;
    }

    .info-item.total {
      border-top: 2px solid #005caa;
      padding-top: 15px;
      margin-top: 15px;
      font-size: 18px;
      font-weight: bold;
    }

    .status-badge {
      padding: 4px 8px;
      border-radius: 12px;
      font-size: 12px;
      font-weight: bold;
      text-transform: uppercase;
    }

    .status-pending {
      background-color: #ffeaa7;
      color: #d63031;
    }

    .status-partial {
      background-color: #fdcb6e;
      color: #e17055;
    }

    .form-group {
      margin-bottom: 20px;
    }

    .form-group label {
      display: block;
      margin-bottom: 5px;
      font-weight: bold;
      color: #333;
    }

    .form-group input,
    .form-group select,
    .form-group textarea {
      width: 100%;
      padding: 12px;
      border: 1px solid #ddd;
      border-radius: 4px;
      font-size: 14px;
    }

    .form-group input:focus,
    .form-group select:focus,
    .form-group textarea:focus {
      outline: none;
      border-color: #005caa;
      box-shadow: 0 0 0 2px rgba(0, 92, 170, 0.2);
    }

    .payment-amount-input {
      position: relative;
    }

    .currency-symbol {
      position: absolute;
      left: 12px;
      top: 50%;
      transform: translateY(-50%);
      color: #666;
      font-weight: bold;
    }

    .payment-amount-input input {
      padding-left: 40px;
      font-size: 18px;
      font-weight: bold;
    }

    .quick-amounts {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(80px, 1fr));
      gap: 10px;
      margin-top: 10px;
    }

    .quick-amount-btn {
      padding: 8px 12px;
      background: #f8f9fa;
      border: 1px solid #dee2e6;
      border-radius: 4px;
      cursor: pointer;
      text-align: center;
      font-size: 12px;
      transition: all 0.3s ease;
    }

    .quick-amount-btn:hover {
      background: #005caa;
      color: white;
      border-color: #005caa;
    }

    .progress-bar {
      background: #e9ecef;
      border-radius: 20px;
      overflow: hidden;
      height: 20px;
      margin: 15px 0;
    }

    .progress-fill {
      height: 100%;
      background: linear-gradient(90deg, #28a745, #20c997);
      transition: width 0.3s ease;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 12px;
      font-weight: bold;
    }

    .btn {
      padding: 12px 24px;
      border: none;
      border-radius: 4px;
      font-weight: bold;
      cursor: pointer;
      text-decoration: none;
      display: inline-block;
      transition: all 0.3s ease;
      margin-right: 10px;
    }

    .btn-success {
      background-color: #28a745;
      color: white;
    }

    .btn-success:hover {
      background-color: #218838;
    }

    .btn-secondary {
      background-color: #6c757d;
      color: white;
    }

    .btn-secondary:hover {
      background-color: #545b62;
    }

    .btn-full {
      width: 100%;
      margin-bottom: 10px;
    }

    .alert {
      padding: 15px;
      margin-bottom: 20px;
      border-radius: 4px;
    }

    .alert-danger {
      background-color: #f8d7da;
      color: #721c24;
      border: 1px solid #f5c6cb;
    }

    .alert-warning {
      background-color: #fff3cd;
      color: #856404;
      border: 1px solid #ffeaa7;
    }

    .payment-methods {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(100px, 1fr));
      gap: 10px;
      margin-bottom: 20px;
    }

    .payment-method {
      padding: 15px 10px;
      border: 2px solid #dee2e6;
      border-radius: 8px;
      text-align: center;
      cursor: pointer;
      transition: all 0.3s ease;
    }

    .payment-method:hover,
    .payment-method.selected {
      border-color: #005caa;
      background: #f0f8ff;
    }

    .payment-method .icon {
      font-size: 24px;
      margin-bottom: 5px;
    }

    .payment-method .label {
      font-size: 12px;
      font-weight: bold;
    }

    footer {
      background: #003e73;
      color: white;
      padding: 30px 10%;
      text-align: center;
    }

    footer p {
      margin-bottom: 5px;
    }

    @media (max-width: 768px) {
      .payment-container {
        grid-template-columns: 1fr;
      }

      .quick-amounts {
        grid-template-columns: repeat(2, 1fr);
      }
    }
  </style>
</head>
<body>
<!-- Header -->
<nav class="navbar">
  <div class="logo">🏊‍♂️ Swimming Pool</div>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
    <a href="${pageContext.request.contextPath}/equipment">Equipment</a>
    <a href="${pageContext.request.contextPath}/compensation">Compensations</a>
    <a href="${pageContext.request.contextPath}/blacklist">Blacklist</a>
    <a href="${pageContext.request.contextPath}/reports">Reports</a>
  </div>
  <div class="auth">
    <a href="${pageContext.request.contextPath}/profile" class="login-btn">Profile</a>
    <a href="${pageContext.request.contextPath}/logout" class="register-btn">Logout</a>
  </div>
</nav>

<!-- Main Content -->
<div class="content">
  <!-- Breadcrumb -->
  <nav class="breadcrumb">
    <a href="${pageContext.request.contextPath}/compensation">📋 Compensations</a>
    <span> > </span>
    <a href="${pageContext.request.contextPath}/compensation?action=view&id=${compensation.compensationId}">Compensation #${compensation.compensationId}</a>
    <span> > </span>
    <span>Payment</span>
  </nav>

  <!-- Page Header -->
  <div class="page-header">
    <h1>💳 Process Payment</h1>
    <p>Add payment for compensation #${compensation.compensationId}</p>
  </div>

  <!-- Error Messages -->
  <c:if test="${not empty error}">
    <div class="alert alert-danger">
      <strong>Error:</strong> ${error}
    </div>
  </c:if>

  <c:choose>
    <c:when test="${not empty compensation}">
      <div class="payment-container">
        <!-- Left Column: Compensation Summary -->
        <div class="card">
          <h3>📊 Compensation Summary</h3>

          <div class="info-item">
            <strong>Compensation ID:</strong>
            <span>#${compensation.compensationId}</span>
          </div>

          <div class="info-item">
            <strong>Type:</strong>
            <span>
                                <c:choose>
                                  <c:when test="${compensation.compensationType == 'damaged'}">🔧 Damaged</c:when>
                                  <c:when test="${compensation.compensationType == 'lost'}">❌ Lost</c:when>
                                  <c:when test="${compensation.compensationType == 'overdue_fee'}">⏰ Overdue</c:when>
                                </c:choose>
                            </span>
          </div>

          <div class="info-item">
            <strong>Status:</strong>
            <span class="status-badge status-${compensation.paymentStatus}">
                ${compensation.paymentStatus}
            </span>
          </div>

          <div class="info-item">
            <strong>Total Amount:</strong>
            <span><fmt:formatNumber value="${compensation.totalAmount}" type="currency" currencyCode="VND"/></span>
          </div>

          <div class="info-item">
            <strong>Paid Amount:</strong>
            <span><fmt:formatNumber value="${compensation.paidAmount}" type="currency" currencyCode="VND"/></span>
          </div>

          <div class="info-item total">
            <strong>Remaining Amount:</strong>
            <span style="color: #dc3545;">
                                <fmt:formatNumber value="${remainingAmount}" type="currency" currencyCode="VND"/>
                            </span>
          </div>

          <!-- Payment Progress -->
          <c:set var="paymentPercent" value="${(compensation.paidAmount / compensation.totalAmount) * 100}"/>
          <div style="margin-top: 20px;">
            <strong>Payment Progress:</strong>
            <div class="progress-bar">
              <div class="progress-fill" style="width: ${paymentPercent}%">
                <fmt:formatNumber value="${paymentPercent}" maxFractionDigits="1"/>%
              </div>
            </div>
          </div>

          <c:if test="${compensation.paymentStatus == 'pending'}">
            <div class="alert alert-warning" style="margin-top: 20px;">
              ⚠️ No payments have been made yet. This compensation is still pending.
            </div>
          </c:if>
        </div>

        <!-- Right Column: Payment Form -->
        <div class="card">
          <h3>💰 Add Payment</h3>

          <form action="${pageContext.request.contextPath}/compensation" method="post" id="paymentForm">
            <input type="hidden" name="action" value="payment">
            <input type="hidden" name="compensationId" value="${compensation.compensationId}">

            <!-- Payment Method Selection -->
            <div class="form-group">
              <label>Payment Method:</label>
              <div class="payment-methods">
                <div class="payment-method selected" data-method="cash">
                  <div class="icon">💵</div>
                  <div class="label">Cash</div>
                </div>
                <div class="payment-method" data-method="card">
                  <div class="icon">💳</div>
                  <div class="label">Card</div>
                </div>
                <div class="payment-method" data-method="transfer">
                  <div class="icon">🏦</div>
                  <div class="label">Transfer</div>
                </div>
              </div>
              <input type="hidden" name="paymentMethod" id="paymentMethod" value="cash">
            </div>

            <!-- Payment Amount -->
            <div class="form-group">
              <label for="paymentAmount">Payment Amount <span style="color: red;">*</span></label>
              <div class="payment-amount-input">
                <span class="currency-symbol">₫</span>
                <input type="number" id="paymentAmount" name="paymentAmount"
                       step="1000" min="1000" max="${remainingAmount}" required
                       placeholder="Enter amount">
              </div>

              <!-- Quick Amount Buttons -->
              <div class="quick-amounts">
                <c:set var="remaining" value="${remainingAmount}"/>
                <div class="quick-amount-btn" onclick="setAmount(${remaining / 4})">25%</div>
                <div class="quick-amount-btn" onclick="setAmount(${remaining / 2})">50%</div>
                <div class="quick-amount-btn" onclick="setAmount(${remaining * 3 / 4})">75%</div>
                <div class="quick-amount-btn" onclick="setAmount(${remaining})">Full</div>
              </div>

              <small style="color: #666;">
                Maximum: <fmt:formatNumber value="${remainingAmount}" type="currency" currencyCode="VND"/>
              </small>
            </div>

            <!-- Payment Notes -->
            <div class="form-group">
              <label for="notes">Payment Notes</label>
              <textarea id="notes" name="notes" rows="3"
                        placeholder="Optional notes about this payment..."></textarea>
            </div>

            <!-- Form Actions -->
            <button type="submit" class="btn btn-success btn-full">
              💳 Process Payment
            </button>

            <a href="${pageContext.request.contextPath}/compensation?action=view&id=${compensation.compensationId}"
               class="btn btn-secondary btn-full">
              ❌ Cancel
            </a>
          </form>
        </div>
      </div>

    </c:when>
    <c:otherwise>
      <div class="card" style="max-width: 600px; margin: 0 auto;">
        <div style="text-align: center; padding: 40px;">
          <h3>❌ Compensation Not Found</h3>
          <p>The compensation record you're trying to pay for doesn't exist or has been removed.</p>
          <a href="${pageContext.request.contextPath}/compensation" class="btn btn-primary">
            📋 Back to Compensations
          </a>
        </div>
      </div>
    </c:otherwise>
  </c:choose>
</div>

<!-- Footer -->
<footer>
  <p>&copy; 2024 Swimming Pool Management System</p>
  <p>Equipment Compensation & Rental Management</p>
</footer>

<script>
  // Payment method selection
  document.querySelectorAll('.payment-method').forEach(method => {
    method.addEventListener('click', function() {
      // Remove selected class from all methods
      document.querySelectorAll('.payment-method').forEach(m => m.classList.remove('selected'));

      // Add selected class to clicked method
      this.classList.add('selected');

      // Update hidden input
      document.getElementById('paymentMethod').value = this.dataset.method;
    });
  });

  // Set payment amount
  function setAmount(amount) {
    document.getElementById('paymentAmount').value = Math.round(amount);
    updatePaymentPreview();
  }

  // Update payment preview
  function updatePaymentPreview() {
    const amount = parseFloat(document.getElementById('paymentAmount').value) || 0;
    const remaining = ${remainingAmount};

    // Update progress bar preview
    const currentPaid = ${compensation.paidAmount};
    const total = ${compensation.totalAmount};
    const newPaid = currentPaid + amount;
    const newPercent = (newPaid / total) * 100;

    // Visual feedback for amount validation
    const amountInput = document.getElementById('paymentAmount');
    if (amount > remaining) {
      amountInput.style.borderColor = '#dc3545';
      amountInput.style.boxShadow = '0 0 0 2px rgba(220, 53, 69, 0.2)';
    } else if (amount > 0) {
      amountInput.style.borderColor = '#28a745';
      amountInput.style.boxShadow = '0 0 0 2px rgba(40, 167, 69, 0.2)';
    } else {
      amountInput.style.borderColor = '#ddd';
      amountInput.style.boxShadow = 'none';
    }
  }

  // Form validation
  document.getElementById('paymentForm').addEventListener('submit', function(e) {
    const amount = parseFloat(document.getElementById('paymentAmount').value);
    const remaining = ${remainingAmount};

    if (!amount || amount <= 0) {
      alert('Please enter a valid payment amount.');
      e.preventDefault();
      return;
    }

    if (amount > remaining) {
      alert('Payment amount cannot exceed the remaining amount: ' +
              new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(remaining));
      e.preventDefault();
      return;
    }

    // Confirm payment
    const method = document.querySelector('.payment-method.selected .label').textContent;
    const formattedAmount = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);

    if (!confirm(`Confirm payment of ${formattedAmount} via ${method}?`)) {
      e.preventDefault();
      return;
    }
  });

  // Real-time amount validation
  document.getElementById('paymentAmount').addEventListener('input', updatePaymentPreview);

  // Auto-format number input
  document.getElementById('paymentAmount').addEventListener('blur', function() {
    const value = parseFloat(this.value);
    if (value) {
      this.value = Math.round(value);
    }
  });

  // Keyboard shortcuts
  document.addEventListener('keydown', function(e) {
    // Ctrl + Enter to submit form
    if (e.ctrlKey && e.key === 'Enter') {
      document.getElementById('paymentForm').submit();
    }

    // ESC to cancel
    if (e.key === 'Escape') {
      if (confirm('Cancel payment and go back?')) {
        window.location.href = '${pageContext.request.contextPath}/compensation?action=view&id=${compensation.compensationId}';
      }
    }
  });

  // Auto-hide alerts after 5 seconds
  setTimeout(function() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(function(alert) {
      alert.style.display = 'none';
    });
  }, 5000);

  // Focus on amount input when page loads
  window.addEventListener('load', function() {
    document.getElementById('paymentAmount').focus();
  });

  // Prevent form submission on Enter in amount field (require explicit button click)
  document.getElementById('paymentAmount').addEventListener('keydown', function(e) {
    if (e.key === 'Enter') {
      e.preventDefault();
      // Move focus to submit button instead
      document.querySelector('.btn-success').focus();
    }
  });

  // Add thousand separators while typing
  document.getElementById('paymentAmount').addEventListener('input', function() {
    // Remove existing formatting
    let value = this.value.replace(/,/g, '');

    // Add thousand separators
    if (value && !isNaN(value)) {
      this.value = parseInt(value).toLocaleString('en-US');
    }
  });

  // Remove formatting before form submission
  document.getElementById('paymentForm').addEventListener('submit', function() {
    const amountInput = document.getElementById('paymentAmount');
    amountInput.value = amountInput.value.replace(/,/g, '');
  });

  // Initialize page
  updatePaymentPreview();
</script>
</body>
</html>
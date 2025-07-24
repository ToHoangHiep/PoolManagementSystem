<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Compensation Management - Swimming Pool</title>
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

    .page-header p {
      font-size: 18px;
      color: #666;
    }

    .filters {
      background: #f8f9fa;
      padding: 20px;
      border-radius: 8px;
      margin-bottom: 30px;
      display: flex;
      gap: 20px;
      align-items: center;
      flex-wrap: wrap;
    }

    .filters select, .filters input {
      padding: 8px 12px;
      border: 1px solid #ddd;
      border-radius: 4px;
      font-size: 14px;
    }

    .btn {
      padding: 10px 20px;
      border: none;
      border-radius: 4px;
      font-weight: bold;
      cursor: pointer;
      text-decoration: none;
      display: inline-block;
      transition: all 0.3s ease;
    }

    .btn-primary {
      background-color: #005caa;
      color: white;
    }

    .btn-primary:hover {
      background-color: #004494;
    }

    .btn-success {
      background-color: #28a745;
      color: white;
    }

    .btn-warning {
      background-color: #ffc107;
      color: #212529;
    }

    .btn-danger {
      background-color: #dc3545;
      color: white;
    }

    .btn-info {
      background-color: #17a2b8;
      color: white;
    }

    .btn-sm {
      padding: 5px 10px;
      font-size: 12px;
    }

    .table-container {
      background: white;
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    }

    .table {
      width: 100%;
      border-collapse: collapse;
    }

    .table th,
    .table td {
      padding: 12px;
      text-align: left;
      border-bottom: 1px solid #dee2e6;
    }

    .table th {
      background-color: #005caa;
      color: white;
      font-weight: bold;
    }

    .table tbody tr:hover {
      background-color: #f8f9fa;
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

    .status-paid {
      background-color: #00b894;
      color: white;
    }

    .status-waived {
      background-color: #6c5ce7;
      color: white;
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

    .alert-success {
      background-color: #d4edda;
      color: #155724;
      border: 1px solid #c3e6cb;
    }

    .no-data {
      text-align: center;
      padding: 40px;
      color: #666;
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
      .filters {
        flex-direction: column;
        align-items: stretch;
      }

      .table-container {
        overflow-x: auto;
      }

      .table {
        min-width: 600px;
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
    <a href="${pageContext.request.contextPath}/reports">Reports</a>
  </div>
  <div class="auth">
    <a href="${pageContext.request.contextPath}/profile" class="login-btn">Profile</a>
    <a href="${pageContext.request.contextPath}/logout" class="register-btn">Logout</a>
  </div>
</nav>

<!-- Main Content -->
<div class="content">
  <div class="page-header">
    <h1>Equipment Compensation Management</h1>
    <p>Manage compensation for damaged, lost, or overdue equipment</p>
  </div>

  <!-- Error/Success Messages -->
  <c:if test="${not empty error}">
    <div class="alert alert-danger">
      <strong>Error:</strong> ${error}
    </div>
  </c:if>

  <c:if test="${not empty success}">
    <div class="alert alert-success">
      <strong>Success:</strong> ${success}
    </div>
  </c:if>

  <!-- Filters & Actions -->
  <div class="filters">
    <div>
      <label for="statusFilter">Filter by Status:</label>
      <select id="statusFilter" onchange="filterByStatus()">
        <option value="">All Status</option>
        <option value="pending" ${currentStatus == 'pending' ? 'selected' : ''}>Pending</option>
        <option value="partial" ${currentStatus == 'partial' ? 'selected' : ''}>Partial</option>
        <option value="paid" ${currentStatus == 'paid' ? 'selected' : ''}>Paid</option>
        <option value="waived" ${currentStatus == 'waived' ? 'selected' : ''}>Waived</option>
      </select>
    </div>

    <div>
      <label for="typeFilter">Filter by Type:</label>
      <select id="typeFilter" onchange="filterByType()">
        <option value="">All Types</option>
        <option value="damaged" ${currentType == 'damaged' ? 'selected' : ''}>Damaged</option>
        <option value="lost" ${currentType == 'lost' ? 'selected' : ''}>Lost</option>
        <option value="overdue_fee" ${currentType == 'overdue_fee' ? 'selected' : ''}>Overdue Fee</option>
      </select>
    </div>

    <div style="margin-left: auto;">
      <a href="${pageContext.request.contextPath}/compensation?action=create" class="btn btn-primary">
        ➕ Create New Compensation
      </a>
    </div>
  </div>

  <!-- Compensations Table -->
  <div class="table-container">
    <c:choose>
      <c:when test="${not empty compensations}">
        <table class="table">
          <thead>
          <tr>
            <th>ID</th>
            <th>Rental ID</th>
            <th>Type</th>
            <th>Import Price</th>
            <th>Total Amount</th>
            <th>Paid Amount</th>
            <th>Status</th>
            <th>Created Date</th>
            <th>Actions</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="compensation" items="${compensations}">
            <tr>
              <td>#${compensation.compensationId}</td>
              <td>#${compensation.rentalId}</td>
              <td>
                <c:choose>
                  <c:when test="${compensation.compensationType == 'damaged'}">🔧 Damaged</c:when>
                  <c:when test="${compensation.compensationType == 'lost'}">❌ Lost</c:when>
                  <c:when test="${compensation.compensationType == 'overdue_fee'}">⏰ Overdue</c:when>
                  <c:otherwise>${compensation.compensationType}</c:otherwise>
                </c:choose>
              </td>
              <td>
                <fmt:formatNumber value="${compensation.importPriceTotal}" type="currency" currencyCode="VND"/>
              </td>
              <td>
                <fmt:formatNumber value="${compensation.totalAmount}" type="currency" currencyCode="VND"/>
              </td>
              <td>
                <fmt:formatNumber value="${compensation.paidAmount}" type="currency" currencyCode="VND"/>
              </td>
              <td>
                <span class="status-badge status-${compensation.paymentStatus}">${compensation.paymentStatus}</span>
              </td>
              <td>
                <fmt:formatDate value="${compensation.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
              </td>
              <td>
                <a href="${pageContext.request.contextPath}/compensation?action=view&id=${compensation.compensationId}"
                   class="btn btn-info btn-sm">👁️ View</a>

                <c:if test="${not compensation.fullyPaid}">
                  <a href="${pageContext.request.contextPath}/compensation?action=payment&compensationId=${compensation.compensationId}"
                     class="btn btn-success btn-sm">💳 Pay</a>
                </c:if>

                <c:if test="${compensation.compensationType == 'damaged' && compensation.canRepair}">
                  <a href="${pageContext.request.contextPath}/repair?action=create&compensationId=${compensation.compensationId}"
                     class="btn btn-warning btn-sm">🔧 Repair</a>
                </c:if>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </c:when>
      <c:otherwise>
        <div class="no-data">
          <h3>🔍 No Compensations Found</h3>
          <p>There are no compensation records to display.</p>
          <a href="${pageContext.request.contextPath}/compensation?action=create" class="btn btn-primary">
            Create First Compensation
          </a>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<!-- Footer -->
<footer>
  <p>&copy; 2024 Swimming Pool Management System</p>
  <p>Equipment Compensation & Rental Management</p>
</footer>

<script>
  function filterByStatus() {
    const status = document.getElementById('statusFilter').value;
    const currentUrl = new URL(window.location);

    if (status) {
      currentUrl.searchParams.set('status', status);
    } else {
      currentUrl.searchParams.delete('status');
    }

    window.location.href = currentUrl.toString();
  }

  function filterByType() {
    const type = document.getElementById('typeFilter').value;
    const currentUrl = new URL(window.location);

    if (type) {
      currentUrl.searchParams.set('type', type);
    } else {
      currentUrl.searchParams.delete('type');
    }

    window.location.href = currentUrl.toString();
  }

  // Auto-hide alerts after 5 seconds
  setTimeout(function() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(function(alert) {
      alert.style.display = 'none';
    });
  }, 5000);
</script>
</body>
</html>
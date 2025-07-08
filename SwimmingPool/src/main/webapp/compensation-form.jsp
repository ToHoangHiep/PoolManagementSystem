<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Create Compensation - Swimming Pool</title>
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

    .form-container {
      max-width: 800px;
      margin: 0 auto;
      background: white;
      padding: 30px;
      border-radius: 8px;
      box-shadow: 0 4px 6px rgba(0,0,0,0.1);
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
      padding: 10px;
      border: 1px solid #ddd;
      border-radius: 4px;
      font-size: 14px;
    }

    .form-group textarea {
      height: 100px;
      resize: vertical;
    }

    .form-group input:focus,
    .form-group select:focus,
    .form-group textarea:focus {
      outline: none;
      border-color: #005caa;
      box-shadow: 0 0 0 2px rgba(0, 92, 170, 0.2);
    }

    .form-row {
      display: flex;
      gap: 20px;
    }

    .form-row .form-group {
      flex: 1;
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

    .btn-primary {
      background-color: #005caa;
      color: white;
    }

    .btn-primary:hover {
      background-color: #004494;
    }

    .btn-secondary {
      background-color: #6c757d;
      color: white;
    }

    .btn-secondary:hover {
      background-color: #545b62;
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

    .alert-info {
      background-color: #d1ecf1;
      color: #0c5460;
      border: 1px solid #bee5eb;
    }

    .rental-info {
      background: #f8f9fa;
      padding: 20px;
      border-radius: 8px;
      margin-bottom: 20px;
      border-left: 4px solid #005caa;
    }

    .rental-info h3 {
      color: #005caa;
      margin-bottom: 15px;
    }

    .info-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 15px;
    }

    .info-item {
      background: white;
      padding: 10px;
      border-radius: 4px;
      border: 1px solid #e9ecef;
    }

    .info-item strong {
      display: block;
      color: #495057;
      font-size: 12px;
      text-transform: uppercase;
      margin-bottom: 5px;
    }

    .calculation-box {
      background: #e7f3ff;
      padding: 20px;
      border-radius: 8px;
      margin-top: 20px;
      border: 1px solid #b3d9ff;
    }

    .calculation-box h4 {
      color: #005caa;
      margin-bottom: 15px;
    }

    .calc-row {
      display: flex;
      justify-content: space-between;
      margin-bottom: 10px;
      padding: 5px 0;
    }

    .calc-row.total {
      border-top: 2px solid #005caa;
      padding-top: 15px;
      margin-top: 15px;
      font-weight: bold;
      font-size: 18px;
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
      .form-row {
        flex-direction: column;
      }

      .info-grid {
        grid-template-columns: 1fr;
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
  <div class="page-header">
    <h1>Create Equipment Compensation</h1>
    <p>Record compensation for damaged, lost, or overdue equipment</p>
  </div>

  <!-- Error Messages -->
  <c:if test="${not empty error}">
    <div class="alert alert-danger">
      <strong>Error:</strong> ${error}
    </div>
  </c:if>

  <div class="form-container">
    <!-- Rental Information (if selected) -->
    <c:if test="${not empty rental}">
      <div class="rental-info">
        <h3>📋 Rental Information</h3>
        <div class="info-grid">
          <div class="info-item">
            <strong>Rental ID</strong>
            #${rental.rentalId}
          </div>
          <div class="info-item">
            <strong>Customer</strong>
              ${rental.customerName}
          </div>
          <div class="info-item">
            <strong>ID Card</strong>
              ${rental.customerIdCard}
          </div>
          <div class="info-item">
            <strong>Equipment</strong>
              ${rental.itemName}
          </div>
          <div class="info-item">
            <strong>Quantity</strong>
              ${rental.quantity} units
          </div>
          <div class="info-item">
            <strong>Rental Date</strong>
            <fmt:formatDate value="${rental.rentalDate}" pattern="dd/MM/yyyy"/>
          </div>
          <div class="info-item">
            <strong>Status</strong>
            <span style="color: ${rental.status == 'active' ? 'green' : 'orange'}">
                ${rental.status}
            </span>
          </div>
          <c:if test="${not empty equipment}">
            <div class="info-item">
              <strong>Sale Price</strong>
              <fmt:formatNumber value="${equipment.salePrice}" type="currency" currencyCode="VND"/>
            </div>
          </c:if>
        </div>
      </div>
    </c:if>

      <!-- Compensation Form -->
      <form action="${pageContext.request.contextPath}/compensation" method="post" id="compensationForm">

          <!-- Rental Selection -->
          <div class="form-group">
              <label for="rentalId">Select Rental <span style="color: red;">*</span></label>
              <select id="rentalId" name="rentalId" required onchange="loadRentalInfo()">
                  <option value="">-- Select a rental --</option>
                  <c:forEach var="activeRental" items="${activeRentals}">
                      <option value="${activeRental.rentalId}"
                          ${(rental != null && rental.rentalId == activeRental.rentalId) ||
                                  (selectedRentalId != null && selectedRentalId == activeRental.rentalId) ? 'selected' : ''}>
                          #${activeRental.rentalId} - ${activeRental.customerName} - ${activeRental.itemName}
                          (Qty: ${activeRental.quantity})
                      </option>
                  </c:forEach>
              </select>
          </div>

          <!-- Compensation Details -->
          <div class="form-row">
              <div class="form-group">
                  <label for="compensationType">Compensation Type <span style="color: red;">*</span></label>
                  <select id="compensationType" name="compensationType" required onchange="updateForm()">
                      <option value="">-- Select type --</option>
                      <option value="damaged" ${compensationType == 'damaged' ? 'selected' : ''}>🔧 Damaged Equipment</option>
                      <option value="lost" ${compensationType == 'lost' ? 'selected' : ''}>❌ Lost Equipment</option>
                      <option value="overdue_fee" ${compensationType == 'overdue_fee' ? 'selected' : ''}>⏰ Overdue Fee</option>
                  </select>
              </div>

              <div class="form-group" id="damageLevelGroup" style="display: ${compensationType == 'damaged' ? 'block' : 'none'};">
                  <label for="damageLevel">Damage Level</label>
                  <select id="damageLevel" name="damageLevel" onchange="updateCompensationRate()">
                      <option value="">-- Select level --</option>
                      <option value="minor">🟡 Minor (10-30%)</option>
                      <option value="major">🟠 Major (40-70%)</option>
                      <option value="total">🔴 Total Loss (80-100%)</option>
                  </select>
              </div>
          </div>

          <!-- Description -->
          <div class="form-group">
              <label for="damageDescription">Description <span style="color: red;">*</span></label>
              <textarea id="damageDescription" name="damageDescription" required
                        placeholder="Describe the damage, loss circumstances, or overdue details...">${param.damageDescription}</textarea>
          </div>

          <!-- Compensation Rate -->
          <div class="form-group">
              <label for="compensationRate">Compensation Rate (0.0 - 1.0) <span style="color: red;">*</span></label>
              <input type="number" id="compensationRate" name="compensationRate"
                     step="0.01" min="0" max="1" required
                     placeholder="e.g., 0.8 for 80%"
                     value="${compensationRate != null ? compensationRate : ''}"
                     onchange="triggerCalculation()">
              <small style="color: #666;">Enter decimal value (e.g., 0.5 = 50%, 1.0 = 100%)</small>
          </div>

          <!-- Server Calculation Result -->
          <c:if test="${not empty calculationResult}">
              <div class="calculation-box">
                  <h4>💰 Compensation Calculation</h4>
                  <div class="calc-row">
                      <span>Equipment Price:</span>
                      <span><fmt:formatNumber value="${calculationResult.salePrice}" type="currency" currencyCode="VND"/></span>
                  </div>
                  <div class="calc-row">
                      <span>Quantity:</span>
                      <span>${calculationResult.quantity}</span>
                  </div>
                  <div class="calc-row">
                      <span>Original Price:</span>
                      <span><fmt:formatNumber value="${calculationResult.originalPrice}" type="currency" currencyCode="VND"/></span>
                  </div>
                  <div class="calc-row">
                      <span>Compensation Rate:</span>
                      <span><fmt:formatNumber value="${calculationResult.rate}" type="percent"/></span>
                  </div>
                  <div class="calc-row total">
                      <span>Total Compensation:</span>
                      <span><fmt:formatNumber value="${calculationResult.totalAmount}" type="currency" currencyCode="VND"/></span>
                  </div>
              </div>
          </c:if>

          <!-- Form Actions -->
          <div style="margin-top: 30px; text-align: center;">
              <c:choose>
                  <c:when test="${not empty calculationResult}">
                      <!-- Show Create button if calculation is done -->
                      <input type="hidden" name="action" value="create">
                      <button type="submit" class="btn btn-primary">
                          💾 Create Compensation
                      </button>
                  </c:when>
                  <c:otherwise>
                      <!-- Show Calculate button if no calculation yet -->
                      <input type="hidden" name="action" value="calculate">
                      <button type="submit" class="btn btn-success" id="calculateBtn">
                          🧮 Calculate Compensation
                      </button>
                  </c:otherwise>
              </c:choose>

              <a href="${pageContext.request.contextPath}/compensation" class="btn btn-secondary">
                  ❌ Cancel
              </a>
          </div>
      </form>
  </div>
</div>

<!-- Footer -->
<footer>
  <p>&copy; 2024 Swimming Pool Management System</p>
  <p>Equipment Compensation & Rental Management</p>
</footer>

<script>
    function loadRentalInfo() {
        const rentalId = document.getElementById('rentalId').value;
        if (rentalId) {
            window.location.href = '${pageContext.request.contextPath}/compensation?action=create&rentalId=' + rentalId;
        }
    }

    function updateForm() {
        const compensationType = document.getElementById('compensationType').value;
        const damageLevelGroup = document.getElementById('damageLevelGroup');
        const damageLevel = document.getElementById('damageLevel');
        const compensationRate = document.getElementById('compensationRate');

        if (compensationType === 'damaged') {
            damageLevelGroup.style.display = 'block';
            damageLevel.required = true;
        } else {
            damageLevelGroup.style.display = 'none';
            damageLevel.required = false;
            damageLevel.value = '';

            // Auto-set compensation rate for non-damaged items
            if (compensationType === 'lost') {
                compensationRate.value = '1.0';
            } else if (compensationType === 'overdue_fee') {
                compensationRate.value = '0.1';
            }
        }
    }

    function updateCompensationRate() {
        const damageLevel = document.getElementById('damageLevel').value;
        const compensationRate = document.getElementById('compensationRate');

        // Suggest compensation rates based on damage level
        switch(damageLevel) {
            case 'minor':
                compensationRate.value = '0.2';
                break;
            case 'major':
                compensationRate.value = '0.6';
                break;
            case 'total':
                compensationRate.value = '1.0';
                break;
        }
    }

    function triggerCalculation() {
        const rentalId = document.getElementById('rentalId').value;
        const compensationType = document.getElementById('compensationType').value;
        const compensationRate = document.getElementById('compensationRate').value;

        // Auto-submit for calculation if all required fields are filled
        if (rentalId && compensationType && compensationRate) {
            const form = document.getElementById('compensationForm');
            const actionInput = form.querySelector('input[name="action"]');
            if (actionInput && actionInput.value === 'calculate') {
                // Small delay to allow user to see the value they entered
                setTimeout(() => {
                    form.submit();
                }, 500);
            }
        }
    }

    // Form validation
    document.getElementById('compensationForm').addEventListener('submit', function(e) {
        const action = document.querySelector('input[name="action"]').value;
        const rentalId = document.getElementById('rentalId').value;
        const compensationType = document.getElementById('compensationType').value;
        const compensationRate = parseFloat(document.getElementById('compensationRate').value);
        const damageDescription = document.getElementById('damageDescription').value;

        if (!rentalId) {
            alert('Please select a rental.');
            e.preventDefault();
            return;
        }

        if (!compensationType) {
            alert('Please select compensation type.');
            e.preventDefault();
            return;
        }

        if (compensationType === 'damaged' && !document.getElementById('damageLevel').value) {
            alert('Please select damage level for damaged equipment.');
            e.preventDefault();
            return;
        }

        if (isNaN(compensationRate) || compensationRate < 0 || compensationRate > 1) {
            alert('Compensation rate must be between 0.0 and 1.0');
            e.preventDefault();
            return;
        }

        // For create action, check description
        if (action === 'create') {
            if (!damageDescription.trim()) {
                alert('Please enter a description.');
                e.preventDefault();
                return;
            }

            // Confirm creation
            if (!confirm('Are you sure you want to create this compensation?')) {
                e.preventDefault();
                return;
            }
        }

        // Show loading state
        const submitBtn = e.target.querySelector('button[type="submit"]');
        if (submitBtn) {
            submitBtn.disabled = true;
            if (action === 'calculate') {
                submitBtn.textContent = '🔄 Calculating...';
            } else {
                submitBtn.textContent = '⏳ Creating...';
            }
        }
    });

    // Initialize form state when page loads
    document.addEventListener('DOMContentLoaded', function() {
        updateForm();

        // If we have calculation result, show success message
        <c:if test="${not empty calculationResult}">
        console.log('Calculation completed successfully!');
        console.log('Original Price: ${calculationResult.originalPrice}');
        console.log('Total Amount: ${calculationResult.totalAmount}');
        </c:if>
    });

    // Auto-hide alerts after 5 seconds
    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(function(alert) {
            alert.style.display = 'none';
        });
    }, 5000);

    // Preserve form state on calculation
    <c:if test="${not empty selectedRentalId}">
    document.addEventListener('DOMContentLoaded', function() {
        document.getElementById('rentalId').value = '${selectedRentalId}';
    });
    </c:if>

    <c:if test="${not empty compensationType}">
    document.addEventListener('DOMContentLoaded', function() {
        document.getElementById('compensationType').value = '${compensationType}';
        updateForm();
    });
    </c:if>
</script>
</body>
</html>
<%@ page import="model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || user.getRole() == null || user.getRole().getId() != 5) {
        response.sendRedirect("error.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo Bồi Thường - Hồ Bơi</title>
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

        .btn-success {
            background-color: #28a745;
            color: white;
        }

        .btn-success:hover {
            background-color: #218838;
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
    <div class="logo">🏊‍♂️ Hồ Bơi</div>
    <div class="auth">
        <a href="${pageContext.request.contextPath}/profile" class="login-btn">Hồ Sơ</a>
        <a href="${pageContext.request.contextPath}/logout" class="register-btn">Đăng Xuất</a>
    </div>
</nav>

<!-- Main Content -->
<div class="content">
    <div class="page-header">
        <h1>Tạo Bồi Thường Dụng Cụ</h1>
        <p>Ghi nhận bồi thường cho dụng cụ bị hỏng, mất hoặc quá hạn</p>
    </div>

    <!-- Error Messages -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger">
            <strong>Lỗi:</strong> ${error}
        </div>
    </c:if>

    <div class="form-container">
        <!-- Rental Information (if selected) -->
        <c:if test="${not empty rental}">
            <div class="rental-info">
                <h3>📋 Thông tin thuê</h3>
                <div class="info-grid">
                    <div class="info-item">
                        <strong>Mã thuê</strong>
                        #${rental.rentalId}
                    </div>
                    <div class="info-item">
                        <strong>Khách hàng</strong>
                            ${rental.customerName}
                    </div>
                    <div class="info-item">
                        <strong>CMND/CCCD</strong>
                            ${rental.customerIdCard}
                    </div>
                    <div class="info-item">
                        <strong>Dụng cụ</strong>
                            ${rental.itemName}
                    </div>
                    <div class="info-item">
                        <strong>Số lượng</strong>
                            ${rental.quantity} cái
                    </div>
                    <div class="info-item">
                        <strong>Ngày thuê</strong>
                        <fmt:formatDate value="${rental.rentalDate}" pattern="dd/MM/yyyy"/>
                    </div>
                    <div class="info-item">
                        <strong>Trạng thái</strong>
                        <span style="color: ${rental.status == 'active' ? 'green' : 'orange'}">
                                ${rental.status}
                        </span>
                    </div>
                    <c:if test="${not empty equipment}">
                        <div class="info-item">
                            <strong>Giá nhập</strong>
                            <fmt:formatNumber value="${equipment.importPrice}" type="currency" currencyCode="VND"/>
                        </div>
                    </c:if>
                </div>
            </div>
        </c:if>

        <!-- Compensation Form -->
        <form action="${pageContext.request.contextPath}/compensation" method="post" id="compensationForm">
            <!-- Rental Selection -->
            <div class="form-group">
                <label for="rentalId">Chọn phiếu thuê <span style="color: red;">*</span></label>
                <select id="rentalId" name="rentalId" required onchange="loadRentalInfo()">
                    <option value="">-- Chọn phiếu thuê --</option>
                    <c:forEach var="activeRental" items="${activeRentals}">
                        <option value="${activeRental.rentalId}"
                            ${(rental != null && rental.rentalId == activeRental.rentalId) ||
                                    (selectedRentalId != null && selectedRentalId == activeRental.rentalId) ? 'selected' : ''}>
                            #${activeRental.rentalId} - ${activeRental.customerName} - ${activeRental.itemName}
                            (SL: ${activeRental.quantity})
                        </option>
                    </c:forEach>
                </select>
            </div>

            <!-- Compensation Details -->
            <div class="form-row">
                <div class="form-group">
                    <label for="compensationType">Loại bồi thường <span style="color: red;">*</span></label>
                    <select id="compensationType" name="compensationType" required onchange="updateForm()">
                        <option value="">-- Chọn loại --</option>
                        <option value="damaged" ${compensationType == 'damaged' ? 'selected' : ''}>🔧 Dụng cụ bị hỏng</option>
                        <option value="lost" ${compensationType == 'lost' ? 'selected' : ''}>❌ Dụng cụ bị mất</option>
                        <option value="overdue_fee" ${compensationType == 'overdue_fee' ? 'selected' : ''}>⏰ Phí quá hạn</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="compensationRate">Tỷ lệ bồi thường <span style="color: red;">*</span></label>
                    <select id="compensationRate" name="compensationRate" required>
                        <option value="">-- Chọn tỷ lệ --</option>
                        <option value="0.1" ${compensationRate == 0.1 ? 'selected' : ''}>10% - Phí quá hạn</option>
                        <option value="0.2" ${compensationRate == 0.2 ? 'selected' : ''}>20% - Hỏng nhẹ</option>
                        <option value="0.4" ${compensationRate == 0.4 ? 'selected' : ''}>40% - Hỏng vừa</option>
                        <option value="0.6" ${compensationRate == 0.6 ? 'selected' : ''}>60% - Hỏng nặng</option>
                        <option value="0.8" ${compensationRate == 0.8 ? 'selected' : ''}>80% - Hỏng rất nặng</option>
                        <option value="1.0" ${compensationRate == 1.0 ? 'selected' : ''}>100% - Mất hoàn toàn</option>
                    </select>
                    <small style="color: #666;">Chọn tỷ lệ bồi thường phù hợp với mức độ hư hỏng</small>
                </div>
            </div>

            <!-- Description -->
            <div class="form-group">
                <label for="damageDescription">Mô tả <span style="color: red;">*</span></label>
                <textarea id="damageDescription" name="damageDescription" required
                          placeholder="Mô tả chi tiết về hư hỏng, mất mát hoặc tình trạng quá hạn...">${param.damageDescription}</textarea>
            </div>

            <!-- Server Calculation Result -->
            <c:if test="${not empty calculationResult}">
                <div class="calculation-box">
                    <h4>💰 Tính toán bồi thường</h4>
                    <div class="calc-row">
                        <span>Giá nhập (mỗi cái):</span>
                        <span><fmt:formatNumber value="${calculationResult.importPrice}" type="currency" currencyCode="VND"/></span>
                    </div>
                    <div class="calc-row">
                        <span>Số lượng:</span>
                        <span>${calculationResult.quantity}</span>
                    </div>
                    <div class="calc-row">
                        <span>Tổng giá nhập:</span>
                        <span><fmt:formatNumber value="${calculationResult.importPriceTotal}" type="currency" currencyCode="VND"/></span>
                    </div>
                    <div class="calc-row">
                        <span>Tỷ lệ bồi thường:</span>
                        <span><fmt:formatNumber value="${calculationResult.rate}" type="percent"/></span>
                    </div>
                    <div class="calc-row total">
                        <span>Số tiền bồi thường:</span>
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
                        <button type="submit" class="btn btn-primary" onclick="console.log('=== Nhấn Create Button - Bắt đầu submit ===');">
                            💾 Tạo bồi thường
                        </button>
                        <!-- Thêm nút Recalculate -->
                        <button type="button" class="btn btn-success" onclick="recalculate()">
                            🔄 Tính lại
                        </button>
                    </c:when>
                    <c:otherwise>
                        <!-- Show Calculate button if no calculation yet -->
                        <input type="hidden" name="action" value="calculate" id="actionInput">
                        <button type="submit" class="btn btn-success" id="calculateBtn">
                            🧮 Tính bồi thường
                        </button>
                    </c:otherwise>
                </c:choose>

                <a href="${pageContext.request.contextPath}/compensation" class="btn btn-secondary">
                    ❌ Hủy
                </a>
            </div>
        </form>
    </div>
</div>

<!-- Footer -->
<footer>
    <p>&copy; 2024 Hệ thống quản lý hồ bơi</p>
    <p>Quản lý bồi thường & cho thuê dụng cụ</p>
</footer>

<script>
    // Load rental information
    function loadRentalInfo() {
        const rentalId = document.getElementById('rentalId').value;
        if (rentalId) {
            window.location.href = '${pageContext.request.contextPath}/compensation?action=create&rentalId=' + rentalId;
        }
    }

    // Update form based on compensation type
    function updateForm() {
        const compensationType = document.getElementById('compensationType').value;
        const compensationRate = document.getElementById('compensationRate');

        // Auto-suggest rates based on type
        if (compensationType === 'lost') {
            compensationRate.value = '1.0'; // 100% for lost items
        } else if (compensationType === 'overdue_fee') {
            compensationRate.value = '0.1'; // 10% for overdue
        } else if (compensationType === 'damaged') {
            // Let user choose for damaged items
            compensationRate.value = '';
        }
    }

    // Trigger calculation
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

    // Recalculate function
    function recalculate() {
        const form = document.getElementById('compensationForm');
        const actionInput = form.querySelector('input[name="action"]');
        actionInput.value = 'calculate';
        form.submit();
    }

    // Form validation
    document.getElementById('compensationForm').addEventListener('submit', function(e) {
        const action = document.querySelector('input[name="action"]').value;
        const rentalId = document.getElementById('rentalId').value;
        const compensationType = document.getElementById('compensationType').value;
        const compensationRate = document.getElementById('compensationRate').value;
        const damageDescription = document.getElementById('damageDescription').value;

        if (!rentalId) {
            alert('Vui lòng chọn phiếu thuê.');
            e.preventDefault();
            return;
        }

        if (!compensationType) {
            alert('Vui lòng chọn loại bồi thường.');
            e.preventDefault();
            return;
        }

        if (!compensationRate) {
            alert('Vui lòng chọn tỷ lệ bồi thường.');
            e.preventDefault();
            return;
        }

        // For create action, check description
        if (action === 'create') {
            if (!damageDescription.trim()) {
                alert('Vui lòng nhập mô tả.');
                e.preventDefault();
                return;
            }

            // Confirm creation
            if (!confirm('Bạn có chắc chắn muốn tạo bồi thường này?\n\nViệc này sẽ tạo hóa đơn cho khách hàng.')) {
                e.preventDefault();
                return;
            }
        }

        // Show loading state
        const submitBtn = e.target.querySelector('button[type="submit"]');
        if (submitBtn) {
            submitBtn.disabled = true;
            if (action === 'calculate') {
                submitBtn.textContent = '🔄 Đang tính...';
            } else {
                submitBtn.textContent = '⏳ Đang tạo...';
            }
        }
    });

    // Initialize form state when page loads
    document.addEventListener('DOMContentLoaded', function() {
        updateForm();

        // If we have calculation result, show success message
        <c:if test="${not empty calculationResult}">
        console.log('Calculation completed successfully!');
        console.log('Import Price Total: ${calculationResult.importPriceTotal}');
        console.log('Total Amount: ${calculationResult.totalAmount}');
        </c:if>
    });

    // Auto-hide alerts after 5 seconds
    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(function(alert) {
            alert.style.transition = 'opacity 0.5s';
            alert.style.opacity = '0';
            setTimeout(() => alert.style.display = 'none', 500);
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

    <c:if test="${not empty compensationRate}">
    document.addEventListener('DOMContentLoaded', function() {
        document.getElementById('compensationRate').value = '${compensationRate}';
    });
    </c:if>

    function recalculate() {
        // Set action về calculate
        const form = document.getElementById('compensationForm');

        // Tạo hidden input mới hoặc update existing
        let actionInput = form.querySelector('input[name="action"]');
        if (!actionInput) {
            actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            form.appendChild(actionInput);
        }
        actionInput.value = 'calculate';

        form.submit();
    }

    // Cải thiện UX:
    document.addEventListener('DOMContentLoaded', function() {
        const rentalId = document.getElementById('rentalId');
        const compensationType = document.getElementById('compensationType');
        const compensationRate = document.getElementById('compensationRate');
        const calculateBtn = document.getElementById('calculateBtn');

        function checkFormReady() {
            if (rentalId.value && compensationType.value && compensationRate.value) {
                calculateBtn.classList.add('btn-warning');
                calculateBtn.innerHTML = '🧮 Sẵn sàng tính toán!';
            }
        }

        rentalId.addEventListener('change', checkFormReady);
        compensationType.addEventListener('change', checkFormReady);
        compensationRate.addEventListener('change', checkFormReady);
    });

    document.addEventListener('DOMContentLoaded', function() {
        console.clear();  // Clear console để sạch
        console.log('=== Page Load Debug ===');
        const actionInput = document.querySelector('input[name="action"]');
        console.log('Hidden action từ HTML:', actionInput ? actionInput.value : 'KHÔNG TỒN TẠI');
        console.log('Calculation box tồn tại?', !!document.querySelector('.calculation-box'));
    });

    // Log khi form submit
    document.getElementById('compensationForm').addEventListener('submit', function(e) {
        console.log('=== Form Submit Triggered ===');
        const action = document.querySelector('input[name="action"]').value;
        console.log('Action gửi đi:', action);
        console.log('Form method:', this.method);
        console.log('Form URL:', this.action);
        // Không e.preventDefault() để submit thật
    });

    // Log cho Recalculate
    function recalculate() {
        console.log('=== Nhấn Recalculate Button - Set action=calculate ===');
        const form = document.getElementById('compensationForm');
        let actionInput = form.querySelector('input[name="action"]');
        actionInput.value = 'calculate';
        form.submit();
    }
</script>
</body>
</html>
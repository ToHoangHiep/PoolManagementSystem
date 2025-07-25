<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Compensation Details - Swimming Pool</title>
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

        .detail-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .detail-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 20px;
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

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }

        .info-item {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 4px;
            border-left: 4px solid #005caa;
        }

        .info-item strong {
            display: block;
            color: #495057;
            font-size: 12px;
            text-transform: uppercase;
            margin-bottom: 5px;
        }

        .info-item span {
            font-size: 16px;
            color: #212529;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
            display: inline-block;
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

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            margin-right: 10px;
            margin-bottom: 10px;
        }

        .btn-primary {
            background-color: #005caa;
            color: white;
        }

        .btn-success {
            background-color: #28a745;
            color: white;
        }

        .btn-warning {
            background-color: #ffc107;
            color: #212529;
        }

        .btn-info {
            background-color: #17a2b8;
            color: white;
        }

        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        .table th,
        .table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #dee2e6;
        }

        .table th {
            background-color: #f8f9fa;
            font-weight: bold;
            color: #495057;
        }

        .table tbody tr:hover {
            background-color: #f8f9fa;
        }

        .progress-bar {
            background: #e9ecef;
            border-radius: 20px;
            overflow: hidden;
            height: 20px;
            margin: 10px 0;
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

        .empty-state {
            text-align: center;
            padding: 40px;
            color: #6c757d;
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
            .detail-grid {
                grid-template-columns: 1fr;
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
        <span>Compensation #${compensation.compensationId}</span>
    </nav>

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

    <div class="detail-container">
        <c:choose>
            <c:when test="${not empty compensation}">
                <!-- Page Header -->
                <div class="page-header">
                    <h1>Compensation #${compensation.compensationId}</h1>
                    <span class="status-badge status-${compensation.paymentStatus}">
                            ${compensation.paymentStatus}
                    </span>
                </div>

                <div class="detail-grid">
                    <!-- Left Column: Main Details -->
                    <div>
                        <!-- Compensation Details -->
                        <div class="card">
                            <h3>🔧 Compensation Details</h3>
                            <div class="info-grid">
                                <div class="info-item">
                                    <strong>Compensation ID</strong>
                                    <span>#${compensation.compensationId}</span>
                                </div>
                                <div class="info-item">
                                    <strong>Rental ID</strong>
                                    <span>#${compensation.rentalId}</span>
                                </div>
                                <div class="info-item">
                                    <strong>Type</strong>
                                    <span>
                                            <c:choose>
                                                <c:when test="${compensation.compensationType == 'damaged'}">🔧 Damaged</c:when>
                                                <c:when test="${compensation.compensationType == 'lost'}">❌ Lost</c:when>
                                                <c:when test="${compensation.compensationType == 'overdue_fee'}">⏰ Overdue</c:when>
                                                <c:otherwise>${compensation.compensationType}</c:otherwise>
                                            </c:choose>
                                        </span>
                                </div>

                                <div class="info-item">
                                    <strong>Import price total</strong>
                                    <span><fmt:formatNumber value="${compensation.importPriceTotal}" type="currency" currencyCode="VND"/></span>
                                </div>
                                <div class="info-item">
                                    <strong>Compensation Rate</strong>
                                    <span><fmt:formatNumber value="${compensation.compensationRate}" type="percent"/></span>
                                </div>
                                <div class="info-item">
                                    <strong>Total Amount</strong>
                                    <span><fmt:formatNumber value="${compensation.totalAmount}" type="currency" currencyCode="VND"/></span>
                                </div>
                                <div class="info-item">
                                    <strong>Paid Amount</strong>
                                    <span><fmt:formatNumber value="${compensation.paidAmount}" type="currency" currencyCode="VND"/></span>
                                </div>
                                <div class="info-item">
                                    <strong>Remaining</strong>
                                    <span><fmt:formatNumber value="${compensation.remainingAmount}" type="currency" currencyCode="VND"/></span>
                                </div>
                                <div class="info-item">
                                    <strong>Can Repair</strong>
                                    <span>${compensation.canRepair ? '✅ Yes' : '❌ No'}</span>
                                </div>
                                <div class="info-item">
                                    <strong>Created Date</strong>
                                    <span><fmt:formatDate value="${compensation.createdAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                                </div>
                                <c:if test="${not empty compensation.resolvedAt}">
                                    <div class="info-item">
                                        <strong>Resolved Date</strong>
                                        <span><fmt:formatDate value="${compensation.resolvedAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                                    </div>
                                </c:if>
                            </div>

                            <c:if test="${not empty compensation.damageDescription}">
                                <div style="margin-top: 20px;">
                                    <strong>Description:</strong>
                                    <p style="margin-top: 10px; padding: 15px; background: #f8f9fa; border-radius: 4px;">
                                            ${compensation.damageDescription}
                                    </p>
                                </div>
                            </c:if>
                        </div>

                        <!-- Rental Information -->
                        <c:if test="${not empty rental}">
                            <div class="card">
                                <h3>📋 Rental Information</h3>
                                <div class="info-grid">
                                    <div class="info-item">
                                        <strong>Customer Name</strong>
                                        <span>${rental.customerName}</span>
                                    </div>
                                    <div class="info-item">
                                        <strong>ID Card</strong>
                                        <span>${rental.customerIdCard}</span>
                                    </div>
                                    <div class="info-item">
                                        <strong>Equipment</strong>
                                        <span>${rental.itemName}</span>
                                    </div>
                                    <div class="info-item">
                                        <strong>Quantity</strong>
                                        <span>${rental.quantity} units</span>
                                    </div>
                                    <div class="info-item">
                                        <strong>Rental Date</strong>
                                        <span><fmt:formatDate value="${rental.rentalDate}" pattern="dd/MM/yyyy"/></span>
                                    </div>
                                    <div class="info-item">
                                        <strong>Rental Status</strong>
                                        <span style="color: ${rental.status == 'active' ? 'green' : 'orange'}">
                                                ${rental.status}
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        <!-- Payment History -->
                        <div class="card">
                            <h3>💳 Payment History</h3>
                            <c:choose>
                                <c:when test="${not empty payments}">
                                    <table class="table">
                                        <thead>
                                        <tr>
                                            <th>Payment ID</th>
                                            <th>Amount</th>
                                            <th>Date</th>
                                            <th>Notes</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach var="payment" items="${payments}">
                                            <td>#${payment.paymentId}</td>
                                            <td><fmt:formatNumber value="${payment.amount}" type="currency"/></td>
                                            <td><fmt:formatDate value="${payment.paymentDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                            <td>${payment.notes}</td>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <p>💸 No payments recorded yet</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Repair Information -->
                        <c:if test="${compensation.compensationType == 'damaged'}">
                            <div class="card">
                                <h3>🔧 Repair Information</h3>
                                <c:choose>
                                    <c:when test="${not empty repairs}">
                                        <table class="table">
                                            <thead>
                                            <tr>
                                                <th>Repair ID</th>
                                                <th>Description</th>
                                                <th>Cost</th>
                                                <th>Vendor</th>
                                                <th>Status</th>
                                                <th>Est. Completion</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:forEach var="repair" items="${repairs}">
                                                <tr>
                                                    <td>#${repair.repairId}</td>
                                                    <td>${repair.repairDescription}</td>
                                                    <td><fmt:formatNumber value="${repair.repairCost}" type="currency" currencyCode="VND"/></td>
                                                    <td>${repair.repairVendor}</td>
                                                    <td>
                                                                <span class="status-badge status-${repair.repairStatus}">
                                                                        ${repair.repairStatus}
                                                                </span>
                                                    </td>
                                                    <td>
                                                        <c:if test="${not empty repair.estimatedCompletion}">
                                                            <fmt:formatDate value="${repair.estimatedCompletion}" pattern="dd/MM/yyyy"/>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="empty-state">
                                            <p>🔧 No repair records yet</p>
                                            <c:if test="${compensation.canRepair}">
                                                <a href="${pageContext.request.contextPath}/repair?action=create&compensationId=${compensation.compensationId}"
                                                   class="btn btn-warning">🔧 Create Repair Record</a>
                                            </c:if>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:if>
                    </div>

                    <!-- Right Column: Actions & Summary -->
                    <div>
                        <!-- Quick Actions -->
                        <div class="card">
                            <h3>⚡ Quick Actions</h3>

<%--                            <c:if test="${not compensation.fullyPaid}">--%>
<%--                                <a href="${pageContext.request.contextPath}/compensation?action=payment&compensationId=${compensation.compensationId}"--%>
<%--                                   class="btn btn-success">💳 Add Payment</a>--%>
<%--                            </c:if>--%>



<%--                            <c:if test="${compensation.compensationType == 'damaged' && compensation.canRepair}">--%>
<%--                                <a href="${pageContext.request.contextPath}/repair?action=create&compensationId=${compensation.compensationId}"--%>
<%--                                   class="btn btn-warning">🔧 Create Repair</a>--%>
<%--                            </c:if>--%>

                            <a href="${pageContext.request.contextPath}/compensation" class="btn btn-secondary">📋 Back to List</a>
                        </div>

                        <!-- Payment Progress -->
                        <div class="card">
                            <h3>📊 Payment Progress</h3>
                            <c:set var="paymentPercent" value="${(compensation.paidAmount / compensation.totalAmount) * 100}"/>
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: ${paymentPercent}%">
                                    <fmt:formatNumber value="${paymentPercent}" maxFractionDigits="1"/>%
                                </div>
                            </div>
                            <div style="display: flex; justify-content: space-between; margin-top: 10px; font-size: 14px;">
                                <span>Paid: <fmt:formatNumber value="${compensation.paidAmount}" type="currency" currencyCode="VND"/></span>
                                <span>Total: <fmt:formatNumber value="${compensation.totalAmount}" type="currency" currencyCode="VND"/></span>
                            </div>
                            <c:if test="${not compensation.fullyPaid}">
                                <div style="margin-top: 15px; padding: 10px; background: #fff3cd; border-radius: 4px; border-left: 4px solid #ffc107;">
                                    <strong>Remaining:</strong>
                                    <fmt:formatNumber value="${compensation.remainingAmount}" type="currency" currencyCode="VND"/>
                                </div>
                            </c:if>
                        </div>

                        <!-- Customer Info -->
                        <c:if test="${not empty rental}">
                            <div class="card">
                                <h3>👤 Customer Info</h3>
                                <div style="text-align: center; margin-bottom: 15px;">
                                    <div style="font-size: 18px; font-weight: bold; color: #005caa;">
                                            ${rental.customerName}
                                    </div>
                                    <div style="color: #666; margin-top: 5px;">
                                        ID: ${rental.customerIdCard}
                                    </div>
                                </div>

                                <a href="${pageContext.request.contextPath}/customer/history?idCard=${rental.customerIdCard}"
                                   class="btn btn-info" style="width: 100%;">📋 View History</a>

                            </div>
                        </c:if>

                        <!-- Compensation Summary -->
                        <div class="card">
                            <h3>📈 Summary</h3>
                            <div class="info-item" style="margin-bottom: 10px;">
                                <strong>Status</strong>
                                <span class="status-badge status-${compensation.paymentStatus}">
                                        ${compensation.paymentStatus}
                                </span>
                            </div>

                            <div class="info-item" style="margin-bottom: 10px;">
                                <strong>Type</strong>
                                <span>
                                        <c:choose>
                                            <c:when test="${compensation.compensationType == 'damaged'}">🔧 Equipment Damage</c:when>
                                            <c:when test="${compensation.compensationType == 'lost'}">❌ Lost Equipment</c:when>
                                            <c:when test="${compensation.compensationType == 'overdue_fee'}">⏰ Overdue Fee</c:when>
                                        </c:choose>
                                    </span>
                            </div>
                            <div class="info-item">
                                <strong>Actions Available</strong>
                                <div style="margin-top: 8px;">
                                    <c:choose>
                                        <c:when test="${compensation.fullyPaid}">
                                            ✅ Fully Paid
                                        </c:when>
                                        <c:otherwise>
                                            💳 Payment Required
                                        </c:otherwise>
                                    </c:choose>
                                    <br>
                                    <c:if test="${compensation.canRepair}">
                                        🔧 Repairable<br>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <!-- Recent Activity -->
                        <div class="card">
                            <h3>🕒 Recent Activity</h3>
                            <div style="font-size: 14px; line-height: 1.6;">
                                <div style="margin-bottom: 10px; padding: 8px; background: #f8f9fa; border-radius: 4px;">
                                    <strong>Created:</strong> <fmt:formatDate value="${compensation.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </div>

                                <c:if test="${not empty payments}">
                                    <div style="margin-bottom: 10px; padding: 8px; background: #d4edda; border-radius: 4px;">
                                        <strong>Last Payment:</strong>
                                        <fmt:formatDate value="${payments[0].paymentDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </div>
                                </c:if>

                                <c:if test="${not empty compensation.resolvedAt}">
                                    <div style="margin-bottom: 10px; padding: 8px; background: #d1ecf1; border-radius: 4px;">
                                        <strong>Resolved:</strong>
                                        <fmt:formatDate value="${compensation.resolvedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>

            </c:when>
            <c:otherwise>
                <div class="card">
                    <div class="empty-state">
                        <h3>❌ Compensation Not Found</h3>
                        <p>The compensation record you're looking for doesn't exist or has been removed.</p>
                        <a href="${pageContext.request.contextPath}/compensation" class="btn btn-primary">
                            📋 Back to Compensations
                        </a>
                    </div>
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
    // Auto-hide alerts after 5 seconds
    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(function(alert) {
            alert.style.display = 'none';
        });
    }, 5000);

    // Smooth scroll for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            document.querySelector(this.getAttribute('href')).scrollIntoView({
                behavior: 'smooth'
            });
        });
    });



    // Refresh page every 30 seconds to update payment status
    setInterval(function() {
        // Only refresh if compensation is not fully paid
        <c:if test="${not compensation.fullyPaid}">
        location.reload();
        </c:if>
    }, 30000);
</script>
</body>
</html>
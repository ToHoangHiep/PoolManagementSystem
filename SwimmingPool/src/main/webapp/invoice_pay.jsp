<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invoice - Swimming Pool</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Arial', sans-serif;
            background: #f5f5f5;
            color: #333;
            line-height: 1.6;
        }
        .invoice-container {
            max-width: 800px;
            margin: 20px auto;
            background: white;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
            position: relative; /* Thêm để watermark absolute đúng vị trí */
        }
        .invoice-header {
            background: linear-gradient(135deg, #005caa 0%, #004494 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        .invoice-header h1 {
            font-size: 32px;
            margin-bottom: 10px;
        }
        .invoice-number {
            font-size: 18px;
            opacity: 0.9;
        }
        .invoice-date {
            font-size: 14px;
            opacity: 0.8;
            margin-top: 5px;
        }
        .invoice-body {
            padding: 40px;
        }
        .section {
            margin-bottom: 30px;
        }
        .section-title {
            font-size: 18px;
            font-weight: bold;
            color: #005caa;
            margin-bottom: 15px;
            padding-bottom: 5px;
            border-bottom: 2px solid #005caa;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }
        .info-item {
            padding: 10px;
            background: #f8f9fa;
            border-radius: 4px;
        }
        .info-label {
            font-size: 12px;
            color: #666;
            text-transform: uppercase;
            margin-bottom: 3px;
        }
        .info-value {
            font-size: 15px;
            font-weight: 500;
            color: #333;
        }
        .calculation-table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        .calculation-table th,
        .calculation-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #dee2e6;
        }
        .calculation-table th {
            background: #f8f9fa;
            font-weight: bold;
            color: #495057;
        }
        .calculation-table .text-right {
            text-align: right;
        }
        .calculation-table .total-row {
            background: #e7f3ff;
            font-weight: bold;
            font-size: 18px;
        }
        .calculation-table .total-row td {
            padding: 15px 12px;
            border-bottom: 2px solid #005caa;
        }
        .alert-box {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
            padding: 15px;
            border-radius: 4px;
            margin: 20px 0;
        }
        .success-box {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
            padding: 15px;
            border-radius: 4px;
            margin: 20px 0;
        }
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
            padding: 20px;
            background: #f8f9fa;
        }
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 4px;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }
        .btn-primary {
            background: #005caa;
            color: white;
        }
        .btn-primary:hover {
            background: #004494;
            transform: translateY(-1px);
        }
        .btn-success {
            background: #28a745;
            color: white;
        }
        .btn-success:hover {
            background: #218838;
            transform: translateY(-1px);
        }
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background: #545b62;
        }
        .watermark {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) rotate(-45deg);
            font-size: 120px;
            font-weight: bold;
            color: rgba(0, 92, 170, 0.1);
            z-index: -1;
            pointer-events: none;
        }
        .print-only {
            display: none;
        }
        @media print {
            body {
                background: white;
            }
            .invoice-container {
                box-shadow: none;
                margin: 0;
            }
            .action-buttons {
                display: none;
            }
            .print-only {
                display: block;
            }
            .watermark {
                display: none;
            }
        }
        .footer-note {
            text-align: center;
            font-size: 12px;
            color: #666;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #dee2e6;
        }
    </style>
</head>
<body>
<div class="invoice-container">
    <div class="watermark">INVOICE</div>

    <!-- Invoice Header -->
    <div class="invoice-header">
        <h1>🏊 SWIMMING POOL</h1>
        <div class="invoice-number">Invoice No: ${invoiceNumber}</div>
        <div class="invoice-date">Date: <fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd/MM/yyyy HH:mm"/></div>
    </div>

    <!-- Invoice Body -->
    <div class="invoice-body">
        <!-- Success Message -->
        <div class="success-box">
            <strong>✅ Payment Successful!</strong><br>
            Please review the details below.
        </div>

        <!-- Customer Information -->
        <div class="section">
            <h3 class="section-title">Customer Information</h3>
            <div class="info-grid">
                <c:choose>
                    <c:when test="${type == 'ticket'}">
                        <!-- For Ticket: Get from first ticket -->
                        <div class="info-item">
                            <div class="info-label">Customer Name</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty tickets and not empty tickets[0].customerName}">
                                        ${tickets[0].customerName}
                                    </c:when>
                                    <c:otherwise>
                                        ${customerName}
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">ID Card</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty tickets and not empty tickets[0].customerIdCard}">
                                        ${tickets[0].customerIdCard}
                                    </c:when>
                                    <c:otherwise>
                                        ${customerIdCard}
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:when>

                    <c:when test="${type == 'equipment_rental'}">
                        <!-- For Rental: Get from first rental -->
                        <div class="info-item">
                            <div class="info-label">Customer Name</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty rentals and not empty rentals[0].customerName}">
                                        ${rentals[0].customerName}
                                    </c:when>
                                    <c:otherwise>
                                        ${customerName}
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">ID Card</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty rentals and not empty rentals[0].customerIdCard}">
                                        ${rentals[0].customerIdCard}
                                    </c:when>
                                    <c:otherwise>
                                        ${customerIdCard}
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:when>

                    <c:when test="${type == 'equipment_buy'}">
                        <!-- For Sale: Get from first sale (no ID Card available) -->
                        <div class="info-item">
                            <div class="info-label">Customer Name</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty sales and not empty sales[0].customerName}">
                                        ${sales[0].customerName}
                                    </c:when>
                                    <c:otherwise>
                                        ${customerName}
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">ID Card</div>
                            <div class="info-value">N/A</div> <!-- Equipment Sale không có ID Card -->
                        </div>
                    </c:when>

                    <c:when test="${type == 'mixed'}">
                        <!-- For Mixed: Priority order - ticket > rental > sale -->
                        <div class="info-item">
                            <div class="info-label">Customer Name</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty tickets and not empty tickets[0].customerName}">
                                        ${tickets[0].customerName}
                                    </c:when>
                                    <c:when test="${not empty rentals and not empty rentals[0].customerName}">
                                        ${rentals[0].customerName}
                                    </c:when>
                                    <c:when test="${not empty sales and not empty sales[0].customerName}">
                                        ${sales[0].customerName}
                                    </c:when>
                                    <c:otherwise>
                                        ${customerName}
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">ID Card</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty tickets and not empty tickets[0].customerIdCard}">
                                        ${tickets[0].customerIdCard}
                                    </c:when>
                                    <c:when test="${not empty rentals and not empty rentals[0].customerIdCard}">
                                        ${rentals[0].customerIdCard}
                                    </c:when>
                                    <c:otherwise>
                                        N/A
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <!-- Fallback: Use generic customer info -->
                        <div class="info-item">
                            <div class="info-label">Customer Name</div>
                            <div class="info-value">${customerName}</div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">ID Card</div>
                            <div class="info-value">${customerIdCard}</div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Phân biệt hóa đơn dựa trên type -->
        <c:choose>
            <c:when test="${type == 'ticket'}">
                <!-- Ticket Details -->
                <div class="section">
                    <h3 class="section-title">Ticket Details</h3>
                    <table class="calculation-table">
                        <thead>
                        <tr>
                            <th>Description</th>
                            <th class="text-right">Quantity</th>
                            <th class="text-right">Unit Price</th>
                            <th class="text-right">Amount</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="ticket" items="${tickets}">
                            <tr>
                                <td>${ticket.ticketTypeName}</td>
                                <td class="text-right">${ticket.quantity}</td>
                                <td class="text-right"><fmt:formatNumber value="${ticket.price}" type="currency" currencyCode="VND"/></td>
                                <td class="text-right"><fmt:formatNumber value="${ticket.total}" type="currency" currencyCode="VND"/></td>
                            </tr>
                        </c:forEach>
                        <tr class="total-row">
                            <td colspan="3">Total Amount</td>
                            <td class="text-right"><fmt:formatNumber value="${totalAmount}" type="currency" currencyCode="VND"/></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </c:when>

            <c:when test="${type == 'equipment_rental'}">
                <!-- Rental Details -->
                <div class="section">
                    <h3 class="section-title">Rental Details</h3>
                    <table class="calculation-table">
                        <thead>
                        <tr>
                            <th>Item Name</th>
                            <th class="text-right">Quantity</th>
                            <th class="text-right">Rent Price</th>
                            <th class="text-right">Amount</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="rental" items="${rentals}">
                            <tr>
                                <td>${rental.itemName}</td>
                                <td class="text-right">${rental.quantity}</td>
                                <td class="text-right"><fmt:formatNumber value="${rental.rentPrice}" type="currency" currencyCode="VND"/></td>
                                <td class="text-right"><fmt:formatNumber value="${rental.totalAmount}" type="currency" currencyCode="VND"/></td>
                            </tr>
                        </c:forEach>
                        <tr class="total-row">
                            <td colspan="3">Total Amount</td>
                            <td class="text-right"><fmt:formatNumber value="${totalAmount}" type="currency" currencyCode="VND"/></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </c:when>

            <c:when test="${type == 'equipment_buy'}">
                <!-- Sale Details -->
                <div class="section">
                    <h3 class="section-title">Sale Details</h3>
                    <table class="calculation-table">
                        <thead>
                        <tr>
                            <th>Item Name</th>
                            <th class="text-right">Quantity</th>
                            <th class="text-right">Sale Price</th>
                            <th class="text-right">Amount</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="sale" items="${sales}">
                            <tr>
                                <td>${sale.itemName}</td>
                                <td class="text-right">${sale.quantity}</td>
                                <td class="text-right"><fmt:formatNumber value="${sale.salePrice}" type="currency" currencyCode="VND"/></td>
                                <td class="text-right"><fmt:formatNumber value="${sale.totalAmount}" type="currency" currencyCode="VND"/></td>
                            </tr>
                        </c:forEach>
                        <tr class="total-row">
                            <td colspan="3">Total Amount</td>
                            <td class="text-right"><fmt:formatNumber value="${totalAmount}" type="currency" currencyCode="VND"/></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </c:when>

            <c:when test="${type == 'mixed'}">
                <!-- Mixed Details: Hiển thị từng phần nếu có -->
                <div class="section">
                    <h3 class="section-title">Mixed Details</h3>

                    <!-- Ticket Details nếu có -->
                    <c:if test="${not empty tickets}">
                        <h4 class="section-title">Ticket Items</h4>
                        <table class="calculation-table">
                            <thead>
                            <tr>
                                <th>Description</th>
                                <th class="text-right">Quantity</th>
                                <th class="text-right">Unit Price</th>
                                <th class="text-right">Amount</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="ticket" items="${tickets}">
                                <tr>
                                    <td>${ticket.ticketTypeName}</td>
                                    <td class="text-right">${ticket.quantity}</td>
                                    <td class="text-right"><fmt:formatNumber value="${ticket.price}" type="currency" currencyCode="VND"/></td>
                                    <td class="text-right"><fmt:formatNumber value="${ticket.total}" type="currency" currencyCode="VND"/></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:if>

                    <!-- Rental Details nếu có -->
                    <c:if test="${not empty rentals}">
                        <h4 class="section-title">Rental Items</h4>
                        <table class="calculation-table">
                            <thead>
                            <tr>
                                <th>Item Name</th>
                                <th class="text-right">Quantity</th>
                                <th class="text-right">Rent Price</th>
                                <th class="text-right">Amount</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="rental" items="${rentals}">
                                <tr>
                                    <td>${rental.itemName}</td>
                                    <td class="text-right">${rental.quantity}</td>
                                    <td class="text-right"><fmt:formatNumber value="${rental.rentPrice}" type="currency" currencyCode="VND"/></td>
                                    <td class="text-right"><fmt:formatNumber value="${rental.totalAmount}" type="currency" currencyCode="VND"/></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:if>

                    <!-- Sale Details nếu có -->
                    <c:if test="${not empty sales}">
                        <h4 class="section-title">Sale Items</h4>
                        <table class="calculation-table">
                            <thead>
                            <tr>
                                <th>Item Name</th>
                                <th class="text-right">Quantity</th>
                                <th class="text-right">Sale Price</th>
                                <th class="text-right">Amount</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="sale" items="${sales}">
                                <tr>
                                    <td>${sale.itemName}</td>
                                    <td class="text-right">${sale.quantity}</td>
                                    <td class="text-right"><fmt:formatNumber value="${sale.salePrice}" type="currency" currencyCode="VND"/></td>
                                    <td class="text-right"><fmt:formatNumber value="${sale.totalAmount}" type="currency" currencyCode="VND"/></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:if>

                    <!-- Total Amount cho mixed -->
                    <table class="calculation-table">
                        <tr class="total-row">
                            <td colspan="3">Total Amount</td>
                            <td class="text-right"><fmt:formatNumber value="${totalAmount}" type="currency" currencyCode="VND"/></td>
                        </tr>
                    </table>
                </div>
            </c:when>

            <c:otherwise>
                <!-- Unknown type -->
                <div class="section">
                    <p class="error">Unknown invoice type: ${type}. Please contact support.</p>
                </div>
            </c:otherwise>
        </c:choose>

        <!-- Payment Information -->
        <div class="section">
            <h3 class="section-title">Payment Information</h3>
            <div class="alert-box">
                <strong>⚠️ Payment Completed</strong><br>
                Amount: <fmt:formatNumber value="${totalAmount}" type="currency" currencyCode="VND"/><br>
            </div>
        </div>

        <!-- Footer Note -->
        <div class="footer-note">
            <p>This is a computer-generated invoice and requires no signature.</p>
            <p>For inquiries, please contact: +84 123 456 789 | support@swimmingpool.com</p>
            <p>Thank you for your cooperation!</p>
        </div>
    </div>

    <!-- Action Buttons -->
    <div class="action-buttons">
        <button class="btn btn-primary" onclick="window.print()">
            ✅ Confirm and Print Invoice
        </button>
        <a href="${backUrl}" class="btn btn-secondary">⬅️ Back Up</a>
    </div>
</div>

<!-- Print-only footer -->
<div class="print-only" style="margin-top: 50px; text-align: center;">
    <p>-----------------------------------</p>
    <p>Customer Signature</p>
    <br><br>
    <p>-----------------------------------</p>
    <p>Staff Signature</p>
</div>

<script>
    setTimeout(function() {
        const successBox = document.querySelector('.success-box');
        if (successBox) {
            successBox.style.display = 'none';
        }
    }, 10000);
    window.addEventListener('afterprint', function () {
        const backUrl = '${backUrl}';
        if (backUrl && backUrl !== '') {
            window.location.href = backUrl;
        } else {
            window.location.href = '/home';  // Fallback
        }
    });
</script>
</body>
</html>
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
    <title>Hóa Đơn Bồi Thường - ${invoiceNumber}</title>
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

        .description-box {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 4px;
            padding: 15px;
            margin: 15px 0;
        }

        .description-label {
            font-weight: bold;
            color: #856404;
            margin-bottom: 5px;
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
    <div class="watermark">HÓA ĐƠN</div>

    <!-- Invoice Header -->
    <div class="invoice-header">
        <h1>🏊 HỒ BƠI</h1>
        <div class="invoice-number">Số hóa đơn: ${invoiceNumber}</div>
        <div class="invoice-date">Ngày: <fmt:formatDate value="${compensation.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div>
    </div>

    <!-- Invoice Body -->
    <div class="invoice-body">
        <!-- Success Message -->
        <div class="success-box">
            <strong>✅ Tạo phiếu bồi thường thành công!</strong><br>
        </div>

        <!-- Customer Information -->
        <div class="section">
            <h3 class="section-title">Thông tin khách hàng</h3>
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">Tên khách hàng</div>
                    <div class="info-value">${rental.customerName}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">CMND/CCCD</div>
                    <div class="info-value">${rental.customerIdCard}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Mã thuê</div>
                    <div class="info-value">#${rental.rentalId}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Ngày thuê</div>
                    <div class="info-value"><fmt:formatDate value="${rental.rentalDate}" pattern="dd/MM/yyyy"/></div>
                </div>
            </div>
        </div>

        <!-- Equipment Information -->
        <div class="section">
            <h3 class="section-title">Chi tiết dụng cụ</h3>
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">Tên dụng cụ</div>
                    <div class="info-value">${rental.itemName}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Số lượng</div>
                    <div class="info-value">${rental.quantity} cái</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Giá nhập (mỗi cái)</div>
                    <div class="info-value"><fmt:formatNumber value="${equipment.importPrice}" type="currency" currencyCode="VND"/></div>
                </div>
                <div class="info-item">
                    <div class="info-label">Danh mục</div>
                    <div class="info-value">${equipment.category}</div>
                </div>
            </div>
        </div>

        <!-- Compensation Details -->
        <div class="section">
            <h3 class="section-title">Chi tiết bồi thường</h3>
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">Loại bồi thường</div>
                    <div class="info-value">
                        <c:choose>
                            <c:when test="${compensation.compensationType == 'damaged'}">🔧 Dụng cụ bị hỏng</c:when>
                            <c:when test="${compensation.compensationType == 'lost'}">❌ Dụng cụ bị mất</c:when>
                            <c:when test="${compensation.compensationType == 'overdue_fee'}">⏰ Phí quá hạn</c:when>
                            <c:otherwise>${compensation.compensationType}</c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="info-item">
                    <div class="info-label">Tỷ lệ bồi thường</div>
                    <div class="info-value"><fmt:formatNumber value="${compensation.compensationRate}" type="percent"/></div>
                </div>
            </div>

            <div class="description-box">
                <div class="description-label">📝 Mô tả hư hỏng:</div>
                ${compensation.damageDescription}
            </div>
        </div>

        <!-- Calculation Breakdown -->
        <div class="section">
            <h3 class="section-title">Chi tiết tính toán</h3>
            <table class="calculation-table">
                <thead>
                <tr>
                    <th>Mô tả</th>
                    <th class="text-right">Số lượng</th>
                    <th class="text-right">Đơn giá</th>
                    <th class="text-right">Thành tiền</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>Giá nhập - ${rental.itemName}</td>
                    <td class="text-right">${rental.quantity}</td>
                    <td class="text-right"><fmt:formatNumber value="${equipment.importPrice}" type="currency" currencyCode="VND"/></td>
                    <td class="text-right"><fmt:formatNumber value="${compensation.importPriceTotal}" type="currency" currencyCode="VND"/></td>
                </tr>
                <tr>
                    <td>Tỷ lệ bồi thường áp dụng</td>
                    <td class="text-right">-</td>
                    <td class="text-right"><fmt:formatNumber value="${compensation.compensationRate}" type="percent"/></td>
                    <td class="text-right">-</td>
                </tr>
                <tr class="total-row">
                    <td colspan="3">Tổng số tiền bồi thường</td>
                    <td class="text-right"><fmt:formatNumber value="${compensation.totalAmount}" type="currency" currencyCode="VND"/></td>
                </tr>
                </tbody>
            </table>
        </div>

        <!-- Payment Information -->
        <div class="section">
            <h3 class="section-title">Thông tin thanh toán</h3>
            <div class="alert-box">
                <strong>⚠️ Yêu cầu thanh toán</strong><br>
                Tổng số tiền cần thanh toán: <strong><fmt:formatNumber value="${compensation.totalAmount}" type="currency" currencyCode="VND"/></strong><br>
                Vui lòng đến quầy thanh toán hoặc sử dụng các phương thức thanh toán bên dưới.
            </div>
        </div> <!-- 🛠️ THÊM THẺ ĐÓNG DIV Ở ĐÂY -->

        <!-- Footer Note -->
        <div class="footer-note">
            <p>Đây là hóa đơn được tạo bởi máy tính và không cần chữ ký.</p>
            <p>Để được hỗ trợ, vui lòng liên hệ: +84 123 456 789 | support@swimmingpool.com</p>
            <p>Cảm ơn quý khách đã hợp tác trong việc duy trì chất lượng dụng cụ của chúng tôi!</p>
        </div>
    </div>

    <!-- Action Buttons -->
    <div class="action-buttons">
        <button class="btn btn-primary" onclick="window.print()">
            🖨️ In hóa đơn
        </button>
        <%--        <a href="${pageContext.request.contextPath}/compensation?action=payment&compensationId=${compensation.compensationId}"--%>
        <%--           class="btn btn-success">--%>
        <%--            💳 Proceed to Payment--%>
        <%--        </a>--%>
        <!-- THÊM BACK TO RENTALS BUTTON: -->
        <a href="${pageContext.request.contextPath}/equipment?mode=rental"
           class="btn btn-success">
            🔙 Quay lại danh sách thuê
        </a>
<%--                <a href="${pageContext.request.contextPath}/compensation?action=view&id=${compensation.compensationId}"--%>
<%--                   class="btn btn-secondary">--%>
<%--                    📋 Xem thông tin--%>
<%--                </a>--%>
    </div>
</div>

<!-- Print-only footer -->
<div class="print-only" style="margin-top: 50px; text-align: center;">
    <p>-----------------------------------</p>
    <p>Chữ ký khách hàng</p>
    <br><br>
    <p>-----------------------------------</p>
    <p>Chữ ký nhân viên</p>
</div>

<script>
    // Auto-hide success message after 10 seconds
    setTimeout(function() {
        const successBox = document.querySelector('.success-box');
        if (successBox) {
            successBox.style.transition = 'opacity 0.5s';
            successBox.style.opacity = '0';
            setTimeout(() => successBox.style.display = 'none', 500);
        }
    }, 10000);

</script>
</body>
</html>
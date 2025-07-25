<%@ page import="model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Poolax - Lịch Sử Giao Dịch</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        html, body {
            height: 100%;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f8f9fa;
            color: #333;
            line-height: 1.6;
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
            color: white;
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
            color: white;
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
        .page-header {
            background: linear-gradient(135deg, #4a90e2 0%, #357abd 100%);
            color: white;
            padding: 100px 0 60px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        .page-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="20" cy="20" r="2" fill="rgba(255,255,255,0.1)"/><circle cx="80" cy="80" r="2" fill="rgba(255,255,255,0.1)"/></svg>');
        }
        .page-header h1 {
            font-size: 48px;
            font-weight: 700;
            margin-bottom: 10px;
        }
        .page-header p {
            font-size: 18px;
            opacity: 0.9;
        }
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 40px 20px;
        }
        .table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .table th {
            background: #f8f9fa;
            padding: 12px;
            text-align: left;
            font-weight: 600;
            border-bottom: 2px solid #dee2e6;
        }
        .table td {
            padding: 12px;
            border-bottom: 1px solid #f0f0f0;
        }
        .table tr:hover {
            background: #f8f9fa;
        }
        .transaction-type {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }
        .transaction-type.rental {
            background: #d4edda;
            color: #155724;
        }
        .transaction-type.sale {
            background: #e2e3e5;
            color: #383d41;
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
            .table {
                font-size: 14px;
            }
            .table th, .table td {
                padding: 8px;
            }
        }
    </style>
</head>
<body>
<%
    User user = (User) session.getAttribute("user");
%>


<div class="navbar">
    <div class="logo">Hồ Bơi</div>
    <div class="nav-links">
        <a href="staff_dashboard.jsp" class="nav-link">Trang Chủ</a>
        <a href="purchase" class="nav-link">Vé Bơi</a>
        <a href="equipment?mode=transaction_history" class="nav-link">📜 Lịch Sử Giao Dịch</a>
        <a href="equipment?mode=rental" class="nav-link ${empty currentFilter ? 'active' : ''}">
            🛒 Thuê Dụng Cụ
        </a>
        <a href="equipment?mode=buy" class="nav-link ${empty currentFilter ? 'active' : ''}">
            🛒 Mua Dụng Cụ
        </a>
        <a href="cart" class="nav-link">
            🛒 Xem Giỏ Hàng <span>(${not empty sessionScope.cart ? sessionScope.cart.items.size() : 0})</span>
        </a>
    </div>
    <div class="auth">
        <% if (user == null) { %>
        <a class="login-btn" href="login.jsp">Đăng Nhập</a>
        <a class="register-btn" href="register.jsp">Đăng Ký</a>
        <% } else { %>
        <span>Xin chào, <a href="userprofile" style="text-decoration:none; color:inherit;"><%= user.getFullName() %></a>!</span>
        <form action="logout" method="post" style="display:inline;">
            <input type="submit" value="Đăng Xuất">
        </form>
        <% } %>
    </div>
</div>

<div style="height: 70px;"></div>


<div class="page-header">
    <h1>Lịch Sử Giao Dịch</h1>
    <p>Xem 100 giao dịch thuê và bán gần đây nhất</p>
</div>


<div class="container">
    <c:if test="${not empty error}">
        <div class="message error">${error}</div>
    </c:if>


    <table class="table">
        <thead>
        <tr>
            <th>Mã</th>
            <th>Loại</th>
            <th>Dụng Cụ</th>
            <th>Khách Hàng</th>
            <th>Số Lượng</th>
            <th>Ngày</th>
            <th>Tổng Tiền</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="transaction" items="${transactions}">
            <tr>
                <td>#${transaction.id}</td>
                <td>
                    <span class="transaction-type ${transaction.type}">
                        <c:choose>
                            <c:when test="${transaction.type == 'rental'}">Thuê</c:when>
                            <c:when test="${transaction.type == 'sale'}">Bán</c:when>
                            <c:otherwise>${transaction.type}</c:otherwise>
                        </c:choose>
                    </span>
                </td>
                <td>${transaction.itemName}</td>
                <td>${transaction.customerName}</td>
                <td>${transaction.quantity}</td>
                <td><fmt:formatDate value="${transaction.transactionDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                <td><fmt:formatNumber value="${transaction.totalAmount}" type="currency" currencyCode="VND"/></td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>


<footer>
    <p>© 2025 Hồ Bơi. Tất cả quyền được bảo lưu.</p>
    <p>Liên hệ: contact@swimmingpool.com | +84 123 456 789</p>
</footer>
</body>
</html>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Shopping Cart</title>
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;600&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; }
        html, body {
            margin: 0;
            padding: 0;
            height: 100%;
            font-family: 'Quicksand', sans-serif;
        }
        .navbar {
            background: rgba(0, 92, 170, 0.9);
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 30px;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            z-index: 999;
            backdrop-filter: blur(4px);
        }
        .nav-links a, .auth a {
            color: white;
            text-decoration: none;
            margin: 0 10px;
            font-weight: 500;
        }
        .auth input[type="submit"] {
            background: white;
            color: #005caa;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
        }
        .bg-cover {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('https://images.pexels.com/photos/6437583/pexels-photo-6437583.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2') center/cover no-repeat;
            z-index: -1;
            filter: brightness(0.8);
        }
        .hero {
            background: transparent;
            height: 280px;
            display: flex;
            justify-content: center;
            align-items: center;
            color: white;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }
        .hero h1 { font-size: 36px; }
        .container {
            width: 90%;
            max-width: 850px;
            background: rgba(255, 255, 255, 0.95);
            margin: -80px auto 40px;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 12px 32px rgba(0,0,0,0.1);
            margin-bottom: 100px;
        }
        h2 {
            text-align: center;
            margin-bottom: 30px;
            color: #007bff;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: center;
        }
        .btn-remove, .btn-update {
            background: #dc3545;
            color: white;
            border: none;
            padding: 5px 10px;
            cursor: pointer;
            border-radius: 4px;
        }
        .btn-update {
            background: #ffc107;
            color: black;
        }
        .btn-checkout {
            background-color: #28a745;
            color: white;
            padding: 12px 30px;
            border: none;
            font-size: 16px;
            border-radius: 6px;
            cursor: pointer;
            transition: background 0.3s ease;
            margin-top: 20px;
            float: right;
        }
        .btn-checkout:hover { background-color: #218838; }
        .message {
            margin-top: 20px;
            font-weight: 500;
            max-width: 800px;
            margin-left: auto;
            margin-right: auto;
        }
        .success { color: green; }
        .error { color: red; }
        .footer {
            background-color: #002b5b;
            color: white;
            padding: 40px 20px;
            text-align: center;
        }
        .footer p {
            margin: 6px 0;
            font-size: 14px;
        }
        .footer a {
            color: #aad4ff;
            text-decoration: none;
        }
        .footer a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="bg-cover"></div>

<div class="navbar">
    <div class="logo">SwimmingPool</div>
    <div class="nav-links">
        <a href="staff_dashboard.jsp" class="nav-link">Home</a>
        <a href="purchase" class="nav-link">Vé Bơi</a>
        <a href="equipment?mode=transaction_history" class="nav-link">📜 Transaction History</a>
        <a href="equipment?mode=rental" class="nav-link ${empty currentFilter ? 'active' : ''}">
            🛒 Equipment Rental
        </a>
        <a href="equipment?mode=buy" class="nav-link ${empty currentFilter ? 'active' : ''}">
            🛒 Equipment Buy
        </a>
        <a href="cart" class="nav-link">
            🛒 View Cart <span>(${not empty sessionScope.cart ? sessionScope.cart.items.size() : 0})</span>
        </a>
    </div>
    <div class="auth">
        <span>Hello, <%= user.getFullName() %>!</span>
        <form action="logout" method="post">
            <input type="submit" value="Logout">
        </form>
    </div>
</div>

<div style="height: 80px;"></div>

<div class="hero">
    <h1>Your Shopping Cart</h1>
</div>

<div class="container">
    <h2>Cart Items</h2>

    <c:if test="${cart != null && !cart.isEmpty()}">
        <table>
            <thead>
            <tr>
                <th>Type</th>
                <th>Quantity</th>
                <th>Price</th>
                <th>Subtotal</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="item" items="${cart.items}" varStatus="status">
                <tr>
                    <td>
                        <c:choose>
                            <c:when test="${fn:startsWith(item.type, 'Ticket_')}">
                                Ticket: ${fn:replace(item.type, 'Ticket_', '')}
                            </c:when>
                            <c:when test="${item.type == 'EquipmentRental'}">
                                Equipment rental (${item.itemName})
                            </c:when>
                            <c:when test="${item.type == 'EquipmentBuy'}">
                                Equipment buy (${item.itemName})
                            </c:when>
                        </c:choose>
                    </td>
                    <td>
                        <form action="cart" method="post" style="display:flex; justify-content:center; align-items:center; gap:6px;">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="index" value="${status.index}">
                            <input type="number" name="newQty" value="${item.qty}" min="1" style="width: 60px;">
                            <button type="submit" class="btn-update">Update</button>
                        </form>
                    </td>
                    <td><fmt:formatNumber value="${item.price}" type="currency" currencyCode="VND"/></td>
                    <td><fmt:formatNumber value="${item.subtotal}" type="currency" currencyCode="VND"/></td>
                    <td>
                        <form action="cart" method="post">
                            <input type="hidden" name="action" value="remove">
                            <input type="hidden" name="index" value="${status.index}">
                            <button type="submit" class="btn-remove">Remove</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <!-- Checkout form -->
        <form action="payment" method="get">
            <input type="hidden" name="action" value="confirm">
            <input type="hidden" name="for" value="mixed">
            <button type="submit" class="btn-checkout">Checkout</button>
        </form>
    </c:if>

    <c:if test="${cart == null || cart.isEmpty()}">
        <c:choose>
            <c:when test="${lastMode == 'equipment_rental'}">
                <p>Giỏ hàng rỗng. <a href="equipment?mode=rental">Tiếp tục thuê thiết bị</a></p>
            </c:when>
            <c:when test="${lastMode == 'equipment_buy'}">
                <p>Giỏ hàng rỗng. <a href="equipment?mode=buy">Tiếp tục mua thiết bị</a></p>
            </c:when>
            <c:when test="${lastMode == 'ticket'}">
                <p>Giỏ hàng rỗng. <a href="ticketPurchase.jsp">Tiếp tục mua vé</a></p>
            </c:when>
            <c:otherwise>  <!-- Cho mixed hoặc không xác định -->
                <p>Giỏ hàng rỗng. Tiếp tục mua sắm:
                    <a href="ticketPurchase.jsp">Mua vé</a> |
                    <a href="equipment?mode=rental">Thuê thiết bị</a> |
                    <a href="equipment?mode=buy">Mua thiết bị</a>
                </p>
            </c:otherwise>
        </c:choose>
    </c:if>

    <div class="message">
        <c:if test="${success != null}"><p class="success">${success}</p></c:if>
        <c:if test="${error != null}"><p class="error">${error}</p></c:if>
    </div>
</div>

<div class="footer">
    <p>© 2025 SwimmingPool. All rights reserved.</p>
    <p>Contact us: contact@swimmingpool.com | +84 123 456 789</p>
</div>

</body>
</html>
<%@ page import="model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || user.getRole() == null || user.getRole().getId() != 5) {
        response.sendRedirect("error.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Mua Vé</title>
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
            margin-bottom: 100px; /* ✅ Đẩy nút lên khỏi footer */
        }
        h2 {
            text-align: center;
            margin-bottom: 30px;
            color: #007bff;
        }
        form table {
            width: 100%;
            max-width: 600px;
            margin: 0 auto;
            table-layout: auto;
            border-spacing: 0 16px;
        }
        th {
            background-color: #007bff;
            color: white;
            padding: 10px 14px;
            width: 180px;
            vertical-align: top;
            text-align: left;
            border-radius: 6px 0 0 6px;
        }
        td {
            padding: 10px 14px;
            vertical-align: middle;
        }
        td input, td select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        .btn {
            background-color: #007bff;
            color: white;
            padding: 12px 30px;
            border: none;
            font-size: 16px;
            border-radius: 6px;
            cursor: pointer;
            transition: background 0.3s ease;
            margin-top: 10px;
            float: right;
        }
        .btn:hover { background-color: #0056b3; }
        .message {
            margin-top: 20px;
            font-weight: 500;
            max-width: 800px;
            margin-left: auto;
            margin-right: auto;
            text-align: center;
        }
        .success { color: green; }
        .error { color: red; }
        .footer {
            background-color: #002b5b;
            color: white;
            padding: 40px 20px;
            text-align: center; /* 👉 căn giữa nội dung */
        }

        .footer p {
            margin: 6px 0;
            font-size: 14px;
        }
        .footer div {
            flex: 1 1 300px;
            padding: 10px;
        }
        .footer h4 {
            font-size: 18px;
            margin-bottom: 10px;
            color: #aad4ff;
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

        .cart-link {
            display: inline-block;
            background-color: #28a745;
            color: white;
            padding: 12px 30px;
            border-radius: 6px;
            text-decoration: none;
            margin-top: 20px;
            float: right;
        }
        .cart-link:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>

<div class="bg-cover"></div>

<div class="navbar">
    <div class="logo">Hồ Bơi</div>
    <div class="nav-links">
        <a href="staff_dashboard.jsp" class="nav-link">Trang chủ</a>
        <a href="purchase" class="nav-link">🎟️ Vé bơi</a>
        <a href="equipment?mode=rental" class="nav-link ${empty currentFilter ? 'active' : ''}">📦 Thuê thiết bị</a>
        <a href="equipment?mode=buy" class="nav-link ${empty currentFilter ? 'active' : ''}">🛍️ Mua thiết bị</a>
        <a href="cart" class="nav-link">
            🛒 Giỏ hàng <span>(${not empty sessionScope.cart ? sessionScope.cart.items.size() : 0})</span>
        </a>
    </div>
    <div class="auth">
        <span>Xin chào, <%= user.getFullName() %>!</span>
        <form action="logout" method="post">
            <input type="submit" value="Đăng xuất">
        </form>
    </div>
</div>

<div style="height: 80px;"></div>

<div class="hero">
    <h1>Mua vé bơi</h1>
</div>

<div class="container">
    <h2>Thông tin mua vé</h2>
    <form action="purchase" method="post" onsubmit="return validateForm()">
        <table>
            <tr>
                <th>Họ tên khách hàng</th>
                <td><input type="text" name="customerName" required placeholder="Nhập họ tên khách hàng"></td>
            </tr>
            <tr>
                <th>Số CMND/CCCD</th>
                <td><input type="text" name="customerIdCard" required placeholder="Nhập số giấy tờ tùy thân" maxlength="10" pattern="\d{10}" title="Số CMND/CCCD phải là 10 chữ số" onkeypress="return event.charCode >= 48 && event.charCode <= 57"></td>
            </tr>
            <tr>
                <th>Loại vé</th>
                <td>
                    <select name="ticketType" id="ticketType" onchange="updateEndDate()" required>
                        <option value="Single">Vé ngày (1 ngày)</option>
                        <option value="Monthly">Vé tháng (30 ngày)</option>
                        <option value="ThreeMonthly">Vé 3 tháng</option>
                        <option value="SixMonthly">Vé 6 tháng</option>
                        <option value="Year">Vé năm</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th>Số lượng</th>
                <td><input type="number" name="quantity" id="quantity" value="1" min="1" required></td>
            </tr>
            <tr>
                <th>Ngày bắt đầu</th>
                <td><input type="date" id="startDate" name="startDate" required readonly></td>
            </tr>
            <tr>
                <th>Ngày kết thúc</th>
                <td><input type="date" id="endDate" name="endDate" required readonly></td>
            </tr>
            <tr>
                <td colspan="2" style="text-align:right;">
                    <button type="submit" class="btn">Thêm vào giỏ hàng</button>
                </td>
            </tr>
        </table>
    </form>

    <div class="message">
        <c:if test="${sessionScope.success != null}">
            <p class="success">${sessionScope.success}</p>
            <c:remove var="success" scope="session" />
        </c:if>
        <c:if test="${error != null}">
            <p class="error">${error}</p>
        </c:if>
    </div>

    <a href="cart" class="cart-link">Xem giỏ hàng & Thanh toán</a>
</div>

<div class="footer">
    <p>© 2025 Hồ Bơi. Mọi quyền được bảo lưu.</p>
    <p>Liên hệ: contact@swimmingpool.com | +84 123 456 789</p>
</div>

<script>
    window.onload = function () {
        const startDateInput = document.getElementById("startDate");
        const today = new Date().toISOString().split("T")[0];
        startDateInput.value = today;
        updateEndDate();
    };
    function updateEndDate() {
        const ticketType = document.getElementById("ticketType").value;
        const startDate = new Date(document.getElementById("startDate").value);
        const endDateInput = document.getElementById("endDate");
        let daysToAdd = 0;
        switch (ticketType) {
            case "Single": daysToAdd = 1; break;
            case "Monthly": daysToAdd = 30; break;
            case "ThreeMonthly": daysToAdd = 90; break;
            case "SixMonthly": daysToAdd = 180; break;
            case "Year": daysToAdd = 365; break;
        }
        const endDate = new Date(startDate);
        endDate.setDate(endDate.getDate() + daysToAdd);
        endDateInput.value = endDate.toISOString().split("T")[0];
    }

    function validateForm() {
        const customerIdCard = document.querySelector('input[name="customerIdCard"]').value.trim();
        if (!/^\d{10}$/.test(customerIdCard)) {
            alert('Số CMND/CCCD phải là 10 chữ số.');
            return false;
        }
        return true;
    }
</script>
</body>
</html>
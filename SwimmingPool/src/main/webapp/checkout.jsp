<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Checkout</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: 'Inter', sans-serif;
            margin: 0;
            background-color: #ffffff;
        }

        /* ===== HEADER from homepage ===== */
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

        /* ===== CONTENT ===== */
        .container {
            max-width: 1140px;
            margin: 100px auto 40px;
            padding: 0 20px;
        }
        h2 {
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .checkout-box {
            display: flex;
            justify-content: space-between;
            gap: 40px;
        }
        .order-summary {
            flex: 0 0 65%;
        }
        .order-summary table {
            width: 100%;
            border-collapse: collapse;
        }
        .order-summary th, .order-summary td {
            padding: 12px;
            border: 1px solid #ccc;
            text-align: left;
        }
        .order-summary th {
            background-color: #007bff;
            color: white;
        }
        .order-summary img {
            width: 60px;
            height: auto;
        }
        .summary-total {
            margin-top: 20px;
            font-size: 18px;
            font-weight: bold;
        }
        .payment-methods {
            flex: 0 0 35%;
        }
        .payment-methods label {
            display: block;
            margin: 10px 0;
            font-weight: 500;
        }
        input[type="radio"] {
            margin-right: 10px;
        }
        .btn-submit {
            background-color: #007bff;
            color: white;
            padding: 12px 24px;
            font-size: 16px;
            border: none;
            border-radius: 4px;
            margin-top: 20px;
            cursor: pointer;
        }
        .btn-cancel {
            background-color: #dc3545;
            color: white;
            padding: 10px 20px;
            font-size: 14px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        /* ===== FOOTER from homepage ===== */
        footer {
            background: #003e73;
            color: white;
            padding: 30px 10%;
            text-align: center;
            position: fixed;
            bottom: 0;
            left: 0;
            width: 100%;
        }
        footer p {
            margin-bottom: 5px;
        }
    </style>
</head>
<body>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!-- HEADER NAVBAR -->
<div class="navbar">
    <div class="logo">SwimmingPool</div>
    <div class="nav-links">
        <a href="#">Home</a>
        <a href="#about">About Us</a>
        <a href="#services">Services</a>
        <a href="#gallery">Gallery</a>
        <a href="#contact">Contact</a>
    </div>
    <div class="auth">
        <span>Hello, <%= user.getFullName() %>!</span>
        <form action="logout" method="post">
            <input type="submit" value="Logout">
        </form>
    </div>
</div>

<!-- MAIN CONTENT -->
<div class="container">
    <h2>Your Order</h2>
    <div class="checkout-box">
        <div class="order-summary">
            <table>
                <tr>
                    <th>Image</th>
                    <th>Product Name</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Total</th>
                </tr>
                <tr>
                    <td><img src="https://www.bing.com/images/blob?bcid=S0WAaaJZJYUIJ0qvdQ0hatgQx7pRDEdrsis" alt="Ticket"></td>
                    <td>${ticket.ticketTypeName}</td>
                    <td>${ticket.price}đ</td>
                    <td>${ticket.quantity}</td>
                    <td>${ticket.total}đ</td>
                </tr>
            </table>
            <div class="summary-total">
                <p><strong>Total: ${ticket.total}đ</strong></p>
            </div>
        </div>
        <div class="payment-methods">
            <form action="checkout" method="post">
                <label><input type="radio" name="paymentMethod" value="bank" required> Direct Bank Transfer</label>
                <label><input type="radio" name="paymentMethod" value="cheque"> Cheque Payment</label>
                <label><input type="radio" name="paymentMethod" value="card"> Credit Card</label>
                <label><input type="radio" name="paymentMethod" value="paypal"> Paypal</label>
                <input type="hidden" name="action" value="confirm">
                <button type="submit" class="btn-submit">PLACE ORDER</button>
            </form>
            <form action="checkout" method="post" style="margin-top: 10px;">
                <input type="hidden" name="action" value="cancel">
                <button type="submit" class="btn-cancel">✖ CANCEL ORDER</button>
            </form>
        </div>
    </div>
</div>

<!-- FOOTER -->
<footer>
    <p>&copy; 2025 SwimmingPool. All rights reserved.</p>
    <p>Contact us: contact@swimmingpool.com | +84 123 456 789</p>
</footer>

</body>
</html>

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
  <title>Payment Confirm</title>
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
    <a href="home.jsp">Home</a>
    <a href="about">About Us</a>
    <a href="home.jsp">Services</a>
    <a href="gallery">Gallery</a>
    <a href="contact">Contact</a>
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
  <h1>Confirm Payment</h1>
</div>

<div class="container">
  <h2>Cart Summary</h2>

  <c:if test="${cart != null && !cart.isEmpty()}">
    <table>
      <tr>
        <th>Type</th>
        <th>Quantity</th>
        <th>Price</th>
        <th>Subtotal</th>
      </tr>
      <c:forEach var="item" items="${cart.items}">
        <tr>
          <td>${item.itemName}</td>
          <td>${item.qty}</td>
          <td><fmt:formatNumber value="${item.price}" type="currency" currencyCode="VND"/></td>
          <td><fmt:formatNumber value="${item.subtotal}" type="currency" currencyCode="VND"/></td>
        </tr>
      </c:forEach>
      <tr>
        <td colspan="3"><strong>Total</strong></td>
        <td><fmt:formatNumber value="${cart.total}" type="currency" currencyCode="VND"/></td>
      </tr>
    </table>

    <form action="payment" method="post">
      <input type="hidden" name="action" value="confirm">
      <input type="hidden" name="for" value="ticket">
      <table>
        <tr><th>Amount</th><td><input type="text" name="amount" value="${cart.total}" readonly></td></tr>
        <tr><th>Notes</th><td><textarea name="notes"></textarea></td></tr>
        <tr><td colspan="2" style="text-align:right;"><button type="submit" class="btn">Confirm Payment</button></td></tr>
      </table>
    </form>
  </c:if>

  <c:if test="${cart == null || cart.isEmpty()}">
    <p>Giỏ hàng rỗng. <a href="ticketPurchase.jsp">Tiếp tục mua vé</a></p>
  </c:if>

  <div class="message">
    <c:if test="${error != null}"><p class="error">${error}</p></c:if>
  </div>
</div>

<div class="footer">
  <p>© 2025 SwimmingPool. All rights reserved.</p>
  <p>Contact us: contact@swimmingpool.com | +84 123 456 789</p>
</div>

<script>
  // Nếu cần JS, thêm ở đây (hiện không có trong cart.jsp, nên bỏ nếu không cần)
</script>

</body>
</html>
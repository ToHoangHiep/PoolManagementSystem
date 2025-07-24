<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Đăng ký tài khoản nhân viên</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f4f4;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      margin: 0;
    }
    .container {
      background-color: white;
      padding: 30px;
      border-radius: 8px;
      box-shadow: 0 0 15px rgba(0,0,0,0.1);
      width: 100%;
      max-width: 450px;
      text-align: center;
    }
    h2 {
      color: #333;
      margin-bottom: 25px;
    }
    .form-group {
      margin-bottom: 15px;
      text-align: left;
    }
    label {
      display: block;
      margin-bottom: 5px;
      font-weight: bold;
      color: #555;
    }
    input[type="email"],
    input[type="password"] {
      width: calc(100% - 22px);
      padding: 10px;
      border: 1px solid #ced4da;
      border-radius: 4px;
      font-size: 16px;
    }
    button {
      width: 100%;
      padding: 12px;
      background-color: #007bff;
      color: white;
      border: none;
      border-radius: 5px;
      font-size: 18px;
      cursor: pointer;
      transition: background-color 0.2s;
      margin-top: 20px;
    }
    button:hover {
      background-color: #0056b3;
    }
    .message {
      margin-top: 20px;
      padding: 10px;
      border-radius: 5px;
      font-weight: bold;
    }
    .error-message {
      color: red;
      background-color: #ffebe8;
      border: 1px solid red;
    }
    .success-message {
      color: green;
      background-color: #e8ffe8;
      border: 1px solid green;
    }
    .back-link {
      display: inline-block;
      margin-top: 20px;
      color: #007bff;
      text-decoration: none;
      font-weight: bold;
    }
    .back-link:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>
<div class="container">
  <h2>Đăng ký tài khoản nhân viên</h2>

  <c:if test="${not empty errorMessage}">
    <p class="message error-message">${errorMessage}</p>
  </c:if>
  <c:if test="${not empty successMessage}">
    <p class="message success-message">${successMessage}</p>
    <% session.removeAttribute("successMessage"); %> <%-- Xóa message sau khi hiển thị --%>
  </c:if>

  <form action="staff-registration" method="post">
    <div class="form-group">
      <label for="email">Email:</label>
      <input type="email" id="email" name="email" value="${email}" required>
    </div>
    <div class="form-group">
      <label for="password">Mật khẩu:</label>
      <input type="password" id="password" name="password" required>
    </div>
    <div class="form-group">
      <label for="confirmPassword">Xác nhận mật khẩu:</label>
      <input type="password" id="confirmPassword" name="confirmPassword" required>
    </div>
    <button type="submit">Đăng ký</button>
  </form>
  <a href="admin_dashboard.jsp" class="back-link">Quay lại trang quản lý</a> <%-- Hoặc manager_dashboard.jsp --%>
</div>
</body>
</html>

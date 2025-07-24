<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %> <%-- Import Calendar for date comparison --%>
<%
  User user = (User) session.getAttribute("user");
  if (user == null || user.getRole() == null || user.getRole().getId() != 5) {
    response.sendRedirect("login.jsp"); // Nếu không phải staff hoặc chưa đăng nhập, chuyển hướng
    return;
  }
  // Định dạng ngày sinh nếu đã có
  String dobString = "";
  if (user.getDob() != null) {
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    dobString = sdf.format(user.getDob());
  }
  request.setAttribute("dobString", dobString);

  // Lấy ngày hiện tại để đặt max attribute cho input date
  SimpleDateFormat sdfForMaxDate = new SimpleDateFormat("yyyy-MM-dd");
  String maxDate = sdfForMaxDate.format(new Date()); // Ngày hiện tại
  request.setAttribute("maxDate", maxDate);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Hoàn thiện hồ sơ nhân viên</title>
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
      max-width: 500px;
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
    input[type="text"],
    input[type="email"],
    input[type="date"],
    input[type="password"], /* Thêm kiểu password */
    select {
      width: calc(100% - 22px);
      padding: 10px;
      border: 1px solid #ced4da;
      border-radius: 4px;
      font-size: 16px;
    }
    button {
      width: 100%;
      padding: 12px;
      background-color: #28a745;
      color: white;
      border: none;
      border-radius: 5px;
      font-size: 18px;
      cursor: pointer;
      transition: background-color 0.2s;
      margin-top: 20px;
    }
    button:hover {
      background-color: #218838;
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
    .info-message {
      color: #007bff;
      background-color: #e0f2ff;
      border: 1px solid #007bff;
    }
    .back-to-login { /* Style for the new button */
      display: inline-block;
      margin-top: 15px;
      padding: 10px 20px;
      background-color: #6c757d;
      color: white;
      border-radius: 5px;
      text-decoration: none;
      font-weight: bold;
      transition: background-color 0.2s;
    }
    .back-to-login:hover {
      background-color: #5a6268;
    }
  </style>
</head>
<body>
<div class="container">
  <h2>Hoàn thiện hồ sơ nhân viên</h2>
  <p class="message info-message">Chào mừng bạn! Vui lòng hoàn thiện thông tin cá nhân và đặt mật khẩu mới để bắt đầu.</p>

  <c:if test="${not empty errorMessage}">
    <p class="message error-message">${errorMessage}</p>
  </c:if>

  <form action="staff-profile-setup" method="post">
    <div class="form-group">
      <label for="email">Email:</label>
      <input type="email" id="email" name="email" value="${user.email}" readonly>
    </div>
    <div class="form-group">
      <label for="fullName">Họ và tên:</label>
      <input type="text" id="fullName" name="fullName" value="${user.fullName != null ? user.fullName : ''}" required>
    </div>
    <div class="form-group">
      <label for="phoneNumber">Số điện thoại:</label>
      <%-- Regex cho 10 hoặc 11 chữ số --%>
      <input type="text" id="phoneNumber" name="phoneNumber" value="${user.phoneNumber != null ? user.phoneNumber : ''}"
             pattern="^\d{10,11}$" title="Số điện thoại phải có 10 hoặc 11 chữ số." required>
    </div>
    <div class="form-group">
      <label for="address">Địa chỉ:</label>
      <input type="text" id="address" name="address" value="${user.address != null ? user.address : ''}" required>
    </div>
    <div class="form-group">
      <label for="dob">Ngày sinh:</label>
      <%-- Thêm thuộc tính max để ngăn chọn ngày trong tương lai --%>
      <input type="date" id="dob" name="dob" value="${dobString}" max="${maxDate}" required>
    </div>
    <div class="form-group">
      <label for="gender">Giới tính:</label>
      <select id="gender" name="gender" required>
        <option value="">Chọn giới tính</option>
        <option value="Male" ${user.gender eq 'Male' ? 'selected' : ''}>Nam</option>
        <option value="Female" ${user.gender eq 'Female' ? 'selected' : ''}>Nữ</option>
        <option value="Other" ${user.gender eq 'Other' ? 'selected' : ''}>Khác</option>
      </select>
    </div>

    <div class="form-group">
      <label for="newPassword">Mật khẩu mới:</label>
      <%-- Regex cho mật khẩu: ít nhất 6 ký tự, loại bỏ yêu cầu phức tạp --%>
      <input type="password" id="newPassword" name="newPassword"
             pattern="^.{6,}$"
             title="Mật khẩu mới phải có ít nhất 6 ký tự." required>
    </div>
    <div class="form-group">
      <label for="confirmNewPassword">Xác nhận mật khẩu mới:</label>
      <input type="password" id="confirmNewPassword" name="confirmNewPassword" required>
    </div>

    <button type="submit">Hoàn tất hồ sơ</button>
  </form>
  <%-- Nút quay lại trang đăng nhập --%>
  <a href="login.jsp" class="back-to-login">Quay lại trang đăng nhập</a>
</div>
</body>
</html>

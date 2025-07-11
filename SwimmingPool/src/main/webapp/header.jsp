<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>
<%
  User user = (User) session.getAttribute("user");
%>

<%-- Nếu là khách hoặc customer thì hiển thị header --%>
<%
  if (user == null || user.getRole().getId() == 3) {
%>
<div class="navbar">
  <div class="logo">Swimming Pool</div>
  <div class="nav-links">
    <a href="home.jsp">Trang chủ</a>
    <a href="#about">Về chúng tôi</a>
    <a href="#services">Dịch vụ</a>
    <a href="courses">Khóa học</a>
    <a href="#contact">Liên hệ</a>
    <a href="blogs">Bài viết</a>
  </div>

  <div class="auth">
    <% if (user == null) { %>
    <a class="login-btn" href="login.jsp">Đăng nhập</a>
    <a class="register-btn" href="register.jsp">Đăng ký</a>
    <% } else { %>
    <span>Xin chào, <a href="userprofile" style="text-decoration:none; color:inherit;">
        <%= user.getFullName() %></a>!</span>
    <form action="logout" method="post" style="display:inline;">
      <input type="submit" value="Đăng xuất">
    </form>
    <% } %>
  </div>
</div>

<!-- CSS for Navbar -->
<style>
  .navbar {
    display: flex;
    justify-content: space-between;
    background-color: #005caa;
    padding: 10px 20px;
    align-items: center;
    color: white;
  }
  .nav-links a {
    color: white;
    padding: 8px 14px;
    text-decoration: none;
    font-weight: bold;
  }
  .auth a {
    color: white;
    margin-left: 10px;
    text-decoration: none;
  }
</style>

<!-- Spacer tránh che nội dung -->
<div style="height: 70px;"></div>
<%
  } // đóng if
%>

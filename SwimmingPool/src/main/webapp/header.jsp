<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>
<%
  User user = (User) session.getAttribute("user");
%>
<!-- Navbar -->
<meta charset="UTF-8">
<div class="navbar">
  <div class="logo">SwimmingPool</div>
  <div class="nav-links">
    <a href="home.jsp">Home</a>
    <a href="#about">About Us</a>
    <a href="#services">Services</a>
    <a href="courses">Khóa học</a>
    <%-- Chỉ hiện nếu là Staff --%>
    <% if (user != null && user.getRole() != null && "staff".equalsIgnoreCase(user.getRole().getName())) { %>
    <a href="equipment-rental">Equipment Rental</a>
    <% } %>

    <% if (user != null && user.getRole() != null) {
      String roleName = user.getRole().getName();
      if ("Admin".equalsIgnoreCase(roleName) || "Manager".equalsIgnoreCase(roleName)) {
    %>
    <a href="maintenance">Maintenance</a>
    <% }} %>

    <%-- View My Maintenance nếu role = 5 (Staff) --%>
    <% if (user != null && user.getRole() != null && user.getRole().getId() == 5) { %>
    <a href="viewMyMaintenance">View My Maintenance</a>
    <% } %>

    <a href="#contact">Contact</a>
    <a href="blogs">Blogs</a>

    <%-- Admin có quyền xem danh sách người dùng --%>
    <% if (user != null && user.getRole() != null && "Admin".equalsIgnoreCase(user.getRole().getName())) { %>
    <a href="admin-user">User List</a>
    <% } %>
  </div>

  <div class="auth">
    <% if (user == null) { %>
    <a class="login-btn" href="login.jsp">Login</a>
    <a class="register-btn" href="register.jsp">Register</a>
    <% } else { %>
    <span>Hello, <a href="userprofile" style="text-decoration:none; color:inherit;">
                <%= user.getFullName() %></a>!</span>
    <form action="logout" method="post" style="display:inline;">
      <input type="submit" value="Logout">
    </form>
    <% } %>
  </div>
</div>

<!-- Spacer tránh bị che bởi navbar cố định -->
<div style="height: 70px;"></div>

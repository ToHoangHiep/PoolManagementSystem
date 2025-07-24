<%@ page import="model.User" %>
<%
  User user = (User) session.getAttribute("user");
%>
<!-- Navbar -->
<div class="navbar">
  <div class="logo">SwimmingPool</div>
  <div class="nav-links">
    <a href="home.jsp">Home</a>
    <a href="#about">About Us</a>
    <a href="#services">Services</a>

      <%-- Chỉ hiện dropdown Equipment Service nếu là Staff và role id = 5 --%>
      <% if (user != null && user.getRole() != null && "staff".equalsIgnoreCase(user.getRole().getName()) && user.getRole().getId() == 5) { %>
      <div class="dropdown">
          <a href="#" class="dropbtn">Equipment Service</a>
          <div class="dropdown-content">
              <a href="${pageContext.request.contextPath}/equipment?mode=rental">Rental</a>
              <a href="${pageContext.request.contextPath}/equipment?mode=buy">Buy</a>
          </div>
      </div>
      <% } %>

    <% if (user != null && user.getRole() != null) {
      String roleName = user.getRole().getName();
      if ("Admin".equalsIgnoreCase(roleName) || "Manager".equalsIgnoreCase(roleName)) {
    %>
    <a href="maintenance">Maintenance</a>
    <a href="inventory">InventorySetting</a>
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

<style>
    /* CSS for Dropdown (hover to show submenu) */
    .dropdown {
        position: relative;
        display: inline-block;
    }

    .dropbtn {
        color: white;
        text-decoration: none;
        margin: 0 15px;
        font-weight: 500;
    }

    .dropdown-content {
        display: none;
        position: absolute;
        background-color: #f9f9f9;
        min-width: 160px;
        box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
        z-index: 1;
    }

    .dropdown-content a {
        color: black;
        padding: 12px 16px;
        text-decoration: none;
        display: block;
    }

    .dropdown-content a:hover {
        background-color: #f1f1f1;
    }

    .dropdown:hover .dropdown-content {
        display: block;
    }

    .dropdown:hover .dropbtn {
        background-color: #3e8e41;  /* Màu hover tùy chỉnh */
    }
</style>

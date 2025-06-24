<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, model.Role, java.util.List" %>
<%
  User user = (User) session.getAttribute("user");
  List<User> users = (List<User>) request.getAttribute("users");
  List<Role> roles = (List<Role>) request.getAttribute("roles");

  String nameFilter = request.getParameter("name") == null ? "" : request.getParameter("name");
  String statusFilter = request.getParameter("status") == null ? "" : request.getParameter("status");
  String roleFilter = request.getParameter("role") == null ? "" : request.getParameter("role");
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>User Management</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background: #f4f7f9;
      margin: 0;
    }

    .navbar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      background: #005caa;
      color: white;
      padding: 15px 30px;
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

    .container {
      padding: 30px;
    }

    h1 {
      color: #005caa;
      text-align: center;
      margin-bottom: 20px;
    }

    .filter-form {
      text-align: center;
      margin-bottom: 20px;
    }

    .filter-form input,
    .filter-form select {
      padding: 6px 10px;
      margin: 5px;
      border: 1px solid #ccc;
      border-radius: 4px;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      background: white;
    }

    th, td {
      padding: 10px;
      border: 1px solid #ddd;
      text-align: center;
    }

    th {
      background-color: #005caa;
      color: white;
    }

    tr:hover {
      background-color: #f1f1f1;
    }

    a {
      color: #005caa;
      text-decoration: none;
    }

    a:hover {
      text-decoration: underline;
    }

    .auth {
      display: flex;
      gap: 15px;
      align-items: center;
    }

    .auth form input {
      padding: 6px 10px;
      cursor: pointer;
    }
  </style>
</head>
<body>

<!-- Navbar -->
<div class="navbar">
  <div class="nav-links">
    <a href="home.jsp">Home</a>
    <% if (user != null && user.getRole() != null && "Admin".equalsIgnoreCase(user.getRole().getName())) { %>
    <a href="admin-user">User List</a>
    <% } %>
  </div>

  <div class="auth">
    <% if (user != null) { %>
    Hello, <strong><%= user.getFullName() %></strong>
    <form action="logout" method="post">
      <input type="submit" value="Logout" />
    </form>
    <% } %>
  </div>
</div>

<!-- Main Content -->
<div class="container">
  <h1>User Management</h1>

  <!-- Filter Form -->
  <form method="get" action="admin-user" class="filter-form">
    Name: <input type="text" name="name" value="<%= nameFilter %>" />

    Status:
    <select name="status">
      <option value="">All</option>
      <option value="Active" <%= "Active".equals(statusFilter) ? "selected" : "" %>>Active</option>
      <option value="Inactive" <%= "Inactive".equals(statusFilter) ? "selected" : "" %>>Inactive</option>
    </select>

    Role:
    <select name="role">
      <option value="">All</option>
      <% for (Role r : roles) { %>
      <option value="<%= r.getId() %>" <%= (r.getId() + "").equals(roleFilter) ? "selected" : "" %>>
        <%= r.getName() %>
      </option>
      <% } %>
    </select>

    <input type="submit" value="Filter" />
  </form>

  <!-- User Table -->
  <table>
    <thead>
    <tr>
      <th>ID</th>
      <th>Full Name</th>
      <th>Email</th>
      <th>Status</th>
      <th>Role</th>
      <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <% if (users != null && !users.isEmpty()) {
      for (User u : users) { %>
    <tr>
      <td><%= u.getId() %></td>
      <td><%= u.getFullName() %></td>
      <td><%= u.getEmail() %></td>
      <td><%= u.getUserStatus() %></td>
      <td><%= u.getRole().getName() %></td>
      <td>
        <a href="edit-user?id=<%= u.getId() %>">Edit</a> |
        <a href="delete-user?id=<%= u.getId() %>" onclick="return confirm('Are you sure?')">Delete</a>
      </td>
    </tr>
    <% } } else { %>
    <tr><td colspan="6">No users found.</td></tr>
    <% } %>
    </tbody>
  </table>
</div>

</body>
</html>

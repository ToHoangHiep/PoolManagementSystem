<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, model.Role, java.util.List" %>
<%
  User user = (User) session.getAttribute("user");
  // Lấy thông tin người dùng đã đăng nhập từ session

  List<User> users = (List<User>) request.getAttribute("users");
  // Lấy danh sách người dùng từ request (được set từ servlet)

  List<Role> roles = (List<Role>) request.getAttribute("roles");
  // Lấy danh sách vai trò từ request (được set từ servlet)

  String nameFilter = request.getParameter("name") == null ? "" : request.getParameter("name");
  // Lấy giá trị lọc theo tên từ URL, nếu null thì gán chuỗi rỗng

  String statusFilter = request.getParameter("status") == null ? "" : request.getParameter("status");
  // Lấy giá trị lọc theo trạng thái từ URL, nếu null thì gán chuỗi rỗng

  String roleFilter = request.getParameter("role") == null ? "" : request.getParameter("role");
  // Lấy giá trị lọc theo vai trò từ URL, nếu null thì gán chuỗi rỗng
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
<!-- Thanh điều hướng navbar -->
<div class="navbar">
  <div class="nav-links">
    <a href="admin_dashboard.jsp">Home</a>
    <% if (user != null && user.getRole() != null && "Admin".equalsIgnoreCase(user.getRole().getName())) { %>
    <!-- Nếu user là Admin thì hiển thị liên kết đến trang danh sách người dùng -->
    <a href="admin-user">User List</a>
    <% } %>
  </div>

  <div class="auth">
    <% if (user != null) { %>
    <!-- Nếu đã đăng nhập thì hiển thị tên người dùng và nút Logout -->
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
    <!-- Form gửi bằng GET tới servlet /admin-user để lọc danh sách -->

    Name:
    <input type="text" name="name" value="<%= nameFilter %>" />
    <!-- Ô nhập tên để lọc, giữ lại giá trị sau khi submit bằng nameFilter -->

    Status:
    <select name="status">
      <option value="">All</option>
      <!-- Tùy chọn lọc tất cả trạng thái -->
      <option value="Active" <%= "Active".equals(statusFilter) ? "selected" : "" %>>Active</option>
      <!-- Nếu đang chọn Active thì thêm selected -->
      <option value="Inactive" <%= "Inactive".equals(statusFilter) ? "selected" : "" %>>Inactive</option>
      <!-- Nếu đang chọn Inactive thì thêm selected -->
    </select>

    Role:
    <select name="role">
      <option value="">All</option>
      <!-- Tùy chọn lọc tất cả vai trò -->
      <% for (Role r : roles) { %>
      <!-- Lặp qua danh sách vai trò -->
      <option value="<%= r.getId() %>" <%= (r.getId() + "").equals(roleFilter) ? "selected" : "" %>>
        <!-- Nếu vai trò hiện tại khớp với roleFilter thì chọn -->
        <%= r.getName() %>
        <!-- Hiển thị tên vai trò -->
      </option>
      <% } %>
    </select>

    <input type="submit" value="Filter" />
    <!-- Nút gửi form để thực hiện lọc -->
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
      // Nếu danh sách users không rỗng thì lặp hiển thị từng user
      for (User u : users) { %>
    <tr>
      <td><%= u.getId() %></td>  <!-- Hiển thị ID người dùng -->
      <td><%= u.getFullName() %></td>  <!-- Hiển thị họ tên -->
      <td><%= u.getEmail() %></td>  <!-- Hiển thị email -->
      <td><%= u.getUserStatus() %></td>  <!-- Hiển thị trạng thái -->
      <td><%= u.getRole().getName() %></td>  <!-- Hiển thị tên vai trò -->

      <td>
        <!-- Liên kết chỉnh sửa và xoá user -->
        <a href="edit-user?id=<%= u.getId() %>">Edit</a> |
        <a href="delete-user?id=<%= u.getId() %>" onclick="return confirm('Are you sure?')">Delete</a>
        <!-- Khi bấm Delete sẽ có hộp thoại xác nhận -->
      </td>
    </tr>
    <% } } else { %>
    <!-- Nếu danh sách users rỗng thì hiển thị thông báo -->
    <tr><td colspan="6">No users found.</td></tr>
    <% } %>

    </tbody>
  </table>
</div>


</body>
</html>

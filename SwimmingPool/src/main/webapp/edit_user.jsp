<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, model.Role, java.util.List" %>
<%
  User u = (User) request.getAttribute("user");
  List<Role> roles = (List<Role>) request.getAttribute("roles");
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Edit User</title>
  <style>
    body {
      font-family: 'Segoe UI', sans-serif;
      background-color: #e6f0fa;
      margin: 0;
      padding: 40px;
    }

    .form-container {
      max-width: 500px;
      margin: auto;
      background-color: #ffffff;
      padding: 30px 40px;
      border-radius: 12px;
      box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
    }

    h2 {
      text-align: center;
      color: #0073e6;
      margin-bottom: 25px;
    }

    label {
      display: block;
      margin-top: 20px;
      font-weight: 600;
      color: #333333;
    }

    select, input[type="submit"] {
      width: 100%;
      padding: 10px 12px;
      margin-top: 8px;
      border: 1px solid #cccccc;
      border-radius: 6px;
      font-size: 14px;
    }

    input[type="submit"] {
      background-color: #0073e6;
      color: #ffffff;
      font-weight: bold;
      cursor: pointer;
      margin-top: 25px;
      transition: background-color 0.3s ease;
    }

    input[type="submit"]:hover {
      background-color: #005bb5;
    }

    .back-link {
      text-align: center;
      margin-top: 25px;
    }

    .back-link a {
      color: #0073e6;
      text-decoration: none;
      font-weight: bold;
    }

    .back-link a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>
<div class="form-container">
  <h2>Edit User</h2>
  <form method="post" action="edit-user">
    <input type="hidden" name="id" value="<%= u.getId() %>" />

    <label for="role">Role:</label>
    <select name="roleId" id="role">
      <% for (Role r : roles) { %>
      <option value="<%= r.getId() %>" <%= r.getId() == u.getRole().getId() ? "selected" : "" %>>
        <%= r.getName() %>
      </option>
      <% } %>
    </select>

    <label for="status">Status:</label>
    <select name="status" id="status">
      <option value="Active" <%= "Active".equalsIgnoreCase(u.getUserStatus()) ? "selected" : "" %>>Active</option>
      <option value="Banned" <%= "Banned".equalsIgnoreCase(u.getUserStatus()) ? "selected" : "" %>>Banned</option>
    </select>

    <input type="submit" value="Update" />
  </form>

  <div class="back-link">
    <a href="admin-user">← Back to User List</a>
  </div>
</div>
</body>
</html>

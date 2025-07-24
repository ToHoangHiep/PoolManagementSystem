<%@ page import="model.User" %>
<%@ page import="model.PoolArea" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  User user = (User) session.getAttribute("user");
  List<PoolArea> poolAreas = (List<PoolArea>) request.getAttribute("poolAreas");
  String error = (String) request.getAttribute("error");
  String success = (String) request.getAttribute("success");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Pool Area Management</title>
  <style>
    body {
      margin: 0;
      padding: 0;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: linear-gradient(to right, #e0f7fa, #ffffff);
    }

    .container {
      background-color: #ffffff;
      padding: 30px;
      max-width: 960px;
      margin: 50px auto;
      border-radius: 12px;
      box-shadow: 0 8px 16px rgba(0,0,0,0.1);
      transition: all 0.3s ease-in-out;
    }

    h2 {
      text-align: center;
      color: #0077b6;
      font-size: 28px;
      margin-bottom: 25px;
    }

    h3 {
      color: #0077b6;
      margin-bottom: 15px;
    }

    .message {
      text-align: center;
      font-weight: 600;
      padding: 10px 15px;
      border-radius: 6px;
      margin-bottom: 15px;
    }

    .message.error {
      color: #b00020;
      background-color: #ffe5e5;
    }

    .message.success {
      color: #2e7d32;
      background-color: #e8f5e9;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      background-color: #f9f9f9;
      border-radius: 6px;
      overflow: hidden;
    }

    th, td {
      padding: 12px 10px;
      border-bottom: 1px solid #ddd;
      text-align: center;
    }

    th {
      background-color: #0077b6;
      color: white;
      font-weight: bold;
    }

    tr:hover {
      background-color: #f1f1f1;
    }

    form.inline {
      display: inline;
    }

    .form-section {
      margin-top: 40px;
      text-align: center;
    }

    .form-row {
      display: flex;
      justify-content: center;
      align-items: flex-start;
      flex-wrap: wrap;
      gap: 15px;
      margin-bottom: 20px;
    }

    input[type="text"], textarea {
      padding: 10px;
      width: 280px;
      border: 1px solid #ccc;
      border-radius: 8px;
      box-shadow: inset 1px 1px 3px rgba(0,0,0,0.05);
      transition: border 0.2s;
    }

    input[type="text"]:focus, textarea:focus {
      border-color: #0077b6;
      outline: none;
    }

    textarea {
      height: 70px;
      resize: vertical;
    }

    input[type="submit"] {
      padding: 10px 22px;
      background-color: #0077b6;
      color: white;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-weight: bold;
      transition: background-color 0.3s ease;
    }

    input[type="submit"]:hover {
      background-color: #005b8e;
    }

    .back-link {
      margin-top: 25px;
      text-align: center;
    }

    .back-link a {
      color: #0077b6;
      font-weight: 600;
      text-decoration: none;
    }

    .back-link a:hover {
      text-decoration: underline;
    }
  </style>

</head>
<body>
<div class="container">
  <h2>Manage Pool Areas</h2>

  <% if (error != null) { %>
  <div class="message error"><%= error %></div>
  <% } %>
  <% if (success != null) { %>
  <div class="message success"><%= success %></div>
  <% } %>

  <table>
    <thead>
    <tr>
      <th>ID</th>
      <th>Pool Name</th>
      <th>Description</th>
      <th>Action</th>
    </tr>
    </thead>
    <tbody>
    <% if (poolAreas != null && !poolAreas.isEmpty()) {
      for (PoolArea area : poolAreas) { %>
    <tr>
      <td><%= area.getId() %></td>
      <td><%= area.getName() %></td>
      <td><%= area.getDescription() %></td>
      <td>
        <form class="inline" method="post" action="pool-area" onsubmit="return confirm('Confirm delete this pool area?');">
          <input type="hidden" name="action" value="delete">
          <input type="hidden" name="id" value="<%= area.getId() %>">
          <input type="submit" value="Delete">
        </form>
      </td>
    </tr>
    <% }} else { %>
    <tr>
      <td colspan="4">No pool areas found.</td>
    </tr>
    <% } %>
    </tbody>
  </table>

  <div class="form-section">
    <h3>Add New Pool Area</h3>
    <form method="post" action="pool-area">
      <input type="hidden" name="action" value="add">
      <div class="form-row">
        <input type="text" name="name" placeholder="Pool Area Name" required>
        <textarea name="description" placeholder="Description" required></textarea>
        <input type="submit" value="Add">
      </div>
    </form>
  </div>

  <div class="back-link">
    <a href="admin_dashboard.jsp">← Back to Home</a>
  </div>
</div>
</body>
</html>

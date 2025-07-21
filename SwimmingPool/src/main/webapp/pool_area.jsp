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
      font-family: 'Segoe UI', sans-serif;
      margin: 0;
      background: url('https://images.pexels.com/photos/261102/pexels-photo-261102.jpeg') no-repeat center center;
      background-size: cover;
    }

    .container {
      background-color: rgba(255,255,255,0.95);
      padding: 30px;
      max-width: 1000px;
      margin: 50px auto;
      border-radius: 8px;
    }

    h2 {
      text-align: center;
      color: #005caa;
      margin-bottom: 20px;
    }

    .message {
      text-align: center;
      font-weight: bold;
      margin: 10px;
    }

    .message.error {
      color: red;
    }

    .message.success {
      color: green;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      background-color: #fff;
    }

    th, td {
      border: 1px solid #ccc;
      padding: 10px;
      text-align: center;
    }

    th {
      background-color: #005caa;
      color: white;
    }

    form.inline {
      display: inline;
    }

    .form-section {
      margin-top: 30px;
      text-align: center;
    }

    .form-row {
      display: flex;
      justify-content: center;
      align-items: center;
      flex-wrap: wrap;
      gap: 10px;
      margin-bottom: 10px;
    }

    input[type="text"], textarea {
      padding: 8px;
      width: 300px;
      border: 1px solid #ccc;
      border-radius: 5px;
    }

    textarea {
      resize: vertical;
      height: 60px;
    }

    input[type="submit"] {
      padding: 8px 20px;
      background-color: #005caa;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
    }

    input[type="submit"]:hover {
      background-color: #004080;
    }

    .back-link {
      margin-top: 20px;
      text-align: center;
    }

    .back-link a {
      color: #005caa;
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
    <a href="home.jsp">← Back to Home</a>
  </div>
</div>
</body>
</html>

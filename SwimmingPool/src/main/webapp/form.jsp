<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.Inventory" %>
<%
  Inventory inv = (Inventory) request.getAttribute("inventory");
  String action = (inv != null) ? "update" : "insert";
%>
<html>
<head>
  <title><%= inv != null ? "Cập nhật thiết bị" : "Thêm thiết bị mới" %></title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f6f8;
      padding: 40px;
    }

    h2 {
      color: #333;
    }

    form {
      background-color: #fff;
      padding: 25px;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
      max-width: 500px;
      margin: auto;
    }

    label {
      display: block;
      margin-bottom: 6px;
      font-weight: bold;
    }

    input[type="text"],
    input[type="number"],
    select {
      width: 100%;
      padding: 10px;
      margin-bottom: 16px;
      border: 1px solid #ccc;
      border-radius: 4px;
    }

    input[type="submit"] {
      background-color: #4CAF50;
      color: white;
      padding: 10px 20px;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      margin-right: 10px;
    }

    input[type="submit"]:hover {
      background-color: #45a049;
    }

    a {
      text-decoration: none;
      color: #2196F3;
      font-weight: bold;
    }

    a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>
<h2 style="text-align: center;"><%= inv != null ? "Cập nhật thiết bị" : "Thêm thiết bị mới" %></h2>
<form action="inventory" method="post">
  <input type="hidden" name="action" value="<%= action %>"/>
  <% if (inv != null) { %>
  <input type="hidden" name="id" value="<%= inv.getInventoryId() %>"/>
  <% } %>

  <label>Manager ID:</label>
  <input type="number" name="manager_id" value="<%= inv != null ? inv.getManagerId() : "" %>" required/>

  <label>Tên thiết bị:</label>
  <input type="text" name="item_name" value="<%= inv != null ? inv.getItemName() : "" %>" required/>

  <label>Loại:</label>
  <input type="text" name="category" value="<%= inv != null ? inv.getCategory() : "" %>" required/>

  <label>Số lượng:</label>
  <input type="number" name="quantity" value="<%= inv != null ? inv.getQuantity() : "" %>" required/>

  <label>Đơn vị:</label>
  <input type="text" name="unit" value="<%= inv != null ? inv.getUnit() : "" %>" required/>

  <label>Trạng thái:</label>
  <select name="status">
    <option value="Available" <%= (inv != null && "Available".equals(inv.getStatus())) ? "selected" : "" %>>Available</option>
    <option value="In Use" <%= (inv != null && "In Use".equals(inv.getStatus())) ? "selected" : "" %>>In Use</option>
    <option value="Maintenance" <%= (inv != null && "Maintenance".equals(inv.getStatus())) ? "selected" : "" %>>Maintenance</option>
    <option value="Broken" <%= (inv != null && "Broken".equals(inv.getStatus())) ? "selected" : "" %>>Broken</option>
  </select>

  <input type="submit" value="Lưu"/>
  <a href="inventory">Quay lại</a>
</form>
</body>
</html>

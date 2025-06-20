<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Inventory" %>

<html>
<head>
  <title>Rentable Inventory</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      padding: 20px;
    }

    h2 {
      text-align: center;
    }

    .top-bar {
      display: flex;
      gap: 10px;
      margin-bottom: 20px;
    }

    .btn {
      padding: 8px 16px;
      border: none;
      border-radius: 6px;
      color: white;
      cursor: pointer;
      font-weight: bold;
      text-decoration: none;
    }

    .btn-edit {
      background-color: #ffc107;
      color: black;
    }

    .btn-delete {
      background-color: #dc3545;
    }

    .green-btn {
      background-color: #28a745;
    }

    .blue-btn {
      background-color: #007bff;
    }

    .orange-btn {
      background-color: #ff9800;
    }

    .btn:hover {
      opacity: 0.9;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }

    th, td {
      padding: 10px;
      border: 1px solid #ddd;
    }

    th {
      background-color: #007bff;
      color: white;
      font-weight: bold;
    }

    tr:nth-child(even) {
      background-color: #f9f9f9;
    }

    tr:hover {
      background-color: #f1f1f1;
    }

    .pagination {
      margin-top: 20px;
      text-align: center;
    }

    .pagination a {
      margin: 0 4px;
      padding: 6px 12px;
      text-decoration: none;
      border: 1px solid #ccc;
      color: black;
      background-color: white;
      border-radius: 4px;
    }

    .pagination a.active {
      background-color: #007bff;
      color: white;
      border: none;
    }

    .message {
      text-align: center;
      color: red;
      font-weight: bold;
      margin-top: 20px;
    }
  </style>
</head>
<body>

<h2>Danh sách sản phẩm có thể cho thuê</h2>

<div class="top-bar">
  <a href="home.jsp" class="btn green-btn">🏠 Home</a>
  <a href="inventory" class="btn blue-btn">🔙 Trở lại danh sách</a>
  <a href="inventory?action=new" class="btn orange-btn">➕ Thêm sản phẩm</a>
</div>

<%
  List<Inventory> list = (List<Inventory>) request.getAttribute("inventoryList");
  Integer currentPage = (Integer) request.getAttribute("currentPage");
  Integer totalPages = (Integer) request.getAttribute("totalPages");
  String message = (String) request.getAttribute("message");
%>

<% if (message != null) { %>
<div class="message"><%= message %></div>
<% } else { %>
<table>
  <tr>
    <th>ID</th>
    <th>Tên</th>
    <th>Danh mục</th>
    <th>Số lượng</th>
    <th>Đơn vị</th>
    <th>Trạng thái</th>
    <th>Hành động</th>
  </tr>
  <% for (Inventory inv : list) { %>
  <tr>
    <td><%= inv.getInventoryId() %></td>
    <td><%= inv.getItemName() %></td>
    <td><%= inv.getCategory() %></td>
    <td><%= inv.getQuantity() %></td>
    <td><%= inv.getUnit() %></td>
    <td><%= inv.getStatus() %></td>
    <td>
      <a href="inventory?action=edit&id=<%= inv.getInventoryId() %>" class="btn btn-edit">Edit</a>
      <a href="inventory?action=delete&id=<%= inv.getInventoryId() %>" class="btn btn-delete"
         onclick="return confirm('Bạn có chắc chắn muốn xóa?');">Delete</a>
    </td>
  </tr>
  <% } %>
</table>

<% if (totalPages != null && totalPages > 1) { %>
<div class="pagination">
  <% for (int i = 1; i <= totalPages; i++) { %>
  <a href="inventory?action=rentable&page=<%= i %>"
     class="<%= (i == currentPage) ? "active" : "" %>"><%= i %></a>
  <% } %>
</div>
<% } %>
<% } %>

</body>
</html>

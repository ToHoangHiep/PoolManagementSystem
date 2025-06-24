<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.Inventory" %>
<%
  Inventory inv = (Inventory) request.getAttribute("inventory");
  String action = (inv != null) ? "update" : "insert";
%>
<html>
<head>
  <title><%= inv != null ? "Cập nhật thiết bị" : "Thêm thiết bị mới" %></title>
  <link rel="stylesheet" href="./Resources/CSS/inventoryForm.css">

</head>
<body>
<h2 style="text-align: center;"><%= inv != null ? "Update Item" : "Add New Item" %></h2>
<form action="inventory" method="post">
  <input type="hidden" name="action" value="<%= action %>"/>
  <% if (inv != null) { %>
  <input type="hidden" name="id" value="<%= inv.getInventoryId() %>"/>
  <% } %>

  <label>Manager ID:</label>
  <input type="number" name="manager_id" value="<%= inv != null ? inv.getManagerId() : "" %>" required/>

  <label>Item Name:</label>
  <input type="text" name="item_name" value="<%= inv != null ? inv.getItemName() : "" %>" required/>

  <label>Category:</label>
  <input type="text" name="category" value="<%= inv != null ? inv.getCategory() : "" %>" required/>

  <label>Quantity:</label>
  <input type="number" name="quantity" value="<%= inv != null ? inv.getQuantity() : "" %>" required/>

  <label>Unit:</label>
  <input type="text" name="unit" value="<%= inv != null ? inv.getUnit() : "" %>" required/>

  <label>Status:</label>
  <select name="status">
    <option value="Available" <%= (inv != null && "Available".equals(inv.getStatus())) ? "selected" : "" %>>Available</option>
    <option value="In Use" <%= (inv != null && "In Use".equals(inv.getStatus())) ? "selected" : "" %>>In Use</option>
    <option value="Maintenance" <%= (inv != null && "Maintenance".equals(inv.getStatus())) ? "selected" : "" %>>Maintenance</option>
    <option value="Broken" <%= (inv != null && "Broken".equals(inv.getStatus())) ? "selected" : "" %>>Broken</option>
  </select>

  <select name="usage_id">
    <option value="1">item for rent</option>
    <option value="2">item for maintainance</option>
    <option value="3">item for sold</option>
    <option value="1">item for facility</option>

  </select>


  <input type="submit" value="Save"/>
  <a href="inventory">Return</a>
</form>

</body>
</html>

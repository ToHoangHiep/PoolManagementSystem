@ -0,0 +1,37 @@
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="entities.Inventory" %>
<%
  Inventory inv = (Inventory) request.getAttribute("inventory");
  String action = (inv != null) ? "update" : "insert";
%>
<html>
<head>
  <title><%= inv != null ? "Cập nhật thiết bị" : "Thêm thiết bị mới" %></title>
</head>
<body>
<h2><%= inv != null ? "Cập nhật thiết bị" : "Thêm thiết bị mới" %></h2>
<form action="inventory" method="post">
  <input type="hidden" name="action" value="<%= action %>"/>
  <% if (inv != null) { %>
  <input type="hidden" name="id" value="<%= inv.getInventoryId() %>"/>
  <% } %>

  Manager ID: <input type="number" name="manager_id" value="<%= inv != null ? inv.getManagerId() : "" %>" required/><br/><br/>
  Tên thiết bị: <input type="text" name="item_name" value="<%= inv != null ? inv.getItemName() : "" %>" required/><br/><br/>
  Loại: <input type="text" name="category" value="<%= inv != null ? inv.getCategory() : "" %>" required/><br/><br/>
  Số lượng: <input type="number" name="quantity" value="<%= inv != null ? inv.getQuantity() : "" %>" required/><br/><br/>
  Đơn vị: <input type="text" name="unit" value="<%= inv != null ? inv.getUnit() : "" %>" required/><br/><br/>

  Trạng thái:
  <select name="status">
    <option value="Available" <%= (inv != null && "Available".equals(inv.getStatus())) ? "selected" : "" %>>Available</option>
    <option value="In Use" <%= (inv != null && "In Use".equals(inv.getStatus())) ? "selected" : "" %>>In Use</option>
    <option value="Maintenance" <%= (inv != null && "Maintenance".equals(inv.getStatus())) ? "selected" : "" %>>Maintenance</option>
    <option value="Broken" <%= (inv != null && "Broken".equals(inv.getStatus())) ? "selected" : "" %>>Broken</option>
  </select><br/><br/>

  <input type="submit" value="Lưu"/>
  <a href="inventory">Quay lại</a>
</form>
</body>
</html>
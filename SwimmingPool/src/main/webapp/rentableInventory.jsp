<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Inventory" %>

<html>
<head>
  <title>Rentable Inventory</title>
  <link rel="stylesheet" href="./Resources/CSS/inventory.css">
</head>
<body>

<h2 style="text-align: center;">Danh sách sản phẩm có thể cho thuê</h2>
<div class="top-navbar" >
<div class="nav-left">
  <a href="home.jsp" class="btn btn-home"><i class="fa fa-home"></i> 🏠 Home</a>
  <a href="inventory" class="btn btn-back"><i class="fa fa-arrow-left"></i> 🔙 Trở lại danh sách</a>
</div>

  <div class="nav-right">
  <form action="inventory" method="get" style="display: flex; align-items: center; gap: 10px; margin: 20px 0;">
    <input type="hidden" name="action" value="filter-rentable" />

    <label for="status">Lọc theo trạng thái:</label>
    <select name="status" id="status">
      <option value="">-- Tất cả --</option>
      <option value="Available" ${"Available".equals(selectedStatus) ? "selected" : ""}>Available</option>
      <option value="In Use" ${"In Use".equals(selectedStatus) ? "selected" : ""}>In Use</option>
      <option value="Broken" ${"Broken".equals(selectedStatus) ? "selected" : ""}>Broken</option>
    </select>

    <button type="submit">Lọc</button>
  </form>

  <form method="get" action="inventory" class="search-form">
    <input type="hidden" name="action" value="search-rentable" />
    <input type="text" name="keyword" placeholder="Tìm kiếm theo tên thiết bị..." value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>" />
    <button type="submit" class="search-btn">Tìm kiếm</button>
  </form>

</div>
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

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Inventory" %>

<%
    List<Inventory> inventoryList = (List<Inventory>) request.getAttribute("inventoryList");
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
%>
<html>
<head>
    <title>Danh sách sản phẩm bán</title>
    <link rel="stylesheet" href="./Resources/CSS/inventory.css">
</head>
<body>

<h2 style="text-align: center;">Danh sách sản phẩm có thể bán</h2>

<div class="top-bar">
    <a href="home.jsp" class="btn btn-home"><i class="fa fa-home"></i> 🏠 Home</a>
    <a href="inventory" class="btn btn-back"><i class="fa fa-arrow-left"></i> 🔙 Trở lại danh sách</a>



    <form action="inventory" method="get" style="display: inline; margin-left: 10px;">
        <input type="hidden" name="action" value="filter-sellable">
        <select name="status">
            <option value="">-- Trạng thái --</option>
            <option value="Available" ${selectedStatus == 'Available' ? 'selected' : ''}>Available</option>
            <option value="In Use" ${selectedStatus == 'In Use' ? 'selected' : ''}>In Use</option>
            <option value="Unavailable" ${selectedStatus == 'Unavailable' ? 'selected' : ''}>Unavailable</option>
        </select>
        <button type="submit">Lọc</button>
    </form>


    <form action="inventory" method="get" class="search-bar">
        <input type="hidden" name="action" value="search-sellable" />
        <input type="text" name="keyword" placeholder="Tìm kiếm sản phẩm để bán..." value="${param.keyword}" />
        <button type="submit">Tìm kiếm</button>
    </form>



</div>

<table>
    <thead>
    <tr>
        <th>ID</th>
        <th>Tên</th>
        <th>Danh mục</th>
        <th>Số lượng</th>
        <th>Đơn vị</th>
        <th>Trạng thái</th>
        <th>Hành động</th>
    </tr>
    </thead>
    <tbody>
    <% if (inventoryList != null && !inventoryList.isEmpty()) {
        for (Inventory inv : inventoryList) { %>
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
    <%  }
    } else { %>
    <tr><td colspan="7">Không có sản phẩm nào để bán.</td></tr>
    <% } %>
    </tbody>
</table>

<% if (totalPages != null && currentPage != null && totalPages > 1) { %>
<div class="pagination">
    <% for (int i = 1; i <= totalPages; i++) { %>
    <a href="inventory?action=sellable&page=<%= i %>"
       class="<%= (i == currentPage) ? "active" : "" %>"><%= i %></a>
    <% } %>
</div>
<% } %>

</body>
</html>

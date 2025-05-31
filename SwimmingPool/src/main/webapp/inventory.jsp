<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Inventory" %>

<%
    String keyword = request.getParameter("keyword");
%>

<html>
<head>
    <title>Inventory List</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 8px;
            border: 1px solid #ccc;
            text-align: left;
        }

        .pagination a {
            padding: 5px 10px;
            margin: 3px;
            text-decoration: none;
            background-color: #eee;
            border: 1px solid #ccc;
            color: black;
        }

        .pagination a.active {
            background-color: #ccc;
            font-weight: bold;
        }
    </style>
</head>
<body>

<h2>Inventory List</h2>

<!-- Tìm kiếm -->
<form method="get" action="inventory">
    <input type="text" name="keyword" placeholder="Search item..." value="<%= keyword != null ? keyword : "" %>"/>
    <button type="submit">Search</button>
</form>

<!-- Bảng danh sách -->
<table>
    <thead>
    <tr>
        <th>ID</th>
        <th>Manager ID</th>
        <th>Item Name</th>
        <th>Category</th>
        <th>Quantity</th>
        <th>Unit</th>
        <th>Status</th>
        <th>Last Updated</th>
    </tr>
    </thead>
    <tbody>
    <%
        List<Inventory> inventoryList = (List<Inventory>) request.getAttribute("inventoryList");
        Integer currentPage = (Integer) request.getAttribute("currentPage");
        Integer totalPages = (Integer) request.getAttribute("totalPages");

        if (inventoryList != null && !inventoryList.isEmpty()) {
            for (Inventory inv : inventoryList) {
    %>
    <tr>
        <td><%= inv.getInventoryId() %></td>
        <td><%= inv.getManagerId() %></td>
        <td><%= inv.getItemName() %></td>
        <td><%= inv.getCategory() %></td>
        <td><%= inv.getQuantity() %></td>
        <td><%= inv.getUnit() %></td>
        <td><%= inv.getStatus() %></td>
        <td><%= inv.getLastUpdated() %></td>
    </tr>
    <%
        }
    } else {
    %>
    <tr><td colspan="8">No data found.</td></tr>
    <%
        }
    %>
    </tbody>
</table>

<!-- Phân trang -->
<% if (totalPages != null && currentPage != null && totalPages > 1) { %>
<div class="pagination" style="margin-top: 20px;">
    <% for (int i = 1; i <= totalPages; i++) { %>
    <a href="inventory?page=<%= i %><%= keyword != null ? "&keyword=" + keyword : "" %>"
       class="<%= (i == currentPage) ? "active" : "" %>"><%= i %></a>
    <% } %>
</div>
<% } %>

</body>
</html>

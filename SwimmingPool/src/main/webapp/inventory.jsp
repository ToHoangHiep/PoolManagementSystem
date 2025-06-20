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
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f4f4f4;
        }

        h2 {
            color: #333;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #fff;
        }

        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }

        th {
            background-color: #007BFF;
            color: white;
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
            background-color: #007BFF;
            color: white;
            font-weight: bold;
        }

        .btn {
            padding: 5px 10px;
            color: white;
            background-color: #28a745;
            text-decoration: none;
            border-radius: 4px;
        }

        .btn-edit {
            background-color: #ffc107;
        }

        .btn-delete {
            background-color: #dc3545;
        }

        form {
            margin-bottom: 20px;
        }
        search-form {
            display: flex;
            justify-content: center;
            margin: 20px auto;
            max-width: 600px;
        }

        search-input {
            flex: 1;
            padding: 10px 15px;
            font-size: 16px;
            border: 2px solid #ccc;
            border-right: none;
            border-radius: 8px 0 0 8px;
            outline: none;
            transition: border-color 0.3s;
        }

        search-input:focus {
            border-color: #007bff;
        }

        search-button {
            padding: 10px 20px;
            background-color: #007bff;
            border: 2px solid #007bff;
            border-radius: 0 8px 8px 0;
            color: white;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .search-button:hover {
            background-color: #0056b3;
        }
        .top-bar {
            display: flex;
            align-items: flex-start;
            justify-content: left;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 20px;
        }

        .btn.green-btn {
            background-color: #2ecc71;
            color: white;
            padding: 10px 15px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: bold;
        }

        .btn.green-btn:hover {
            background-color: #27ae60;
        }

        .search-form,
        .filter-form {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .search-input {
            padding: 8px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        .search-button {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 5px;
        }

        .filter-button {
            background-color: #17a2b8;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 5px;
        }

        .btn.return-btn {
            background-color: #f39c12;
            color: white;
            padding: 10px 15px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: bold;
            margin-right: 10px;
        }

        .btn.return-btn:hover {
            background-color: #e67e22;
        }


        @media (max-width: 600px) {
            .inventory-actions {
                flex-direction: column;
                align-items: stretch;
            }
        }








    </style>
</head>
<body>

<h2>Inventory List</h2>

<div class="top-bar">
    <a href="home.jsp" class="btn green-btn">🏠 Home</a>
    <a href="inventory?action=default" class="btn return-btn">🔙 Return To List</a>
    <a href="inventory?action=new" class="btn green-btn">➕ Add New Item</a>
    <a href="inventory?action=rentable" class="btn green-btn">Show Rentable Item</a>

    <form method="get" action="inventory" class="filter-form">
        <input type="hidden" name="action" value="filter" />
        <select name="status">
            <option value="">-- Status --</option>
            <option value="Available">Available</option>
            <option value="In Use">In Use</option>
            <option value="Maintenance">Maintenance</option>
            <option value="Broken">Broken</option>
        </select>
        <button type="submit" class="filter-button">Filter</button>
    </form>



    <form method="get" action="inventory" class="search-form">
        <input type="hidden" name="action" value="search" />
        <input type="text" name="keyword" placeholder="Search item..." class="search-input" />
        <button type="submit" class="search-button">Search</button>
    </form>




</div>



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
        <th>Actions</th>
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
        <td>
            <a href="inventory?action=edit&id=<%= inv.getInventoryId() %>" class="btn btn-edit">Edit</a>
            <a href="inventory?action=delete&id=<%= inv.getInventoryId() %>" class="btn btn-delete"
               onclick="return confirm('Bạn có chắc chắn muốn xóa?');">Delete</a>
        </td>
    </tr>
    <%
        }
    } else {
    %>
    <tr><td colspan="9">No data found.</td></tr>
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

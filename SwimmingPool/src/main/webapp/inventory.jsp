<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Inventory" %>
<%@ page import="model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
%>
<%
    String keyword = request.getParameter("keyword");
%>
<html>
<head>
    <title>Inventory List</title>
    <link rel="stylesheet" href="./Resources/CSS/inventory.css">

</head>
<body>

<h2 style="text-align: center;">Inventory List</h2>

<!-- Thanh menu điều hướng -->
<div class="top-navbar">
    <div class="nav-left">
        <a href="home.jsp" class="nav-btn">🏠 Home</a>
        <a href="inventory?action=default" class="nav-btn orange">🔙 Return To List</a>
        <a href="inventory?action=new" class="nav-btn green">➕ Add New Item</a>
        <a href="inventory?action=lowstock" class="nav-btn blue" >Thiết bị sắp hết kho</a>


    </div>

    <div class="nav-right">
        <form method="get" action="inventory" class="filter-form">
            <input type="hidden" name="action" value="filter" />

            <!-- Lọc theo status -->
            <select name="status">
                <option value="">-- Status --</option>
                <%
                    String selectedStatus = (String) request.getAttribute("selectedStatus");
                    String[] statuses = {"Available", "In Use", "Maintenance", "Broken"};
                    for (String status : statuses) {
                %>
                <option value="<%= status %>" <%= status.equals(selectedStatus) ? "selected" : "" %>><%= status %></option>
                <%
                    }
                %>
            </select>

            <!-- Lọc theo usage_name -->
            <select name="usage">
                <option value="">-- Usage --</option>
                <%
                    String selectedUsage = (String) request.getAttribute("selectedUsage");
                    String[] usages = {"item for rent", "item for sold"};
                    for (String usage : usages) {
                %>
                <option value="<%= usage %>" <%= usage.equals(selectedUsage) ? "selected" : "" %>><%= usage %></option>
                <%
                    }
                %>
            </select>

            <button type="submit" class="filter-button">Filter</button>
        </form>


        <form method="get" action="inventory" class="inline-form">
            <input type="hidden" name="action" value="search" />
            <input type="text" name="keyword" placeholder="Search item..." class="nav-input" />
            <button type="submit" class="search-btn">Search</button>
        </form>
    </div>
</div>


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
        <td><%= inv.getCategoryName() %></td>
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

<c:if test="${not empty lowStockItems}">
    <div style="margin-top: 20px; padding: 10px; background-color: #fff3cd; border-left: 5px solid #ffecb5;">
        <strong>&#9888; Cảnh báo:</strong> Các mặt hàng sắp hết:
        <ul>
            <c:forEach var="item" items="${lowStockItems}">
                <li>${item.itemName} (Còn: ${item.quantity}, Mức cảnh báo: ${item.categoryQuantity})</li>
            </c:forEach>
        </ul>
    </div>
</c:if>


</body>
</html>
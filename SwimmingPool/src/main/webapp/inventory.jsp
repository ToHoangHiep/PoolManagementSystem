<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Inventory" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
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
        <a href="admin_dashboard.jsp" class="nav-btn">🏠 Home</a>
        <a href="inventory?action=new" class="nav-btn green">➕ Add New Item</a>
        <a href="inventory?action=requestList" class="nav-btn blue">📦 Yêu cầu nhập kho</a>
        <a href="inventory?action=repairRequestList" class="nav-btn blue">🔧 Yêu cầu sửa chữa</a>
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
        <th>Mã thiết bị</th>
        <th>Quản lý</th>
        <th>Tên thiết bị</th>
        <th>Danh mục</th>
        <th>Số lượng</th>
        <th>Đơn vị</th>
        <th>Trạng thái</th>
        <th>Cập nhật lần cuối</th>
        <th>Thao tác</th>
    </tr>
    </thead>
    <tbody>
    <%
        List<Inventory> inventoryList = (List<Inventory>) request.getAttribute("inventoryList");

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

</body>
</html>

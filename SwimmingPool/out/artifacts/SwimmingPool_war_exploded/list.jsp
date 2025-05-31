<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Inventory" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <title>Danh sách thiết bị</title>
</head>
<body>
<h2>Danh sách thiết bị</h2>
<a href="inventory?action=new">➕ Thêm thiết bị mới</a>
<form action="inventory" method="get">
    <input type="hidden" name="action" value="search" />
    <input type="text" name="keyword" placeholder="Tìm kiếm thiết bị..." />
    <button type="submit">Tìm</button>
</form>

<table>
    <c:forEach var="item" items="${inventoryList}">
        <tr>
            <td>${item.itemName}</td>
            <td>${item.category}</td>
            <td>${item.quantity}</td>
            <td>${item.unit}</td>
            <td>${item.status}</td>
            <td>${item.lastUpdated}</td>
        </tr>
    </c:forEach>
</table>


<table border="1" cellpadding="5" cellspacing="0">
    <tr>
        <th>ID</th>
        <th>Manager ID</th>
        <th>Tên thiết bị</th>
        <th>Loại</th>
        <th>Số lượng</th>
        <th>Đơn vị</th>
        <th>Trạng thái</th>
        <th>Cập nhật</th>
        <th>Hành động</th>
    </tr>
    <%
        List<Inventory> list = (List<Inventory>) request.getAttribute("inventoryList");
        if (list != null) {
            for (Inventory i : list) {
    %>
    <tr>
        <td><%= i.getInventoryId() %></td>
        <td><%= i.getManagerId() %></td>
        <td><%= i.getItemName() %></td>
        <td><%= i.getCategory() %></td>
        <td><%= i.getQuantity() %></td>
        <td><%= i.getUnit() %></td>
        <td><%= i.getStatus() %></td>
        <td><%= i.getLastUpdated() %></td>
        <td>
            <a href="inventory?action=edit&id=<%= i.getInventoryId() %>">Sửa</a> |
            <a href="inventory?action=delete&id=<%= i.getInventoryId() %>"
               onclick="return confirm('Bạn có chắc chắn muốn xóa?');">Xóa</a>
        </td>
    </tr>
    <%
            }
        }
    %>
    <%
        String message = (String) session.getAttribute("message");
        if (message != null) {
    %>
    <p style="color: green; font-weight: bold;"><%= message %></p>
    <%
            session.removeAttribute("message");
        }
    %>

</table>
</body>
</html>

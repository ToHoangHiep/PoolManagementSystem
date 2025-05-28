<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entities.Inventory" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <title>Danh sách thiết bị</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f8;
            margin: 40px;
        }

        h2 {
            color: #333;
        }

        a {
            display: inline-block;
            margin-bottom: 15px;
            padding: 8px 12px;
            background-color: white;
            color: black;
            text-decoration: none;
            border-radius: 4px;
        }

        form {
            margin-bottom: 20px;
        }

        input[type="text"] {
            padding: 6px 10px;
            width: 250px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        button {
            padding: 7px 12px;
            background-color: #2196F3;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        button:hover {
            background-color: #0b7dda;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }

        th {
            background-color: #1976D2;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        .actions a {
            color: black;
            text-decoration: none;
            margin: 0 5px;
        }

        .message {
            color: green;
            font-weight: bold;
            margin-top: 15px;
        }
    </style>
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
        <td class="actions">
            <a href="inventory?action=edit&id=<%= i.getInventoryId() %>">Sửa</a> |
            <a href="inventory?action=delete&id=<%= i.getInventoryId() %>"
               onclick="return confirm('Bạn có chắc chắn muốn xóa?');">Xóa</a>
        </td>
    </tr>
    <%
            }
        }
    %>
</table>

<%
    String message = (String) session.getAttribute("message");
    if (message != null) {
%>
<p class="message"><%= message %></p>
<%
        session.removeAttribute("message");
    }
%>

</body>
</html>

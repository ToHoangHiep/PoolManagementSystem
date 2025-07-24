<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 7/21/2025
  Time: 9:46 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Inventory" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<h2>Danh sách thiết bị đang bảo trì</h2>
<table border="1">
    <tr>
        <th>Tên thiết bị</th>
        <th>Loại</th>
        <th>Số lượng</th>
        <th>Đơn vị</th>
        <th>Lý do</th>
        <th>Thời gian cập nhật</th>
        <th>Thao tác</th>
    </tr>
    <c:forEach var="item" items="${maintenanceList}">
        <tr>
            <td>${item.itemName}</td>
            <td>${item.categoryName}</td>
            <td>${item.quantity}</td>
            <td>${item.unit}</td>
            <td>${item.status}</td>
            <td>${item.lastUpdated}</td>
            <td>
                <form action="repairRequest" method="post">
                    <input type="hidden" name="inventoryId" value="${item.inventoryId}" />
                    <button type="submit">Gửi yêu cầu sửa chữa</button>
                </form>
            </td>
        </tr>
    </c:forEach>
</table>

</body>
</html>

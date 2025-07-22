<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 7/21/2025
  Time: 9:38 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<h2>Gửi yêu cầu sửa chữa</h2>
<form action="inventory?action=submitRepair" method="post">
    <label>Chọn thiết bị cần sửa:</label>
    <select name="inventory_id">
        <c:forEach var="item" items="${repairItems}">
            <option value="${item.inventoryId}">${item.itemName}</option>
        </c:forEach>
    </select><br/>

    <label>Lý do:</label>
    <textarea name="reason" required></textarea><br/>

    <button type="submit">Gửi yêu cầu</button>
</form>

</body>
</html>

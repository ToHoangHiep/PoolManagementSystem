<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Thiết bị bị hỏng</title>
    <!-- CSS hiện đại -->
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f6f9;
            padding: 40px;
            margin: 0;
        }

        h2 {
            text-align: center;
            color: #007bff;
            margin-bottom: 25px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 0 auto;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        th, td {
            padding: 14px 16px;
            text-align: left;
            border-bottom: 1px solid #dee2e6;
        }

        thead {
            background-color: #f1f3f5;
            font-weight: bold;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:hover {
            background-color: #f1f7ff;
        }

        input[type="text"] {
            padding: 6px 10px;
            border-radius: 4px;
            border: 1px solid #ccc;
            width: 150px;
        }

        button {
            padding: 6px 12px;
            border: none;
            border-radius: 5px;
            background-color: #007bff;
            color: white;
            font-weight: bold;
            cursor: pointer;
            margin-left: 5px;
        }

        button:hover {
            background-color: #0056b3;
        }
    </style>

</head>
<body>

<h2>Danh sách thiết bị bị hỏng</h2>

<table>
    <thead>
    <tr>
        <th>Tên thiết bị</th>
        <th>Loại</th>
        <th>Số lượng</th>
        <th>Đơn vị</th>
        <th>Trạng thái</th>
        <th>Cập nhật</th>
        <th>Thao tác</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="item" items="${brokenList}">
        <tr>
            <td>${item.itemName}</td>
            <td>${item.categoryName}</td>
            <td>${item.quantity}</td>
            <td>${item.unit}</td>
            <td>${item.status}</td>
            <td>${item.lastUpdated}</td>
            <td>
                <form action="inventory" method="post" style="display: flex;">
                    <input type="hidden" name="action" value="submitRepair" />
                    <input type="hidden" name="inventoryId" value="${item.inventoryId}" />
                    <input type="text" name="reason" placeholder="Lý do sửa chữa" required />
                    <button type="submit">Gửi yêu cầu</button>
                </form>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>
<div style="text-align: center;">
    <a href="staff_dashboard.jsp">Quay lại danh sách</a>
</div>
<%
    String message = request.getParameter("message");
    if ("success".equals(message)) {
%>
<div style="color: green; text-align: center; font-weight: bold; margin: 10px;">
    Gửi yêu cầu sửa chữa thành công!
</div>
<%
} else if ("error".equals(message)) {
%>
<div style="color: red; text-align: center; font-weight: bold; margin: 10px;">
    Gửi yêu cầu sửa chữa thất bại. Vui lòng thử lại!
</div>
<%
    }
%>

</body>
</html>

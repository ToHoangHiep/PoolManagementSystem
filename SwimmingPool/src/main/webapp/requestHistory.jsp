<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Lịch sử nhập kho đã duyệt</title>
    <style>
        table {
            width: 90%;
            margin: auto;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 10px;
        }
        th {
            background-color: #eee;
        }
        h2 {
            text-align: center;
        }
    </style>
</head>
<body>
<h2>Lịch sử nhập kho đã duyệt</h2>

<table>
    <thead>
    <tr>
        <th>Mã yêu cầu</th>
        <th>Tên thiết bị</th>
        <th>Số lượng</th>
        <th>Lý do</th>
        <th>Ngày yêu cầu</th>
        <th>Ngày duyệt</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="req" items="${requestList}">
        <tr>
            <td>${req.requestId}</td>
            <td>${req.itemName}</td>
            <td>${req.requestedQuantity}</td>
            <td>${req.reason}</td>
            <td>${req.requestedAt}</td>
            <td>${req.approvedAt}</td>
        </tr>
    </c:forEach>
    </tbody>
</table>
</body>
</html>

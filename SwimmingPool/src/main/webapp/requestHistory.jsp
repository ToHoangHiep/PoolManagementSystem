<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Lịch sử nhập kho đã duyệt</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f9f9f9;
            padding: 30px;
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }

        table {
            width: 95%;
            margin: auto;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        th, td {
            padding: 12px 15px;
            border: 1px solid #ddd;
            text-align: center;
            font-size: 14px;
        }

        th {
            background-color: #f0f0f0;
            color: #333;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:hover {
            background-color: #eef2f7;
        }

        .back-btn {
            display: block;
            text-align: center;
            margin-top: 25px;
        }

        .back-btn a {
            text-decoration: none;
            background-color: #3498db;
            color: white;
            padding: 10px 20px;
            border-radius: 6px;
            transition: background-color 0.2s;
        }

        .back-btn a:hover {
            background-color: #2980b9;
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

<div class="back-btn">
    <a href="inventory">Quay lại danh sách yêu cầu</a>
</div>

</body>
</html>

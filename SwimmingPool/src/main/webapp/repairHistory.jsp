<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Lịch sử yêu cầu sửa chữa</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f8f9fa;
            padding: 40px;
            margin: 0;
        }

        h2 {
            color: #007bff;
            margin-bottom: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            border-radius: 10px;
            overflow: hidden;
        }

        th, td {
            padding: 15px;
            text-align: left;
        }

        thead {
            background-color: #f1f3f5;
            font-weight: bold;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .status {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 20px;
            font-weight: bold;
            color: #28a745;
            border: 1px solid #28a745;
            background-color: #e9f9ef;
        }

        .status.rejected {
            color: #dc3545;
            border-color: #dc3545;
            background-color: #fdecea;
        }

        .status.pending {
            color: #ffc107;
            border-color: #ffc107;
            background-color: #fff8e1;
        }

        button {
            margin: 2px;
            padding: 6px 12px;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
        }

        button[type=submit][value=approved] {
            background-color: #28a745;
            color: white;
        }

        button[type=submit][value=rejected] {
            background-color: #dc3545;
            color: white;
        }
    </style>
</head>
<body>

<h2>🛠️ Lịch sử yêu cầu sửa chữa</h2>

<table>
    <thead>
    <tr>
        <th>Tên thiết bị</th>
        <th>Lý do</th>
        <th>Trạng thái</th>
        <th>Ngày yêu cầu</th>
        <th>Ngày xử lý</th>
        <th>Thao tác</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="req" items="${repairRequests}">
        <tr>
            <td>${req.itemName}</td>
            <td>${req.reason}</td>
            <td>
                <c:choose>
                    <c:when test="${req.status == 'approved'}">
                        <span class="status">Đã duyệt</span>
                    </c:when>
                    <c:when test="${req.status == 'rejected'}">
                        <span class="status rejected">Đã từ chối</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status pending">Đang chờ</span>
                    </c:otherwise>
                </c:choose>
            </td>
            <td>${req.requestedAt}</td>
            <td>${req.reviewedAt}</td>
            <td>
                <c:if test="${req.status != 'approved' && req.status != 'rejected'}">
                    <form method="post" action="inventory" style="display:inline;">
                        <input type="hidden" name="action" value="updateRepairStatus" />
                        <input type="hidden" name="requestId" value="${req.requestId}" />
                        <button type="submit" name="status" value="approved">Duyệt</button>
                        <button type="submit" name="status" value="rejected">Từ chối</button>
                    </form>
                </c:if>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>
<div style="text-align: center;">
    <a href="inventory">Quay lại danh sách</a>
</div>
</body>
</html>

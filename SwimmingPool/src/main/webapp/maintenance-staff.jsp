<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.List" %>
<%@ page import="model.MaintenanceLog" %>

<%
    // Nhận danh sách logs đã gán cho staff
    List<MaintenanceLog> logs = (List<MaintenanceLog>) request.getAttribute("logs");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>My Maintenance Tasks</title>
    <style>
        table { width: 80%; margin: 20px auto; border-collapse: collapse; }
        th, td { padding: 10px; border: 1px solid #ddd; text-align: center; }
        th { background-color: #f4f4f4; }
        a.button { display: inline-block; padding: 6px 12px; margin: 4px 2px; background-color: #007bff; color: white; text-decoration: none; border-radius: 4px; }
        a.button:hover { background-color: #0056b3; }
    </style>
</head>
<body>
<h2 style="text-align:center;">My Maintenance Tasks</h2>
<div style="text-align:center; margin-bottom: 20px;">
    <a href="MaintenanceServlet?action=showRequestForm" class="button">Request Repair</a>
</div>

<c:choose>
    <c:when test="${empty logs}">
        <p style="text-align:center;">No tasks assigned.</p>
    </c:when>
    <c:otherwise>
        <table>
            <tr>
                <th>Date</th>
                <th>Task</th>
                <th>Area</th>
                <th>Status</th>
                <th>Detail</th>
            </tr>
            <c:forEach var="l" items="${logs}">
                <tr>
                    <td>${l.maintenanceDate}</td>
                    <td>${l.scheduleTitle}</td>
                    <td>${l.areaName}</td>
                    <td>${l.status}</td>
                    <td>
                        <!-- Chuyển sang detail tuần với đúng scheduleId -->
                        <a href="MaintenanceServlet?action=staffDetail&amp;scheduleId=${l.scheduleId}" class="button">View Week</a>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </c:otherwise>
</c:choose>
</body>
</html>

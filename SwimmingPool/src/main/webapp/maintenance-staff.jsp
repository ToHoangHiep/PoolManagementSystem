<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Nhiệm vụ Bảo trì</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; margin: 20px; background-color: #f8f9fa; color: #333; }
        .container { max-width: 1200px; margin: auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        h1 { color: #0056b3; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #dee2e6; padding: 12px; text-align: left; }
        th { background-color: #e9ecef; }
        .btn { padding: 10px 15px; border: none; color: white; cursor: pointer; text-decoration: none; display: inline-block; border-radius: 5px; font-size: 14px; text-align: center; }
        .btn-complete { background-color: #28a745; /* Green */ }
        .btn-complete:hover { background-color: #218838; }
        .btn-request { background-color: #dc3545; /* Red */ font-size: 16px; margin-bottom: 20px; }
        .btn-request:hover { background-color: #c82333; }
        .status-done { color: #28a745; font-weight: bold; }
        .status-pending { color: #ffc107; font-weight: bold; }
        .done-row { background-color: #f0fff0; }
        .no-tasks { text-align: center; color: #6c757d; padding: 20px; }
    </style>
</head>
<body>

<div class="container">
    <h1>Danh sách công việc của tôi</h1>

    <a href="MaintenanceServlet?action=showRequestForm" class="btn btn-request">➕ Tạo Yêu Cầu Bảo Trì Mới</a>

    <table>
        <thead>
        <tr>
            <th>Tên công việc</th>
            <th>Khu vực</th>
            <th>Ngày thực hiện</th>
            <th>Trạng thái</th>
            <th>Hành động</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${not empty logs}">
                <c:forEach var="log" items="${logs}">
                    <tr class="${log.status == 'Done' ? 'done-row' : ''}">
                        <td>${log.scheduleTitle}</td>
                        <td>${log.areaName}</td>
                        <td><fmt:formatDate value="${log.maintenanceDate}" pattern="dd-MM-yyyy"/></td>
                        <td>
                            <c:if test="${log.status == 'Done'}">
                                <span class="status-done">✔ Đã hoàn thành</span>
                            </c:if>
                            <c:if test="${log.status != 'Done'}">
                                <span class="status-pending">❗ Chưa hoàn thành</span>
                            </c:if>
                        </td>
                        <td>
                            <c:if test="${log.status != 'Done'}">
                                <form action="MaintenanceServlet" method="post" style="margin:0;">
                                    <input type="hidden" name="action" value="complete"/>
                                    <input type="hidden" name="logId" value="${log.id}"/>
                                    <button type="submit" class="btn btn-complete">Xác nhận hoàn thành</button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="5" class="no-tasks">🎉 Bạn không có nhiệm vụ nào. Hãy tận hưởng ngày làm việc!</td>
                </tr>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
</div>

</body>
</html>
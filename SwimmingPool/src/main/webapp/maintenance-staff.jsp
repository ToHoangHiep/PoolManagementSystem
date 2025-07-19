<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Nhiệm vụ Bảo trì của Tôi</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; color: #333; }
        .container { max-width: 1200px; margin: auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 6px rgba(0,0,0,0.1); }
        h1, h2 { color: #007bff; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        th { background-color: #f0f0f0; }
        .btn { padding: 8px 12px; background-color: #28a745; color: white; border: none; border-radius: 5px; cursor: pointer; }
        .btn:hover { background-color: #218838; }
        .btn-request { background-color: #dc3545; margin-bottom: 20px; }
        .btn-request:hover { background-color: #c82333; }
        .status-done { color: #28a745; font-weight: bold; }
        .status-pending { color: #ffc107; font-weight: bold; }
        .done-row { background-color: #f0fff0; }
        .section { margin-top: 40px; }
        /* Style for notifications */
        .notification-alert {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1050;
            width: 300px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            animation: fadein 0.5s, fadeout 0.5s 4.5s forwards;
        }

        @keyframes fadein {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes fadeout {
            from { opacity: 1; transform: translateY(0); }
            to { opacity: 0; transform: translateY(-20px); }
        }

        /* Styles for new request statuses */
        .status-processing { color: #ffc107; font-weight: bold; } /* Giống pending vì đang chờ */
        .status-accepted { color: green; font-weight: bold; } /* Đã được chấp nhận */
        .status-rejected { color: red; font-weight: bold; } /* Đã bị từ chối */
    </style>
</head>
<body>

<div class="container">
    <h1>📋 Nhiệm vụ bảo trì của tôi</h1>

    <a href="MaintenanceServlet?action=showRequestForm" class="btn btn-request">➕ Tạo Yêu Cầu Bảo Trì Mới</a>
    <a href="${pageContext.request.contextPath}/staff-maintenance-sent-requests" class="btn btn-info">✉️ Xem Yêu Cầu Đã Gửi Của Tôi</a>

    <div id="notificationArea" class="mt-4">
        <c:if test="${not empty unreadNotifications}">
            <c:forEach var="notification" items="${unreadNotifications}" varStatus="loop">
                <div class="alert alert-info alert-dismissible fade show notification-alert" role="alert"
                     style="top: ${20 + loop.index * 70}px;"> <%-- Stack notifications vertically --%>
                        ${notification}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:forEach>
        </c:if>
    </div>

    <div class="section">
        <h2>✅ Công việc định kỳ</h2>
        <table>
            <thead>
            <tr>
                <th>Công việc</th>
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
                                <c:choose>
                                    <c:when test="${log.status == 'Done'}">
                                        <span class="status-done">✔ Đã hoàn thành</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-pending">❗ Chưa hoàn thành</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:if test="${log.status != 'Done'}">
                                    <form action="MaintenanceServlet" method="post" style="margin:0;">
                                        <input type="hidden" name="action" value="complete"/>
                                        <input type="hidden" name="logId" value="${log.id}"/>
                                        <button type="submit" class="btn">Xác nhận hoàn thành</button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="5" style="text-align:center;">🎉 Không có công việc nào định kỳ.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>

    <div class="section">
        <h2>🔄 Yêu cầu của tôi – Đang xử lý</h2>
        <c:choose>
            <c:when test="${not empty myProcessingRequests}"> <%-- Thay thế 'sentRequests' bằng 'myProcessingRequests' --%>
                <table>
                    <thead>
                    <tr>
                        <th>Mô tả</th>
                        <th>Khu vực</th>
                        <th>Ngày gửi</th>
                        <th>Trạng thái</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="r" items="${myProcessingRequests}">
                        <tr>
                            <td>${r.description}</td>
                            <td>${r.poolAreaName}</td>
                            <td><fmt:formatDate value="${r.createdAt}" pattern="dd-MM-yyyy HH:mm"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${r.status eq 'Processing'}">
                                        <span class="status-processing">Đang xử lý...</span>
                                    </c:when>
                                    <%-- Nếu bạn muốn hiển thị các trạng thái khác ở đây, ví dụ: "Open", "New" --%>
                                    <c:otherwise>
                                        <span class="status-pending">${r.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <p>Không có yêu cầu nào của tôi đang chờ xử lý.</p>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="section">
        <h2>🟢 Yêu cầu của tôi – Đã được chấp nhận</h2>
        <c:choose>
            <c:when test="${not empty myAccepted}">
                <table>
                    <thead>
                    <tr><th>Mô tả</th><th>Khu vực</th><th>Thời gian tạo</th><th>Trạng thái hiện tại</th></tr>
                    </thead>
                    <tbody>
                    <c:forEach var="r" items="${myAccepted}">
                        <tr>
                            <td>${r.description}</td>
                            <td>${r.poolAreaName}</td>
                            <td><fmt:formatDate value="${r.createdAt}" pattern="dd-MM-yyyy HH:mm"/></td>
                            <td><span class="status-accepted">Đã chuyển đổi thành công việc</span></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <p>Không có yêu cầu nào của tôi được chấp nhận.</p>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="section">
        <h2>🔴 Yêu cầu của tôi – Bị từ chối</h2>
        <c:choose>
            <c:when test="${not empty myRejected}">
                <table>
                    <thead>
                    <tr><th>Mô tả</th><th>Khu vực</th><th>Thời gian tạo</th></tr>
                    </thead>
                    <tbody>
                    <c:forEach var="r" items="${myRejected}">
                        <tr>
                            <td>${r.description}</td>
                            <td>${r.poolAreaName}</td>
                            <td><fmt:formatDate value="${r.createdAt}" pattern="dd-MM-yyyy HH:mm"/></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <p>Không có yêu cầu nào của tôi bị từ chối.</p>
            </c:otherwise>
        </c:choose>
    </div>

    <%-- Phần "Yêu cầu được phân công cho tôi" đã bị comment, nếu bạn muốn dùng lại thì bỏ comment --%>
    <%--
    <div class="section">
        <h2>🛠️ Yêu cầu được phân công cho tôi</h2>
        <c:choose>
            <c:when test="${not empty assigned}">
                <table>
                    <thead>
                    <tr><th>Mô tả</th><th>Khu vực</th><th>Thời gian cập nhật</th></tr>
                    </thead>
                    <tbody>
                    <c:forEach var="r" items="${assigned}">
                        <tr>
                            <td>${r.description}</td>
                            <td>${r.poolAreaName}</td>
                            <td><fmt:formatDate value="${r.updatedAt}" pattern="dd-MM-yyyy HH:mm"/></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <p>Chưa có yêu cầu nào được giao cho tôi.</p>
            </c:otherwise>
        </c:choose>
    </div>
    --%>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Nhiệm vụ Bảo trì của Tôi</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #007bff;
            --secondary-color: #6c757d;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --info-color: #17a2b8;
            --bg-light: #f8f9fa;
            --text-dark: #343a40;
            --border-color: #dee2e6;
            --shadow-light: rgba(0, 0, 0, 0.08);
            --shadow-medium: rgba(0, 0, 0, 0.15);
        }

        body {
            font-family: 'Roboto', sans-serif;
            margin: 0;
            padding: 20px;
            background-color: var(--bg-light);
            color: var(--text-dark);
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 20px auto;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 6px 20px var(--shadow-light);
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 2px solid var(--border-color);
        }

        h1 {
            color: var(--primary-color);
            font-size: 2.2em;
            margin: 0;
            display: flex;
            align-items: center;
        }

        h1 .icon {
            margin-right: 15px;
            font-size: 1.2em;
            color: #4a90e2; /* A slightly different blue for icon */
        }

        h2 {
            color: var(--primary-color);
            font-size: 1.6em;
            margin-top: 35px;
            margin-bottom: 20px;
            padding-bottom: 8px;
            border-bottom: 1px dashed var(--border-color);
        }

        .btn {
            /* Đảm bảo flexbox để icon và text nằm cạnh nhau */
            display: inline-flex; /* Giữ nguyên inline-flex vì nó phù hợp với các nút */
            align-items: center; /* Căn giữa theo chiều dọc */
            /* justify-content: center; */ /* Bỏ cái này đi để văn bản bắt đầu sau icon */

            padding: 10px 20px;
            font-size: 1em;
            font-weight: 500;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            transition: background-color 0.3s ease, transform 0.2s ease;
            box-shadow: 0 2px 5px var(--shadow-light);
            white-space: nowrap; /* Đảm bảo văn bản không bị xuống dòng trong nút */
            gap: 8px; /* Thêm thuộc tính gap để tạo khoảng cách giữa icon và chữ */
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 10px var(--shadow-medium);
        }

        .btn-primary {
            background-color: var(--primary-color);
        }

        .btn-primary:hover {
            background-color: #0056b3;
        }

        .btn-success {
            background-color: var(--success-color);
        }

        .btn-success:hover {
            background-color: #218838;
        }

        .btn-danger {
            background-color: var(--danger-color);
        }

        .btn-danger:hover {
            background-color: #c82333;
        }



        .actions-top {
            display: flex;
            gap: 15px;
            margin-bottom: 25px;
        }

        /* Table Styles */
        table {
            width: 100%;
            border-collapse: separate; /* Use separate for rounded corners */
            border-spacing: 0; /* Remove space between cells */
            margin-top: 20px;
            border-radius: 10px; /* Outer table border radius */
            overflow: hidden; /* Hide overflowing borders for inner cells */
            box-shadow: 0 4px 12px var(--shadow-light);
        }

        th, td {
            border: 1px solid var(--border-color);
            padding: 12px 15px;
            text-align: left;
        }

        th {
            background-color: #e9ecef;
            color: var(--text-dark);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.9em;
        }

        tr:nth-child(even) {
            background-color: #f6f9fc;
        }

        tr:hover {
            background-color: #e0f2f7;
            transition: background-color 0.2s ease;
        }

        .status-done {
            color: var(--success-color);
            font-weight: 600;
        }

        .status-pending, .status-processing {
            color: var(--warning-color);
            font-weight: 600;
        }

        .status-accepted {
            color: var(--primary-color); /* Use primary for accepted */
            font-weight: 600;
        }

        .status-rejected {
            color: var(--danger-color);
            font-weight: 600;
        }

        .done-row {
            background-color: #e6ffe6 !important; /* Lighter green for completed rows */
        }

        /* Form Button in Table Cell */
        td form {
            margin: 0;
            display: inline-block;
        }

        td .btn {
            font-size: 0.85em;
            padding: 6px 10px;
            box-shadow: none; /* No shadow for small buttons in table */
        }

        /* Notifications */
        .notification-area {
            position: relative; /* Changed to relative to fit within container */
            margin-bottom: 30px;
            background-color: #f0f8ff; /* Light blue background for notification area */
            border: 1px solid #cce5ff; /* Blue border */
            border-radius: 8px;
            padding: 15px;
            box-shadow: 0 2px 8px var(--shadow-light);
        }

        .notification-item {
            background-color: var(--info-color);
            color: white;
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 10px; /* Space between notifications */
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.95em;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            animation: slideInFromRight 0.5s ease-out;
            opacity: 0.95;
        }

        .notification-item:last-child {
            margin-bottom: 0;
        }

        .notification-close-btn {
            background: none;
            border: none;
            color: white;
            font-size: 1.2em;
            cursor: pointer;
            padding: 0 5px;
            transition: transform 0.2s ease;
        }

        .notification-close-btn:hover {
            transform: scale(1.1);
        }

        @keyframes slideInFromRight {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }

        /* For responsiveness */
        @media (max-width: 768px) {
            .container {
                padding: 15px;
            }
            h1 {
                font-size: 1.8em;
            }
            h2 {
                font-size: 1.4em;
            }
            .btn {
                padding: 8px 15px;
                font-size: 0.9em;
            }
            .actions-top {
                flex-direction: column;
                gap: 10px;
            }
            table, th, td {
                display: block;
                width: 100%;
            }
            thead {
                display: none; /* Hide table headers on small screens */
            }
            tr {
                margin-bottom: 15px;
                border: 1px solid var(--border-color);
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 2px 8px var(--shadow-light);
            }
            td {
                border: none;
                border-bottom: 1px solid var(--border-color);
                position: relative;
                padding-left: 50%;
                text-align: right;
            }
            td:last-child {
                border-bottom: none;
            }
            td::before {
                content: attr(data-label);
                position: absolute;
                left: 10px;
                width: 45%;
                padding-right: 10px;
                white-space: nowrap;
                text-align: left;
                font-weight: 600;
                color: var(--primary-color);
            }
        }


    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <h1><span class="icon">📋</span> Nhiệm vụ bảo trì của tôi</h1>
        <div class="header-actions">
            <a href="home.jsp" style="background: #007bff; color: white; padding: 10px 20px; border-radius: 6px; display: inline-flex; gap: 8px; text-decoration: none;">
                <span>🏠</span><span>Quay lại Trang chủ</span>
            </a>


        </div>
    </div>

    <div class="actions-top">
        <a href="MaintenanceServlet?action=showRequestForm" class="btn btn-danger">
            <span class="btn-icon">➕</span> Tạo Yêu Cầu Bảo Trì Mới
        </a>
    </div>

    <div id="notificationArea" class="notification-area">
        <c:if test="${not empty unreadNotifications}">
            <p style="margin-bottom: 15px; font-weight: 500; color: var(--primary-color);">Bạn có thông báo mới:</p>
            <c:forEach var="notification" items="${unreadNotifications}" varStatus="loop">
                <div class="notification-item">
                        ${notification}
                    <button type="button" class="notification-close-btn" onclick="this.parentElement.style.display='none';">&times;</button>
                </div>
            </c:forEach>
        </c:if>
        <c:if test="${empty unreadNotifications && not empty param.notificationDisplayed}">
            <p style="color: var(--secondary-color);">Không có thông báo mới.</p>
        </c:if>
    </div>
    <c:if test="${not empty unreadNotifications}">
        <script>
            // Add a parameter to the URL to indicate notifications have been displayed,
            // so on refresh, the 'empty unreadNotifications' message can be shown without new notifications popping up.
            window.onload = function() {
                const urlParams = new URLSearchParams(window.location.search);
                if (!urlParams.has('notificationDisplayed')) {
                    urlParams.append('notificationDisplayed', 'true');
                    window.history.replaceState({}, '', `${location.pathname}?${urlParams}`);
                }
            };
        </script>
    </c:if>


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
                            <td data-label="Công việc">${log.scheduleTitle}</td>
                            <td data-label="Khu vực">${log.areaName}</td>
                            <td data-label="Ngày thực hiện"><fmt:formatDate value="${log.maintenanceDate}" pattern="dd-MM-yyyy"/></td>
                            <td data-label="Trạng thái">
                                <c:choose>
                                    <c:when test="${log.status == 'Done'}">
                                        <span class="status-done">✔ Đã hoàn thành</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-pending">❗ Chưa hoàn thành</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td data-label="Hành động">
                                <c:if test="${log.status != 'Done'}">
                                    <form action="MaintenanceServlet" method="post" style="margin:0;">
                                        <input type="hidden" name="action" value="complete"/>
                                        <input type="hidden" name="logId" value="${log.id}"/>
                                        <button type="submit" class="btn btn-success">Xác nhận hoàn thành</button>
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
            <c:when test="${not empty myProcessingRequests}">
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
                            <td data-label="Mô tả">${r.description}</td>
                            <td data-label="Khu vực">${r.poolAreaName}</td>
                            <td data-label="Ngày gửi"><fmt:formatDate value="${r.createdAt}" pattern="dd-MM-yyyy HH:mm"/></td>
                            <td data-label="Trạng thái">
                                <span class="status-processing">Đang xử lý...</span>
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
                            <td data-label="Mô tả">${r.description}</td>
                            <td data-label="Khu vực">${r.poolAreaName}</td>
                            <td data-label="Thời gian tạo"><fmt:formatDate value="${r.createdAt}" pattern="dd-MM-yyyy HH:mm"/></td>
                            <td data-label="Trạng thái"><span class="status-accepted">Đã chuyển đổi thành công việc</span></td>
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
                            <td data-label="Mô tả">${r.description}</td>
                            <td data-label="Khu vực">${r.poolAreaName}</td>
                            <td data-label="Thời gian tạo"><fmt:formatDate value="${r.createdAt}" pattern="dd-MM-yyyy HH:mm"/></td>
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

</div>

</body>
</html>
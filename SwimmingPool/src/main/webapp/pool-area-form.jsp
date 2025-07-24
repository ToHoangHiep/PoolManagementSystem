<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.PoolArea" %>
<%@ page import="model.MaintenanceLog" %>
<%@ page import="model.MaintenanceRequest" %>
<%@ page import="java.util.List" %>

<html>
<head>
    <title>${area.id != 0 ? "Cập nhật" : "Thêm"} khu vực hồ bơi</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f4f4f4;
        }
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 25px;
        }
        form {
            max-width: 600px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        label {
            display: block;
            margin-top: 15px;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        input[type="text"],
        input[type="number"],
        textarea,
        select {
            width: calc(100% - 22px); /* Kích thước box-sizing: border-box */
            padding: 10px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 16px;
            margin-bottom: 10px;
        }
        textarea {
            resize: vertical;
            min-height: 80px;
        }
        .actions {
            margin-top: 25px;
            text-align: center;
        }
        .actions button {
            padding: 10px 25px;
            font-size: 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin: 0 10px;
        }
        .actions button[type="submit"] {
            background-color: #007bff;
            color: white;
        }
        .actions button[type="submit"]:hover {
            background-color: #0056b3;
        }
        .actions a {
            background-color: #6c757d;
            color: white;
            padding: 10px 25px;
            font-size: 16px;
            border-radius: 5px;
            text-decoration: none;
        }
        .actions a:hover {
            background-color: #5a6268;
        }
        .error-message {
            color: red;
            background-color: #ffebe8;
            border: 1px solid red;
            padding: 10px;
            margin-top: 15px;
            border-radius: 5px;
            text-align: center;
        }
        .section-title {
            margin-top: 30px;
            margin-bottom: 15px;
            color: #333;
            border-bottom: 1px solid #eee;
            padding-bottom: 5px;
        }
        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
            background-color: #fff;
            box-shadow: 0 0 8px rgba(0,0,0,0.05);
        }
        .data-table th, .data-table td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
            font-size: 14px;
        }
        .data-table th {
            background-color: #f8f9fa;
        }
        .no-data {
            text-align: center;
            color: #666;
            padding: 10px;
        }
    </style>
</head>
<body>

<h2 style="text-align:center;">${area.id != 0 ? "Cập nhật" : "Thêm mới"} khu vực hồ bơi</h2>

<form action="pool-area" method="post">
    <%-- Sửa logic action: Nếu area.id == 0 thì là "insert", ngược lại là "update" --%>
    <input type="hidden" name="action" value="${area.id != 0 ? "update" : "insert"}"/>

    <%-- Chỉ gửi id nếu đang ở chế độ cập nhật (id khác 0) --%>
    <c:if test="${area.id != 0}">
        <input type="hidden" name="id" value="${area.id}"/>
    </c:if>

    <label for="name">Tên khu vực:</label>
    <input type="text" name="name" id="name" value="${area != null ? area.name : ''}" required/>

    <label for="description">Mô tả:</label>
    <textarea name="description" id="description">${area != null ? area.description : ''}</textarea>

    <label for="type">Loại khu:</label>
    <select name="type" id="type">
        <c:forEach var="option" items="${['Standard', 'Trẻ em', 'VIP', 'Tập luyện']}">
            <option value="${option}" ${area != null && area.type eq option ? "selected" : ""}>${option}</option>
        </c:forEach>
    </select>

    <label for="waterDepth">Độ sâu nước (m):</label>
    <%-- Đảm bảo giá trị mặc định là 0 nếu area là null hoặc id là 0 --%>
    <input type="number" step="0.01" name="waterDepth" id="waterDepth" value="${area != null ? area.waterDepth : 0}" required/>

    <label for="length">Chiều dài (m):</label>
    <input type="number" step="0.01" name="length" id="length" value="${area != null ? area.length : 0}" required/>

    <label for="width">Chiều rộng (m):</label>
    <input type="number" step="0.01" name="width" id="width" value="${area != null ? area.width : 0}" required/>

    <label for="maxCapacity">Sức chứa tối đa:</label>
    <input type="number" name="maxCapacity" id="maxCapacity" value="${area != null ? area.maxCapacity : 0}" required/>

    <div class="actions">
        <button type="submit">${area.id != 0 ? "Cập nhật" : "Thêm mới"}</button>
        <a href="pool-area">Huỷ</a>
    </div>

    <c:if test="${not empty error}">
        <p class="error-message">${error}</p>
    </c:if>
</form>

<c:if test="${area.id != 0}"> <%-- Chỉ hiển thị phần này khi đang ở chế độ cập nhật --%>
    <div style="max-width: 600px; margin: 30px auto; background-color: white; padding: 30px; border-radius: 8px; box-shadow: 0 0 15px rgba(0,0,0,0.1);">
        <h3 class="section-title">Lịch sử bảo trì</h3>
        <c:choose>
            <c:when test="${not empty maintenanceLogs}">
                <table class="data-table">
                    <thead>
                    <tr>
                        <th>ID Log</th>
                        <th>Nhiệm vụ</th>
                        <th>Nhân viên</th>
                        <th>Khu vực</th>
                        <th>Ngày</th>
                        <th>Trạng thái</th>
                        <th>Tần suất</th>
                        <th>Ghi chú</th>
                        <th>Cập nhật lúc</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="log" items="${maintenanceLogs}">
                        <tr>
                            <td>${log.id}</td>
                            <td>${log.scheduleTitle}</td>
                            <td>${log.staffName}</td>
                            <td>${log.areaName}</td>
                            <td><fmt:formatDate value="${log.maintenanceDate}" pattern="dd/MM/yyyy"/></td>
                            <td>${log.status}</td>
                            <td>${log.frequency}</td>
                            <td>${log.note}</td>
                            <td><fmt:formatDate value="${log.updatedAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <p class="no-data">Không có lịch sử bảo trì nào cho khu vực này.</p>
            </c:otherwise>
        </c:choose>

        <h3 class="section-title">Yêu cầu bảo trì</h3>
        <c:choose>
            <c:when test="${not empty maintenanceRequests}">
                <table class="data-table">
                    <thead>
                    <tr>
                        <th>ID YC</th>
                        <th>Mô tả</th>
                        <th>Trạng thái</th>
                        <th>Người tạo</th>
                        <th>Khu vực</th>
                        <th>Ngày tạo</th>
                        <th>ID Nhân viên phụ trách</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="request" items="${maintenanceRequests}">
                        <tr>
                            <td>${request.id}</td>
                            <td>${request.description}</td>
                            <td>${request.status}</td>
                            <td>${request.createdByName}</td>
                            <td>${request.poolAreaName}</td>
                            <td><fmt:formatDate value="${request.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td>${request.staffId != 0 ? request.staffId : 'Chưa phân công'}</td> <%-- Hiển thị staffId --%>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <p class="no-data">Không có yêu cầu bảo trì nào cho khu vực này.</p>
            </c:otherwise>
        </c:choose>
    </div>
</c:if>

</body>
</html>

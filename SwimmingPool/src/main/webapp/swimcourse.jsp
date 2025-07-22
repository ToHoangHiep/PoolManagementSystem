<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.SwimCourse" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách khóa học</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f7fa;
            padding: 30px;
            margin: 0;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1100px;
            margin: 0 auto 25px;
            padding: 0 10px;
        }

        .header a {
            display: inline-block;
            padding: 10px 18px;
            border-radius: 5px;
            text-decoration: none;
            color: white;
            font-weight: bold;
            transition: background-color 0.2s;
        }

        .btn-home {
            background-color: #2ecc71;
        }

        .btn-home:hover {
            background-color: #27ae60;
        }

        .btn-add {
            background-color: #3498db;
        }

        .btn-add:hover {
            background-color: #2980b9;
        }

        h2 {
            color: #2c3e50;
            text-align: center;
        }

        table {
            width: 100%;
            max-width: 1100px;
            margin: 0 auto;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }

        th, td {
            padding: 12px 14px;
            border: 1px solid #ddd;
            text-align: left;
            vertical-align: middle;
        }

        th {
            background-color: #f0f2f5;
        }

        .actions {
            display: flex;
            gap: 6px;
        }

        .actions form {
            display: inline;
        }

        .actions button {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            color: white;
            font-size: 14px;
            cursor: pointer;
            transition: 0.2s;
        }

        .btn-edit {
            background-color: #3498db;
        }

        .btn-edit:hover {
            background-color: #2980b9;
        }

        .btn-delete {
            background-color: #e74c3c;
        }

        .btn-delete:hover {
            background-color: #c0392b;
        }

        .no-data {
            text-align: center;
            color: #999;
        }
    </style>
</head>
<body>

<div class="header">
    <a href="admin_dashboard.jsp" class="btn-home">🏠 Trang chủ</a>
    <a href="swimcourse?action=add" class="btn-add">➕ Thêm khóa học</a>
</div>

<h2>Danh sách khóa học</h2>

<table>
    <tr>
        <th>Tên</th>
        <th>Mô tả</th>
        <th>Giá (VNĐ)</th>
        <th>Số lượng học viên</th>
        <th>Lịch học</th>
        <th>Thời gian hoàn thành</th>
        <th>Thời lượng</th>
        <th>Hành động</th>
    </tr>
    <%
        List<SwimCourse> list = (List<SwimCourse>) request.getAttribute("courses");
        if (list != null && !list.isEmpty()) {
            for (SwimCourse c : list) {
    %>
    <tr>
        <td><%= c.getName() %></td>
        <td><%= c.getDescription() %></td>
        <td><%= String.format("%,.0f", c.getPrice()) %></td>
        <td><%= c.getStudentDescription() %></td>
        <td><%= c.getScheduleDescription() %></td>
        <td><%= c.getDuration() %></td>
        <td><%= c.getEstimatedSessionTime() %></td>
        <td class="actions">
            <form action="swimcourse" method="get">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="id" value="<%= c.getId() %>">
                <button class="btn-edit" type="submit">✏️ Sửa</button>
            </form>
            <form action="swimcourse" method="get" onsubmit="return confirm('Bạn có chắc chắn muốn xóa?');">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" value="<%= c.getId() %>">
                <button class="btn-delete" type="submit">🗑️ Xóa</button>
            </form>
        </td>
    </tr>
    <% }} else { %>
    <tr><td colspan="8" class="no-data">Không có dữ liệu</td></tr>
    <% } %>
</table>

</body>
</html>

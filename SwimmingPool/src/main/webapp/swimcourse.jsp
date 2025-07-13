<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.SwimCourse" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách khóa học</title>
</head>
<body>
<h2>Danh sách khóa học</h2>
<a href="swimcourse?action=add">+ Thêm khóa học</a>
<table border="1" cellpadding="8">
    <tr>
        <th>Tên</th>
        <th>Mô tả</th>
        <th>Giá</th>
        <th>Số lượng học viên</th>
        <th>Lịch học</th>
        <th>Thời gian dự kiến hoàn thành</th>
        <th>Thời lượng học</th>
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
        <td><%= c.getPrice() %></td>
        <td><%= c.getStudentDescription() %></td>
        <td><%= c.getScheduleDescription() %></td>
        <td><%= c.getDuration() %></td>
        <td><%= c.getEstimatedSessionTime() %></td>
        <td>
            <a href="swimcourse?action=edit&id=<%= c.getId() %>">Sửa</a> |
            <a href="swimcourse?action=delete&id=<%= c.getId() %>">Xóa</a>
        </td>
    </tr>
    <% }} else { %>
    <tr><td colspan="8">Không có dữ liệu</td></tr>
    <% } %>
</table>
</body>
</html>

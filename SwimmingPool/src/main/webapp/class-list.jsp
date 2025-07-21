<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.Class" %>
<%
    List<Class> list = (List<Class>) request.getAttribute("classes");
    String error = (String) request.getAttribute("error");
    String message = (String) request.getAttribute("message");
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách lớp học</title>
</head>
<body>
<h2>Danh sách lớp học</h2>
<a href="class?action=add">+ Thêm lớp học</a><br/><br/>
<% if (error != null) { %><div style="color:red"><%= error %></div><% } %>
<% if (message != null) { %><div style="color:green"><%= message %></div><% } %>

<table border="1" cellpadding="8">
    <tr>
        <th>Tên lớp</th>
        <th>Khóa học</th>
        <th>Huấn luyện viên</th>
        <th>Lịch học</th>
        <th>Địa điểm</th>
        <th>Trạng thái</th>
        <th>Hành động</th>
    </tr>
    <% if (list != null && !list.isEmpty()) {
        for (Class cls : list) {
    %>
    <tr>
        <td><%= cls.getId() %></td>
        <td><%= cls.getCourseId() %></td>
        <td><%= cls.getCoachId() %></td>
        <td><%= cls.getName() %></td>
        <td><%= cls.getStatus() %></td>
        <td><%= cls.getNote() %></td>
        <td>
            <a href="class?action=edit&id=<%= cls.getId() %>">Sửa</a> |
            <a href="class?action=delete&id=<%= cls.getId() %>" onclick="return confirm('Bạn có chắc muốn xóa?')">Xóa</a>
        </td>
    </tr>
    <% }} else { %>
    <tr><td colspan="7">Không có dữ liệu</td></tr>
    <% } %>
</table>
</body>
</html>


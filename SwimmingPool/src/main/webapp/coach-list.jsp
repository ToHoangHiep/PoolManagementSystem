<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.Coach" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách Huấn luyện viên</title>
</head>
<body>
<h2>Danh sách Huấn luyện viên</h2>
<a href="coach-list?action=add">+ Thêm Huấn luyện viên</a>
<table border="1" cellpadding="8">
    <tr>
        <th>Họ tên</th>
        <th>Email</th>
        <th>Số điện thoại</th>
        <th>Giới tính</th>
        <th>Tiểu sử</th>
        <th>Ảnh</th>
        <th>Hành động</th>
    </tr>
    <%
        List<Coach> list = (List<Coach>) request.getAttribute("coaches");
        if (list != null && !list.isEmpty()) {
            for (Coach c : list) {
    %>
    <tr>
        <td><%= c.getFullName() %></td>
        <td><%= c.getEmail() %></td>
        <td><%= c.getPhone() %></td>
        <td><%= c.getGender() %></td>
        <td><%= c.getBio() %></td>
        <td><img src="images/<%= c.getProfilePicture() %>" width="80" height="80"/></td>
        <td>
            <a href="coach-list?action=edit&id=<%= c.getId() %>">Sửa</a> |
            <a href="coach-list?action=delete&id=<%= c.getId() %>" onclick="return confirm('Bạn chắc chắn muốn xóa?')">Xóa</a>
        </td>
    </tr>
    <% }} else { %>
    <tr><td colspan="7">Không có dữ liệu</td></tr>
    <% } %>
</table>
</body>
</html>

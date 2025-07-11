<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.SwimCourse" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách khóa học</title>
</head>
<body>
<h2>Danh sách khóa học</h2>
<a href="swimcourse?action=add">+ Thêm khóa học</a>

<table border="1" cellpadding="8" cellspacing="0">
    <tr>
        <th>Tên khóa học</th>
        <th>Huấn luyện viên</th>
        <th>Giá</th>
        <th>Trạng thái</th>
        <th>Mô tả</th>
        <th>Lịch học</th>
        <th>Học viên</th>
        <th>Hành động</th>
    </tr>
    <%
        List<SwimCourse> list = (List<SwimCourse>) request.getAttribute("courses");
        for (SwimCourse c : list) {
    %>
    <tr>
        <td><%= c.getName() %></td>
        <td><%= c.getCoachName() != null ? c.getCoachName() : "Chưa gán" %></td>
        <td><%= c.getPrice() %> VNĐ</td>
        <td><%= c.getStatus() %></td>
        <td><%= c.getDescription() != null ? c.getDescription() : "---" %></td>
        <td>Chưa có</td> <!-- Có thể thay bằng dữ liệu từ bảng lịch -->
        <td>0</td> <!-- Có thể thay bằng số lượng học viên đăng ký -->
        <td>
            <a href="swimcourse?action=edit&id=<%= c.getId() %>">Sửa</a> |
            <a href="swimcourse?action=delete&id=<%= c.getId() %>"
               onclick="return confirm('Bạn có chắc chắn muốn xóa khóa học này không?');">
                Xóa
            </a>
        </td>
    </tr>
    <% } %>
</table>
</body>
</html>

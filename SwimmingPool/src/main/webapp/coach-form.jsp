<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="model.Coach" %>
<%
    Coach coach = (Coach) request.getAttribute("coach");
    boolean isEdit = coach != null;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= isEdit ? "Chỉnh sửa" : "Thêm" %> Huấn luyện viên</title>
</head>
<body>
<h2><%= isEdit ? "Chỉnh sửa" : "Thêm" %> Huấn luyện viên</h2>
<form action="coach-list" method="post">
    <% if (isEdit) { %>
    <input type="hidden" name="id" value="<%= coach.getId() %>"/>
    <% } %>
    Họ tên: <input type="text" name="fullName" value="<%= isEdit ? coach.getFullName() : "" %>" required/><br/><br/>
    Email: <input type="email" name="email" value="<%= isEdit ? coach.getEmail() : "" %>" required/><br/><br/>
    Số điện thoại: <input type="text" name="phoneNumber" value="<%= isEdit ? coach.getPhone() : "" %>" required/><br/><br/>
    Giới tính:
    <select name="gender" required>
        <option value="Male" <%= isEdit && "Male".equals(coach.getGender()) ? "selected" : "" %>>Nam</option>
        <option value="Female" <%= isEdit && "Female".equals(coach.getGender()) ? "selected" : "" %>>Nữ</option>
        <option value="Other" <%= isEdit && "Other".equals(coach.getGender()) ? "selected" : "" %>>Khác</option>
    </select><br/><br/>
    Tiểu sử:<br/>
    <textarea name="bio" rows="4" cols="40"><%= isEdit ? coach.getBio() : "" %></textarea><br/><br/>
    Ảnh (tên file): <input type="text" name="profilePicture" value="<%= isEdit ? coach.getProfilePicture() : "" %>"/><br/><br/>

    <input type="submit" value="<%= isEdit ? "Cập nhật" : "Thêm mới" %>"/>
</form>
</body>
</html>

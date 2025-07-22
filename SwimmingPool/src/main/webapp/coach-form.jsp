<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="model.Coach" %>
<%
    Coach coach = (Coach) request.getAttribute("coach");
    boolean isEdit = coach != null;
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><%= isEdit ? "Chỉnh sửa" : "Thêm" %> Huấn luyện viên</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f8f9fa;
            padding: 30px;
            margin: 0;
        }

        h2 {
            text-align: center;
            color: #2c3e50;
        }

        form {
            max-width: 600px;
            margin: 0 auto;
            background-color: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
        }

        input[type="text"],
        input[type="email"],
        select,
        textarea {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }

        input[type="file"] {
            margin-top: 5px;
        }

        .checkbox-wrapper {
            margin-top: 15px;
        }

        input[type="checkbox"] {
            margin-right: 5px;
        }

        input[type="submit"] {
            margin-top: 20px;
            padding: 12px 20px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 15px;
        }

        input[type="submit"]:hover {
            background-color: #2980b9;
        }

        .avatar-preview {
            margin-top: 10px;
        }

        .avatar-preview img {
            width: 140px;
            height: 140px;
            border-radius: 8px;
            border: 1px solid #ccc;
            object-fit: cover;
        }

        .back-link {
            display: block;
            margin: 20px auto 0;
            text-align: center;
        }

        .back-link a {
            color: #555;
            text-decoration: none;
            font-size: 14px;
        }

        .back-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<h2><%= isEdit ? "Chỉnh sửa" : "Thêm mới" %> Huấn luyện viên</h2>

<form action="coach-list" method="post" enctype="multipart/form-data">
    <% if (isEdit) { %>
    <input type="hidden" name="id" value="<%= coach.getId() %>"/>
    <% } %>

    <label>Họ tên:</label>
    <input type="text" name="fullName" value="<%= isEdit ? coach.getFullName() : "" %>" required/>

    <label>Email:</label>
    <input type="email" name="email" value="<%= isEdit ? coach.getEmail() : "" %>" required/>

    <label>Số điện thoại:</label>
    <input type="text" name="phoneNumber" value="<%= isEdit ? coach.getPhone() : "" %>" required/>

    <label>Giới tính:</label>
    <select name="gender" required>
        <option value="Male" <%= isEdit && "Male".equals(coach.getGender()) ? "selected" : "" %>>Nam</option>
        <option value="Female" <%= isEdit && "Female".equals(coach.getGender()) ? "selected" : "" %>>Nữ</option>
        <option value="Other" <%= isEdit && "Other".equals(coach.getGender()) ? "selected" : "" %>>Khác</option>
    </select>

    <label>Tiểu sử:</label>
    <textarea name="bio" rows="4"><%= isEdit ? coach.getBio() : "" %></textarea>

    <label>Ảnh đại diện:</label>
    <input type="file" name="profilePicture"/>
    <% if (isEdit && coach.getProfilePicture() != null && !coach.getProfilePicture().isEmpty()) { %>
    <div class="avatar-preview">
        <img src="images/<%= coach.getProfilePicture() %>" alt="Ảnh đại diện hiện tại"/>
    </div>
    <% } %>

    <div class="checkbox-wrapper">
        <label><input type="checkbox" name="active" <%= !isEdit || coach.isActive() ? "checked" : "" %> /> Đang hoạt động</label>
    </div>

    <input type="submit" value="<%= isEdit ? "Cập nhật" : "Thêm mới" %>"/>
</form>

<div class="back-link">
    <a href="coach-list.jsp">← Quay về danh sách</a>
</div>

</body>
</html>

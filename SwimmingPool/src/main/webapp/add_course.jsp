<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, model.Coach" %>
<html>
<head><title>Thêm khóa học</title></head>
<body>
<h2>Thêm khóa học mới</h2>
<form action="admincourse" method="post">
    Tên khóa học: <input type="text" name="name" required><br>
    Mô tả: <textarea name="description" required></textarea><br>
    Giá: <input type="number" name="price" step="0.01" required><br>
    Thời lượng (phút): <input type="number" name="duration" required><br>
    Huấn luyện viên:
    <select name="coachId">
        <%
            List<Coach> list = (List<Coach>) request.getAttribute("coaches");
            for (Coach c : list) {
        %>
        <option value="<%= c.getId() %>"><%= c.getFullName() %></option>
        <% } %>
    </select><br>
    <button type="submit">Tạo khóa học</button>
</form>
</body>
</html>

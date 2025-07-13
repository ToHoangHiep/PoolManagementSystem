<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="model.SwimCourse" %>
<%
  SwimCourse course = (SwimCourse) request.getAttribute("course");
%>
<html>
<head>
  <meta charset="UTF-8">
  <title>Sửa khóa học</title>
</head>
<body>
<h2>Sửa khóa học</h2>
<form method="post" action="swimcourse">
  <input type="hidden" name="id" value="<%= course.getId() %>">
  <label>Tên khóa học: <input type="text" name="name" value="<%= course.getName() %>" required></label><br><br>
  <label>Mô tả: <textarea name="description" required><%= course.getDescription() %></textarea></label><br><br>
  <label>Giá tiền: <input type="number" name="price" value="<%= course.getPrice() %>" required></label><br><br>
  <label>Thời gian dự kiến hoàn thành: <input type="number" name="duration" value="<%= course.getDuration() %>" required></label><br><br>
  <label>Thời lượng học: <input type="text" name="estimatedSessionTime" value="<%= course.getEstimatedSessionTime() %>" required></label><br><br>
  <label>Số lượng học viên: <input type="text" name="studentDescription" value="<%= course.getStudentDescription() %>" required></label><br><br>
  <label>Lịch học: <input type="text" name="scheduleDescription" value="<%= course.getScheduleDescription() %>" required></label><br><br>
  <button type="submit">Cập nhật</button>
  <a href="swimcourse">Hủy</a>
</form>
</body>
</html>

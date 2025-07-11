<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.SwimCourse, model.Coach, java.util.List" %>
<%
  SwimCourse course = (SwimCourse) request.getAttribute("course");
  List<Coach> coaches = (List<Coach>) request.getAttribute("coaches");
%>
<html>
<head><title>Chỉnh sửa khóa học</title></head>
<body>
<h2>Chỉnh sửa thông tin khóa học</h2>
<form action="swimcourse" method="post">
  <input type="hidden" name="id" value="<%= course.getId() %>">

  Tên khóa học: <input type="text" name="name" value="<%= course.getName() %>"><br><br>
  Mô tả: <textarea name="description"><%= course.getDescription() %></textarea><br><br>
  Giá: <input type="number" name="price" value="<%= course.getPrice() %>"><br><br>
  Thời lượng (giờ): <input type="number" name="duration" value="<%= course.getDuration() %>"><br><br>

  Huấn luyện viên:
  <select name="coachId">
    <% for (Coach coach : coaches) { %>
    <option value="<%= coach.getId() %>" <%= coach.getId() == course.getCoachId() ? "selected" : "" %>>
      <%= coach.getFullName() %>
    </option>
    <% } %>
  </select><br><br>

  <input type="submit" value="Cập nhật khóa học">
</form>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, model.Coach" %>
<html>
<head><title>Add Course</title></head>
<body>
<h2>Add New Course</h2>
<form action="swimcourse" method="post">
    Name: <input type="text" name="name" required><br>
    Description: <textarea name="description" required></textarea><br>
    Price: <input type="number" name="price" step="0.01" required><br>
    Duration (minutes): <input type="number" name="duration" required><br>
    Coach:
    <select name="coachId">
        <%
            List<Coach> list = (List<Coach>) request.getAttribute("coaches");
            for (Coach c : list) {
        %>
        <option value="<%= c.getId() %>"><%= c.getFullName() %></option>
        <% } %>
    </select><br>
    <button type="submit">Create Course</button>
</form>
</body>
</html>

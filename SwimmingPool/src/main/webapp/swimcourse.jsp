<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, model.SwimCourse" %>
<html>
<head><title>Admin - Manage Courses</title></head>
<body>
<h2>All Courses</h2>
<a href="swimcourse">Add New Course</a>
<table border="1">
    <tr><th>Name</th><th>Coach</th><th>Status</th><th>Price</th></tr>
    <%
        List<SwimCourse> list = (List<SwimCourse>) request.getAttribute("courses");
        for (SwimCourse c : list) {
    %>
    <tr>
        <td><%= c.getName() %></td>
        <td><%= c.getCoachName() != null ? c.getCoachName() : "---" %></td>
        <td><%= c.getStatus() %></td>
        <td>$<%= c.getPrice() %></td>
    </tr>
    <% } %>
</table>
</body>
</html>

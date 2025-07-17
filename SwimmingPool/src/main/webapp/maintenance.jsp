<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.List" %>
<%@ page import="model.MaintenanceSchedule" %>

<%
  List<MaintenanceSchedule> schedules = (List<MaintenanceSchedule>) request.getAttribute("schedules");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Maintenance Templates</title>
</head>
<body>
<h2>Maintenance Templates</h2>
<a href="MaintenanceServlet?action=showForm">Add Maintenance Task</a>
<br/><br/>

<c:if test="${empty schedules}">
  <p><strong>No maintenance templates found.</strong></p>
</c:if>

<c:if test="${not empty schedules}">
  <table border="1" cellpadding="5">
    <tr>
      <th>ID</th><th>Title</th><th>Frequency</th><th>Description</th>
    </tr>
    <c:forEach var="m" items="${schedules}">
      <tr>
        <td>${m.id}</td>
        <td>${m.title}</td>
        <td>${m.frequency}</td>
        <td>${m.description}</td>
      </tr>
    </c:forEach>
  </table>
</c:if>
</body>
</html>

<%@ page import="java.util.List" %>
<%@ page import="model.MaintenanceSchedule" %>
<%
  List<MaintenanceSchedule> schedules = (List<MaintenanceSchedule>) request.getAttribute("schedules");
%>
<h2>Maintenance Templates</h2>
<a href="MaintenanceServlet?action=showForm">Add Maintenance Task</a>
<table>
  <tr><th>Title</th><th>Freq</th><th>Time</th><th>Creator</th></tr>
  <c:forEach var="m" items="${schedules}">
    <tr>
      <td>${m.title}</td>
      <td>${m.frequency}</td>
      <td>${m.scheduledTime}</td>
      <td>${m.createdByName}</td>
    </tr>
  </c:forEach>
</table>

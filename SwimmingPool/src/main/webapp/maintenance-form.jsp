<%@ page import="java.util.List" %>
<%@ page import="model.MaintenanceSchedule, model.PoolArea, model.User" %>
<%
  List<MaintenanceSchedule> templates = (List<MaintenanceSchedule>) request.getAttribute("templates");
  List<PoolArea> areas = (List<PoolArea>) request.getAttribute("areas");
  List<User> staffs = (List<User>) request.getAttribute("staffs");
%>
<h2>Create Maintenance Task</h2>
<form action="MaintenanceServlet" method="post">
  <input type="hidden" name="action" value="create"/>
  Template:
  <select name="templateId">
    <c:forEach var="t" items="${templates}">
      <option value="${t.id}">${t.title} (${t.frequency})</option>
    </c:forEach>
  </select><br/>
  Area:
  <select name="areaId">
    <c:forEach var="a" items="${areas}">
      <option value="${a.id}">${a.name}</option>
    </c:forEach>
  </select><br/>
  Staff:
  <select name="staffId">
    <c:forEach var="u" items="${staffs}">
      <option value="${u.id}">${u.fullName}</option>
    </c:forEach>
  </select><br/>
  <button type="submit">Assign</button>
</form>

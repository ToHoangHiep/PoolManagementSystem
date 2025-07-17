<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.List,model.PoolArea,model.User" %>

<%
  List<PoolArea> areas = (List<PoolArea>) request.getAttribute("areas");
  User user = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Request Repair</title>
</head>
<body>
<h2>Request Repair</h2>
<form action="MaintenanceServlet" method="post">
  <input type="hidden" name="action" value="request"/>
  <input type="hidden" name="createdBy" value="${user.id}"/>

  <label>Area:</label>
  <select name="areaId" required>
    <c:forEach var="a" items="${areas}">
      <option value="${a.id}">${a.name}</option>
    </c:forEach>
  </select><br/><br/>

  <label>Description:</label><br/>
  <textarea name="description" rows="4" cols="50" required></textarea><br/><br/>

  <button type="submit">Send Request</button>
</form>
</body>
</html>

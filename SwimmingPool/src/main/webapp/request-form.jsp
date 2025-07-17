<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.PoolArea" %>
<%@ page import="model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  // Lấy danh sách khu vực và user từ session
  List<PoolArea> areas = (List<PoolArea>) request.getAttribute("areas");
  User user = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Request Repair</title>
  <link rel="stylesheet" href="Resources/CSS/style.css">
</head>
<body>
<h2>Request Repair</h2>
<form action="MaintenanceServlet" method="post">
  <input type="hidden" name="action" value="request"/>
  <!-- Staff không cần gửi createdBy, lấy từ session trong Servlet -->

  <label for="areaId">Area:</label>
  <select name="areaId" id="areaId">
    <c:forEach var="a" items="${areas}">
      <option value="${a.id}">${a.name}</option>
    </c:forEach>
  </select><br/><br/>

  <label for="description">Description:</label><br/>
  <textarea name="description" id="description" rows="4" cols="50"></textarea><br/><br/>

  <button type="submit">Send Request</button>
</form>
</body>
</html>

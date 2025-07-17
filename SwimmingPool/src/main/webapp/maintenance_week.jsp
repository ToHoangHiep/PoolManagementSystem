<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.MaintenanceSchedule" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
  MaintenanceSchedule schedule = (MaintenanceSchedule) request.getAttribute("schedule");
  Map<String, Boolean> dailyStatus = (Map<String, Boolean>) request.getAttribute("dailyStatus");
  String weekStatus = (String) request.getAttribute("weekStatus");
  String error = (String) request.getAttribute("error");

  Calendar cal = Calendar.getInstance();
  int today = cal.get(Calendar.DAY_OF_WEEK); // 1 (Sunday) to 7 (Saturday)
  String[] days = {"Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"};
%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Maintenance Week View</title>
  <style>
    table { width: 70%; margin: auto; border-collapse: collapse; }
    th, td { padding: 12px; text-align: center; border: 1px solid #ddd; }
    .btn { padding: 10px 20px; margin: 20px auto; display: block; background-color: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer; }
    .btn[disabled] { background-color: gray; }
    .error { color: red; text-align: center; margin-top: 10px; }
  </style>
</head>
<body>
<h2 style="text-align:center">Maintenance Week View</h2>
<h3 style="text-align:center">Schedule: <%= schedule.getTitle() %> - <%= schedule.getDescription() %></h3>

<!-- Hiển thị lỗi nếu có -->
<c:if test="${not empty error}">
  <div class="error">${error}</div>
</c:if>

<form action="MaintenanceServlet" method="post" style="width:80%; margin:auto; text-align:center;">
  <input type="hidden" name="action" value="submitWeekStatus" />
  <input type="hidden" name="scheduleId" value="<%= schedule.getId() %>" />
  <input type="hidden" name="areaId" value="<%= schedule.getPoolAreaId() %>" />

  <table>
    <tr>
      <th>Day</th>
      <th>Completed</th>
    </tr>
    <% for (int i = 1; i <= 7; i++) {
      String dayName = days[(i - 1)];
      boolean checked = dailyStatus != null && Boolean.TRUE.equals(dailyStatus.get(dayName));
      boolean isToday = (i == today);
    %>
    <tr>
      <td><%= dayName %></td>
      <td>
        <input type="checkbox" name="completedDays" value="<%= dayName %>"
                <%= checked ? "checked" : "" %>
                <%= (!isToday && !checked) ? "disabled" : "" %> />
      </td>
    </tr>
    <% } %>
  </table>

  <p style="text-align:center;">Status: <strong><%= weekStatus %></strong></p>
  <button type="submit" class="btn" <%= !"Doing".equals(weekStatus) ? "disabled" : "" %>>
    Submit Today
  </button>
</form>
</body>
</html>

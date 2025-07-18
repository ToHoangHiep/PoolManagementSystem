<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.MaintenanceSchedule, java.util.*, java.time.*" %>
<jsp:useBean id="schedule" type="model.MaintenanceSchedule" scope="request"/>
<jsp:useBean id="dailyStatus" type="java.util.Map" scope="request"/>
<jsp:useBean id="weekStatus" type="java.lang.String" scope="request"/>
<jsp:useBean id="areaId" type="java.lang.Integer" scope="request"/>
<%
  LocalDate today = LocalDate.now();
  LocalDate startOfWeek = today.with(DayOfWeek.MONDAY);
%>

<html>
<head>
  <title>Chi tiết bảo trì tuần</title>
</head>
<body>
<h2>Chi tiết lịch bảo trì tuần</h2>

<p><strong>Công việc:</strong> <%= schedule.getTitle() %></p>
<p><strong>Mô tả:</strong> <%= schedule.getDescription() %></p>
<p><strong>Tần suất:</strong> <%= schedule.getFrequency() %></p>
<p><strong>Thời gian:</strong> <%= schedule.getScheduledTime() %></p>
<p><strong>Trạng thái tuần:</strong> <%= weekStatus %></p>

<form method="post" action="MaintenanceServlet">
  <input type="hidden" name="action" value="submitWeekStatus"/>
  <input type="hidden" name="scheduleId" value="<%= schedule.getId() %>"/>
  <input type="hidden" name="areaId" value="<%= areaId %>"/>

  <table border="1" cellpadding="5">
    <tr>
      <th>Thứ</th>
      <th>Ngày</th>
      <th>Hoàn thành</th>
    </tr>
    <%
      for (int i = 0; i < 7; i++) {
        LocalDate day = startOfWeek.plusDays(i);
        String dayName = day.getDayOfWeek().getDisplayName(java.time.format.TextStyle.FULL, new java.util.Locale("vi"));
        String dateStr = day.toString(); // yyyy-MM-dd
        Boolean checked = (Boolean) dailyStatus.getOrDefault(day.getDayOfWeek().toString(), false);

    %>
    <tr>
      <td><%= dayName %></td>
      <td><%= dateStr %></td>
      <td>
        <input type="checkbox" name="dates" value="<%= dateStr %>"
                <%= checked ? "checked disabled" : "" %>
                <%= day.isAfter(today) ? "disabled" : "" %> />
      </td>
    </tr>
    <% } %>
  </table>

  <br/>
  <input type="submit" value="Gửi cập nhật tuần này"/>
</form>

<% if (request.getAttribute("error") != null) { %>
<p style="color:red;"><%= request.getAttribute("error") %></p>
<% } %>

</body>
</html>

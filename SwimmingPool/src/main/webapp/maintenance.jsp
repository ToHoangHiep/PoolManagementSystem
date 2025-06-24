<%@ page import="java.util.List" %>
<%@ page import="model.MaintenanceSchedule" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
  List<MaintenanceSchedule> schedules = (List<MaintenanceSchedule>) request.getAttribute("schedules");
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Maintenance Schedule</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f9ff;
      padding: 40px;
    }

    h2 {
      color: #005caa;
      text-align: center;
      margin-bottom: 30px;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      background: white;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }

    th, td {
      padding: 12px 15px;
      border-bottom: 1px solid #e0e0e0;
      text-align: left;
    }

    th {
      background-color: #005caa;
      color: white;
    }

    tr:hover {
      background-color: #f1f7ff;
    }

    .status {
      padding: 4px 8px;
      border-radius: 4px;
      font-size: 13px;
      font-weight: bold;
    }

    .Scheduled { background-color: #fff3cd; color: #856404; }
    .Completed { background-color: #d4edda; color: #155724; }
    .Missed { background-color: #f8d7da; color: #721c24; }
  </style>
</head>
<body>

<h2>Daily Maintenance Schedule</h2>

<table>
  <tr>
    <th>ID</th>
    <th>Title</th>
    <th>Description</th>
    <th>Frequency</th>
    <th>Scheduled Time</th>
    <th>Status</th>
  </tr>

  <%
    if (schedules != null && !schedules.isEmpty()) {
      for (MaintenanceSchedule m : schedules) {
  %>
  <tr>
    <td><%= m.getId() %></td>
    <td><%= m.getTitle() %></td>
    <td><%= m.getDescription() %></td>
    <td><%= m.getFrequency() %></td>
    <td><%= m.getScheduledTime() %></td>
    <td><span class="status <%= m.getStatus() %>"><%= m.getStatus() %></span></td>
  </tr>
  <%
    }
  } else {
  %>
  <tr>
    <td colspan="6" style="text-align:center;">No maintenance schedule found.</td>
  </tr>
  <% } %>

</table>

</body>
</html>

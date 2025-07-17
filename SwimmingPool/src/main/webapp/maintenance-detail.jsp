<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat, model.MaintenanceLog, model.MaintenanceSchedule" %>

<%
    MaintenanceSchedule sch = (MaintenanceSchedule) request.getAttribute("schedule");
    List<MaintenanceLog> weekLogs = (List<MaintenanceLog>) request.getAttribute("weekLogs");

    SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");
    String today = fmt.format(new java.util.Date());

    // map trước các ngày đã có log
    Map<String,String> statusMap = new HashMap<>();
    for (MaintenanceLog log : weekLogs) {
        statusMap.put(fmt.format(log.getMaintenanceDate()), log.getStatus());
    }

    // build danh sách 7 ngày Mon→Sun
    Calendar cal = Calendar.getInstance();
    int dow = cal.get(Calendar.DAY_OF_WEEK);
    cal.add(Calendar.DATE, (dow == Calendar.SUNDAY ? -6 : Calendar.MONDAY - dow));
    List<String> week = new ArrayList<>();
    for(int i=0;i<7;i++){
        week.add(fmt.format(cal.getTime()));
        cal.add(Calendar.DATE,1);
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head><meta charset="UTF-8"><title>Week Detail</title></head>
<body>
<h2>Task: <%= sch.getTitle() %></h2>
<p><%= sch.getDescription() %></p>

<form action="MaintenanceServlet" method="post">
    <input type="hidden" name="action" value="completeWeek"/>
    <input type="hidden" name="scheduleId" value="<%= sch.getId() %>"/>
    <input type="hidden" name="areaId" value="<%= sch.getPoolAreaId() %>"/>

    <table border="1" cellpadding="5">
        <tr>
            <% for (String d : week) { %>
            <th><%= d.substring(5) %></th>
            <% } %>
        </tr>
        <tr>
            <% for (String d : week) { %>
            <td style="text-align:center;">
                <% if (statusMap.containsKey(d)) { %>
                <!-- Đã log trước đó -->
                <input type="checkbox" checked disabled/>
                <% } else if (d.equals(today)) { %>
                <!-- Hôm nay, cho phép check -->
                <input type="checkbox" name="dates" value="<%=d%>"/>
                <% } else { %>
                <!-- Các ngày khác không cho check -->
                <input type="checkbox" disabled/>
                <% } %>
            </td>
            <% } %>
        </tr>
    </table>
    <br/>
    <button type="submit">Submit Week</button>
</form>
</body>
</html>

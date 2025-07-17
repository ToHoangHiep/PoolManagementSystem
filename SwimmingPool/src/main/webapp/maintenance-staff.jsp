<%@ page import="java.util.List" %>
<%@ page import="model.MaintenanceLog" %>
<%
    List<MaintenanceLog> logs = (List<MaintenanceLog>) request.getAttribute("logs");
%>
<h2>My Maintenance Tasks</h2>
<table>
    <tr><th>Date</th><th>Task</th><th>Area</th><th>Status</th><th>Action</th></tr>
    <c:forEach var="l" items="${logs}">
        <tr>
            <td>${l.maintenanceDate}</td>
            <td>${l.scheduleTitle}</td>
            <td>${l.areaName}</td>
            <td>${l.status}</td>
            <td>
                <c:if test="${l.status != 'Done'}">
                    <form action="MaintenanceServlet" method="post">
                        <input type="hidden" name="action" value="complete"/>
                        <input type="hidden" name="logId" value="${l.id}"/>
                        <button type="submit">Mark Done</button>
                    </form>
                </c:if>
            </td>
        </tr>
    </c:forEach>
</table>
<a href="MaintenanceServlet?action=showRequestForm">Request Repair</a>

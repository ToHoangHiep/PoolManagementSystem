<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.List, model.MaintenanceSchedule, model.MaintenanceRequest, model.User" %>
<%
  List<MaintenanceSchedule> schedules = (List<MaintenanceSchedule>) request.getAttribute("schedules");
  List<MaintenanceRequest> requests  = (List<MaintenanceRequest>) request.getAttribute("requests");
  List<User> staffs = (List<User>) request.getAttribute("staffs");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Maintenance Dashboard</title>
  <style>
    .section { margin-bottom: 40px; }
    table { width:100%; border-collapse: collapse; }
    th, td { border:1px solid #ccc; padding:8px; text-align: center; }
    th { background:#f0f0f0; }
    .btn-accept { background:green; color:white; border:none; padding:6px 10px; cursor:pointer; }
    .btn-reject { background:red; color:white; border:none; padding:6px 10px; cursor:pointer; }
    .status-open { color: orange; font-weight: bold; }
    select.staff-select { margin-right: 8px; }
  </style>
</head>
<body>
<h1>Maintenance Dashboard</h1>

<!-- Section: Templates -->
<div class="section">
  <h2>Maintenance Templates</h2>
  <a href="MaintenanceServlet?action=showForm">➕ Add Maintenance Task</a>
  <c:if test="${empty schedules}">
    <p><strong>No maintenance templates found.</strong></p>
  </c:if>
  <c:if test="${not empty schedules}">
    <table>
      <tr><th>ID</th><th>Title</th><th>Frequency</th><th>Description</th></tr>
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
</div>

<!-- Section: Requests -->
<div class="section">
  <h2>Danh sách Yêu cầu Bảo trì</h2>
  <c:if test="${empty requests}">
    <p><strong>Không có yêu cầu bảo trì nào.</strong></p>
  </c:if>
  <c:if test="${not empty requests}">
    <table>
      <tr>
        <th>ID</th>
        <th>Người gửi</th>
        <th>Khu vực</th>
        <th>Mô tả</th>
        <th>Trạng thái</th>
        <th>Ngày tạo</th>
        <th>Hành động</th>
      </tr>
      <c:forEach var="r" items="${requests}">
        <tr>
          <td>${r.id}</td>
          <td>${r.createdByName}</td>
          <td>${r.poolAreaName}</td>
          <td>${r.description}</td>
          <td>
            <c:choose>
              <c:when test="${r.status == 'Open'}">
                <span class="status-open">⏳ Open</span>
              </c:when>
              <c:otherwise>${r.status}</c:otherwise>
            </c:choose>
          </td>
          <td><fmt:formatDate value="${r.createdAt}" pattern="dd-MM-yyyy HH:mm"/></td>
          <td>
            <c:choose>
              <c:when test="${r.status == 'Open'}">
                <form action="MaintenanceServlet" method="post" style="display:inline-block; margin-right:5px;">
                  <input type="hidden" name="action" value="acceptRequest"/>
                  <input type="hidden" name="id" value="${r.id}"/>
                  <select name="staffId" class="staff-select" required>
                    <option value="">Chọn nhân viên</option>
                    <c:forEach var="s" items="${staffs}">
                      <option value="${s.id}">${s.fullName}</option>
                    </c:forEach>
                  </select>
                  <button type="submit" class="btn-accept">✔ Chấp nhận</button>
                </form>
                <form action="MaintenanceServlet" method="post" style="display:inline-block;">
                  <input type="hidden" name="action" value="rejectRequest"/>
                  <input type="hidden" name="id" value="${r.id}"/>
                  <button type="submit" class="btn-reject">✖ Từ chối</button>
                </form>
              </c:when>

              <c:when test="${r.status == 'In Progress'}">
                Đã giao cho nhân viên
              </c:when>

              <c:when test="${r.status == 'Rejected'}">
                Đã từ chối
              </c:when>

              <c:otherwise>
                ${r.status}
              </c:otherwise>
            </c:choose>

          </td>
        </tr>
      </c:forEach>
    </table>
  </c:if>
</div>
</body>
</html>

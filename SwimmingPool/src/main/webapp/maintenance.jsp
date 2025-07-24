<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.List, model.MaintenanceSchedule, model.MaintenanceRequest, model.User, model.MaintenanceLog" %>
<%
  // Existing attributes
  List<MaintenanceSchedule> schedules = (List<MaintenanceSchedule>) request.getAttribute("schedules");
  List<MaintenanceRequest> requests = (List<MaintenanceRequest>) request.getAttribute("requests");
  List<User> staffs = (List<User>) request.getAttribute("staffs");
  // NEW: Get the list of all maintenance logs for Admin/Manager
  List<MaintenanceLog> allMaintenanceLogs = (List<MaintenanceLog>) request.getAttribute("allMaintenanceLogs");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Maintenance Dashboard</title>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
  <style>
    /* Global Variables */
    :root {
      --primary-color: #007bff;
      --secondary-color: #6c757d;
      --success-color: #28a745;
      --warning-color: #ffc107;
      --danger-color: #dc3545;
      --info-color: #17a2b8;
      --bg-light: #f8f9fa;
      --text-dark: #343a40;
      --border-color: #dee2e6;
      --shadow-light: rgba(0, 0, 0, 0.08);
      --shadow-medium: rgba(0, 0, 0, 0.15);
    }

    /* Base Styles */
    body {
      font-family: 'Roboto', sans-serif;
      margin: 0;
      padding: 20px;
      background-color: var(--bg-light);
      color: var(--text-dark);
      line-height: 1.6;
    }

    .container {
      max-width: 1200px;
      margin: 20px auto;
      background: white;
      padding: 30px;
      border-radius: 12px;
      box-shadow: 0 6px 20px var(--shadow-light);
    }

    /* Header Section */
    .dashboard-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 30px;
      padding-bottom: 15px;
      border-bottom: 2px solid var(--border-color);
    }

    h1 {
      color: var(--primary-color);
      font-size: 2.2em;
      margin: 0;
      display: flex;
      align-items: center;
    }

    h1 .icon {
      margin-right: 15px;
      font-size: 1.2em;
      color: #4a90e2; /* A slightly different blue for icon */
    }

    h2 {
      color: var(--primary-color);
      font-size: 1.6em;
      margin-top: 35px;
      margin-bottom: 20px;
      padding-bottom: 8px;
      border-bottom: 1px dashed var(--border-color);
    }

    /* Buttons */
    .btn {
      display: inline-flex;
      align-items: center;
      padding: 10px 20px;
      font-size: 1em;
      font-weight: 500;
      color: white;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      text-decoration: none;
      transition: background-color 0.3s ease, transform 0.2s ease;
      box-shadow: 0 2px 5px var(--shadow-light);
      white-space: nowrap; /* Prevent text wrapping */
      gap: 8px; /* Space between icon and text */
    }

    .btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 10px var(--shadow-medium);
    }

    .btn-primary { background-color: var(--primary-color); }
    .btn-primary:hover { background-color: #0056b3; }

    .btn-success { background-color: var(--success-color); }
    .btn-success:hover { background-color: #218838; }

    .btn-danger { background-color: var(--danger-color); }
    .btn-danger:hover { background-color: #c82333; }

    .btn-secondary { background-color: var(--secondary-color); }
    .btn-secondary:hover { background-color: #5a6268; }

    .btn-icon {
      line-height: 1; /* Ensure icon doesn't take extra vertical space */
      flex-shrink: 0;
    }

    .action-row {
      display: flex;
      gap: 15px;
      margin-bottom: 25px;
      flex-wrap: wrap; /* Allow wrapping on small screens */
    }

    /* Table Styles */
    table {
      width: 100%;
      border-collapse: separate;
      border-spacing: 0;
      margin-top: 20px;
      border-radius: 10px;
      overflow: hidden;
      box-shadow: 0 4px 12px var(--shadow-light);
    }

    th, td {
      border: 1px solid var(--border-color);
      padding: 12px 15px;
      text-align: left;
    }

    th {
      background-color: #e9ecef;
      color: var(--text-dark);
      font-weight: 600;
      text-transform: uppercase;
      font-size: 0.9em;
    }

    tr:nth-child(even) {
      background-color: #f6f9fc;
    }

    tr:hover {
      background-color: #e0f2f7;
      transition: background-color 0.2s ease;
    }

    /* Status Badges */
    .status-badge {
      display: inline-block;
      padding: 5px 10px;
      border-radius: 20px;
      font-weight: 500;
      font-size: 0.85em;
      text-transform: uppercase;
    }

    .status-open, .status-processing { /* Added status-processing for consistency */
      background-color: #fff3cd;
      color: var(--warning-color);
      border: 1px solid var(--warning-color);
    }
    .status-in-progress, .status-pending { /* Added status-pending for consistency */
      background-color: #e7f3ff;
      color: var(--primary-color);
      border: 1px solid var(--primary-color);
    }
    .status-rejected {
      background-color: #f8d7da;
      color: var(--danger-color);
      border: 1px solid var(--danger-color);
    }
    .status-completed, .status-done, .status-transferred { /* For cases like 'Done' or 'Accepted' after conversion */
      background-color: #d4edda;
      color: var(--success-color);
      border: 1px solid var(--success-color);
    }


    /* Form Elements in Table */
    .action-buttons form {
      display: flex; /* Use flex for alignment of select and button */
      align-items: center;
      gap: 5px; /* Space between select and button */
      margin: 5px 0; /* Adjust margin for forms */
    }

    select.staff-select {
      padding: 8px 10px;
      border: 1px solid var(--border-color);
      border-radius: 5px;
      font-size: 0.9em;
      min-width: 150px; /* Ensure select box has a decent width */
      background-color: white;
      color: var(--text-dark);
    }

    select.staff-select:focus {
      outline: none;
      border-color: var(--primary-color);
      box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.25);
    }

    /* Responsive Design */
    @media (max-width: 768px) {
      .container {
        padding: 15px;
      }
      .dashboard-header {
        flex-direction: column;
        align-items: flex-start;
      }
      .dashboard-header h1 {
        margin-bottom: 20px;
      }
      h1 {
        font-size: 1.8em;
      }
      h2 {
        font-size: 1.4em;
      }
      .btn {
        padding: 8px 15px;
        font-size: 0.9em;
      }
      .action-row {
        flex-direction: column;
        gap: 10px;
      }
      table, th, td {
        display: block;
        width: 100%;
      }
      thead {
        display: none;
      }
      tr {
        margin-bottom: 15px;
        border: 1px solid var(--border-color);
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 2px 8px var(--shadow-light);
      }
      td {
        border: none;
        border-bottom: 1px solid var(--border-color);
        position: relative;
        padding-left: 50%;
        text-align: right;
      }
      td:last-child {
        border-bottom: none;
      }
      td::before {
        content: attr(data-label);
        position: absolute;
        left: 10px;
        width: 45%;
        padding-right: 10px;
        white-space: nowrap;
        text-align: left;
        font-weight: 600;
        color: var(--primary-color);
      }
      .action-buttons form {
        flex-direction: column;
        align-items: flex-end;
        gap: 8px;
      }
      select.staff-select {
        width: 100%; /* Full width on small screens */
      }
    }
  </style>
</head>
<body>

<div class="container">
  <div class="dashboard-header">
    <h1><span class="icon">🛠️</span> Bảng điều khiển bảo trì</h1>
    <a href="admin_dashboard.jsp" class="btn btn-secondary">
      <span class="btn-icon">🏠</span> Về Trang Chủ
    </a>
  </div>

  <div class="section">
    <h2><span class="icon">📋</span> Tạo Công Việc Bảo Trì</h2>
    <div class="action-row">
      <a href="MaintenanceServlet?action=showForm" class="btn btn-primary">
        <span class="btn-icon">➕</span> Thêm Công Việc Bảo Trì Mới
      </a>
    </div>
  </div>

  <div class="section">
    <h2><span class="icon">🔔</span> Danh sách Yêu cầu Bảo trì</h2>
    <c:choose>
      <c:when test="${empty requests}">
        <p><strong>Không có yêu cầu bảo trì nào.</strong></p>
      </c:when>
      <c:otherwise>
        <table>
          <thead>
          <tr>
            <th>ID</th>
            <th>Người gửi</th>
            <th>Khu vực</th>
            <th>Mô tả</th>
            <th>Trạng thái</th>
            <th>Ngày tạo</th>
            <th>Hành động</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="r" items="${requests}">
            <tr>
              <td data-label="ID">${r.id}</td>
              <td data-label="Người gửi">${r.createdByName}</td>
              <td data-label="Khu vực">${r.poolAreaName}</td>
              <td data-label="Mô tả">${r.description}</td>
              <td data-label="Trạng thái">
                <c:choose>
                  <c:when test="${r.status == 'Open'}">
                    <span class="status-badge status-open">⏳ Mở</span>
                  </c:when>
                  <c:when test="${r.status == 'Transferred'}"> <%-- Changed from 'In Progress' to 'Transferred' as per DAO logic --%>
                    <span class="status-badge status-completed">✅ Đã chấp nhận</span> <%-- Display as accepted --%>
                  </c:when>
                  <c:when test="${r.status == 'Rejected'}">
                    <span class="status-badge status-rejected">❌ Đã từ chối</span>
                  </c:when>
                  <c:otherwise>
                    <span class="status-badge status-info">${r.status}</span> <%-- Fallback for other statuses --%>
                  </c:otherwise>
                </c:choose>
              </td>
              <td data-label="Ngày tạo"><fmt:formatDate value="${r.createdAt}" pattern="dd-MM-yyyy HH:mm"/></td>
              <td data-label="Hành động" class="action-buttons">
                <c:choose>
                  <c:when test="${r.status == 'Open'}">
                    <form action="MaintenanceServlet" method="post">
                      <input type="hidden" name="action" value="acceptRequest"/>
                      <input type="hidden" name="id" value="${r.id}"/>
                      <select name="staffId" class="staff-select" required>
                        <option value="">Chọn nhân viên</option>
                        <c:forEach var="s" items="${staffs}">
                          <option value="${s.id}">${s.fullName}</option>
                        </c:forEach>
                      </select>
                      <button type="submit" class="btn btn-success">✔ Chấp nhận</button>
                    </form>
                    <form action="MaintenanceServlet" method="post">
                      <input type="hidden" name="action" value="rejectRequest"/>
                      <input type="hidden" name="id" value="${r.id}"/>
                      <button type="submit" class="btn btn-danger">✖ Từ chối</button>
                    </form>
                  </c:when>
                  <c:when test="${r.status == 'Transferred'}"> <%-- Changed from 'In Progress' to 'Transferred' --%>
                    <span style="color: var(--success-color); font-weight: 500;">Đã chấp nhận & giao việc</span>
                  </c:when>
                  <c:when test="${r.status == 'Rejected'}">
                    <span style="color: var(--danger-color); font-weight: 500;">Đã từ chối</span>
                  </c:when>
                  <c:otherwise>
                    <span>${r.status}</span>
                  </c:otherwise>
                </c:choose>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </c:otherwise>
    </c:choose>
  </div>

  <%-- NEW SECTION: All Maintenance Logs for Admin/Manager --%>
  <div class="section">
    <h2><span class="icon">📊</span> Tất cả Công việc Bảo trì</h2>
    <c:choose>
      <c:when test="${empty allMaintenanceLogs}">
        <p><strong>Chưa có công việc bảo trì nào được ghi nhận.</strong></p>
      </c:when>
      <c:otherwise>
        <table>
          <thead>
          <tr>
            <th>ID Log</th>
            <th>Tiêu đề công việc</th>
            <th>Khu vực</th>
            <th>Ngày bảo trì</th>
            <th>Nhân viên thực hiện</th>
            <th>Trạng thái</th>
              <%-- Cột "Ghi chú" đã bị loại bỏ --%>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="log" items="${allMaintenanceLogs}">
            <tr>
              <td data-label="ID Log">${log.id}</td>
              <td data-label="Tiêu đề công việc">${log.scheduleTitle} (${log.frequency})</td>
              <td data-label="Khu vực">${log.areaName}</td>
              <td data-label="Ngày bảo trì"><fmt:formatDate value="${log.maintenanceDate}" pattern="dd-MM-yyyy"/></td>
              <td data-label="Nhân viên thực hiện">${log.staffName}</td>
              <td data-label="Trạng thái">
                <c:choose>
                  <c:when test="${log.status == 'Pending'}">
                    <span class="status-badge status-pending">Đang chờ</span>
                  </c:when>
                  <c:when test="${log.status == 'Done'}">
                    <span class="status-badge status-done">Hoàn thành</span>
                  </c:when>
                  <c:when test="${log.status == 'Missed'}">
                    <span class="status-badge status-rejected">Đang chờ</span>
                  </c:when>
                  <c:otherwise>
                    <span class="status-badge status-info">${log.status}</span>
                  </c:otherwise>
                </c:choose>
              </td>
                <%-- Ô dữ liệu cho "Ghi chú" cũng đã bị loại bỏ --%>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </c:otherwise>
    </c:choose>
  </div>

</div>
</body>
</html>
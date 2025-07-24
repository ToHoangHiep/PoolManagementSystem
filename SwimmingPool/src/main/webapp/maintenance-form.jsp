<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.MaintenanceSchedule, model.PoolArea, model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
  List<MaintenanceSchedule> templates = (List<MaintenanceSchedule>) request.getAttribute("templates");
  List<PoolArea> areas = (List<PoolArea>) request.getAttribute("areas");
  List<User> staffs = (List<User>) request.getAttribute("staffs");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Create Maintenance Task</title>
  <link rel="stylesheet" href="Resources/CSS/style.css">
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 20px;
    }
    .container {
      max-width: 700px;
      margin: auto;
      padding: 20px;
      background: #f9f9f9;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    h2 { text-align: center; margin-bottom: 20px; }
    .btn {
      display: inline-block;
      padding: 8px 16px;
      margin: 10px 0;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      text-decoration: none;
      color: white;
    }
    .btn-back { background: #6c757d; }
    .btn-create { background: #28a745; float: right; }
    .form-row {
      display: flex;
      flex-wrap: wrap;
      margin-bottom: 16px;
    }
    .form-row label {
      width: 150px;
      padding: 6px 0;
    }
    .form-row .input-wrap {
      flex: 1;
    }
    input[type=text], input[type=time], select, textarea {
      width: 100%;
      padding: 8px;
      border: 1px solid #ccc;
      border-radius: 4px;
      box-sizing: border-box;
    }
    @media (max-width: 600px) {
      .form-row { flex-direction: column; }
      .form-row label { width: 100%; padding-bottom: 4px; }
    }
  </style>
</head>
<body>
<div class="container">
  <h2>Tạo nhiệm vụ bảo trì</h2>
  <a href="MaintenanceServlet?action=list" class="btn btn-back">Quay lại trang bảo trì</a>

  <form action="MaintenanceServlet" method="post">
    <input type="hidden" name="action" value="create"/>

    <div class="form-row">
      <label for="templateId">Sử dụng mẫu:</label>
      <div class="input-wrap">
        <select name="templateId" id="templateId">
          <option value="">-- None --</option>
          <c:forEach var="t" items="${templates}">
            <option value="${t.id}"
                    data-title="${t.title}"
                    data-description="${t.description}"
                    data-frequency="${t.frequency}"
                    data-time="${t.scheduledTime}">
                ${t.title} (${t.frequency} @ ${t.scheduledTime})
            </option>
          </c:forEach>
        </select>
      </div>
    </div>

    <div class="form-row">
      <label for="title">Tiêu đề:</label>
      <div class="input-wrap">
        <input type="text" name="title" id="title" required/>
      </div>
    </div>

    <div class="form-row">
      <label for="description">Mô tả:</label>
      <div class="input-wrap">
        <textarea name="description" id="description" rows="4" required></textarea>
      </div>
    </div>

    <div class="form-row">
      <label for="frequency">Tần suất:</label>
      <div class="input-wrap">
        <select name="frequency" id="frequency" required>
          <option value="Daily">Daily</option>
          <option value="Weekly">Weekly</option>
          <option value="Monthly">Monthly</option>
        </select>
      </div>
    </div>

    <div class="form-row">
      <label for="scheduledTime">Thời gian làm:</label>
      <div class="input-wrap">
        <input type="time" name="scheduledTime" id="scheduledTime" required/>
      </div>
    </div>

    <div class="form-row">
      <label for="areaId">Khu vực:</label>
      <div class="input-wrap">
        <select name="areaId" id="areaId" required>
          <c:forEach var="a" items="${areas}">
            <option value="${a.id}">${a.name}</option>
          </c:forEach>
        </select>
      </div>
    </div>

    <div class="form-row">
      <label for="staffId">Giao cho nhân viên:</label>
      <div class="input-wrap">
        <select name="staffId" id="staffId" required>
          <c:forEach var="u" items="${staffs}">
            <option value="${u.id}">${u.fullName}</option>
          </c:forEach>
        </select>
      </div>
    </div>

    <button type="submit" class="btn btn-create">Tạo lịch trình</button>
  </form>
</div>

<script>
  const templateSel = document.getElementById('templateId');
  const titleInput = document.getElementById('title');
  const descInput = document.getElementById('description');
  const freqSel = document.getElementById('frequency');
  const timeInput = document.getElementById('scheduledTime');

  templateSel.addEventListener('change', function() {
    const opt = this.options[this.selectedIndex];
    if (opt.value) {
      titleInput.value = opt.dataset.title || '';
      descInput.value = opt.dataset.description || '';
      freqSel.value = opt.dataset.frequency || 'Daily';
      timeInput.value = opt.dataset.time || '';
      titleInput.readOnly = true;
      descInput.readOnly = true;
    } else {
      titleInput.value = '';
      descInput.value = '';
      freqSel.value = 'Daily';
      timeInput.value = '';
      titleInput.readOnly = false;
      descInput.readOnly = false;
    }
  });
</script>
</body>
</html>

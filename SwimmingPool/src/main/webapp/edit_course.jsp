<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="model.SwimCourse" %>
<%
  SwimCourse course = (SwimCourse) request.getAttribute("course");
%>
<html>
<head>
  <meta charset="UTF-8">
  <title>Sửa khóa học</title>
  <style>
    body {
      font-family: 'Segoe UI', Tahoma, sans-serif;
      background-color: #f0f2f5;
      margin: 0;
      padding: 0;
    }

    .header {
      padding: 15px 25px;
      background-color: #2ecc71;
      display: flex;
      justify-content: flex-start;
      align-items: center;
      box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
    }

    .header a {
      text-decoration: none;
      color: white;
      font-weight: bold;
      font-size: 16px;
      background-color: #27ae60;
      padding: 10px 20px;
      border-radius: 6px;
      transition: 0.2s ease-in-out;
    }

    .header a:hover {
      background-color: #219150;
    }

    h2 {
      text-align: center;
      margin-top: 30px;
      color: #2c3e50;
    }

    .form-container {
      background-color: #ffffff;
      max-width: 700px;
      margin: 20px auto;
      padding: 35px;
      border-radius: 12px;
      box-shadow: 0 6px 20px rgba(0,0,0,0.1);
    }

    label {
      display: block;
      margin-bottom: 15px;
      font-weight: 600;
      color: #34495e;
    }

    input[type="text"],
    input[type="number"],
    textarea {
      width: 100%;
      padding: 12px 14px;
      border: 1px solid #ccc;
      border-radius: 8px;
      margin-top: 6px;
      box-sizing: border-box;
      font-size: 14px;
    }

    textarea {
      height: 90px;
    }

    .button-group {
      display: flex;
      justify-content: space-between;
      margin-top: 30px;
    }

    .button-group a,
    .button-group button {
      padding: 12px 24px;
      text-decoration: none;
      border: none;
      border-radius: 6px;
      font-size: 15px;
      cursor: pointer;
      color: white;
      transition: 0.2s ease-in-out;
    }

    .btn-home {
      background-color: #2ecc71;
    }

    .btn-cancel {
      background-color: #e74c3c;
    }

    .btn-submit {
      background-color: #3498db;
    }

    .btn-home:hover {
      background-color: #27ae60;
    }

    .btn-cancel:hover {
      background-color: #c0392b;
    }

    .btn-submit:hover {
      background-color: #2980b9;
    }

    .checkbox-group label {
      display: inline-block;
      margin-right: 12px;
      margin-bottom: 8px;
    }

    @media screen and (max-width: 600px) {
      .button-group {
        flex-direction: column;
        gap: 10px;
      }
    }
  </style>

  <script>
    function kiemTraForm() {
      var ten = document.getElementById("name").value.trim();
      var moTa = document.getElementById("description").value.trim();
      var soBuoi = document.getElementById("duration").value.trim();
      var thoiLuong = document.getElementById("estimatedSessionTime").value.trim();
      var soLuongHV = document.getElementById("studentDescription").value.trim();

      if (!ten || !moTa || !soBuoi || !thoiLuong || !soLuongHV) {
        alert("Vui lòng điền đủ tất cả các trường.");
        return false;
      }

      const duration = parseInt(soBuoi);
      if (isNaN(duration) || duration < 1 || duration > 30) {
        alert("Số buổi học phải từ 1 đến 30.");
        return false;
      }

      return true;
    }

    function tinhTien() {
      const soBuoi = parseInt(document.getElementById("duration").value);
      const price = isNaN(soBuoi) ? 0 : Math.min(soBuoi, 30) * 100000;
      document.getElementById("price").value = price;
    }

    window.addEventListener('DOMContentLoaded', () => {
      tinhTien();

      // ✅ Lấy lịch đã lưu và đánh dấu lại checkbox tương ứng
      const savedSchedule = document.getElementById("scheduleDescription").value;
      const selectedDays = savedSchedule.split(",").map(d => d.trim());

      document.querySelectorAll('input[name="days"]').forEach(checkbox => {
        if (selectedDays.includes(checkbox.value)) {
          checkbox.checked = true;
        }

        checkbox.addEventListener('change', () => {
          const selected = Array.from(document.querySelectorAll('input[name="days"]:checked')).map(cb => cb.value);
          document.getElementById("scheduleDescription").value = selected.join(', ');
        });
      });
    });
  </script>
</head>
<body>

<div class="header">
  <a href="home.jsp">🏠 Trang chủ</a>
</div>

<h2>Sửa khóa học</h2>

<div class="form-container">
  <form method="post" action="swimcourse" onsubmit="return kiemTraForm();">
    <input type="hidden" name="id" value="<%= course.getId() %>">

    <label>
      Tên khóa học:
      <input type="text" name="name" id="name" value="<%= course.getName() %>">
    </label>

    <label>
      Mô tả:
      <textarea name="description" id="description"><%= course.getDescription() %></textarea>
    </label>

    <label>
      Thời gian dự kiến hoàn thành (số buổi):
      <input type="number" name="duration" id="duration" value="<%= course.getDuration() %>" min="1" max="30" onchange="tinhTien()">
    </label>

    <label>
      Giá tiền:
      <input type="number" name="price" id="price" value="<%= course.getPrice() %>" readonly>
    </label>

    <label>
      Thời lượng học mỗi buổi:
      <input type="text" name="estimatedSessionTime" id="estimatedSessionTime" value="<%= course.getEstimatedSessionTime() %>">
    </label>

    <label>
      Số lượng học viên:
      <input type="text" name="studentDescription" id="studentDescription" value="<%= course.getStudentDescription() %>">
    </label>

    <label>
      Lịch học:
      <div class="checkbox-group">
        <label><input type="checkbox" name="days" value="Thứ 2"> Thứ 2</label>
        <label><input type="checkbox" name="days" value="Thứ 3"> Thứ 3</label>
        <label><input type="checkbox" name="days" value="Thứ 4"> Thứ 4</label>
        <label><input type="checkbox" name="days" value="Thứ 5"> Thứ 5</label>
        <label><input type="checkbox" name="days" value="Thứ 6"> Thứ 6</label>
        <label><input type="checkbox" name="days" value="Thứ 7"> Thứ 7</label>
        <label><input type="checkbox" name="days" value="Chủ Nhật"> Chủ Nhật</label>
        <label><input type="checkbox" name="days" value="Linh hoạt"> Linh hoạt</label>
      </div>
      <input type="hidden" name="scheduleDescription" id="scheduleDescription" value="<%= course.getScheduleDescription() %>">
    </label>

    <div class="button-group">
      <a class="btn-cancel" href="swimcourse">❌ Hủy</a>
      <button type="submit" class="btn-submit">📀 Cập nhật</button>
    </div>
  </form>
</div>

</body>
</html>

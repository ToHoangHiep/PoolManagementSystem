<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="model.SwimCourse" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm khóa học</title>
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
        .checkbox-group {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 10px;
        }
        .checkbox-group label {
            display: flex;
            align-items: center;
            gap: 5px;
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
        .btn-home { background-color: #2ecc71; }
        .btn-cancel { background-color: #e74c3c; }
        .btn-submit { background-color: #3498db; }
        .btn-home:hover { background-color: #27ae60; }
        .btn-cancel:hover { background-color: #c0392b; }
        .btn-submit:hover { background-color: #2980b9; }

        @media screen and (max-width: 600px) {
            .button-group { flex-direction: column; gap: 10px; }
        }
    </style>

    <script>
        function tinhGia() {
            let soBuoi = parseInt(document.getElementById("duration").value);
            if (isNaN(soBuoi) || soBuoi <= 0 || soBuoi > 30) {
                alert("Số buổi học phải từ 1 đến 30.");
                document.getElementById("duration").value = "";
                document.getElementById("price").value = "";
                return;
            }
            document.getElementById("price").value = soBuoi * 100000;
        }
    </script>
</head>
<body>
<div class="header">
    <a href="home.jsp">🏠 Trang chủ</a>
</div>
<h2>Thêm khóa học</h2>
<div class="form-container">
    <form method="post" action="swimcourse" onsubmit="return true;">
        <label>
            Tên khóa học:
            <input type="text" name="name" id="name" required>
        </label>

        <label>
            Mô tả:
            <textarea name="description" id="description" required></textarea>
        </label>

        <label>
            Thời gian dự kiến hoàn thành (số buổi):
            <input type="number" name="duration" id="duration" min="1" max="30" onchange="tinhGia();" required>
        </label>

        <label>
            Giá tiền:
            <input type="number" name="price" id="price" readonly>
        </label>

        <label>
            Thời lượng học mỗi buổi:
            <input type="text" name="estimatedSessionTime" id="estimatedSessionTime" required>
        </label>

        <label>
            Số lượng học viên:
            <input type="text" name="studentDescription" id="studentDescription" required>
        </label>

        <label>Lịch học:</label>
        <div class="checkbox-group">
            <% String[] days = {"Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7", "Chủ nhật", "Linh hoạt"};
                for (String d : days) { %>
            <label><input type="checkbox" name="schedule" value="<%= d %>"> <%= d %></label>
            <% } %>
        </div>

        <div class="button-group">
            <a class="btn-cancel" href="swimcourse">❌ Hủy</a>
            <button type="submit" class="btn-submit">➕ Thêm</button>
        </div>
    </form>
</div>
</body>
</html>

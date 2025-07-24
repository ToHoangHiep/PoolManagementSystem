<%@ page contentType="text/html; charset=UTF-8" language="java" %>
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

        input[type="text"], input[type="number"], textarea {
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

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            cursor: pointer;
            color: white;
            text-decoration: none;
            transition: 0.2s ease-in-out;
        }

        .btn-green { background-color: #2ecc71; }
        .btn-red { background-color: #e74c3c; }
        .btn-blue { background-color: #3498db; }

        .btn:hover {
            opacity: 0.92;
        }

        .form-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
        }

        @media screen and (max-width: 600px) {
            .form-buttons {
                flex-direction: column;
                gap: 10px;
            }
        }
    </style>

    <script>
        function kiemTraForm() {
            var ten = document.getElementById("name").value.trim();
            var moTa = document.getElementById("description").value.trim();
            var gia = document.getElementById("price").value.trim();
            var soBuoi = document.getElementById("duration").value.trim();
            var thoiLuong = document.getElementById("estimatedSessionTime").value.trim();
            var soLuongHV = document.getElementById("studentDescription").value.trim();
            var lichHoc = document.getElementById("scheduleDescription").value.trim();

            if (!ten || !moTa || !gia || !soBuoi || !thoiLuong || !soLuongHV || !lichHoc) {
                alert("Vui lòng điền đủ thông tin.");
                return false;
            }

            if (parseFloat(gia) <= 0) {
                alert("Giá tiền phải lớn hơn 0.");
                return false;
            }

            if (parseInt(soBuoi) <= 0) {
                alert("Số buổi phải lớn hơn 0.");
                return false;
            }

            return true;
        }
    </script>
</head>
<body>

<div class="header">
    <a href="home.jsp">🏠 Trang chủ</a>
</div>

<h2>Thêm khóa học</h2>

<div class="form-container">
    <form method="post" action="swimcourse" onsubmit="return kiemTraForm();">
        <label>Tên khóa học:
            <input type="text" name="name" id="name">
        </label>
        <label>Mô tả:
            <textarea name="description" id="description"></textarea>
        </label>
        <label>Giá tiền:
            <input type="number" name="price" id="price" min="0">
        </label>
        <label>Thời gian dự kiến hoàn thành (số buổi):
            <input type="number" name="duration" id="duration" min="1">
        </label>
        <label>Thời lượng học:
            <input type="text" name="estimatedSessionTime" id="estimatedSessionTime">
        </label>
        <label>Số lượng học viên:
            <input type="text" name="studentDescription" id="studentDescription">
        </label>
        <label>Lịch học:
            <input type="text" name="scheduleDescription" id="scheduleDescription">
        </label>

        <div class="form-buttons">
            <a href="swimcourse" class="btn btn-red">❌ Hủy</a>
            <button type="submit" class="btn btn-blue">💾 Lưu</button>
        </div>
    </form>
</div>

</body>
</html>

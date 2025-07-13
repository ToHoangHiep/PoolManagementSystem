<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm khóa học</title>
</head>
<body>
<h2>Thêm khóa học</h2>
<form method="post" action="swimcourse">
    <label>Tên khóa học: <input type="text" name="name" required></label><br><br>
    <label>Mô tả: <textarea name="description" required></textarea></label><br><br>
    <label>Giá tiền: <input type="number" name="price" required></label><br><br>
    <label>Thời gian dự kiến hoàn thành: <input type="number" name="duration" required></label><br><br>
    <label>Thời lượng học: <input type="text" name="estimatedSessionTime" required></label><br><br>
    <label>Số lượng học viên: <input type="text" name="studentDescription" required></label><br><br>
    <label>Lịch học: <input type="text" name="scheduleDescription" required></label><br><br>
    <button type="submit">Lưu</button>
    <a href="swimcourse">Hủy</a>
</form>
</body>
</html>

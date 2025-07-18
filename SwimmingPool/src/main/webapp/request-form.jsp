<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <title>Tạo Yêu Cầu Bảo Trì</title>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; background-color: #f8f9fa; display: flex; justify-content: center; align-items: center; min-height: 100vh; }
    .form-container { width: 100%; max-width: 600px; padding: 30px; background: white; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
    h2 { text-align: center; color: #0056b3; margin-bottom: 10px; }
    p { text-align: center; color: #6c757d; margin-bottom: 25px; }
    .form-group { margin-bottom: 20px; }
    label { display: block; margin-bottom: 8px; font-weight: 500; }
    select, textarea { width: 100%; padding: 10px; border-radius: 5px; border: 1px solid #ced4da; box-sizing: border-box; }
    .btn-group { display: flex; gap: 10px; margin-top: 25px; }
    .btn { flex-grow: 1; padding: 12px 15px; border: none; color: white; cursor: pointer; text-decoration: none; border-radius: 5px; font-size: 16px; text-align: center; }
    .btn-submit { background-color: #007bff; }
    .btn-submit:hover { background-color: #0069d9; }
    .btn-back { background-color: #6c757d; }
    .btn-back:hover { background-color: #5a6268; }
  </style>
</head>
<body>

<div class="form-container">
  <h2>Tạo Yêu Cầu Bảo Trì Mới</h2>
  <p>Sử dụng form này để báo cáo các thiết bị hỏng hóc hoặc sự cố cần sửa chữa.</p>

  <form action="MaintenanceServlet" method="post">
    <input type="hidden" name="action" value="request"/>

    <div class="form-group">
      <label for="areaId">Khu vực phát hiện sự cố:</label>
      <select id="areaId" name="areaId" required>
        <c:forEach var="area" items="${areas}">
          <option value="${area.id}">${area.name}</option>
        </c:forEach>
      </select>
    </div>

    <div class="form-group">
      <label for="description">Mô tả chi tiết sự cố:</label>
      <textarea id="description" name="description" rows="5" required placeholder="Ví dụ: Đèn ở khu vực Bể B bị chập chờn, cần thay thế."></textarea>
    </div>

    <div class="btn-group">
      <button type="submit" class="btn btn-submit">Gửi Yêu Cầu</button>
      <a href="MaintenanceServlet?action=staffView" class="btn btn-back">Quay lại</a>
    </div>
  </form>
</div>

</body>
</html>
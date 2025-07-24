<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.PoolArea" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<html>
<head>
  <title>Danh sách khu vực hồ bơi</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 20px;
      background-color: #f4f4f4;
    }
    h2 {
      color: #333;
      text-align: center;
      margin-bottom: 25px;
    }
    .add-link, .back-link { /* Thêm .back-link vào style */
      display: inline-block;
      margin-bottom: 15px;
      padding: 8px 15px;
      border-radius: 5px;
      text-decoration: none;
      color: white; /* Màu chữ chung */
    }
    .add-link {
      background-color: #28a745;
    }
    .add-link:hover {
      background-color: #218838;
    }
    .back-link { /* Style cho nút quay lại */
      background-color: #6c757d; /* Màu xám */
      margin-left: 10px; /* Khoảng cách với nút thêm */
    }
    .back-link:hover {
      background-color: #5a6268;
    }
    .search-container {
      margin-bottom: 20px;
      padding: 15px;
      background-color: #e9ecef;
      border-radius: 5px;
      display: flex;
      gap: 10px;
      align-items: center;
    }
    .search-container form {
      display: flex;
      gap: 10px;
      flex-grow: 1;
    }
    .search-container input[type="text"] {
      flex-grow: 1;
      padding: 8px;
      border: 1px solid #ced4da;
      border-radius: 4px;
    }
    .search-container button {
      padding: 8px 15px;
      background-color: #007bff;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
    }
    .search-container button:hover {
      background-color: #0056b3;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      background-color: white;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }
    th, td {
      border: 1px solid #dee2e6;
      padding: 12px;
      text-align: left;
    }
    th {
      background-color: #007bff;
      color: white;
      text-align: center;
    }
    td {
      text-align: center;
    }
    .action-buttons a {
      margin: 0 5px;
      text-decoration: none;
      color: #007bff;
    }
    .action-buttons a:hover {
      text-decoration: underline;
    }
    .status-ok {
      color: green;
      font-weight: bold;
    }
    .status-problem {
      color: orange;
      font-weight: bold;
    }
    .error-message {
      color: red;
      background-color: #ffebe8;
      border: 1px solid red;
      padding: 10px;
      margin-top: 20px;
      border-radius: 5px;
      text-align: center;
    }
  </style>
</head>
<body>
<h2>Danh sách khu vực hồ bơi</h2>

<div style="margin-bottom: 15px;">
  <a href="pool-area?action=add" class="add-link">+ Thêm khu vực</a>
  <a href="admin_dashboard.jsp" class="back-link">Quay lại trang chủ</a> <%-- NÚT QUAY LẠI MỚI --%>
</div>

<div class="search-container">
  <form action="pool-area" method="get">
    <input type="text" name="searchKeyword" placeholder="Tìm kiếm theo tên, mô tả, loại..." value="${searchKeyword != null ? searchKeyword : ''}">
    <button type="submit">Tìm kiếm</button>
    <button type="button" onclick="window.location.href='pool-area'">Xóa tìm kiếm</button>
  </form>
</div>

<table>
  <thead>
  <tr>
    <th>ID</th>
    <th>Tên</th>
    <th>Mô tả</th>
    <th>Loại</th>
    <th>Độ sâu (m)</th>
    <th>Chiều dài (m)</th>
    <th>Chiều rộng (m)</th>
    <th>Sức chứa</th>
    <th>Trạng thái</th>
    <th>Hành động</th>
  </tr>
  </thead>
  <tbody>
  <c:forEach var="area" items="${areas}">
    <tr>
      <td>${area.id}</td>
      <td>${area.name}</td>
      <td>${area.description}</td>
      <td>${area.type}</td>
      <td>${area.waterDepth}</td>
      <td>${area.length}</td>
      <td>${area.width}</td>
      <td>${area.maxCapacity}</td>
      <td>
        <c:set var="statusKey" value="poolStatus_${area.id}"/>
        <c:if test="${requestScope[statusKey] eq 'Đang bảo trì/Có vấn đề'}">
          <span class="status-problem">${requestScope[statusKey]}</span>
        </c:if>
        <c:if test="${requestScope[statusKey] eq 'Hoạt động bình thường'}">
          <span class="status-ok">${requestScope[statusKey]}</span>
        </c:if>
      </td>
      <td class="action-buttons">
        <a href="pool-area?action=edit&id=${area.id}">Sửa/Xem chi tiết</a> |
        <a href="pool-area?action=delete&id=${area.id}"
           onclick="return confirm('Bạn có chắc muốn xóa? Hành động này không thể hoàn tác nếu không có dữ liệu liên quan.')">Xóa</a>
      </td>
    </tr>
  </c:forEach>
  <c:if test="${empty areas}">
    <tr>
      <td colspan="10">Không tìm thấy khu vực bể bơi nào.</td>
    </tr>
  </c:if>
  </tbody>
</table>

<c:if test="${not empty error}">
  <p class="error-message">${error}</p>
</c:if>
</body>
</html>
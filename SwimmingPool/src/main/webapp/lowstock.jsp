<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>Thiết bị sắp hết kho</title>
  <style>
    table {
      width: 90%;
      margin: auto;
      border-collapse: collapse;
    }
    th, td {
      padding: 10px;
      border: 1px solid #ddd;
    }
    h2 {
      text-align: center;
    }
  </style>
</head>
<body>

<h2>${message}</h2>

<table>
  <thead>
  <tr>
    <th>ID</th>
    <th>Tên thiết bị</th>
    <th>Danh mục</th>
    <th>Số lượng tồn</th>
    <th>Ngưỡng cảnh báo</th>
    <th>Trạng thái</th>
    <th>Cách sử dụng</th>
    <th>Cập nhật lần cuối</th>
    <th>Hoạt động</th>
  </tr>
  </thead>
  <tbody>
  <c:forEach var="inv" items="${inventoryList}">
    <tr>
      <td>${inv.inventoryId}</td>
      <td>${inv.itemName}</td>
      <td>${inv.categoryName}</td>
      <td>${inv.quantity}</td>
      <td>${inv.categoryQuantity}</td>
      <td>${inv.status}</td>
      <td>${inv.usageName}</td>
      <td>${inv.lastUpdated}</td>
      <td>
        <a href="inventory?action=edit&id=${inv.inventoryId}" class="btn-edit">Request Import</a>
      </td>
    </tr>
  </c:forEach>
  </tbody>
</table>

<br/>
<div style="text-align: center;">
  <a href="inventory">Quay lại danh sách</a>
</div>

</body>
</html>

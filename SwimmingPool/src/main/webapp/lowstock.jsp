<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Inventory" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>Thiết bị sắp hết kho</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f5f7fa;
      margin: 0;
      padding: 20px;
    }

    h2 {
      text-align: center;
      color: #2c3e50;
      margin-bottom: 30px;
    }

    table {
      width: 95%;
      margin: auto;
      border-collapse: collapse;
      background-color: #ffffff;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
    }

    th, td {
      padding: 12px 15px;
      border: 1px solid #dee2e6;
      text-align: center;
      font-size: 14px;
    }

    th {
      background-color: #f0f2f5;
      color: #333;
      font-weight: bold;
    }

    tr:nth-child(even) {
      background-color: #f9fbfd;
    }

    a {
      color: #007bff;
      text-decoration: none;
      font-weight: 500;
    }

    a:hover {
      text-decoration: underline;
      color: #0056b3;
    }

    .back-link {
      text-align: center;
      margin-top: 30px;
    }

    .back-link a {
      padding: 8px 16px;
      background-color: #3498db;
      color: #fff;
      border-radius: 5px;
      display: inline-block;
      text-decoration: none;
      transition: background-color 0.2s;
    }

    .back-link a:hover {
      background-color: #2980b9;
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
    <th>Số lượng</th>
    <th>Danh mục SL</th>
    <th>Trạng thái</th>
    <th>Cách sử dụng</th>
    <th>Cập nhật</th>
    <th>Thao tác</th>
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
        <a href="inventory?action=requestForm&inventory_id=${inv.inventoryId}">
          Nhập thêm
        </a>
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

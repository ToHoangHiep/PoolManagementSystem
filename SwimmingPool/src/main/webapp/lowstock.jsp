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
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  }

  th, td {
    padding: 12px 14px;
    border: 1px solid #dee2e6;
    text-align: center;
    font-size: 14px;
  }

  thead th {
    background-color: #007bff;
    color: white;
    font-weight: bold;
  }

  tr:nth-child(even) {
    background-color: #f9f9f9;
  }

  a {
    text-decoration: none;
    padding: 6px 10px;
    font-size: 13px;
    font-weight: bold;
    border-radius: 4px;
  }

  a[href*="requestForm"] {
    background-color: #ffc107;
    color: #000;
    border: 1px solid #e0a800;
  }

  a[href*="requestForm"]:hover {
    background-color: #e0a800;
    color: white;
  }

  .back-link {
    text-align: center;
    margin-top: 30px;
  }

  .back-link a {
    padding: 8px 16px;
    background-color: #007bff;
    color: #fff;
    border-radius: 5px;
    display: inline-block;
    transition: background-color 0.2s;
  }

  .back-link a:hover {
    background-color: #0056b3;
  }

  .message-box {
    max-width: 600px;
    margin: 20px auto;
    padding: 12px 20px;
    background-color: #e0f7fa;
    color: #00796b;
    border-left: 5px solid #00796b;
    border-radius: 5px;
    font-weight: bold;
    text-align: center;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
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
  <a href="staff_dashboard.jsp">Quay lại </a>
</div>
<%
  String message = (String) session.getAttribute("message");
  if (message != null) {
%>
<div class="message-box"><%= message %></div>
<%
    session.removeAttribute("message"); // Xoá sau khi hiển thị 1 lần
  }
%>

</body>
</html>

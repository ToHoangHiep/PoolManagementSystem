<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>Lịch sử nhập kho</title>
  <style>
    table {
      width: 95%;
      margin: auto;
      border-collapse: collapse;
    }
    th, td {
      border: 1px solid #ccc;
      padding: 10px;
      text-align: center;
    }
    th {
      background-color: #f2f2f2;
    }
    h2 {
      text-align: center;
      margin: 20px 0;
    }
    .back-btn {
      display: block;
      text-align: center;
      margin-top: 25px;
    }

    .back-btn a {
      text-decoration: none;
      background-color: #3498db;
      color: white;
      padding: 10px 20px;
      border-radius: 6px;
      transition: background-color 0.2s;
    }

    .back-btn a:hover {
      background-color: #2980b9;
    }
  </style>
</head>
<body>

<h2>Lịch sử nhập kho đã hoàn thành</h2>

<table>
  <tr>
    <th>Thiết bị</th>
    <th>Số lượng</th>
    <th>Ngày nhập</th>
  </tr>
  <c:forEach var="r" items="${completedList}">
    <tr>
      <td>${r.itemName}</td>
      <td>${r.requestedQuantity}</td>
      <td>${r.completedAt}></td>

    </tr>
  </c:forEach>
</table>
<div class="back-btn">
  <a href="inventory?action=requestList">Quay lại danh sách yêu cầu</a>
</div>
</body>
</html>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.InventoryRequest" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>Danh sách yêu cầu nhập kho</title>
  <style>
    body {
      font-family: 'Segoe UI', sans-serif;
      background-color: #f5f7fa;
      margin: 0;
      padding: 30px;
    }

    h2 {
      text-align: center;
      color: #2c3e50;
      margin-bottom: 30px;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      background-color: #ffffff;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
      border-radius: 8px;
      overflow: hidden;
    }

    th, td {
      padding: 14px 16px;
      border: 1px solid #e0e0e0;
      text-align: center;
    }

    th {
      background-color: #ecf0f1;
      color: #34495e;
      font-weight: bold;
    }

    tr:nth-child(even) {
      background-color: #f9f9f9;
    }

    tr:hover {
      background-color: #f1f1f1;
    }

    button {
      padding: 8px 14px;
      margin: 2px;
      border: none;
      border-radius: 6px;
      color: white;
      cursor: pointer;
      font-size: 14px;
      transition: 0.2s;
    }

    button[name="statusUD"][value="approve"] {
      background-color: #28a745;
    }

    button[name="statusUD"][value="reject"] {
      background-color: #dc3545;
    }

    button:hover {
      opacity: 0.9;
    }

    a {
      margin: 10px;
      padding: 8px 16px;
      display: inline-block;
      text-decoration: none;
      background-color: #007BFF;
      color: white;
      border-radius: 5px;
      transition: background-color 0.3s;
    }

    a:hover {
      background-color: #0056b3;
    }

    div {
      margin-top: 20px;
      text-align: center;
    }

  </style>
</head>

<body>
<!-- inventoryRequestList.jsp -->
<h2>Danh sách yêu cầu nhập kho</h2>
<table border="1">
  <tr>
    <th>Thiết bị</th><th>Số lượng</th><th>Ngày yêu cầu</th><th>Trạng thái</th><th>Thao tác</th>
  </tr>
  <c:forEach var="r" items="${requestList}">
    <tr>
      <td>${r.itemName}</td>
      <td>${r.requestedQuantity}</td>
      <td>${r.requestedAt}</td>
      <td>${r.status}</td><td>
      <c:if test="${r.status == 'pending'}">
        <form action="inventory?action=approveRequest" method="post" style="display:inline;">
          <input type="hidden" name="request_id" value="${r.requestId}"/>
          <button type="submit" name="statusUD" value="approve">Phê duyệt</button>
          <button type="submit" name="statusUD" value="reject">Từ chối</button>
        </form>
      </c:if>
    </td>


    </tr>
  </c:forEach>
</table>
<div style="text-align: center;">
  <a href="inventory">Quay lại danh sách</a>
  <a href="inventory?action=approvedRequestHistory">Lịch sử đã phê duyệt</a>
  <a href="inventory?action=completedList">Lịch sử nhập kho</a>

</div>

</body>
</html>

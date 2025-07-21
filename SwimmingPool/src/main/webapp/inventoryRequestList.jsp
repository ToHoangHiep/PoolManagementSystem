
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.InventoryRequest" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>Danh sách yêu cầu nhập kho</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f9f9f9;
      padding: 20px;
    }

    h2 {
      text-align: center;
      color: #333;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      background-color: white;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    th, td {
      padding: 12px 15px;
      border: 1px solid #ddd;
      text-align: center;
    }

    th {
      background-color: #f0f0f0;
      color: #333;
    }

    tr:nth-child(even) {
      background-color: #f9f9f9;
    }

    button {
      background-color: #4CAF50;
      border: none;
      color: white;
      padding: 6px 12px;
      margin: 2px;
      cursor: pointer;
      border-radius: 4px;
      font-size: 14px;
    }

    button[name="statusUD"][value="reject"] {
      background-color: #f44336;
    }

    button:hover {
      opacity: 0.9;
    }
  </style>
</head>

<body>
<!-- inventoryRequestList.jsp -->
<h2>Danh sách yêu cầu nhập kho</h2>
<table border="1">
  <tr>
    <th>Thiết bị</th><th>Số lượng</th><th>Lý do</th><th>Ngày yêu cầu</th><th>Trạng thái</th><th>Thao tác</th>
  </tr>
  <c:forEach var="r" items="${requestList}">
    <tr>
      <td>${r.itemName}</td>
      <td>${r.requestedQuantity}</td>
      <td>${r.reason}</td>
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
</div>

</body>
</html>

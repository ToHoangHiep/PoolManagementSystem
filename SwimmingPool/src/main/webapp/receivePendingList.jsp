<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>Yêu cầu nhập kho đã được phê duyệt</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      padding: 20px;
    }

    table {
      width: 95%;
      margin: auto;
      border-collapse: collapse;
    }

    th, td {
      padding: 10px;
      border: 1px solid #ccc;
      text-align: center;
    }

    th {
      background-color: #f2f2f2;
    }

    h2 {
      text-align: center;
      margin-bottom: 30px;
    }

    button {
      padding: 6px 14px;
      background-color: #28a745;
      border: none;
      color: white;
      border-radius: 5px;
      cursor: pointer;
    }

    button:hover {
      background-color: #218838;
    }
  </style>
</head>
<body>

<h2>Yêu cầu chờ xác nhận nhập kho</h2>


<table border="1">
  <tr>
    <th>Thiết bị</th>
    <th>Số lượng</th>
    <th>Thao tác</th>
  </tr>
  <c:forEach var="r" items="${pendingList}">
    <tr>
      <td>${r.itemName}</td>
      <td>${r.requestedQuantity}</td>

      <td>
        <form method="post" action="inventory?action=confirmReceive">
          <input type="hidden" name="request_id" value="${r.requestId}" />
          <button type="submit">Xác nhận đã nhập</button>
        </form>
      </td>
    </tr>
  </c:forEach>
</table>
<c:if test="${not empty message}">
  <p style="color: green">${message}</p>
</c:if>
<div style="text-align: center;">
  <a href="staff_dashboard.jsp">Quay lại </a> 
</div>
</body>
</html>

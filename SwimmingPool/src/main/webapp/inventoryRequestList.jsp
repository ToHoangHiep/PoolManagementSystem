
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.InventoryRequest" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Title</title>
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
      <td>${r.status}</td>
      <td>
        <c:if test="${r.status == 'pending'}">
          <form action="inventory" method="post" style="display:inline;">
            <input type="hidden" name="action" value="updateStatus"/>
            <input type="hidden" name="request_id" value="${r.requestId}"/>
            <a href="inventory?action=approveRequest&id=${r.requestId}">Phê duyệt</a>
            <a href="inventory?action=rejectRequest&id=${r.requestId}">Từ chối</a>
          </form>
        </c:if>
      </td>

    </tr>
  </c:forEach>
</table>

</body>
</html>

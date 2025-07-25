<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.Inventory" %>
<%@ page import="model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
  Inventory inv = (Inventory) request.getAttribute("inventory");
  String action = (inv != null) ? "update" : "insert";
%>
<%
  User user = (User) session.getAttribute("user");
  int managerId = user != null ? user.getId() : 2; // hoặc getManagerId() tùy thuộc hệ thống
%>

<html>
<head>
  <title><%= inv != null ? "Cập nhật thiết bị" : "Thêm thiết bị mới" %></title>
  <link rel="stylesheet" href="./Resources/CSS/inventoryForm.css">
</head>
<body>

<h2 style="text-align: center;"><%= inv != null ? "Cập nhật thiết bị" : "Thêm thiết bị mới" %></h2>

<form action="inventory" method="post">
  <input type="hidden" name="action" value="<%= action %>"/>
  <% if (inv != null) { %>
  <input type="hidden" name="id" value="<%= inv.getInventoryId() %>"/>
  <% } %>


  <input type="hidden" name="manager_id" value="<%= inv != null ? inv.getManagerId() : managerId %>" />


  <label>Tên thiết bị:</label>
  <input type="text" name="item_name" value="<%= inv != null ? inv.getItemName() : "" %>" required/>

  <label>Danh mục:</label>
  <select name="category_id" required>
    <c:forEach var="cat" items="${categoryList}">
      <option value="${cat.categoryId}"
              <c:if test="${inv != null and inv.categoryId == cat.categoryId}">selected</c:if>>
          ${cat.categoryName}
      </option>
    </c:forEach>
  </select>

  <label>Số lượng:</label>
  <input type="number" name="quantity" min="1"
         oninput="validity.valid||(value='');"
         value="<%= inv != null ? inv.getQuantity() : "" %>" required/>

  <label>Đơn vị:</label>
  <input type="text" name="unit" value="<%= inv != null ? inv.getUnit() : "" %>" required/>

  <label>Giá nhập (VNĐ):</label>
  <input type="number" step="0.01" min="0"
         oninput="validity.valid||(value='');"
         name="import_price" value="<%= inv != null ? inv.getImportPrice() : "" %>" required/>

  <label>Trạng thái:</label>
  <select name="status">
    <option value="Available" <%= (inv != null && "Available".equals(inv.getStatus())) ? "selected" : "" %>>Sẵn sàng</option>
    <option value="In Use" <%= (inv != null && "In Use".equals(inv.getStatus())) ? "selected" : "" %>>Đang sử dụng</option>
    <option value="Maintenance" <%= (inv != null && "Maintenance".equals(inv.getStatus())) ? "selected" : "" %>>Bảo trì</option>
    <option value="Broken" <%= (inv != null && "Broken".equals(inv.getStatus())) ? "selected" : "" %>>Hỏng</option>
  </select>

  <label>Loại sử dụng:</label>
  <select name="usage_id">
    <option value="1">Thiết bị cho thuê</option>
    <option value="2">Thiết bị bảo trì</option>
    <option value="3">Thiết bị bán</option>
    <option value="4">Thiết bị cơ sở vật chất</option>
  </select>

  <br><br>
  <input type="submit" value="Lưu"/>
  <a href="inventory">Quay lại</a>
</form>

</body>
</html>

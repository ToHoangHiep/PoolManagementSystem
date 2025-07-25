<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.Coach" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách Huấn luyện viên</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f6f9; padding: 30px; margin: 0; }
        h2 { text-align: center; color: #2c3e50; margin-bottom: 30px; }
        .top-bar { max-width: 1200px; margin: auto auto 20px; display: flex; justify-content: space-between; flex-wrap: wrap; }
        .top-bar a { text-decoration: none; padding: 10px 20px; border-radius: 6px; color: white; font-weight: bold; font-size: 15px; margin: 5px; }
        .btn-home { background-color: #2ecc71; } .btn-home:hover { background-color: #27ae60; }
        .btn-add { background-color: #3498db; } .btn-add:hover { background-color: #2980b9; }
        .search-box input[type="text"] { padding: 8px; border-radius: 4px; border: 1px solid #ccc; font-size: 14px; }
        .search-box input[type="submit"] { padding: 8px 12px; background-color: #16a085; color: white; border: none; border-radius: 4px; margin-left: 5px; }
        table { width: 100%; max-width: 1200px; margin: auto; border-collapse: collapse; background-color: white; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        th, td { padding: 12px 15px; border: 1px solid #ddd; text-align: left; vertical-align: middle; }
        th { background-color: #ecf0f1; }
        img.coach-photo { width: 100px; height: 100px; object-fit: cover; border-radius: 8px; border: 1px solid #ccc; }
        .action { display: flex; gap: 6px; align-items: center; }
        .btn-edit, .btn-delete {
            padding: 6px 12px; border: none; border-radius: 4px; font-weight: bold; cursor: pointer; color: white; text-decoration: none;
        }
        .btn-edit { background-color: #f39c12; } .btn-edit:hover { background-color: #d68910; }
        .btn-delete { background-color: #e74c3c; } .btn-delete:hover { background-color: #c0392b; }
        .status-active { color: green; font-weight: bold; }
        .status-inactive { color: red; font-weight: bold; }
        .no-data { text-align: center; color: #888; padding: 20px; }
    </style>
</head>
<body>

<h2>Danh sách Huấn luyện viên</h2>

<div class="top-bar">
    <div>
        <a href="admin_dashboard.jsp" class="btn-home"><i class="fas fa-home"></i> Trang chủ</a>
        <a href="coach-list?action=add" class="btn-add"><i class="fas fa-user-plus"></i> Thêm Huấn luyện viên</a>
    </div>
    <form action="coach-list" method="get" class="search-box">
        <input type="text" name="keyword" placeholder="Tìm theo tên..." value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>"/>
        <input type="submit" value="Tìm kiếm"/>
    </form>
</div>

<table>
    <tr>
        <th>Họ tên</th>
        <th>Email</th>
        <th>Số điện thoại</th>
        <th>Giới tính</th>
        <th>Tiểu sử</th>
        <th>Ảnh</th>
        <th>Trạng thái</th>
        <th>Hành động</th>
    </tr>
    <%
        List<Coach> list = (List<Coach>) request.getAttribute("coaches");
        String keyword = request.getParameter("keyword");
        boolean hasResult = false;

        if (list != null && !list.isEmpty()) {
            for (Coach c : list) {
                if (keyword == null || keyword.trim().isEmpty() || c.getFullName().toLowerCase().contains(keyword.toLowerCase())) {
                    hasResult = true;
    %>
    <tr>
        <td><%= c.getFullName() %></td>
        <td><%= c.getEmail() %></td>
        <td><%= c.getPhone() %></td>
        <td><%= c.getGender() %></td>
        <td><%= c.getBio() %></td>
        <td><img src="images/<%= c.getProfilePicture() %>" class="coach-photo" alt="Ảnh"/></td>
        <td>
            <%= c.isActive() ? "<span class='status-active'>Đang hoạt động</span>" : "<span class='status-inactive'>Ngưng hoạt động</span>" %>
        </td>
        <td class="action">
            <a class="btn-edit" href="coach-list?action=edit&id=<%= c.getId() %>">Sửa</a>
            <form method="post" action="coach-list" onsubmit="return confirm('Bạn có chắc muốn xóa huấn luyện viên này?');">
                <input type="hidden" name="action" value="delete"/>
                <input type="hidden" name="id" value="<%= c.getId() %>"/>
                <button type="submit" class="btn-delete">Xóa</button>
            </form>
        </td>
    </tr>
    <%
                }
            }
        }

        if (!hasResult) {
    %>
    <tr>
        <td colspan="8" class="no-data">
            <% if (keyword != null && !keyword.trim().isEmpty()) { %>
            Không tìm thấy kết quả phù hợp với từ khóa "<%= keyword %>"
            <% } else { %>
            Không có dữ liệu
            <% } %>
        </td>
    </tr>
    <% } %>
</table>

</body>
</html>

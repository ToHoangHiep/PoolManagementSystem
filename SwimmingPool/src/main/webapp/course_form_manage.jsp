<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.CourseForm" %>
<%@ page import="dal.CourseDAO" %>
<%@ page import="dal.UserDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // --- Kiểm tra bảo mật ---
    // Đảm bảo chỉ người dùng đã đăng nhập và có quyền mới có thể xem trang này.
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // --- Lấy dữ liệu ---
    List<CourseForm> courseForms = (List<CourseForm>)  request.getAttribute("courseForms");
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM, yyyy");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Đơn đăng ký Khóa học</title>
    <!-- Bootstrap CSS -->
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .table-hover tbody tr:hover {
            background-color: #e9ecef;
        }
    </style>
</head>
<body>

<%
    // This block checks for a message and an optional action from the servlet.
    String alertMessage = (String) request.getAttribute("alert_message");
    if (alertMessage != null) {
        String alertAction = (String) request.getAttribute("alert_action");
%>
<script>
    // Using an IIFE to keep variables out of the global scope.
    (function() {
        // Display the alert. We escape single quotes to prevent JS errors.
        alert('<%= alertMessage.replace("'", "\\'") %>');

        // If an action URL was provided, redirect the user after they click "OK".
        <% if (alertAction != null && !alertAction.isEmpty()) { %>
        window.location.href = '<%= alertAction %>';
        <% } %>
    })();
</script>
<%
    }
%>

<div class="container my-5">
    <div class="card shadow-sm">
        <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
            <h2 class="mb-0 h4">
                <i class="fas fa-tasks me-2 text-primary"></i>Quản lý Đơn đăng ký Khóa học
            </h2>
            <%if (adminUser.getRole().getId() == 4) {%>
                <a href="blogs" class="btn btn-sm btn-outline-secondary">
                    <i class="fas fa-arrow-left me-1"></i> Quay lại Danh mục
                </a>
            <%} else { %>
                <a href="admin_dashboard.jsp" class="btn btn-sm btn-outline-secondary">
                    <i class="fas fa-arrow-left me-1"></i> Quay lại quản lí
                </a>
            <%}%>


        </div>
        <div class="card-body">
            <% if (courseForms == null || courseForms.isEmpty()) { %>
            <div class="alert alert-info text-center">
                Hiện tại không có đơn đăng ký nào để hiển thị.
            </div>
            <% } else { %>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>Mã đơn</th>
                        <th>Tên người đăng ký</th>
                        <th>Email</th>
                        <th>Khóa học</th>
                        <th>Ngày đăng ký</th>
                        <th class="text-center">Trạng thái</th>
                        <th class="text-end">Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (CourseForm form : courseForms) { %>
                    <tr>
                        <td>#<%= form.getId() %></td>
                        <td>
                            <% if (form.getUser_id() > 0) { %>
                            <i class="fas fa-user-check text-success me-1" title="Người dùng hệ thống"></i>
                            <%= UserDAO.getFullNameById(form.getUser_id()) %>
                            <% } else { %>
                            <i class="fas fa-user-secret text-info me-1" title="Khách"></i>
                            <%= form.getUser_fullName() %>
                            <% } %>
                        </td>
                        <td>
                            <% if (form.getUser_id() > 0) { %>
                            <%= UserDAO.getUserById(form.getUser_id()).getEmail() %>
                            <% } else { %>
                            <%= form.getUser_email() %>
                            <% } %>
                        </td>
                        <td><%= CourseDAO.getCourseById(form.getCourse_id()).getName() %></td>
                        <td><%= sdf.format(form.getRequest_date()) %></td>
                        <td class="text-center">
                            <% if (form.isHas_processed()) { %>
                            <span class="badge bg-success">Đã xác nhận</span>
                            <% } else { %>
                            <span class="badge bg-warning text-dark">Chờ xử lý</span>
                            <% } %>
                        </td>
                        <td class="text-end">
                            <a href="course?action=view_form&formId=<%= form.getId() %>" class="btn btn-sm btn-outline-primary">
                                <i class="fas fa-eye me-1"></i>Xem chi tiết
                            </a>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="Resources/bootstrap/js/bootstrap.bundle.min.js"></script>

</body>
</html>
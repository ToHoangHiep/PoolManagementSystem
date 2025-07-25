<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Course" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Arrays" %>

<%
    // --- Kiểm tra người dùng & vai trò ---
    // User có thể là null, cho phép khách xem trang.
    User user = (User) session.getAttribute("user");

    // Kiểm tra xem người dùng có phải là quản trị viên để hiển thị các nút quản lý.
    boolean isAdmin = false;
    if (user != null && user.getRole() != null) {
        // Giả sử các vai trò khác 3 (Coach) và 4 (Customer) là quản trị viên.
        isAdmin = !Arrays.asList(3, 4).contains(user.getRole().getId());
    }

    // --- Lấy dữ liệu ---
    List<Course> courses = (List<Course>) request.getAttribute("courses");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Các khóa học hiện có</title>
    <!-- Bootstrap CSS -->
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f0f2f5; /* Màu xám nhạt hơn để trông mềm mại hơn */
        }
        .course-card {
            transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
            border: none;
        }
        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15) !important;
        }
        .card-title {
            color: #0056b3;
        }
        .card-footer {
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>

<%-- Xử lý thông báo alert từ session (dành cho các lần chuyển hướng từ trang khác) --%>
<%
    String alertMessage = (String) session.getAttribute("alert_message");
    if (alertMessage != null) {
        session.removeAttribute("alert_message"); // Xóa sau khi đọc
%>
<script>
    // Dịch các thông báo phổ biến
    let message = '<%= alertMessage.replace("'", "\\'") %>';
    if (message.includes("course could not be found")) {
        message = "Không tìm thấy khóa học được yêu cầu.";
    } else if (message.includes("coach could not be found")) {
        message = "Không tìm thấy huấn luyện viên được yêu cầu.";
    }
    alert(message);
</script>
<%
    }
%>

<div class="container my-5">
    <!-- Tiêu đề trang -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h2">Các khóa học bơi của chúng tôi</h1>
        <%-- Các nút chỉ dành cho quản trị viên --%>
        <% if (isAdmin) { %>
        <div class="d-flex gap-2">
            <a href="course?action=list_form" class="btn btn-outline-primary">
                <i class="fas fa-tasks me-2"></i>Quản lý Đơn đăng ký
            </a>
            <a href="course?action=create" class="btn btn-primary">
                <i class="fas fa-plus-circle me-2"></i>Tạo Khóa học mới
            </a>
        </div>
        <% } %>
    </div>

    <% if (courses == null || courses.isEmpty()) { %>
    <div class="alert alert-info text-center">
        Hiện tại không có khóa học nào. Vui lòng quay lại sau!
    </div>
    <% } else { %>
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
        <% for (Course course : courses) { %>
        <div class="col">
            <div class="card h-100 shadow-sm course-card">
                <div class="card-body d-flex flex-column">
                    <div class="mb-2">
                        <%-- Dịch trạng thái --%>
                        <span class="badge <%= "Active".equals(course.getStatus()) ? "bg-success" : "bg-secondary" %>">
                            <%= "Active".equals(course.getStatus()) ? "Hoạt động" : "Tạm ngưng" %>
                        </span>
                    </div>
                    <h5 class="card-title"><%= course.getName() %></h5>
                    <p class="card-text text-muted flex-grow-1">
                        <%-- Rút gọn mô tả dài để giao diện gọn gàng hơn --%>
                        <%= course.getDescription().length() > 100 ? course.getDescription().substring(0, 100) + "..." : course.getDescription() %>
                    </p>
                    <ul class="list-unstyled text-secondary mb-4">
                        <%-- Dịch và định dạng tiền tệ --%>
                        <li><i class="fas fa-dollar-sign fa-fw me-2"></i><strong>Giá:</strong> <%= String.format("%,.0f", course.getPrice()) %> VNĐ</li>
                        <li><i class="fas fa-calendar-alt fa-fw me-2"></i><strong>Thời lượng:</strong> <%= course.getDuration() %> buổi</li>
                    </ul>
                </div>
                <div class="card-footer d-grid gap-2 d-md-flex justify-content-end">
                    <a href="course?action=view&courseId=<%= course.getId() %>" class="btn btn-outline-secondary btn-sm">
                        <i class="fas fa-info-circle me-1"></i>Chi tiết
                    </a>
                    <%-- Nút Đăng ký chỉ hoạt động nếu khóa học có sẵn --%>
                    <% if ("Active".equals(course.getStatus())) { %>
                    <a href="course?action=create_form&courseId=<%= course.getId() %>" class="btn btn-primary btn-sm">
                        <i class="fas fa-user-plus me-1"></i>Đăng ký ngay
                    </a>
                    <% } else { %>
                    <button class="btn btn-secondary btn-sm" disabled>
                        <i class="fas fa-times-circle me-1"></i>Không có sẵn
                    </button>
                    <% } %>
                </div>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>
</div>

<!-- Bootstrap JS -->
<script src="Resources/bootstrap/js/bootstrap.bundle.min.js"></script>

</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%
    // --- Kiểm tra bảo mật ---
    // Đảm bảo chỉ người dùng đã đăng nhập và có quyền mới có thể xem trang này.
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    // Ví dụ: Vai trò 4 (Khách hàng) không thể tạo khóa học.
    // Việc kiểm tra này cũng nên có trong servlet của bạn để bảo mật tốt hơn.
    if (user.getRole().getId() == 4) {
        session.setAttribute("alert_message", "Bạn không có quyền truy cập trang này.");
        response.sendRedirect("course");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo Khóa học mới</title>
    <!-- Bootstrap CSS -->
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>

<%-- Khối này xử lý các thông báo pop-up và hành động được gửi từ servlet --%>
<%
    String alertMessage = (String) request.getAttribute("alert_message");
    if (alertMessage != null) {
        String alertAction = (String) request.getAttribute("alert_action");
%>
<script>
    // Sử dụng một hàm tự gọi để tránh làm ô nhiễm phạm vi toàn cục
    (function() {
        // Dịch các thông báo phổ biến
        let message = '<%= alertMessage.replace("'", "\\'") %>';
        if (message.includes("You do not have permission")) {
            message = "Bạn không có quyền truy cập trang này.";
        } else if (message.includes("Failed to create course")) {
            message = "Tạo khóa học thất bại.";
        }

        // Hiển thị thông báo. Chúng ta thoát ký tự ' để tránh lỗi JS.
        alert(message);

        // Nếu có URL hành động, chuyển hướng người dùng sau khi họ đóng thông báo.
        <% if (alertAction != null && !alertAction.isEmpty()) { %>
        window.location.href = '<%= request.getContextPath() %>/<%= alertAction %>';
        <% } %>
    })();
</script>
<%
    }
%>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h2 class="mb-0 h4">
                        <i class="fas fa-plus-circle me-2"></i>Tạo Khóa học mới
                    </h2>
                </div>

                <div class="card-body p-4">
                    <%-- Khối này xử lý các thông báo lỗi tại trang (ví dụ: cho việc xác thực) --%>
                    <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <%= request.getAttribute("error") %>
                    </div>
                    <% } %>

                    <form action="course?action=create" method="post">
                        <!-- Tên Khóa học -->
                        <div class="mb-3">
                            <label for="name" class="form-label fw-bold">Tên Khóa học</label>
                            <input type="text" class="form-control" id="name" name="name" placeholder="ví dụ: Bơi sải Cơ bản" required>
                        </div>

                        <!-- Mô tả -->
                        <div class="mb-3">
                            <label for="description" class="form-label fw-bold">Mô tả</label>
                            <textarea class="form-control" id="description" name="description" rows="4" placeholder="Thông tin chi tiết về nội dung và mục tiêu khóa học." required></textarea>
                        </div>

                        <div class="row">
                            <!-- Giá -->
                            <div class="col-md-6 mb-3">
                                <label for="price" class="form-label fw-bold">Giá (VNĐ)</label>
                                <input type="number" class="form-control" id="price" name="price" step="1" min="0" placeholder="ví dụ: 1500000" required>
                            </div>
                            <!-- Thời lượng -->
                            <div class="col-md-6 mb-3">
                                <label for="duration" class="form-label fw-bold">Thời lượng (buổi)</label>
                                <input type="number" class="form-control" id="duration" name="duration" min="1" placeholder="ví dụ: 8" required>
                            </div>
                        </div>

                        <div class="row">
                            <!-- Thời gian mỗi buổi -->
                            <div class="col-md-6 mb-3">
                                <label for="estimated_session_time" class="form-label fw-bold">Thời gian mỗi buổi</label>
                                <input type="text" class="form-control" id="estimated_session_time" name="estimated_session_time" placeholder="ví dụ: 60 phút" required>
                            </div>
                            <!-- Trạng thái -->
                            <div class="col-md-6 mb-3">
                                <label for="status" class="form-label fw-bold">Trạng thái</label>
                                <select class="form-select" id="status" name="status" required>
                                    <option value="Active" selected>Hoạt động</option>
                                    <option value="Inactive">Tạm ngưng</option>
                                </select>
                            </div>
                        </div>

                        <!-- Mô tả Lịch học -->
                        <div class="mb-4">
                            <label for="schedule_description" class="form-label fw-bold">Mô tả Lịch học</label>
                            <input type="text" class="form-control" id="schedule_description" name="schedule_description" placeholder="ví dụ: Thứ 2, 4, 6 từ 17h - 18h" required>
                        </div>

                        <!-- Nút hành động -->
                        <div class="d-flex justify-content-end gap-2 border-top pt-3 mt-3">
                            <a href="course" class="btn btn-secondary">
                                <i class="fas fa-times me-1"></i>Hủy
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-1"></i>Lưu Khóa học
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="Resources/bootstrap/js/bootstrap.bundle.min.js"></script>

</body>
</html>
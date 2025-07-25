<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Course" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%
    // --- Kiểm tra bảo mật & Lấy dữ liệu ---
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    // Biện pháp bảo vệ: Đảm bảo chỉ người dùng được ủy quyền mới có thể truy cập.
    if (user.getRole().getId() == 4) { // Giả sử vai trò 4 là khách hàng
        session.setAttribute("alert_message", "Bạn không có quyền truy cập trang này.");
        response.sendRedirect("course");
        return;
    }

    Course course = (Course) request.getAttribute("course");
    if (course == null) {
        session.setAttribute("alert_message", "Không tìm thấy khóa học được yêu cầu để xóa.");
        response.sendRedirect("course"); // Chuyển hướng về danh sách khóa học chính
        return;
    }

    // Định dạng tiền tệ cho VNĐ
    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác nhận Hành động cho Khóa học</title>
    <!-- Bootstrap CSS -->
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .details-label {
            font-weight: bold;
            color: #6c757d; /* Màu phụ của Bootstrap */
        }
        .details-value {
            margin-bottom: 1rem;
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
    (function() {
        // Dịch các thông báo phổ biến
        let message = '<%= alertMessage.replace("'", "\\'") %>';
        if (message.includes("Course deleted successfully")) {
            message = "Khóa học đã được xóa thành công.";
        } else if (message.includes("Failed to delete course")) {
            message = "Xóa khóa học thất bại.";
        } else if (message.includes("course could not be found")) {
            message = "Không tìm thấy khóa học được yêu cầu.";
        }
        alert(message);
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
            <div class="card shadow-sm border-danger">
                <div class="card-header bg-danger text-white">
                    <h2 class="mb-0 h4">
                        <i class="fas fa-exclamation-triangle me-2"></i>Xác nhận Hành động
                    </h2>
                </div>

                <div class="card-body p-4">
                    <p class="lead">Bạn muốn làm gì với khóa học này?</p>
                    <p class="text-muted">Bạn có thể <strong>tạm ngưng</strong> khóa học để ẩn nó khỏi người dùng, hoặc <strong>xóa vĩnh viễn</strong>. Hành động xóa không thể hoàn tác.</p>

                    <%-- Khối này xử lý các thông báo lỗi tại trang (ví dụ: nếu xóa thất bại) --%>
                    <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <%= request.getAttribute("error") %>
                    </div>
                    <% } %>

                    <hr>

                    <!-- Chi tiết Khóa học -->
                    <h5 class="mb-3">Thông tin Khóa học</h5>
                    <div class="row">
                        <div class="col-md-12">
                            <p class="details-label">Tên Khóa học</p>
                            <p class="details-value fs-5"><%= course.getName() %></p>
                        </div>
                        <div class="col-md-12">
                            <p class="details-label">Mô tả</p>
                            <p class="details-value" style="white-space: pre-wrap;"><%= course.getDescription() %></p>
                        </div>
                        <div class="col-md-4">
                            <p class="details-label">Giá</p>
                            <p class="details-value"><%= currencyFormatter.format(course.getPrice()) %></p>
                        </div>
                        <div class="col-md-4">
                            <p class="details-label">Thời lượng</p>
                            <p class="details-value"><%= course.getDuration() %> buổi</p>
                        </div>
                        <div class="col-md-4">
                            <p class="details-label">Trạng thái</p>
                            <p class="details-value">
                                <span class="badge <%= "Active".equals(course.getStatus()) ? "bg-success" : "bg-secondary" %>">
                                    <%= "Active".equals(course.getStatus()) ? "Hoạt động" : "Tạm ngưng" %>
                                </span>
                            </p>
                        </div>
                    </div>

                    <hr>

                    <!-- Các nút hành động -->
                    <div class="d-flex justify-content-end align-items-center gap-2 mt-3">
                        <a href="course?action=view&courseId=<%= course.getId() %>" class="btn btn-secondary">
                            <i class="fas fa-times me-1"></i>Hủy
                        </a>

                        <%-- Nút Tạm ngưng chỉ hiển thị nếu khóa học đang hoạt động --%>
                        <% if ("Active".equals(course.getStatus())) { %>
                        <form action="course?action=deactivate" method="post" class="d-inline" onsubmit="return confirm('Bạn có chắc muốn tạm ngưng khóa học này?');">
                            <input type="hidden" name="courseId" value="<%= course.getId() %>">
                            <button type="submit" class="btn btn-warning">
                                <i class="fas fa-pause-circle me-1"></i>Tạm ngưng
                            </button>
                        </form>
                        <% } %>

                        <%-- Nút Xóa vĩnh viễn --%>
                        <form action="course?action=delete" method="post" class="d-inline" onsubmit="return confirm('CẢNH BÁO: Bạn có chắc chắn muốn XÓA VĨNH VIỄN khóa học này không?');">
                            <input type="hidden" name="courseId" value="<%= course.getId() %>">
                            <button type="submit" class="btn btn-danger">
                                <i class="fas fa-trash-alt me-1"></i>Xóa Vĩnh viễn
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="Resources/bootstrap/js/bootstrap.bundle.min.js"></script>

</body>
</html>
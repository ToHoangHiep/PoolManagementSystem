<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Course" %>
<%
    // --- Security & Data Retrieval ---
    // Ensures only logged-in, authorized users can see this page.
    User user = (User) session.getAttribute("user");
    if (user == null) { //
        response.sendRedirect("login.jsp");
        return;
    }
    // Example: Role 4 (Customer) cannot edit courses.
    // This check should also be in your servlet for stronger security.
    if (user.getRole().getId() == 4) {
        session.setAttribute("alert_message", "Bạn không có quyền truy cập trang này.");
        response.sendRedirect("course");
        return;
    }

    Course course = (Course) request.getAttribute("course");
    if (course == null) {
        // If the course object is missing, we can't display the page.
        // Redirect to the list with a session-based alert.
        session.setAttribute("alert_message", "Không tìm thấy khóa học được yêu cầu để chỉnh sửa.");
        response.sendRedirect("course"); // Redirect to the main course list
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa Khóa học: <%= course.getName() %></title>
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

<%-- This block handles pop-up alert messages and actions sent from the servlet --%>
<%
    String alertMessage = (String) request.getAttribute("alert_message");
    if (alertMessage != null) {
        String alertAction = (String) request.getAttribute("alert_action");
%>
<script>
    (function() {
        let message = '<%= alertMessage.replace("'", "\\'") %>';
        // Dịch các thông báo phổ biến
        if (message.includes("Course updated successfully")) {
            message = "Khóa học đã được cập nhật thành công.";
        } else if (message.includes("Failed to update course")) {
            message = "Cập nhật khóa học thất bại.";
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
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h2 class="mb-0 h4">
                        <i class="fas fa-edit me-2"></i>Chỉnh sửa Khóa học
                    </h2>
                </div>

                <div class="card-body p-4">
                    <%-- This block handles on-page error messages (e.g., for validation) --%>
                    <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <%= request.getAttribute("error") %>
                    </div>
                    <% } %>

                    <form action="course?action=edit" method="post">
                        <%-- Hidden field to send the course ID back to the servlet --%>
                        <input type="hidden" name="courseId" value="<%= course.getId() %>">

                        <!-- Course Name -->
                        <div class="mb-3">
                            <label for="name" class="form-label fw-bold">Tên Khóa học</label>
                            <input type="text" class="form-control" id="name" name="name" value="<%= course.getName() %>" required>
                        </div>

                        <!-- Description -->
                        <div class="mb-3">
                            <label for="description" class="form-label fw-bold">Mô tả</label>
                            <textarea class="form-control" id="description" name="description" rows="4" required><%= course.getDescription() %></textarea>
                        </div>

                        <div class="row">
                            <!-- Price -->
                            <div class="col-md-6 mb-3">
                                <label for="price" class="form-label fw-bold">Giá (VNĐ)</label>
                                <input type="number" class="form-control" id="price" name="price" step="1" min="0" value="<%= (long) course.getPrice() %>" required>
                            </div>
                            <!-- Duration -->
                            <div class="col-md-6 mb-3">
                                <label for="duration" class="form-label fw-bold">Thời lượng (buổi)</label>
                                <input type="number" class="form-control" id="duration" name="duration" min="1" value="<%= course.getDuration() %>" required>
                            </div>
                        </div>

                        <div class="row">
                            <!-- Estimated Session Time -->
                            <div class="col-md-6 mb-3">
                                <label for="estimated_session_time" class="form-label fw-bold">Thời gian mỗi buổi</label>
                                <input type="text" class="form-control" id="estimated_session_time" name="estimated_session_time" value="<%= course.getEstimated_session_time() %>" required>
                            </div>
                            <!-- Status -->
                            <div class="col-md-6 mb-3">
                                <label for="status" class="form-label fw-bold">Trạng thái</label>
                                <select class="form-select" id="status" name="status" required>
                                    <option value="Active" <%= "Active".equals(course.getStatus()) ? "selected" : "" %>>Hoạt động</option>
                                    <option value="Inactive" <%= "Inactive".equals(course.getStatus()) ? "selected" : "" %>>Tạm ngưng</option>
                                </select>
                            </div>
                        </div>

                        <!-- Schedule Description -->
                        <div class="mb-4">
                            <label for="schedule_description" class="form-label fw-bold">Mô tả Lịch học</label>
                            <input type="text" class="form-control" id="schedule_description" name="schedule_description" value="<%= course.getSchedule_description() %>" required>
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex justify-content-end gap-2 border-top pt-3 mt-3">
                            <a href="course?action=list" class="btn btn-secondary">
                                <i class="fas fa-times me-1"></i>Hủy
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-1"></i>Lưu thay đổi
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
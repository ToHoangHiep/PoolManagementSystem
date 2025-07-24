<%@ page import="model.User" %>
<%@ page import="model.Course" %>
<%@ page import="model.Coach" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%
    // --- Kiểm tra người dùng đã đăng nhập ---
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // --- Lấy dữ liệu cho các Dropdown (từ Servlet) ---
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    List<Coach> coaches = (List<Coach>) request.getAttribute("coaches");

    // Biện pháp bảo vệ để tránh lỗi NullPointerException
    if (courses == null) courses = Collections.emptyList();
    if (coaches == null) coaches = Collections.emptyList();
%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gửi Phản hồi</title>
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .card {
            border: 1px solid #dee2e6;
        }
        /* CSS tùy chỉnh cho thanh trượt đánh giá có màu */
        .form-range {
            --track-color: #ffc107; /* Bắt đầu với màu vàng */
        }
        .form-range::-webkit-slider-runnable-track {
            background-color: var(--track-color);
        }
        .form-range::-moz-range-track {
            background-color: var(--track-color);
        }
    </style>
</head>
<body>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h1 class="h3 mb-0">Chia sẻ Trải nghiệm của bạn</h1>
                </div>
                <div class="card-body">
                    <%-- Hiển thị bất kỳ thông báo nào được truyền từ servlet --%>
                    <% if (request.getAttribute("alert_message") != null) { %>
                    <script>
                        alert('<%= request.getAttribute("alert_message") %>');
                    </script>
                    <% } %>

                    <form action="feedback?action=create" method="post">
                        <!-- Loại Phản hồi -->
                        <div class="mb-3">
                            <label for="feedback_type" class="form-label">Loại Phản hồi</label>
                            <select name="feedback_type" id="feedback_type" class="form-select" required onchange="showHideFields()">
                                <option value="" disabled selected>Chọn một loại...</option>
                                <option value="General">Phản hồi Chung</option>
                                <option value="Course">Phản hồi về Khóa học</option>
                                <option value="Coach">Phản hồi về Huấn luyện viên</option>
                            </select>
                        </div>

                        <!-- Chủ đề Cụ thể (cho phản hồi chung) -->
                        <div class="mb-3 d-none" id="general_feedback_type_group">
                            <label for="general_feedback_type" class="form-label">Chủ đề Cụ thể</label>
                            <select name="general_feedback_type" id="general_feedback_type" class="form-select">
                                <option value="" disabled selected>Chọn chủ đề cụ thể...</option>
                                <option value="Food">Đồ ăn & Dịch vụ ăn uống</option>
                                <option value="Service">Dịch vụ Khách hàng</option>
                                <option value="Facility">Cơ sở vật chất & Tiện nghi</option>
                                <option value="Other">Khác</option>
                            </select>
                        </div>

                        <%-- Dropdown cho Phản hồi Khóa học --%>
                        <div class="mb-3 d-none" id="course_feedback_group">
                            <label for="course_id" class="form-label">Chọn Khóa học</label>
                            <select name="course_id" id="course_id" class="form-select">
                                <option value="" disabled selected>-- Chọn một khóa học --</option>
                                <% for (Course c : courses) { %>
                                <option value="<%= c.getId() %>"><%= c.getName() %></option>
                                <% } %>
                            </select>
                        </div>

                        <%-- Dropdown cho Phản hồi Huấn luyện viên --%>
                        <div class="mb-3 d-none" id="coach_feedback_group">
                            <label for="coach_id" class="form-label">Chọn Huấn luyện viên</label>
                            <select name="coach_id" id="coach_id" class="form-select">
                                <option value="" disabled selected>-- Chọn một huấn luyện viên --</option>
                                <% for (Coach c : coaches) { %>
                                <option value="<%= c.getId() %>"><%= c.getFullName() %></option>
                                <% } %>
                            </select>
                        </div>

                        <!-- Nội dung Phản hồi -->
                        <div class="mb-3">
                            <label for="content" class="form-label">Nội dung Phản hồi Chi tiết</label>
                            <textarea name="content" id="content" rows="5" class="form-control" required placeholder="Vui lòng chia sẻ suy nghĩ của bạn..."></textarea>
                        </div>

                        <!-- Thanh trượt Đánh giá -->
                        <div class="mb-4">
                            <label for="rating" class="form-label">
                                Đánh giá Tổng thể: <span id="ratingValueDisplay" class="fw-bold">5</span>/10
                            </label>
                            <input type="range" class="form-range" id="rating" name="rating" min="0" max="10" step="1" value="5">
                        </div>

                        <!-- Nút hành động -->
                        <div class="d-flex justify-content-end gap-2">
                            <a href="home.jsp" class="btn btn-secondary">Hủy</a>
                            <button type="submit" class="btn btn-primary">Gửi Phản hồi</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="Resources/bootstrap/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Lấy tất cả các phần tử cần tương tác
        const feedbackTypeSelect = document.getElementById('feedback_type');
        const generalGroup = document.getElementById('general_feedback_type_group');
        const generalSelect = document.getElementById('general_feedback_type');
        const courseGroup = document.getElementById('course_feedback_group');
        const courseSelect = document.getElementById('course_id');
        const coachGroup = document.getElementById('coach_feedback_group');
        const coachSelect = document.getElementById('coach_id');
        const ratingSlider = document.getElementById('rating');
        const ratingValueDisplay = document.getElementById('ratingValueDisplay');

        // Hàm để hiển thị/ẩn các dropdown danh mục cụ thể
        window.showHideFields = function() {
            const selectedType = feedbackTypeSelect.value;

            // Ẩn tất cả các nhóm trước và bỏ thuộc tính 'required'
            generalGroup.classList.add('d-none');
            generalSelect.required = false;
            courseGroup.classList.add('d-none');
            courseSelect.required = false;
            coachGroup.classList.add('d-none');
            coachSelect.required = false;

            // Hiển thị nhóm liên quan dựa trên lựa chọn và đặt nó là bắt buộc
            if (selectedType === 'General') {
                generalGroup.classList.remove('d-none');
                generalSelect.required = true;
            } else if (selectedType === 'Course') {
                courseGroup.classList.remove('d-none');
                courseSelect.required = true;
            } else if (selectedType === 'Coach') {
                coachGroup.classList.remove('d-none');
                coachSelect.required = true;
            }
        };

        // Hàm để cập nhật hiển thị giá trị và màu sắc của thanh trượt
        function updateRating() {
            const value = ratingSlider.value;
            ratingValueDisplay.textContent = value; // Cập nhật hiển thị số

            let color;
            if (value <= 3) {
                color = '#dc3545'; // Màu đỏ (Danger) của Bootstrap
            } else if (value <= 7) {
                color = '#ffc107'; // Màu vàng (Warning) của Bootstrap
            } else {
                color = '#198754'; // Màu xanh lá (Success) của Bootstrap
            }
            // Đặt biến CSS mà stylesheet sử dụng
            ratingSlider.style.setProperty('--track-color', color);
        }

        // Thêm trình lắng nghe sự kiện cho thanh trượt
        ratingSlider.addEventListener('input', updateRating);

        // Thiết lập ban đầu khi tải trang để đảm bảo các trường được hiển thị đúng
        showHideFields();
        updateRating();
    });
</script>

</body>
</html>
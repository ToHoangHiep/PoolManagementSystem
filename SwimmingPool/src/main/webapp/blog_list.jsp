<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Course" %>
<%@ page import="model.Coach" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.Collections" %>

<%
    // --- Kiểm tra người dùng & vai trò ---
    User user = (User) session.getAttribute("user");
    boolean isAdmin = false;
    if (user != null && user.getRole() != null) {
        // Giả sử các vai trò khác 3 (Coach) và 4 (Customer) là quản trị viên
        isAdmin = !Arrays.asList(3, 4).contains(user.getRole().getId());
    }

    // --- Lấy dữ liệu từ Servlet ---
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    List<Coach> coaches = (List<Coach>) request.getAttribute("coaches");
    Map<Integer, Integer> courseCounts = (Map<Integer, Integer>) request.getAttribute("courseCounts");

    // --- Các biện pháp bảo vệ để render JSP ---
    if (courses == null) courses = Collections.emptyList();
    if (coaches == null) coaches = Collections.emptyList();
    if (courseCounts == null) courseCounts = Collections.emptyMap();
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh mục Khóa học & Huấn luyện viên</title>
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f0f2f5;
        }
        .directory-card {
            border: 1px solid #dee2e6;
            border-radius: 0.75rem;
            height: 100%;
            display: flex;
            flex-direction: column;
            background-color: #fff;
        }
        .card-title-link a {
            color: inherit;
            text-decoration: none;
            font-weight: 500;
        }
        .card-title-link a:hover {
            color: var(--bs-primary);
        }
        .coach-avatar {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border: 3px solid var(--bs-gray-200);
        }
        .card-text-truncate {
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
            min-height: 63px;
        }
        .card-body {
            flex-grow: 1;
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

<div class="container-fluid my-5 px-4">
    <!-- Tiêu đề trang -->
    <div class="text-center mb-5">
        <h1 class="display-5">Danh mục của chúng tôi</h1>
        <p class="lead text-muted">Khám phá các khóa học chuyên nghiệp và gặp gỡ các huấn luyện viên chuyên môn của chúng tôi.</p>
    </div>

    <div class="mb-4">
        <a href="home.jsp" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-left me-1"></i> Quay về Trang chủ
        </a>
        <a href="course?action=create_form" class="btn btn-outline-success">
            <i class="fas fa-plus me-1"></i> Đăng ký khóa học
        </a>
    </div>

    <div class="mb-5">
        <h2 class="h4 mb-4 border-bottom pb-2"><i class="fas fa-book-open text-primary me-2"></i>Các khóa học hiện có</h2>
        <div class="row row-cols-1 row-cols-lg-2 g-4">
            <% if (!courses.isEmpty()) { %>
            <% for (Course course : courses) { %>
            <div class="col">
                <div class="card directory-card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start">
                            <h5 class="card-title card-title-link mb-1">
                                <a href="blogs?action=view_course&courseId=<%= course.getId() %>"><%= course.getName() %></a>
                            </h5>
                            <%
                                String statusText = "Active".equals(course.getStatus()) ? "Hoạt động" : "Không hoạt động";
                                String statusClass = "Active".equals(course.getStatus()) ? "bg-success-subtle text-success-emphasis" : "bg-secondary-subtle text-secondary-emphasis";
                            %>
                            <span class="badge fs-6 <%= statusClass %>">
                                    <%= statusText %>
                                </span>
                        </div>
                        <p class="card-text card-text-truncate text-muted"><%= course.getDescription() %></p>
                        <ul class="list-unstyled text-secondary small">
                            <li class="mb-1"><i class="fas fa-dollar-sign fa-fw me-2"></i><strong>Giá:</strong> <%= String.format("%,.0f", course.getPrice()) %> VNĐ</li>
                            <li class="mb-1"><i class="fas fa-calendar-alt fa-fw me-2"></i><strong>Thời lượng:</strong> <%= course.getDuration() %> buổi</li>
                            <li><i class="fas fa-clock fa-fw me-2"></i><strong>Lịch học:</strong> <%= course.getSchedule_description() %></li>
                        </ul>
                    </div>
                    <div class="card-footer bg-light d-flex justify-content-between align-items-center">
                        <%-- Đây là phần logic mới của bạn đã được tích hợp --%>
                        <div>
                            <% if ("Active".equals(course.getStatus())) { %>
                            <a href="course?action=create_form&courseId=<%= course.getId() %>" class="btn btn-sm btn-primary">
                                Đăng ký ngay <i class="fas fa-arrow-right ms-1"></i>
                            </a>
                            <% } else { %>
                            <button class="btn btn-sm btn-secondary" disabled>
                                Tạm thời không có sẵn
                            </button>
                            <% } %>
                            <a class="btn btn-sm btn-info" href="blogs?action=view_course&courseId=<%= course.getId() %>">
                                Xem chi tiết
                            </a>
                        </div>
                        <div class="text-muted" title="Lượt đăng ký đã xác nhận">
                            <i class="fas fa-user-check me-1"></i>
                            <%= courseCounts.getOrDefault(course.getId(), 0) %>
                        </div>
                    </div>
                </div>
            </div>
            <% } %>
            <% } else { %>
            <div class="col">
                <div class="alert alert-info">Hiện tại không có khóa học nào.</div>
            </div>
            <% } %>
        </div>
    </div>

    <div>
        <h2 class="h4 mb-4 border-bottom pb-2"><i class="fas fa-user-tie text-success me-2"></i>Đội ngũ Huấn luyện viên chuyên nghiệp</h2>
        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
            <% if (!coaches.isEmpty()) { %>
            <% for (Coach coach : coaches) { %>
            <div class="col">
                <div class="card directory-card">
                    <div class="card-body d-flex">
                        <img src="<%= coach.getProfilePicture() != null && !coach.getProfilePicture().isEmpty() ? coach.getProfilePicture() : "images/coach"+coach.getId()+".jpg" %>"
                             alt="images/default-avatar.jpg" class="rounded-circle coach-avatar me-3"
                        >
                        <div class="flex-grow-1">
                            <h5 class="card-title card-title-link mb-1">
                                <a href="blogs?action=view_coach&coachId=<%= coach.getId() %>"><%= coach.getFullName() %></a>
                            </h5>
                            <p class="card-text card-text-truncate text-muted"><%= coach.getBio() != null ? coach.getBio() : "Huấn luyện viên chuyên nghiệp, tận tâm giúp bạn đạt được mục tiêu bơi lội." %></p>
                        </div>
                    </div>
                    <div class="card-footer bg-light text-end">
                        <a href="blogs?action=view_coach&coachId=<%= coach.getId() %>" class="btn btn-sm btn-success">
                            Xem hồ sơ <i class="fas fa-arrow-right ms-1"></i>
                        </a>
                    </div>
                </div>
            </div>
            <% } %>
            <% } else { %>
            <div class="col">
                <div class="alert alert-info">Hiện tại không có huấn luyện viên nào.</div>
            </div>
            <% } %>
        </div>
    </div>

</div>

<script src="Resources/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Coach" %>

<%
    // --- Lấy dữ liệu từ Servlet ---
    Coach coach = (Coach) request.getAttribute("coach");

    // --- Biện pháp bảo vệ ---
    if (coach == null) {
        session.setAttribute("alert_message", "Không tìm thấy huấn luyện viên được yêu cầu.");
        response.sendRedirect("blogs"); // Chuyển hướng về trang danh mục chính
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ Huấn luyện viên: <%= coach.getFullName() %></title>
    <!-- Bootstrap CSS -->
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f0f2f5;
        }
        .profile-card {
            border: none;
            border-radius: 0.75rem;
            background-color: #fff;
        }
        .profile-header {
            /* Sử dụng gradient màu xanh lá cây cho huấn luyện viên */
            background-image: linear-gradient(135deg, #198754, #146c43);
            color: white;
            padding: 2rem;
            border-top-left-radius: 0.75rem;
            border-top-right-radius: 0.75rem;
            position: relative;
        }
        .profile-picture {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            border: 5px solid rgba(255, 255, 255, 0.8);
            object-fit: cover;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            margin-top: -95px; /* Kéo ảnh lên trên một chút */
            background-color: white;
        }
        .bio-text {
            white-space: pre-wrap; /* Giữ lại các dấu xuống dòng từ tiểu sử */
            font-size: 1.05rem;
            line-height: 1.7;
            color: #495057;
        }
        .detail-item {
            display: flex;
            align-items: flex-start;
            margin-bottom: 1.25rem;
        }
        .detail-item .icon {
            font-size: 1.25rem;
            color: var(--bs-success); /* Màu xanh lá cây cho icon */
            width: 30px;
            text-align: center;
            margin-right: 1rem;
            padding-top: 0.25rem;
        }
        .detail-item .content .label {
            font-weight: bold;
            color: #6c757d;
            display: block;
            margin-bottom: 0.25rem;
        }
        .detail-item .content .value {
            font-size: 1.1rem;
        }
        .btn-back {
            position: absolute;
            top: 1rem;
            left: 1rem;
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
    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="card shadow-lg profile-card">
                <!-- Header của thẻ -->
                <div class="profile-header">
                    <a href="blogs" class="btn btn-light btn-back">
                        <i class="fas fa-arrow-left me-1"></i> Quay lại Danh mục
                    </a>
                    <div class="text-center">
                        <h1 class="display-5 mb-1"><%= coach.getFullName() %></h1>
                    </div>
                </div>

                <!-- Ảnh đại diện được đặt giữa header và body -->
                <div class="card-body text-center" style="margin-top: -75px;">
                    <img src="<%= coach.getProfilePicture() != null && !coach.getProfilePicture().isEmpty() ? coach.getProfilePicture() : "https://via.placeholder.com/150" %>"
                         alt="Ảnh đại diện của <%= coach.getFullName() %>" class="profile-picture mb-3">
                </div>

                <!-- Thân thẻ với thông tin chi tiết -->
                <div class="card-body p-4 p-md-5 pt-3">
                    <div class="row">
                        <!-- Phần Tiểu sử -->
                        <div class="col-lg-7 border-end-lg mb-4 mb-lg-0">
                            <h4 class="mb-3 border-bottom pb-2"><i class="fas fa-user-circle me-2"></i>Giới thiệu</h4>
                            <p class="bio-text text-secondary"><%= coach.getBio() != null && !coach.getBio().isEmpty() ? coach.getBio() : "Chưa có tiểu sử." %></p>
                        </div>

                        <!-- Phần Thông tin liên hệ -->
                        <div class="col-lg-5">
                            <h4 class="mb-3 border-bottom pb-2"><i class="fas fa-info-circle me-2"></i>Thông tin chi tiết</h4>
                            <div class="detail-item">
                                <div class="icon"><i class="fas fa-envelope fa-fw"></i></div>
                                <div class="content">
                                    <span class="label">Email</span>
                                    <a href="mailto:<%= coach.getEmail() %>" class="value"><%= coach.getEmail() %></a>
                                </div>
                            </div>
                            <div class="detail-item">
                                <div class="icon"><i class="fas fa-phone fa-fw"></i></div>
                                <div class="content">
                                    <span class="label">Số điện thoại</span>
                                    <span class="value"><%= coach.getPhone() != null ? coach.getPhone() : "Chưa cập nhật" %></span>
                                </div>
                            </div>
                            <div class="detail-item">
                                <div class="icon"><i class="fas fa-venus-mars fa-fw"></i></div>
                                <div class="content">
                                    <span class="label">Giới tính</span>
                                    <span class="value"><%= coach.getGender() %></span>
                                </div>
                            </div>
                            <div class="detail-item">
                                <div class="icon"><i class="fas fa-check-circle fa-fw"></i></div>
                                <div class="content">
                                    <span class="label">Trạng thái</span>
                                    <span class="value">
                                        <% if (coach.isActive()) { %>
                                            <span class="badge fs-6 bg-success">Đang hoạt động</span>
                                        <% } else { %>
                                            <span class="badge fs-6 bg-secondary">Tạm ngưng</span>
                                        <% } %>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Nút hành động -->
                    <hr class="my-4">
                    <div class="text-center">
                        <% if (coach.isActive()) { %>
                        <%-- Sửa lại URL cho đúng --%>
                        <a href="course?action=create_form&coachId=<%= coach.getId() %>" class="btn btn-success btn-lg">
                            <i class="fas fa-user-plus me-2"></i>Đăng ký với Huấn luyện viên này
                        </a>
                        <% } else { %>
                        <button class="btn btn-secondary btn-lg" disabled>
                            <i class="fas fa-times-circle me-2"></i>Hiện không nhận học viên
                        </button>
                        <% } %>
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
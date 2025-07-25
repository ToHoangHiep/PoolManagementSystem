<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Course" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%
    // --- Lấy dữ liệu từ Servlet ---
    Course course = (Course) request.getAttribute("course");
    Integer registrationCount = (Integer) request.getAttribute("registrationCount");

    // --- Biện pháp bảo vệ ---
    // Nếu đối tượng khóa học bị thiếu, chuyển hướng về trang danh mục chính.
    if (course == null) {
        session.setAttribute("alert_message", "Không tìm thấy khóa học được yêu cầu.");
        response.sendRedirect("blogs"); // Chuyển hướng về trang danh mục chính
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
    <title>Chi tiết Khóa học: <%= course.getName() %></title>
    <!-- Bootstrap CSS -->
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f0f2f5;
        }
        .details-card {
            border: none;
            border-radius: 0.75rem;
            background-color: #fff;
        }
        .details-header {
            /* Sử dụng gradient để header trông đẹp hơn */
            background-image: linear-gradient(135deg, #0d6efd, #0056b3);
            color: white;
            padding: 2rem;
            border-top-left-radius: 0.75rem;
            border-top-right-radius: 0.75rem;
        }
        .details-header h1 {
            font-weight: 300;
        }
        .detail-item {
            display: flex;
            align-items: flex-start;
            margin-bottom: 1.25rem;
        }
        .detail-item .icon {
            font-size: 1.25rem;
            color: var(--bs-primary);
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
        .description-text {
            white-space: pre-wrap; /* Giữ lại các dấu xuống dòng từ mô tả */
            font-size: 1.05rem;
            line-height: 1.7;
            color: #495057;
        }
        .btn-back {
            position: absolute;
            top: 1rem;
            left: 1rem;
        }
    </style>
</head>
<body>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="card shadow-lg details-card">
                <!-- Header của thẻ với Tiêu đề và Nút Quay lại -->
                <div class="details-header text-center position-relative">
                    <a href="blogs" class="btn btn-light btn-back">
                        <i class="fas fa-arrow-left me-1"></i> Quay lại Danh mục
                    </a>
                    <h1 class="display-5 mb-1"><%= course.getName() %></h1>
                    <p class="lead mb-0">Khám phá chi tiết về khóa học này.</p>
                </div>

                <!-- Thân thẻ với thông tin khóa học -->
                <div class="card-body p-4 p-md-5">
                    <!-- Mô tả khóa học -->
                    <div class="mb-4">
                        <h4 class="mb-3 border-bottom pb-2">Mô tả Khóa học</h4>
                        <p class="description-text"><%= course.getDescription() %></p>
                    </div>

                    <hr class="my-4">

                    <!-- Phần Chi tiết chính -->
                    <h4 class="mb-4 border-bottom pb-2">Thông tin chi tiết</h4>
                    <div class="row g-4">
                        <div class="col-md-6">
                            <div class="detail-item">
                                <div class="icon"><i class="fas fa-dollar-sign fa-fw"></i></div>
                                <div class="content">
                                    <span class="label">Học phí</span>
                                    <%-- Sử dụng NumberFormat để định dạng tiền tệ VNĐ --%>
                                    <span class="value"><%= currencyFormatter.format(course.getPrice()) %></span>
                                </div>
                            </div>
                            <div class="detail-item">
                                <div class="icon"><i class="fas fa-calendar-alt fa-fw"></i></div>
                                <div class="content">
                                    <span class="label">Thời lượng</span>
                                    <span class="value"><%= course.getDuration() %> buổi</span>
                                </div>
                            </div>
                            <div class="detail-item">
                                <div class="icon"><i class="fas fa-clock fa-fw"></i></div>
                                <div class="content">
                                    <span class="label">Thời gian mỗi buổi (dự kiến)</span>
                                    <span class="value"><%= course.getEstimated_session_time() %></span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="detail-item">
                                <div class="icon"><i class="fas fa-info-circle fa-fw"></i></div>
                                <div class="content">
                                    <span class="label">Trạng thái</span>
                                    <span class="value">
                                        <%
                                            String statusText = "Active".equals(course.getStatus()) ? "Đang hoạt động" : "Tạm ngưng";
                                            String statusClass = "Active".equals(course.getStatus()) ? "bg-success" : "bg-secondary";
                                        %>
                                        <span class="badge fs-6 <%= statusClass %>"><%= statusText %></span>
                                    </span>
                                </div>
                            </div>
                            <div class="detail-item">
                                <div class="icon"><i class="fas fa-users fa-fw"></i></div>
                                <div class="content">
                                    <span class="label">Lượt đăng ký đã xác nhận</span>
                                    <span class="value"><%= registrationCount %> học viên</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="detail-item">
                                <div class="icon"><i class="fas fa-calendar-check fa-fw"></i></div>
                                <div class="content">
                                    <span class="label">Mô tả Lịch học</span>
                                    <span class="value"><%= course.getSchedule_description() %></span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <hr class="my-4">

                    <!-- Nút hành động -->
                    <div class="text-center mt-4">
                        <% if ("Active".equals(course.getStatus())) { %>
                        <a href="course?action=create_form&courseId=<%= course.getId() %>" class="btn btn-success btn-lg">
                            <i class="fas fa-user-plus me-2"></i>Đăng ký Khóa học này
                        </a>
                        <% } else { %>
                        <button class="btn btn-secondary btn-lg" disabled>
                            <i class="fas fa-times-circle me-2"></i>Hiện không có sẵn
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
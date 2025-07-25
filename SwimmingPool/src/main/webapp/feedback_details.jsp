<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Feedback" %>
<%@ page import="model.Course" %>
<%@ page import="model.Coach" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // --- Lấy dữ liệu từ Servlet ---
    Feedback feedback = (Feedback) request.getAttribute("feedback");
    if (feedback == null) {
        session.setAttribute("alert_message", "Không tìm thấy phản hồi được yêu cầu.");
        response.sendRedirect("feedback?action=list");
        return;
    }

    // Lấy các đối tượng liên quan được truyền từ servlet
    Course relatedCourse = (Course) request.getAttribute("relatedCourse");
    Coach relatedCoach = (Coach) request.getAttribute("relatedCoach");

    // Định dạng ngày tháng cho phù hợp với tiếng Việt
    SimpleDateFormat sdf = new SimpleDateFormat("HH:mm 'ngày' dd/MM/yyyy");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Phản hồi</title>
    <!-- Bootstrap CSS -->
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .details-label { font-weight: bold; color: #6c757d; }
        .rating-display { font-size: 1.5rem; font-weight: bold; }
        .rating-bar {
            height: 10px;
            border-radius: 5px;
            background-color: #e9ecef;
        }
        .rating-bar-inner {
            height: 100%;
            border-radius: 5px;
            transition: width 0.5s ease-in-out;
        }
    </style>
</head>
<body>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-9">
            <div class="card shadow-sm">
                <div class="card-header bg-white py-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <h3 class="mb-0">
                            <i class="fas fa-comment-dots me-2 text-primary"></i>Chi tiết Phản hồi
                        </h3>
                        <a href="feedback?action=list" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-1"></i>Quay lại Danh sách Phản hồi
                        </a>
                    </div>
                </div>

                <div class="card-body p-4">
                    <!-- Thông tin người dùng và ngày tháng -->
                    <div class="d-flex flex-wrap justify-content-between text-muted mb-4 pb-3 border-bottom">
                        <div>
                            <span class="details-label">Gửi bởi:</span>
                            <%= feedback.getUserName() %> (<a href="mailto:<%= feedback.getUserEmail() %>"><%= feedback.getUserEmail() %></a>)
                        </div>
                        <div>
                            <span class="details-label">Ngày gửi:</span>
                            <%= sdf.format(feedback.getCreatedAt()) %>
                        </div>
                    </div>

                    <div class="row">
                        <!-- Đối tượng Phản hồi -->
                        <div class="col-md-7 mb-4">
                            <h5 class="mb-3">Đối tượng Phản hồi</h5>
                            <%-- Khối này hiển thị động đối tượng phản hồi --%>
                            <% if ("Course".equals(feedback.getFeedbackType()) && relatedCourse != null) { %>
                            <p class="mb-1"><strong class="details-label">Loại:</strong> Khóa học</p>
                            <p><strong class="details-label">Tên:</strong> <%= relatedCourse.getName() %></p>
                            <% } else if ("Coach".equals(feedback.getFeedbackType()) && relatedCoach != null) { %>
                            <p class="mb-1"><strong class="details-label">Loại:</strong> Huấn luyện viên</p>
                            <p><strong class="details-label">Tên:</strong> <%= relatedCoach.getFullName() %></p>
                            <% } else {
                                String generalType = feedback.getGeneralFeedbackType();
                                String translatedGeneralType = "Khác"; // Mặc định
                                if ("Food".equals(generalType)) translatedGeneralType = "Đồ ăn & Dịch vụ";
                                if ("Service".equals(generalType)) translatedGeneralType = "Dịch vụ Khách hàng";
                                if ("Facility".equals(generalType)) translatedGeneralType = "Cơ sở vật chất";
                            %>
                            <p class="mb-1"><strong class="details-label">Loại:</strong> Chung</p>
                            <p><strong class="details-label">Chủ đề:</strong> <%= translatedGeneralType %></p>
                            <% } %>
                        </div>

                        <!-- Đánh giá -->
                        <div class="col-md-5 mb-4">
                            <h5 class="mb-3">Đánh giá Tổng thể</h5>
                            <div class="d-flex align-items-center">
                                <span class="rating-display me-3"><%= feedback.getRating() %> / 10</span>
                                <div class="flex-grow-1">
                                    <div class="rating-bar">
                                        <div id="ratingBarInner" class="rating-bar-inner"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <hr class="my-3">

                    <!-- Nội dung -->
                    <div>
                        <h5 class="mb-3">Nội dung Phản hồi</h5>
                        <p class="text-secondary" style="white-space: pre-wrap;"><%= feedback.getContent() %></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="Resources/bootstrap/js/bootstrap.bundle.min.js"></script>
<script>
    // Script này tô màu thanh đánh giá một cách linh động dựa trên điểm số
    document.addEventListener('DOMContentLoaded', function() {
        const rating = <%= feedback.getRating() %>;
        const ratingBarInner = document.getElementById('ratingBarInner');
        const percentage = rating * 10; // Chuyển đổi điểm đánh giá sang phần trăm

        let color;
        if (rating <= 3) {
            color = 'var(--bs-danger)'; // Màu đỏ
        } else if (rating <= 7) {
            color = 'var(--bs-warning)'; // Màu vàng
        } else {
            color = 'var(--bs-success)'; // Màu xanh
        }

        ratingBarInner.style.width = percentage + '%';
        ratingBarInner.style.backgroundColor = color;
    });
</script>
</body>
</html>
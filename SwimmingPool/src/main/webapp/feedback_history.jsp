<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Feedback" %>
<%@ page import="model.Course" %>
<%@ page import="model.Coach" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // --- Kiểm tra bảo mật & Lấy dữ liệu ---
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    // Ví dụ: Vai trò 4 (Khách hàng) không thể quản lý phản hồi.
    if (adminUser.getRole().getId() == 4) {
        session.setAttribute("alert_message", "Bạn không có quyền truy cập trang này.");
        response.sendRedirect("home.jsp");
        return;
    }

    // Dữ liệu từ Servlet
    List<Feedback> feedbackList = (List<Feedback>) request.getAttribute("feedbackList");
    Map<Integer, Course> courseMap = (Map<Integer, Course>) request.getAttribute("courseMap");
    Map<Integer, Coach> coachMap = (Map<Integer, Coach>) request.getAttribute("coachMap");
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM, yyyy");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Phản hồi</title>
    <!-- Bootstrap CSS -->
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .table-hover tbody tr:hover { background-color: #e9ecef; }
        .rating-star { color: #ffc107; }
    </style>
</head>
<body>

<%-- Xử lý thông báo alert từ session --%>
<%
    String alertMessage = (String) session.getAttribute("alert_message");
    if (alertMessage != null) {
        session.removeAttribute("alert_message");
%>
<script>
    // Dịch các thông báo phổ biến
    let message = '<%= alertMessage.replace("'", "\\'") %>';
    if (message.includes("You do not have permission")) {
        message = "Bạn không có quyền truy cập trang này.";
    }
    alert(message);
</script>
<%
    }
%>

<div class="container my-5">
    <div class="card shadow-sm">
        <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
            <h2 class="mb-0 h4">
                <i class="fas fa-comments me-2 text-primary"></i>Quản lý Phản hồi Người dùng
            </h2>
            <a href="home.jsp" class="btn btn-sm btn-outline-secondary">
                <i class="fas fa-arrow-left me-1"></i> Quay về Trang chủ
            </a>
        </div>
        <div class="card-body">
            <% if (feedbackList == null || feedbackList.isEmpty()) { %>
            <div class="alert alert-info text-center">
                Hiện tại không có phản hồi nào để hiển thị.
            </div>
            <% } else { %>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>Mã</th>
                        <th>Người gửi</th>
                        <th class="text-center">Loại</th>
                        <th>Đối tượng</th>
                        <th class="text-center">Đánh giá</th>
                        <th>Ngày gửi</th>
                        <th class="text-end">Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Feedback feedback : feedbackList) { %>
                    <tr>
                        <td>#<%= feedback.getId() %></td>
                        <td><%= feedback.getUserName() %></td>
                        <td class="text-center">
                            <%
                                String type = feedback.getFeedbackType();
                                String badgeClass = "bg-secondary";
                                String translatedType = "Chung"; // Mặc định
                                if ("Course".equals(type)) {
                                    badgeClass = "bg-primary";
                                    translatedType = "Khóa học";
                                }
                                if ("Coach".equals(type)) {
                                    badgeClass = "bg-info text-dark";
                                    translatedType = "Huấn luyện viên";
                                }
                                if ("General".equals(type)) {
                                    badgeClass = "bg-success";
                                }
                            %>
                            <span class="badge <%= badgeClass %>"><%= translatedType %></span>
                        </td>
                        <td>
                            <%-- Hiển thị động đối tượng phản hồi --%>
                            <% if ("Course".equals(type) && courseMap.containsKey(feedback.getCourseId())) { %>
                            <%= courseMap.get(feedback.getCourseId()).getName() %>
                            <% } else if ("Coach".equals(type) && coachMap.containsKey(feedback.getCoachId())) { %>
                            <%= coachMap.get(feedback.getCoachId()).getFullName() %>
                            <% } else if ("General".equals(type)) {
                                String generalType = feedback.getGeneralFeedbackType();
                                String translatedGeneralType = "Khác"; // Mặc định
                                if ("Food".equals(generalType)) translatedGeneralType = "Đồ ăn & Dịch vụ";
                                if ("Service".equals(generalType)) translatedGeneralType = "Dịch vụ Khách hàng";
                                if ("Facility".equals(generalType)) translatedGeneralType = "Cơ sở vật chất";
                            %>
                            <%= translatedGeneralType %>
                            <% } else { %>
                            <span class="text-muted">N/A</span>
                            <% } %>
                        </td>
                        <td class="text-center">
                            <span class="rating-star"><i class="fas fa-star"></i></span>
                            <%= feedback.getRating() %>
                        </td>
                        <td><%= sdf.format(feedback.getCreatedAt()) %></td>
                        <td class="text-end">
                            <a href="feedback?action=details&id=<%= feedback.getId() %>" class="btn btn-sm btn-outline-primary">
                                <i class="fas fa-eye me-1"></i>Xem Chi tiết
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
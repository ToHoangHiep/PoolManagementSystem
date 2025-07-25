<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Course" %>
<%@ page import="model.Coach" %>
<%@ page import="model.CourseForm" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // --- Bảo mật & Lấy dữ liệu ---
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    CourseForm form = (CourseForm) request.getAttribute("courseForm");
    Course course = (Course) request.getAttribute("course");
    Coach coach = (Coach) request.getAttribute("coach");
    User applicant = (User) request.getAttribute("user"); // Sửa tên thuộc tính cho rõ ràng
    boolean isManagement = (boolean) request.getAttribute("isManagement");

    // Nếu thiếu bất kỳ dữ liệu cần thiết nào, chuyển hướng an toàn
    if (form == null || course == null || coach == null) {
        session.setAttribute("alert_message", "Không thể lấy chi tiết đăng ký hoàn chỉnh.");
        response.sendRedirect("course?action=list_form");
        return;
    }

    boolean isGuest = form.getUser_id() <= 0;
    // Cập nhật định dạng ngày tháng cho phù hợp với tiếng Việt
    SimpleDateFormat sdf = new SimpleDateFormat("HH:mm 'ngày' dd/MM/yyyy");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Đơn đăng ký #<%= form.getId() %></title>
    <!-- Bootstrap CSS -->
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .details-label { font-weight: bold; color: #6c757d; }
        .details-value { margin-bottom: 1rem; }
        .avatar-circle {
            width: 64px; height: 64px;
            display: flex; align-items: center; justify-content: center;
            border-radius: 50%; font-size: 2rem;
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
        <div class="col-lg-9">
            <div class="card shadow-sm">
                <!-- Header của Card -->
                <div class="card-header bg-white py-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <h3 class="mb-0">
                            <i class="fas fa-clipboard-list me-2 text-primary"></i>Chi tiết Đơn đăng ký
                        </h3>
                        <a href="course?action=list_form" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-1"></i>Quay lại Danh sách Đơn
                        </a>
                    </div>
                </div>

                <!-- Thân Card -->
                <div class="card-body p-4">
                    <%-- Hiển thị lỗi tại trang --%>
                    <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <%= request.getAttribute("error") %>
                    </div>
                    <% } %>

                    <!-- Siêu dữ liệu của Đơn -->
                    <div class="d-flex flex-wrap align-items-center gap-4 mb-4 pb-3 border-bottom">
                        <div>
                            <p class="details-label mb-1">Mã đơn</p>
                            <p class="details-value fw-bold mb-0">#<%= form.getId() %></p>
                        </div>
                        <div>
                            <p class="details-label mb-1">Ngày gửi yêu cầu</p>
                            <p class="details-value fw-bold mb-0"><%= sdf.format(form.getRequest_date()) %></p>
                        </div>
                        <div>
                            <p class="details-label mb-1">Trạng thái</p>
                            <p class="details-value mb-0">
                                <%
                                    // Determine the status text and CSS class based on the integer value
                                    String statusText;
                                    String statusClass;
                                    int status = form.getHas_processed(); // Use getHas_processed() which returns an int

                                    statusClass = switch (status) {
                                        case 1 -> {
                                            statusText = "Đã xác nhận";
                                            yield "bg-success";
                                        }
                                        case 2 -> {
                                            statusText = "Đã từ chối";
                                            yield "bg-danger";
                                        }
                                        default -> {
                                            statusText = "Chờ xác nhận";
                                            yield "bg-warning text-dark";
                                        }
                                    };
                                %>
                                <span class="badge fs-6 <%= statusClass %>">
                                    <%= statusText %>
                                </span>
                            </p>
                        </div>
                        <% if (form.getHas_processed() == 2) { %>
                        <div>
                            <p class="details-label mb-1">Lý do</p>
                            <p class="details-value fw-bold mb-0"><%= form.getRejected_reason() %></p>
                        </div>
                        <% } %>
                    </div>

                    <div class="row">
                        <!-- Phần thông tin người dùng -->
                        <div class="col-md-6 mb-4 mb-md-0">
                            <h5 class="mb-3">Thông tin Người đăng ký</h5>
                            <div class="d-flex align-items-center">
                                <div class="avatar-circle <%= isGuest ? "bg-secondary" : "bg-primary" %> text-white me-3">
                                    <i class="fas <%= isGuest ? "fa-user-secret" : "fa-user-check" %>"></i>
                                </div>
                                <div>
                                    <% if (isGuest) { %>
                                    <%-- Hiển thị thông tin từ đơn cho khách --%>
                                    <h5 class="mb-0"><%= form.getUser_fullName() %></h5>
                                    <a href="mailto:<%= form.getUser_email() %>" class="text-muted text-decoration-none"><%= form.getUser_email() %></a>
                                    <p class="mb-0 text-muted"><%= form.getUser_phone() %></p>
                                    <% } else if (applicant != null) { %>
                                    <%-- Hiển thị thông tin từ đối tượng User cho người dùng đã đăng ký --%>
                                    <h5 class="mb-0"><%= applicant.getFullName() %></h5>
                                    <a href="mailto:<%= applicant.getEmail() %>" class="text-muted text-decoration-none"><%= applicant.getEmail() %></a>
                                    <p class="mb-0 text-muted"><%= applicant.getPhoneNumber() %></p>
                                    <% } else { %>
                                    <%-- Dự phòng cho trường hợp dữ liệu không nhất quán --%>
                                    <h5 class="mb-0 text-danger fst-italic">Thiếu dữ liệu người dùng</h5>
                                    <p class="text-muted">Người dùng đã đăng ký (ID: <%= form.getUser_id() %>)</p>
                                    <% } %>
                                    <p class="mb-0 mt-1">
                                        <span class="badge <%= isGuest ? "bg-info text-dark" : "bg-success" %>">
                                            <%= isGuest ? "Người dùng Khách" : "Người dùng Hệ thống" %>
                                        </span>
                                    </p>
                                </div>
                            </div>
                        </div>

                        <!-- Phần Khóa học & Huấn luyện viên -->
                        <div class="col-md-6">
                            <h5 class="mb-3">Đăng ký cho</h5>
                            <div class="mb-3">
                                <p class="details-label mb-0">Khóa học</p>
                                <p class="details-value fs-5"><%= course.getName() %></p>
                            </div>
                            <div class="mb-3">
                                <p class="details-label mb-0">Huấn luyện viên Phụ trách</p>
                                <p class="details-value fs-5"><%= coach.getFullName() %></p>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- Chân Card với Nút hành động --%>
                <% if (form.getHas_processed() == 0 && isManagement && form.getUser_id() != user.getId()) { %>
                <div class="card-footer bg-light p-3">
                    <form id="decisionForm" method="post" novalidate>
                        <input type="hidden" name="formId" value="<%= form.getId() %>">

                        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                            <!-- Left side: Controls for confirmation and rejection -->
                            <div class="d-flex align-items-center gap-3">
                                <div class="form-check form-switch fs-5">
                                    <input class="form-check-input" type="checkbox" role="switch" id="confirmSwitch" checked>
                                    <label class="form-check-label pt-1" for="confirmSwitch" id="switchLabel">Xác nhận</label>
                                </div>

                                <!-- This container will only appear when rejecting -->
                                <div id="rejectionReasonContainer" class="d-none">
                                    <select class="form-select form-select-sm" name="reason" id="rejectionReason" required>
                                        <option value="" selected disabled>Chọn lý do từ chối...</option>
                                        <option value="Lịch học không phù hợp">Lịch học không phù hợp</option>
                                        <option value="Khóa học đã đủ học viên">Khóa học đã đủ học viên</option>
                                        <option value="Thông tin đăng ký không hợp lệ">Thông tin đăng ký không hợp lệ</option>
                                        <option value="Khác">Khác</option>
                                    </select>
                                </div>
                            </div>

                            <!-- Right side: The dynamic submit button -->
                            <button type="submit" id="submitButton" class="btn btn-success">
                                <i class="fas fa-check-circle me-1"></i>Xác nhận Đơn đăng ký
                            </button>
                        </div>
                    </form>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="Resources/bootstrap/js/bootstrap.bundle.min.js"></script>

<%-- Add this new script block for the dynamic form --%>
<script>
    // This script only runs if the decision form is present on the page
    const decisionForm = document.getElementById('decisionForm');
    if (decisionForm) {
        const confirmSwitch = document.getElementById('confirmSwitch');
        const switchLabel = document.getElementById('switchLabel');
        const reasonContainer = document.getElementById('rejectionReasonContainer');
        const reasonSelect = document.getElementById('rejectionReason');
        const submitButton = document.getElementById('submitButton');

        function updateFormState() {
            if (confirmSwitch.checked) {
                // --- STATE: CONFIRM ---
                switchLabel.textContent = 'Xác nhận';
                reasonContainer.classList.add('d-none');
                reasonSelect.required = false; // No reason needed for confirmation

                decisionForm.action = 'course?action=form_confirmed';
                submitButton.className = 'btn btn-success';
                submitButton.innerHTML = '<i class="fas fa-check-circle me-1"></i>Xác nhận Đơn đăng ký';

                // Update the confirmation prompt
                decisionForm.onsubmit = () => confirm('Bạn có chắc chắn muốn XÁC NHẬN đơn đăng ký này không? Email sẽ được gửi đi.');

            } else {
                // --- STATE: REJECT ---
                switchLabel.textContent = 'Từ chối';
                reasonContainer.classList.remove('d-none');
                reasonSelect.required = true; // Reason is required for rejection

                decisionForm.action = 'course?action=form_rejected';
                submitButton.className = 'btn btn-danger';
                submitButton.innerHTML = '<i class="fas fa-times-circle me-1"></i>Từ chối Đơn đăng ký';

                // Update the confirmation prompt
                decisionForm.onsubmit = () => {
                    if (!reasonSelect.value) {
                        alert('Vui lòng chọn lý do từ chối.');
                        return false;
                    }
                    return confirm('Bạn có chắc chắn muốn TỪ CHỐI đơn đăng ký này không? Email sẽ được gửi đi.');
                };
            }
        }

        // Add event listener to the switch
        confirmSwitch.addEventListener('change', updateFormState);

        // Run once on page load to set the initial correct state
        document.addEventListener('DOMContentLoaded', updateFormState);
    }
</script>
</body>
</html>
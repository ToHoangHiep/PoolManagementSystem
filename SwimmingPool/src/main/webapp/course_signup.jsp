<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Course" %>
<%@ page import="model.Coach" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%
    // --- Lấy dữ liệu người dùng & dữ liệu từ Servlet ---
    User user = (User) session.getAttribute("user");
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    List<Coach> coaches = (List<Coach>) request.getAttribute("coaches");

    // Lấy ID đã được chọn trước từ servlet
    Integer preselectedCourseId = (Integer) request.getAttribute("preselectedCourseId");
    Integer preselectedCoachId = (Integer) request.getAttribute("preselectedCoachId");

    // --- Tìm đối tượng Course và Coach tương ứng nếu có ID ---
    Course selectedCourse = null;
    if (preselectedCourseId != null && courses != null) {
        for (Course c : courses) {
            if (c.getId() == preselectedCourseId) {
                selectedCourse = c;
                break;
            }
        }
    }

    Coach selectedCoach = null;
    if (preselectedCoachId != null && coaches != null) {
        for (Coach c : coaches) {
            if (c.getId() == preselectedCoachId) {
                selectedCoach = c;
                break;
            }
        }
    }

    // --- Biện pháp bảo vệ để render JSP ---
    if (courses == null) courses = Collections.emptyList();
    if (coaches == null) coaches = Collections.emptyList();

    // Định dạng tiền tệ cho VNĐ
    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký Khóa học</title>
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .details-box {
            transition: opacity 0.3s ease-in-out;
        }
    </style>
</head>
<body>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h2 class="mb-0 h4"><i class="fas fa-user-plus me-2"></i>Đăng ký Khóa học</h2>
                </div>
                <div class="card-body p-4">
                    <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger" role="alert">
                        <%= request.getAttribute("error") %>
                    </div>
                    <% } %>

                    <form action="course?action=create_form" method="post">
                        <% if (user != null) { %>
                        <div class="alert alert-info">
                            Bạn đang đăng ký với tư cách: <strong><%= user.getFullName() %></strong> (<%= user.getEmail() %>)
                        </div>

                        <% } else { %>
                        <%-- BANNER MỚI ĐƯỢC THÊM VÀO ĐÂY --%>
                        <div class="alert alert-light border-start border-4 border-info mb-4">
                            <p class="mb-1 small">
                                <i class="fas fa-info-circle me-2 text-info"></i>
                                Đã có tài khoản? <a href="login" class="fw-bold text-decoration-none">Đăng nhập</a> để điền thông tin nhanh hơn.
                            </p>
                            <p class="mb-0 small">
                                <i class="fas fa-user-plus me-2 text-info"></i>
                                Chưa có tài khoản? <a href="register" class="fw-bold text-decoration-none">Đăng ký ngay</a> để xem lại lịch sử đăng ký của bạn.
                            </p>
                        </div>

                        <h5 class="mb-3">Thông tin của bạn (Khách)</h5>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="name" class="form-label">Họ và Tên</label>
                                <input type="text" class="form-control" id="name" name="name" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="email" class="form-label">Địa chỉ Email</label>
                                <input type="email" class="form-control" id="email" name="email" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="phone" class="form-label">Số điện thoại</label>
                            <input type="tel" class="form-control" id="phone" name="phone" required>
                        </div>
                        <hr class="my-4">
                        <% } %>

                        <h5 class="mb-3">Chọn Khóa học và Huấn luyện viên</h5>
                        <div class="mb-3">
                            <label for="courseId" class="form-label fw-bold">Khóa học</label>
                            <select class="form-select" id="courseId" name="courseId" required>
                                <option value="" disabled <%= (preselectedCourseId == null) ? "selected" : "" %>>-- Chọn một Khóa học --</option>
                                <% for (Course c : courses) { %>
                                <option value="<%= c.getId() %>" <%= (preselectedCourseId != null && preselectedCourseId == c.getId()) ? "selected" : "" %>>
                                    <%= c.getName() %> (<%= currencyFormatter.format(c.getPrice()) %>)
                                </option>
                                <% } %>
                            </select>
                        </div>

                        <div id="courseDetailsContainer" class="alert alert-light border p-3 mt-2 details-box" style="display: <%= selectedCourse != null ? "block" : "none" %>;">
                            <% if (selectedCourse != null) { %>
                            <h6 class="alert-heading">Thông tin Khóa học đã chọn:</h6>
                            <ul class="list-unstyled mb-0 small">
                                <li><strong>Giá:</strong> <%= currencyFormatter.format(selectedCourse.getPrice()) %></li>
                                <li><strong>Thời lượng:</strong> <%= selectedCourse.getDuration() %> buổi</li>
                                <li><strong>Lịch học:</strong> <%= selectedCourse.getSchedule_description() %></li>
                            </ul>
                            <% } %>
                        </div>

                        <div class="mb-4">
                            <label for="coachId" class="form-label fw-bold">Huấn luyện viên</label>
                            <select class="form-select" id="coachId" name="coachId" required>
                                <option value="" disabled <%= (preselectedCoachId == null) ? "selected" : "" %>>-- Chọn một Huấn luyện viên --</option>
                                <% for (Coach c : coaches) { %>
                                <option value="<%= c.getId() %>" <%= (preselectedCoachId != null && preselectedCoachId == c.getId()) ? "selected" : "" %>>
                                    <%= c.getFullName() %>
                                </option>
                                <% } %>
                            </select>
                        </div>

                        <div id="coachDetailsContainer" class="alert alert-light border p-3 mt-2 details-box" style="display: <%= selectedCoach != null ? "block" : "none" %>;">
                            <% if (selectedCoach != null) { %>
                            <h6 class="alert-heading">Thông tin Huấn luyện viên đã chọn:</h6>
                            <p class="small mb-0 text-muted"><%= selectedCoach.getBio() %></p>
                            <% } %>
                        </div>

                        <div class="d-flex justify-content-end gap-2 border-top pt-3 mt-3">
                            <a href="blogs" class="btn btn-secondary">
                                <i class="fas fa-times me-1"></i>Hủy
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-check-circle me-1"></i>Gửi Đơn Đăng ký
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    const courseData = {
        <% for (Course c : courses) { %>
        '<%= c.getId() %>': {
            price: '<%= currencyFormatter.format(c.getPrice()) %>',
            duration: '<%= c.getDuration() %>',
            schedule: '<%= c.getSchedule_description().replace("'", "\\'").replace("\\r", "").replace("\\n", "<br>") %>'
        },
        <% } %>
    };

    const coachData = {
        <% for (Coach c : coaches) { %>
        '<%= c.getId() %>': {
            bio: '<%= (c.getBio() != null ? c.getBio() : "Chưa có tiểu sử.").replace("'", "\\'").replace("\\r", "").replace("\\n", "<br>") %>'
        },
        <% } %>
    };

    const courseSelect = document.getElementById('courseId');
    const coachSelect = document.getElementById('coachId');
    const courseDetailsContainer = document.getElementById('courseDetailsContainer');
    const coachDetailsContainer = document.getElementById('coachDetailsContainer');

    function updateCourseDetails() {
        const selectedId = courseSelect.value;
        const details = courseData[selectedId];

        if (details) {
            courseDetailsContainer.innerHTML = `
                <h6 class="alert-heading">Thông tin Khóa học đã chọn:</h6>
                <ul class="list-unstyled mb-0 small">
                    <li><strong>Giá:</strong> ` + details.price + `</li>
                    <li><strong>Thời lượng:</strong> ` + details.duration + ` buổi</li>
                    <li><strong>Lịch học:</strong> ` + details.schedule + ` </li>
                </ul>
            `;
            courseDetailsContainer.style.display = 'block';
        } else {
            courseDetailsContainer.style.display = 'none';
        }
    }

    function updateCoachDetails() {
        const selectedId = coachSelect.value;
        const details = coachData[selectedId];

        if (details) {
            coachDetailsContainer.innerHTML = `
                <h6 class="alert-heading">Thông tin Huấn luyện viên đã chọn:</h6>
                <p class="small mb-0 text-muted">` + details.bio + `</p>
            `;
            coachDetailsContainer.style.display = 'block';
        } else {
            coachDetailsContainer.style.display = 'none';
        }
    }
    courseSelect.addEventListener('change', updateCourseDetails);
    coachSelect.addEventListener('change', updateCoachDetails);

</script>

<script src="Resources/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
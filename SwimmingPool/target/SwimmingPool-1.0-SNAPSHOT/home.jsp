<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%-- Loại bỏ các import không cần thiết nếu không hiển thị bình luận trực tiếp --%>
<%-- <%@ page import="model.Feedback" %> --%>
<%-- <%@ page import="java.util.List" %> --%>
<%-- <%@ page import="java.text.SimpleDateFormat" %> --%>
<%
    User user = (User) session.getAttribute("user");
    // Loại bỏ dòng này nếu không hiển thị bình luận trực tiếp
    // List<Feedback> recentFeedbacks = (List<Feedback>) request.getAttribute("recentFeedbacks");
    // SimpleDateFormat sdf = new SimpleDateFormat("dd MMM, yyyy 'lúc' HH:mm");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Swimming Pool - Trang Chủ</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="Resources/CSS/home.css">
</head>
<body>

<!-- Thanh điều hướng -->
<div class="navbar">
    <div class="logo">SwimmingPool</div>
    <div class="nav-links">
        <a href="home.jsp">Trang chủ</a>
        <a href="#about">Giới thiệu</a>
        <a href="#services">Dịch vụ</a>
        <a href="#how-to-register">Bài viết</a>
        <a href="blogs">Đăng kí khóa học</a>

    </div>

    <div class="auth">
        <% if (user == null) { %>
        <a class="login-btn" href="login.jsp">Đăng nhập</a>
        <a class="register-btn" href="register.jsp">Đăng ký</a>
        <% } else { %>
        <div class="user-menu-container">
            <i class="fas fa-user-circle user-icon"></i>
            <div class="dropdown-menu">
                <a href="userprofile">Hồ sơ của tôi</a>
                <a href="course?action=list_form">Lịch sử Đăng kí khóa học</a>
                <a href="change-password">Đổi mật khẩu</a> <%-- Giả định có trang đổi mật khẩu --%>
                <form action="logout" method="post" style="display:inline-block;">
                    <button type="submit">Đăng xuất</button>
                </form>
            </div>
        </div>
        <% } %>
    </div>
</div>

<!-- Khoảng trắng tránh bị che bởi navbar cố định -->
<div style="height: 70px;"></div>

<!-- Phần Giới Thiệu Chính -->
<div class="hero">
    <div class="hero-content">
        <h4>Swimming Pool</h4>
        <h1>Thư Giãn, Vui Chơi & Rèn Luyện Tại Nơi Đây</h1>
        <p>Hãy đến và trải nghiệm những dịch vụ tuyệt vời của chúng tôi, từ bơi lội giải trí đến các khóa học.</p>
        <button class="btn btn-primary">Khám phá</button>
        <button class="btn btn-outline" onclick="window.location.href='#how-to-register';">Đăng ký học bơi</button>
    </div>
</div>

<!-- Về Chúng Tôi -->
<div class="section" id="about">
    <div class="flex-row reverse">
        <div class="image-box">
            <img src="https://images.pexels.com/photos/5663203/pexels-photo-5663203.jpeg" alt="Nhân viên Bể bơi">
        </div>
        <div class="text-box">
            <h2>Về Bể Bơi Của Chúng Tôi</h2>
            <p>Chúng tôi cung cấp dịch vụ bể bơi hiện đại, vệ sinh và được bảo trì chuyên nghiệp cho các cá nhân và gia đình.</p>
            <p>Bể bơi của chúng tôi được thiết kế để phục vụ cả nhu cầu giải trí và tập luyện, với sự an toàn và sạch sẽ là ưu tiên hàng đầu.</p>
            <ul>
                <li>Nhân viên cứu hộ có chứng chỉ luôn túc trực</li>
                <li>Kiểm tra chất lượng nước hàng tuần</li>
                <li>Các gói bể bơi tùy chỉnh có sẵn</li>
                <li>Khu vực ghế dài thư giãn bên hồ bơi</li>
            </ul>
        </div>
    </div>
</div>

<!-- Dịch Vụ -->
<div class="section" id="services">
    <div class="flex-row">
        <div class="image-box">
            <img src="https://images.pexels.com/photos/261102/pexels-photo-261102.jpeg" alt="Dịch vụ Bể bơi">
        </div>
        <div class="text-box">
            <h2>Các Dịch Vụ Của Chúng Tôi</h2>
            <ul>
                <li>Đào tạo bơi lội chuyên nghiệp cho mọi lứa tuổi</li>
                <li>Đặt thuê bể bơi riêng cho sự kiện & gia đình</li>
                <li>Các buổi tập thể dục nhịp điệu dưới nước & trị liệu</li>
                <li>Dịch vụ bảo trì & vệ sinh bể bơi</li>
                <li>Mua Vé: Theo tháng, theo ngày....</li>
            </ul>
        </div>
    </div>
</div>

<!-- Cách Đăng Ký Lớp Học Bơi & Lưu Ý -->
<div class="section" id="how-to-register">
    <h2 style="text-align:center; color:#005caa; margin-bottom: 30px;">Cách Đăng Ký Lớp Học Bơi Tại Bể Bơi Của Chúng Tôi</h2>

    <div class="info-block">
        <h3>Để đăng ký lớp học bơi, bạn chỉ cần thực hiện 1 vài bước cơ bản sau đây:</h3>
        <ol>
            <li>**Lựa chọn khóa học bơi mong muốn**</li>
            <li>**Chốt khóa học và sắp xếp lịch học buổi đầu với giáo viên**</li>
            <li>Khi tới học buổi đầu, học viên sẽ liên hệ trực tiếp với giáo viên sẽ trực tiếp đón học viên và đăng ký học bơi tại quầy.</li>
            <li>Các buổi còn lại học viên sẽ chủ động sắp xếp lịch đi học bơi để hoàn thành khóa học.</li>
        </ol>
    </div>

    <div class="info-block">
        <h3>Những lưu ý khi tham gia khóa học bơi:</h3>
        <ul>
            <li>Buổi đầu tới học, học viên cần gọi trực tiếp cho giáo viên đón để tránh nhầm sang bên khác.</li>
            <li>Những trường hợp sợ nước, nhát nước thời gian học có thể lâu hơn.</li>
            <li>Học viên khi tới học bơi chỉ cần chuẩn bị đồ bơi, khăn tắm, dầu gội (theo nhu cầu), kính bơi.</li>
            <li>Trung tâm có kính, mũ hỗ trợ cho học viên mượn.</li>
        </ul>
    </div>

    <div class="info-block">
        <h3>Một số thắc mắc khi học viên đăng ký học bơi:</h3>
        <h4>1. Cần chuẩn bị gì khi đi học bơi?</h4>
        <p>Học viên cần chuẩn bị đồ bơi (hoặc đồ vải mềm, co dãn thoải mái), kính bơi (trung tâm có kính bơi cho học viên mượn). Ngoài ra, học viên nên mang đồ dùng cá nhân như: khăn tắm, dầu gội, sữa tắm… để sử dụng sau khi học xong. Bể có khu vực tắm riêng, nước ấm cho học viên, ngoài ra còn có máy sấy tóc.</p>

        <h4>2. Học viên có thể bắt đầu học bơi khi nào?</h4>
        <p><strong>BẤT KỂ LÚC NÀO.</strong></p>
        <p>Miễn học viên có nhu cầu, trung tâm đều có lớp học dành cho học viên đăng ký (lưu ý: lớp học kèm tối đa 2 học viên, chứ không phải bắt buộc 2 học viên mới tổ chức lớp).</p>

        <h4>3. Sau bao lâu thì học viên biết bơi?</h4>
        <p>Thời gian biết bơi nhanh hay chậm sẽ tùy thuộc vào năng khiếu của mỗi học viên, nhưng thông thường từ 5-7 buổi là học viên có thể biết bơi hoặc sớm hơn.</p>
        <p>Muốn biết bơi nhanh bạn nên:</p>
        <ul>
            <li>Đi học bơi đều, thường xuyên.</li>
            <li>Đừng sợ, thả lỏng cơ thể thoải mái khi học bơi.</li>
        </ul>
    </div>
</div>

<style>
    /* CSS cho các khối thông tin (info-block) */
    .info-block {
        max-width: 800px;
        margin: 0 auto 40px auto;
        padding: 25px 30px;
        background-color: #f9f9f9;
        border: 1px solid #e5e5e5;
        border-radius: 10px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }

    .info-block h3, .info-block h4 {
        color: #005caa;
        margin-bottom: 15px;
        border-bottom: 1px solid #eee;
        padding-bottom: 10px;
    }

    .info-block ul, .info-block ol {
        margin-left: 25px;
        margin-bottom: 15px;
        line-height: 1.6;
    }

    .info-block ul li, .info-block ol li {
        margin-bottom: 8px;
    }

    .info-block p {
        margin-bottom: 10px;
        line-height: 1.6;
    }

    /* CSS cho footer */
    footer {
        background-color: #005caa;
        color: white;
        padding: 40px 20px;
        text-align: center;
        font-size: 0.9em;
    }

    .footer-container {
        display: flex;
        flex-wrap: wrap;
        justify-content: space-around;
        max-width: 1200px;
        margin: 0 auto;
        gap: 30px;
        align-items: flex-start;
    }

    .footer-column {
        flex: 1;
        min-width: 280px;
        padding: 15px;
        text-align: left;
        display: flex;
        flex-direction: column;
        /* Thêm thuộc tính căn chỉnh nội dung theo chiều ngang */
        align-items: flex-start; /* Căn trái nội dung trong cột */
    }

    .footer-column.footer-feedback-section {
        align-items: center; /* Căn giữa nội dung trong cột feedback */
    }

    .footer-column h3 {
        color: white;
        margin-bottom: 20px;
        font-size: 1.3em;
        border-bottom: 1px solid rgba(255, 255, 255, 0.3);
        padding-bottom: 10px;
        width: 100%; /* Đảm bảo đường gạch ngang chiếm toàn bộ chiều rộng của tiêu đề */
        max-width: 200px; /* Giữ max-width để đường gạch ngang không quá dài */
        box-sizing: border-box; /* Bao gồm padding và border trong width */
    }

    /* Điều chỉnh margin cho h3 trong các cột để căn chỉnh đường gạch ngang */
    .footer-column.footer-info h3 {
        margin-left: 0;
        margin-right: auto;
    }

    .footer-column.footer-feedback-section h3 {
        margin-left: auto;
        margin-right: auto;
    }


    .footer-column p {
        margin-bottom: 8px;
    }

    .footer-column a {
        color: white;
        text-decoration: none;
    }

    .footer-column a:hover {
        text-decoration: underline;
    }

    .social-links a {
        color: white;
        margin: 0 10px;
        font-size: 1.5em;
    }

    /* CSS cho nút feedback trong footer */
    .footer-feedback-btn {
        background-color: #198754;
        color: white;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        font-size: 1em;
        cursor: pointer;
        transition: background-color 0.3s ease;
        text-decoration: none;
        display: inline-block;
        margin-top: 15px;
    }

    .footer-feedback-btn:hover {
        background-color: #157347;
    }

    /* CSS cho menu người dùng */
    .user-menu-container {
        position: relative;
        display: inline-block;
        cursor: pointer;
        padding: 0 10px; /* Thêm padding để icon dễ bấm hơn */
    }

    .user-icon {
        font-size: 1.8em; /* Kích thước icon lớn hơn */
        color: white;
        vertical-align: middle;
    }

    .dropdown-menu {
        display: none;
        position: absolute;
        background-color: #f9f9f9;
        min-width: 160px;
        box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
        z-index: 1;
        right: 0; /* Căn menu sang phải */
        border-radius: 5px;
        overflow: hidden; /* Đảm bảo các góc bo tròn */
        top: 100%; /* Đặt menu ngay dưới icon */
        transform: translateY(10px); /* Khoảng cách nhỏ từ icon */
        opacity: 0;
        transition: opacity 0.3s ease, transform 0.3s ease;
        pointer-events: none; /* Không nhận sự kiện chuột khi ẩn */
    }

    .dropdown-menu a, .dropdown-menu button {
        color: black;
        padding: 12px 16px;
        text-decoration: none;
        display: block;
        text-align: left;
        background: none;
        border: none;
        width: 100%;
        cursor: pointer;
        font-size: 1em;
    }

    .dropdown-menu a:hover, .dropdown-menu button:hover {
        background-color: #f1f1f1;
    }

    .user-menu-container:hover .dropdown-menu {
        display: block;
        opacity: 1;
        transform: translateY(0);
        pointer-events: auto; /* Nhận sự kiện chuột khi hiển thị */
    }
</style>

<!-- Footer -->
<footer>
    <div class="footer-container">
        <div class="footer-column footer-info">
            <h3>SwimmingPool</h3>
            <p>&copy; 2025 SwimmingPool. All rights reserved.</p>
            <p>Địa chỉ: 123 Đường Thanh Niên, Sơn Tây, Hà Nội</p>
            <p>Liên hệ chúng tôi: contact@swimmingpool.com</p>
            <p>Hotline: +84 123 456 789</p>
            <div class="social-links">
                <a href="#" style="color: white; margin: 0 10px; font-size: 1.5em;"><i class="fab fa-facebook-f"></i></a>
                <a href="#" style="color: white; margin: 0 10px; font-size: 1.5em;"><i class="fab fa-instagram"></i></a>
                <a href="#" style="color: white; margin: 0 10px; font-size: 1.5em;"><i class="fab fa-youtube"></i></a>
            </div>
        </div>

        <div class="footer-column footer-feedback-section" style="text-align: center;">
            <h3>Góp Ý Của Bạn</h3>
            <p>Chúng tôi luôn lắng nghe để cải thiện dịch vụ tốt hơn.</p>
            <a href="feedback?action=create" class="footer-feedback-btn">
                <i class="fas fa-paper-plane me-2"></i>Gửi Phản Hồi
            </a>
        </div>
    </div>
</footer>

</body>
</html>

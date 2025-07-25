<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Customer" %>
<%@ page import="model.Role" %>
<%
    // Lấy đối tượng Customer từ request
    Customer user = (Customer) request.getAttribute("user");
    if (user == null) {
%>
<h2 style="text-align:center; color:red;">Không tìm thấy thông tin người dùng</h2>
<p style="text-align:center;"><a href="home.jsp">Về trang chủ</a></p>
<%
        return; // Dừng xử lý nếu không có người dùng
    }

    // Xác định liên kết quay lại dựa trên vai trò
    String backLink = "home.jsp"; // Liên kết mặc định
    if (user.getRole() != null) { // Kiểm tra xem Role có tồn tại không
        String roleName = user.getRole().getName().toLowerCase(); // Lấy tên vai trò và chuyển sang chữ thường
        if ("admin".equals(roleName)) {
            backLink = "admin_dashboard.jsp"; // Cho quản trị viên
        } else if ("staff".equals(roleName)) {
            backLink = "staff_dashboard.jsp"; // Cho nhân viên
        }
        // Các vai trò khác sẽ mặc định về home.jsp
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>User Profile</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* CSS cho toàn bộ trang */
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        html, body {
            width: 100%;
            min-height: 100%;
            display: flex; /* Sử dụng flexbox để căn chỉnh header và container */
            flex-direction: column; /* Xếp các phần tử theo chiều dọc */
            justify-content: flex-start;
            align-items: center;
            background-color: #eef2f8;
            font-family: 'Poppins', sans-serif;
            color: #333;
            line-height: 1.6;
            overflow-y: auto;
        }

        /* CSS cho Header (Phần này là giả định, bạn có thể thay thế bằng file header.jsp của mình) */
        .header {
            width: 100%;
            background-color: #007bff; /* Màu xanh dương trong ảnh bạn cung cấp */
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: white;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            margin-bottom: 20px; /* Khoảng cách giữa header và nội dung */
        }

        .header .logo a {
            color: white;
            text-decoration: none;
            font-size: 28px;
            font-weight: 600;
        }

        .user-avatar {
            display: flex;
            align-items: center;
        }

        .user-avatar .avatar-link {
            text-decoration: none;
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            width: 50px; /* Kích thước của vòng tròn avatar */
            height: 50px;
            border: 2px solid white; /* Viền trắng như trong ảnh */
            border-radius: 50%; /* Làm tròn */
            overflow: hidden;
            transition: transform 0.2s ease-in-out;
        }

        .user-avatar .avatar-link:hover {
            transform: scale(1.05);
        }

        /* Style cho Font Awesome icon trong header */
        .user-avatar .avatar-link i {
            font-size: 28px; /* Kích thước icon */
            color: white;
            line-height: 1; /* Cân bằng chiều cao để icon nằm giữa */
        }
        /* Kết thúc CSS cho Header */


        /* CSS cho Container hồ sơ người dùng */
        .container {
            display: flex;
            max-width: 950px;
            width: 100%;
            background: #ffffff;
            border-radius: 15px;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.08);
            padding: 0;
            margin: 50px 20px; /* Cập nhật margin để không bị chồng với header */
            overflow: hidden;
        }

        .left-side {
            width: 280px;
            background-color: #f8fafd;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            align-items: center;
            padding: 40px 20px;
            border-right: 1px solid #e0e6f0;
        }
        .left-side img {
            width: 160px;
            height: 160px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 25px;
            border: 5px solid #ffffff;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }
        .left-side img:hover {
            transform: scale(1.03);
        }
        .left-side input[type="file"] {
            cursor: pointer;
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #ccd9ed;
            border-radius: 8px;
            background-color: #f0f5fb;
            color: #444;
            font-size: 14px;
            transition: all 0.3s ease;
        }
        .left-side input[type="file"]:hover:not(:disabled) {
            background-color: #e3eaf4;
            border-color: #a4c0eb;
        }
        .left-side input[type="file"]:disabled {
            opacity: 0.7;
            cursor: not-allowed;
        }

        .right-side {
            flex-grow: 1;
            padding: 40px 50px;
            display: flex;
            flex-direction: column;
        }

        .form-group {
            margin-bottom: 20px;
        }
        label {
            font-weight: 500;
            margin-bottom: 8px;
            display: block;
            font-size: 14px;
            color: #555;
        }
        input[type="text"],
        input[type="email"],
        input[type="date"],
        input[type="tel"],
        select {
            width: 100%;
            padding: 12px 15px;
            font-size: 15px;
            border: 1px solid #dbe2ef;
            border-radius: 8px;
            background-color: #fdfdfd;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }
        input[type="text"]:focus,
        input[type="email"]:focus,
        input[type="date"]:focus,
        input[type="tel"]:focus,
        select:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.2);
        }
        input[disabled], select[disabled] {
            background-color: #f0f2f7;
            color: #777;
            cursor: not-allowed;
            border-color: #e0e6f0;
        }
        input[readonly] {
            background-color: #eef2f8 !important;
            cursor: default !important;
            border-color: #e0e6f0 !important;
        }

        .form-actions {
            margin-top: 30px;
            text-align: right;
            padding-top: 20px;
            border-top: 1px solid #eef2f8;
        }
        .form-actions button {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 12px 28px;
            font-size: 16px;
            font-weight: 500;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.2s ease;
            margin-left: 10px;
        }
        .form-actions button:disabled {
            background-color: #a4c0eb;
            cursor: not-allowed;
            box-shadow: none;
            transform: none;
        }
        .form-actions button:hover:not(:disabled) {
            background-color: #0056b3;
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0, 90, 179, 0.2);
        }
        #btnEdit {
            background-color: #6c757d;
        }
        #btnEdit:hover:not(:disabled) {
            background-color: #5a6268;
            box-shadow: 0 4px 10px rgba(108, 117, 125, 0.2);
        }

        .back-home {
            position: absolute; /* Giữ lại position absolute */
            top: 25px;
            left: 25px;
            background-color: #6c757d;
            color: white;
            padding: 10px 18px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            box-shadow: 0 3px 8px rgba(0,0,0,0.15);
            transition: background-color 0.3s ease, transform 0.2s ease;
            z-index: 1000;
            display: flex;
            align-items: center;
            gap: 8px; /* Khoảng cách giữa icon và chữ */
        }
        .back-home:hover {
            background-color: #5a6268;
            transform: translateY(-1px);
        }
        /* Style cho icon bên trong liên kết quay về trang chính */
        .back-home i {
            font-size: 1.1em; /* Kích thước của icon */
        }

        /* Responsive */
        @media (max-width: 768px) {
            html, body {
                flex-direction: column;
                align-items: center;
                padding: 10px; /* Giảm padding tổng thể */
                height: auto;
            }
            .header {
                padding: 10px 15px;
                margin-bottom: 15px; /* Giảm khoảng cách */
            }
            .header .logo a {
                font-size: 24px;
            }
            .user-avatar .avatar-link {
                width: 40px;
                height: 40px;
            }
            .user-avatar .avatar-link i {
                font-size: 24px;
            }
            .container {
                flex-direction: column;
                margin: 20px 0;
                box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            }
            .left-side {
                width: 100%;
                border-radius: 15px 15px 0 0;
                padding: 30px 20px;
                border-right: none;
                border-bottom: 1px solid #e0e6f0;
            }
            .left-side img {
                width: 120px;
                height: 120px;
            }
            .right-side {
                width: 100%;
                padding: 30px 30px;
                border-radius: 0 0 15px 15px;
            }
            .form-actions {
                text-align: center;
                margin-top: 25px;
            }
            .form-actions button {
                width: calc(50% - 10px);
                margin: 5px;
            }
            .back-home {
                position: static; /* Thay đổi để không bị chồng chéo trên mobile */
                margin-bottom: 15px;
                align-self: flex-start; /* Căn chỉnh về bên trái */
            }
        }
        @media (max-width: 480px) {
            .right-side {
                padding: 20px 20px;
            }
            .form-actions button {
                width: 100%;
                margin: 5px 0;
            }
        }
    </style>
</head>
<body>

<div class="header">
    <div class="logo">
        <a href="home.jsp">Swimming Pool</a>
    </div>
    <div class="user-avatar">
        <a href="userprofile" class="avatar-link">
            <i class="fas fa-user"></i>
        </a>
    </div>
</div>
<a href="<%= backLink %>" class="back-home">
    <i class="fas fa-home"></i> Quay về trang chính
</a>

<div class="container">
    <form id="profileForm" method="post" action="userprofile" enctype="multipart/form-data" novalidate onsubmit="return validateForm()" style="display:flex; width:100%;">
        <div class="left-side">
            <img id="avatarPreview" src="<%= (user.getProfilePicture() != null && !user.getProfilePicture().isEmpty()) ? user.getProfilePicture() : "https://via.placeholder.com/160x160?text=No+Image" %>" alt="Avatar" />
            <input type="file" name="avatar" accept="image/*" onchange="previewImage(event)" disabled />
        </div>

        <div class="right-side">
            <input type="hidden" name="userId" value="<%= user.getUserId() %>" />
            <div class="form-group">
                <label for="fullName">Name</label>
                <input id="fullName" name="fullName" type="text" value="<%= user.getFullName() %>" disabled required minlength="2" />
            </div>
            <div class="form-group">
                <label for="dob">Date of Birth</label>
                <input id="dob" name="dob" type="date" value="<%= user.getDobString() %>" disabled required />
            </div>
            <div class="form-group">
                <label for="gender">Gender</label>
                <select id="gender" name="gender" disabled required>
                    <option value="" <%= (user.getGender() == null || user.getGender().isEmpty()) ? "selected" : "" %>>-- Select Gender --</option>
                    <option value="Male" <%= "Male".equalsIgnoreCase(user.getGender()) ? "selected" : "" %>>Male</option>
                    <option value="Female" <%= "Female".equalsIgnoreCase(user.getGender()) ? "selected" : "" %>>Female</option>
                    <option value="Other" <%= "Other".equalsIgnoreCase(user.getGender()) ? "selected" : "" %>>Other</option>
                </select>
            </div>
            <div class="form-group">
                <label for="phoneNumber">Phone</label>
                <input id="phoneNumber" name="phoneNumber" type="tel" pattern="[0-9+ \\-]*" value="<%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "" %>" disabled required minlength="7" />
            </div>
            <div class="form-group">
                <label for="email">Email</label>
                <input id="email" type="email" value="<%= user.getEmail() != null ? user.getEmail() : "" %>" readonly />
                <input type="hidden" name="email" value="<%= user.getEmail() != null ? user.getEmail() : "" %>" />
            </div>
            <div class="form-group">
                <label for="address">Address</label>
                <input id="address" name="address" type="text" value="<%= user.getAddress() != null ? user.getAddress() : "" %>" disabled />
            </div>
            <div class="form-actions">
                <button type="button" id="btnEdit" onclick="toggleEdit()">Edit</button>
                <button type="submit" id="btnSave" disabled>Save</button>
            </div>
        </div>
    </form>
</div>

<script>
    // Hiển thị thông báo (nếu có) từ Servlet
    <% String message = (String) request.getAttribute("message"); %>
    <% if (message != null && !message.isEmpty()) { %>
    alert("<%= message.replace("\"", "\\\"") %>");
    <% } %>

    // Hàm xem trước ảnh đại diện
    function previewImage(event) {
        const reader = new FileReader();
        reader.onload = function () {
            document.getElementById("avatarPreview").src = reader.result;
        };
        reader.readAsDataURL(event.target.files[0]);
    }

    // Hàm bật/tắt chế độ chỉnh sửa
    function toggleEdit() {
        const form = document.getElementById("profileForm");
        // Chọn tất cả các input và select trong form, trừ những cái có thuộc tính 'readonly' (như email)
        const inputs = form.querySelectorAll("input:not([readonly]), select");
        const btnSave = document.getElementById("btnSave");
        const btnEdit = document.getElementById("btnEdit");
        const avatarInput = document.querySelector(".left-side input[type=file]");

        // Kiểm tra trạng thái hiện tại của nút Edit
        const isEditing = btnEdit.textContent === "Cancel";

        if (isEditing) {
            // Chuyển về chế độ xem (disabled)
            inputs.forEach(input => {
                input.disabled = true;
            });
            btnSave.disabled = true;
            btnEdit.textContent = "Edit";
            avatarInput.disabled = true;
        } else {
            // Chuyển sang chế độ chỉnh sửa (enabled)
            inputs.forEach(input => {
                input.disabled = false;
            });
            btnSave.disabled = false;
            btnEdit.textContent = "Cancel";
            avatarInput.disabled = false;
        }
    }

    // Hàm kiểm tra hợp lệ form trước khi gửi
    function validateForm() {
        const fullName = document.getElementById("fullName").value.trim();
        const dob = document.getElementById("dob").value;
        const gender = document.getElementById("gender").value;
        const phone = document.getElementById("phoneNumber").value.trim();
        const email = document.getElementById("email").value.trim();

        if (fullName.length < 2) {
            alert("Full name must be at least 2 characters.");
            return false;
        }

        if (!dob) {
            alert("Please select your date of birth.");
            return false;
        }
        const dobDate = new Date(dob);
        const now = new Date();
        if (dobDate > now) {
            alert("Date of birth cannot be in the future.");
            return false;
        }

        if (gender !== "Male" && gender !== "Female" && gender !== "Other") {
            alert("Please select your gender.");
            return false;
        }

        const phonePattern = /^[0-9+ \-]+$/;
        if (!phonePattern.test(phone)) {
            alert("Phone number is invalid. Only digits, +, -, and spaces are allowed.");
            return false;
        }
        const digitsOnly = phone.replace(/\D/g, '');
        if (digitsOnly.length < 10 || digitsOnly.length > 11) { // Điều chỉnh độ dài số điện thoại phù hợp
            alert("Phone number must contain between 10 and 11 digits.");
            return false;
        }

        const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailPattern.test(email)) {
            alert("Invalid email address.");
            return false;
        }

        return true;
    }
</script>

</body>
</html>
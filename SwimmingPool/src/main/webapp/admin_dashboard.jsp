<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || user.getRole() == null || (user.getRole().getId() != 1 && user.getRole().getId() != 2)) {
        response.sendRedirect("error.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Swimming Pool</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', sans-serif;
        }

        .topbar {
            background: linear-gradient(to right, #0078d7, #005a9e);
            color: white;
            padding: 12px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 60px;
        }

        .topbar h1 {
            font-size: 22px;
            font-weight: bold;
        }

        .dropdown {
            position: relative;
            display: inline-block;
            cursor: pointer;
        }

        /* CSS cho biểu tượng người dùng trong topbar */
        .user-avatar-icon {
            width: 40px; /* Kích thước của vòng tròn */
            height: 40px;
            border-radius: 50%; /* Làm tròn */
            border: 2px solid #fff; /* Viền trắng */
            display: flex; /* Dùng flexbox để căn giữa icon */
            justify-content: center;
            align-items: center;
            transition: 0.3s;
            font-size: 20px; /* Kích thước của icon */
            color: #fff; /* Màu của icon */
        }

        .user-avatar-icon:hover {
            border-color: #ffcc00;
        }

        .dropdown-menu {
            display: none;
            position: absolute;
            right: 0;
            background-color: white;
            color: #333;
            min-width: 200px;
            box-shadow: 0 8px 16px rgba(0,0,0,0.2);
            border-radius: 6px;
            padding: 12px;
            z-index: 999;
        }

        .dropdown:hover .dropdown-menu {
            display: block;
        }

        .dropdown-menu .greeting {
            font-size: 14px;
            margin-bottom: 8px;
            color: #333;
        }

        .dropdown-menu a,
        .dropdown-menu button {
            display: block;
            width: 100%;
            padding: 8px 10px;
            margin: 4px 0;
            border: none;
            background: none;
            color: #0078d7;
            text-align: left;
            text-decoration: none;
            font-size: 14px;
            cursor: pointer;
            border-radius: 4px;
        }

        .dropdown-menu a:hover,
        .dropdown-menu button:hover {
            background-color: #f1f1f1;
        }

        .main-wrapper {
            display: flex;
            height: calc(100vh - 60px);
        }

        .sidebar {
            width: 240px;
            padding-top: 20px;
            background-color: rgba(255, 255, 255, 0.6);
            backdrop-filter: blur(6px);
            -webkit-backdrop-filter: blur(6px);
            border-right: 1px solid rgba(255,255,255,0.4);
        }

        .sidebar a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 20px;
            color: #333;
            font-weight: 500;
            text-decoration: none;
            transition: 0.2s;
        }

        .sidebar a:hover {
            background-color: rgba(255, 255, 255, 0.4);
            color: #0078d7;
        }

        .sidebar i {
            font-size: 18px;
            min-width: 20px;
        }

        .hero-section {
            flex: 1;
            background-image: url('https://images.pexels.com/photos/6437583/pexels-photo-6437583.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }
    </style>
</head>
<body>

<div class="topbar">
    <h1>Swimming Pool</h1>
    <div class="dropdown">
        <div class="user-avatar-icon">
            <i class="fas fa-user"></i> </div>

        <div class="dropdown-menu">
            <div class="greeting">Xin chào, <strong><%= user.getFullName() %></strong></div>
            <a href="userprofile"><i class="fas fa-id-card"></i> Hồ sơ của tôi</a>
            <a href="change-password"><i class="fas fa-key"></i> Đổi mật khẩu</a>
            <a href="course?action=list_form"><i class="fas fa-book"></i> Lịch sử đăng kí khóa học</a>
            <form action="logout" method="post">
                <button type="submit"><i class="fas fa-sign-out-alt"></i> Đăng xuất</button>
            </form>
        </div>
    </div>
</div>

<div class="main-wrapper">
    <div class="sidebar">
        <div style="padding-left: 20px;">
            <div style="font-weight:bold; margin-bottom:8px; color:#0078d7;"><i class="fas fa-swimmer"></i> Quản lý tài khoản</div>
            <a href="admin-user" style="padding-left: 30px;"><i class="fas fa-book"></i> Quản lý người dùng </a>
            <a href="staff-registration" style="padding-left: 30px;"><i class="fas fa-user-plus"></i> Tạo tài khoản cho nhân viên</a>
        </div>

        <div style="padding-left: 20px;">
            <div style="font-weight:bold; margin-bottom:8px; color:#0078d7;"><i class="fas fa-swimmer"></i> Quản lý khóa học</div>
            <a href="swimcourse" style="padding-left: 30px;"><i class="fas fa-book"></i> Khóa học</a>
            <a href="course?action=list_form" style="padding-left: 30px;"><i class="fas fa-user-plus"></i> Đăng kí mới</a>
        </div>
        <a href="inventory"><i class="fas fa-warehouse"></i> Quản lý kho</a>
        <a href="feedback?action=list"><i class="fas fa-file"></i> Quản lý Phản hồi</a>
        <a href="MaintenanceServlet"><i class="fas fa-tools"></i> Quản lý bảo trì</a>
        <a href="coach-list"><i class="fas fa-user-tie"></i> Quản lý huấn luyện viên</a>
        <a href="pool-area"><i class="fas fa-warehouse"></i> Quản bể bơi</a>
    </div>

    <div class="hero-section"></div>
</div>

</body>
</html>
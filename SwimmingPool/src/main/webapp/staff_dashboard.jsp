<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || user.getRole() == null || user.getRole().getId() != 5) {
        response.sendRedirect("error.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang Nhân viên - Swimming Pool</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; }

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

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #fff;
            transition: 0.3s;
        }

        .user-avatar:hover {
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
            width: 220px;
            background-color: rgba(255, 255, 255, 0.6);
            backdrop-filter: blur(6px);
            -webkit-backdrop-filter: blur(6px);
            border-right: 1px solid rgba(255,255,255,0.4);
            box-shadow: 2px 0 4px rgba(0, 0, 0, 0.05);
            padding-top: 20px;
        }

        .sidebar a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 20px;
            color: #333;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.2s ease-in-out;
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

<!-- Topbar -->
<div class="topbar">
    <h1>Swimming Pool</h1>
    <div class="dropdown">
        <img class="user-avatar" src="images/<%= user.getProfilePicture() != null && !user.getProfilePicture().isEmpty() ? user.getProfilePicture() : "default-avatar.png" %>" alt="Avatar" />
        <div class="dropdown-menu">
            <div class="greeting">Xin chào, <strong><%= user.getFullName() %></strong></div>
            <a href="userprofile"><i class="fas fa-id-card"></i> Hồ sơ của tôi</a>
            <a href="change-password.jsp"><i class="fas fa-key"></i> Đổi mật khẩu</a>
            <form action="logout" method="post">
                <button type="submit"><i class="fas fa-sign-out-alt"></i> Đăng xuất</button>
            </form>
        </div>
    </div>
</div>

<!-- Layout -->
<div class="main-wrapper">
    <!-- Sidebar -->
    <div class="sidebar">
        <a href="equipment?mode=rental"><i class="fas fa-handshake"></i> Thuê thiết bị</a>
        <a href="equipment?mode=buy"><i class="fas fa-shopping-cart"></i> Mua thiết bị</a>
        <a href="purchase"><i class="fas fa-ticket-alt"></i> Vé bơi</a>
        <a href="MaintenanceServlet"><i class="fas fa-screwdriver-wrench"></i> Bảo trì của tôi</a>
        <a href="product"><i class="fas fa-box-open"></i> Sản phẩm</a>
        <a href="feedback?action=create"><i class="fas fa-comment-dots"></i> Gửi phản hồi</a>
        <a href="feedback?mode=list"><i class="fas fa-history"></i> Phản hồi trước đây</a>
    </div>

    <!-- Background bên phải -->
    <div class="hero-section"></div>
</div>

</body>
</html>

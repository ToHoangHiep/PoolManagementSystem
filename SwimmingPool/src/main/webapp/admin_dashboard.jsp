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
    <!-- FontAwesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', sans-serif;
        }

        .topbar {
            background: linear-gradient(to right, #0078d7, #005a9e);
            color: white;
            padding: 16px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 60px;
        }

        .topbar h1 {
            font-size: 22px;
            font-weight: bold;
        }

        .auth {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .auth a {
            color: white;
            text-decoration: underline;
            font-weight: 500;
        }

        .auth input[type="submit"] {
            padding: 6px 14px;
            border: none;
            background-color: white;
            color: #005a9e;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
        }

        .auth input[type="submit"]:hover {
            background-color: #ffcc00;
            color: #003d6a;
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
    <div class="auth">
        Xin chào, <a href="userprofile"><%= user.getFullName() %></a>
        <form action="logout" method="post" style="display:inline;">
            <input type="submit" value="Đăng xuất">
        </form>
    </div>
</div>

<div class="main-wrapper">
    <div class="sidebar">
        <a href="admin-user"><i class="fas fa-users-cog"></i> Quản lý người dùng</a>
        <a href="inventory"><i class="fas fa-warehouse"></i> Quản lý kho</a>

        <div style="padding-left: 20px;">
            <div style="font-weight:bold; margin-bottom:8px; color:#0078d7;"><i class="fas fa-swimmer"></i> Quản lý khóa học</div>
            <a href="swimcourse" style="padding-left: 30px;"><i class="fas fa-book"></i> Khóa học</a>
            <a href="class-list" style="padding-left: 30px;"><i class="fas fa-chalkboard-teacher"></i> Lớp học</a>
            <a href="register-course" style="padding-left: 30px;"><i class="fas fa-user-plus"></i> Đăng kí mới</a>
        </div>

        <a href="MaintenanceServlet"><i class="fas fa-tools"></i> Quản lý bảo trì</a>
        <a href="coach-list"><i class="fas fa-user-tie"></i> Quản lý huấn luyện viên</a>
        <a href="pool-area"><i class="fas fa-warehouse"></i> Quản bể bơi</a>
    </div>

    <div class="hero-section"></div>
</div>

</body>
</html>

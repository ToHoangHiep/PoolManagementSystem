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

        body {
            font-family: 'Segoe UI', sans-serif;
        }

        /* Topbar */
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
            transition: background-color 0.2s;
        }

        .auth input[type="submit"]:hover {
            background-color: #ffcc00;
            color: #003d6a;
        }

        .main-wrapper {
            display: flex;
            height: calc(100vh - 60px);
        }

        /* Sidebar */
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

        /* Dropdown container */
        .dropdown {
            position: relative;
            display: inline-block;
        }

        /* Nút chính */
        .dropbtn {
            background-color: #4CAF50;
            color: white;
            padding: 10px 18px;
            font-size: 14px;
            border: none;
            cursor: pointer;
            border-radius: 4px;
        }

        /* Nội dung dropdown */
        .dropdown-content {
            display: none;
            position: absolute;
            background-color: #f9f9f9;
            min-width: 210px;
            box-shadow: 0px 8px 16px rgba(0,0,0,0.2);
            z-index: 1;
            border-radius: 4px;
        }

        /* Các link trong dropdown */
        .dropdown-content a {
            color: black;
            padding: 10px 14px;
            text-decoration: none;
            display: block;
            font-size: 14px;
        }

        /* Hover */
        .dropdown-content a:hover {
            background-color: #f1f1f1;
        }

        /* Hiển thị dropdown khi hover */
        .dropdown:hover .dropdown-content {
            display: block;
        }

        .dropdown:hover .dropbtn {
            background-color: #3e8e41;
        }


        /* Background */
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
    <div class="auth">
        Xin chào, <a href="userprofile"><%= user.getFullName() %></a>
        <form action="logout" method="post" style="display:inline;">
            <input type="submit" value="Đăng xuất">
        </form>
    </div>
</div>

<!-- Layout -->
<div class="main-wrapper">
    <!-- Sidebar -->
    <div class="sidebar">
        <a href="equipment?mode=rental"><i class="fas fa-handshake"></i> Thuê thiết bị
        </a>
        <a href="equipment?mode=buy"><i class="fas fa-shopping-cart"></i> Mua thiết bị
        </a>
        <a href="purchase"><i class="fas fa-ticketpurchase"></i> Vé bơi
        </a>
        <a href="MaintenanceServlet"><i class="fas fa-screwdriver-wrench"></i> Bảo trì của tôi</a>
        <div class="dropdown">
            <button class="dropbtn"><i class="fas fa-box"></i> Danh mục thiết bị</button>
            <div class="dropdown-content">
                <a href="inventory?action=lowstock"><i class="fas fa-box-open"></i> Sản phẩm sắp hết</a>
                <a href="inventory?action=broken"><i class="fas fa-tools"></i> Sản phẩm hỏng</a>
            </div>
        </div>

        <a href="feedback?action=create"><i class="fas fa-comment-dots"></i> Gửi phản hồi</a>
        <a href="feedback?mode=list"><i class="fas fa-history"></i> Phản hồi trước đây</a>
    </div>

    <!-- Background bên phải -->
    <div class="hero-section"></div>
</div>

</body>
</html>

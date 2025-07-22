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
    <!-- FontAwesome Icon -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f2f5f7;
            color: #333;
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
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
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

        /* Sidebar */
        .sidebar {
            position: fixed;
            top: 60px;
            left: 0;
            width: 220px;
            height: calc(100vh - 60px);
            background-color: #ffffff;
            border-right: 1px solid #ddd;
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
            background-color: #e6f2ff;
            color: #0078d7;
        }

        .sidebar i {
            font-size: 18px;
            min-width: 20px;
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

<!-- Sidebar -->
<div class="sidebar">
    <a href="equipment-rental"><i class="fas fa-toolbox"></i> Thiết bị</a>
    <a href="MaintenanceServlet"><i class="fas fa-screwdriver-wrench"></i> Bảo trì của tôi</a>
    <a href="product"><i class="fas fa-box-open"></i> Sản phẩm</a>
    <a href="feedback?action=create"><i class="fas fa-comment-dots"></i> Gửi phản hồi</a>
    <a href="feedback?mode=list"><i class="fas fa-history"></i> Phản hồi trước đây</a>
</div>

</body>
</html>

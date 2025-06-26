<%@ page import="model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Swimming Pool - Home Page</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html, body {
            height: 100%;
            font-family: Arial, sans-serif;
            scroll-behavior: smooth;
        }

        body {
            background-image: url('https://images.pexels.com/photos/221457/pexels-photo-221457.jpeg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            color: white;
        }

        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(0, 92, 170, 0.9);
            padding: 15px 30px;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            z-index: 999;
            backdrop-filter: blur(4px);
        }

        .logo {
            font-size: 26px;
            font-weight: bold;
        }

        .nav-links a {
            color: white;
            text-decoration: none;
            margin: 0 15px;
            font-weight: 500;
        }

        .nav-links a:hover {
            text-decoration: underline;
        }

        .auth {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .auth a.login-btn,
        .auth a.register-btn,
        .auth form input[type="submit"] {
            padding: 8px 16px;
            background-color: #ffffff;
            color: #005caa;
            border: none;
            border-radius: 4px;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
        }

        .auth a.login-btn:hover,
        .auth a.register-btn:hover,
        .auth form input[type="submit"]:hover {
            background-color: #e6e6e6;
        }

        .hero {
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 0 10%;
            background: rgba(0, 0, 0, 0.5);
        }

        .hero-content h4 {
            color: #00d4ff;
            margin-bottom: 10px;
            font-size: 18px;
        }

        .hero-content h1 {
            font-size: 48px;
            margin-bottom: 20px;
        }

        .hero-content p {
            font-size: 18px;
            margin-bottom: 30px;
        }

        .hero-content .btn {
            padding: 12px 20px;
            margin: 5px;
            border: none;
            border-radius: 4px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background-color: #005caa;
            color: white;
        }

        .btn-outline {
            background-color: transparent;
            border: 2px solid white;
            color: white;
        }

        .btn-outline:hover {
            background: white;
            color: #005caa;
        }

        .section {
            padding: 80px 10%;
            background: white;
            color: #333;
        }

        .flex-row {
            display: flex;
            flex-wrap: wrap;
            gap: 40px;
            align-items: center;
            justify-content: center;
        }

        .flex-row.reverse {
            flex-direction: row-reverse;
        }

        .image-box {
            flex: 1;
            min-width: 280px;
        }

        .image-box img {
            width: 100%;
            max-width: 500px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }

        .text-box {
            flex: 1;
            min-width: 280px;
        }

        .text-box h2 {
            font-size: 32px;
            color: #005caa;
            margin-bottom: 20px;
        }

        .text-box p {
            font-size: 16px;
            line-height: 1.6;
            margin-bottom: 15px;
        }

        .text-box ul {
            list-style: none;
            padding-left: 0;
        }

        .text-box li {
            margin-bottom: 10px;
            padding-left: 20px;
            position: relative;
        }

        .text-box li::before {
            content: "\2714";
            color: #005caa;
            position: absolute;
            left: 0;
        }

        footer {
            background: #003e73;
            color: white;
            padding: 30px 10%;
            text-align: center;
        }

        footer p {
            margin-bottom: 5px;
        }

        @media (max-width: 768px) {
            .hero-content h1 {
                font-size: 36px;
            }

            .flex-row,
            .flex-row.reverse {
                flex-direction: column !important;
                text-align: center;
            }
        }
    </style>
</head>

<body>
<!-- Navbar -->
<div class="navbar">
    <div class="logo">SwimmingPool</div>
    <div class="nav-links">
        <a href="#">Home</a>
        <a href="#about">About Us</a>
        <a href="#services">Services</a>

        <%-- Chỉ hiện "User List" nếu là Admin --%>
        <% if (user != null && user.getRole() != null && "Admin".equalsIgnoreCase(user.getRole().getName())) { %>
        <a href="admin-user">User List</a>
        <% } %>
        <%-- Chỉ hiện "User List" nếu là Admin --%>
        <% if (user != null && user.getRole() != null && "staff".equalsIgnoreCase(user.getRole().getName())) { %>
        <a href="equipment-rental">Equiqment Rental</a>
        <% } %>

        <% if (user != null && user.getRole() != null) {
        String roleName = user.getRole().getName();
        if ("Admin".equalsIgnoreCase(roleName) ||
                "Manager".equalsIgnoreCase(roleName)
            ) {
        %>
        <a href="maintenance">Maintenance</a>
        <% }
        } %>


        <%-- Chỉ hiển thị "View My Maintenance" nếu người dùng có role = 5 (Staff) --%>
        <% if (user != null && user.getRole() != null && user.getRole().getId() == 5) { %>
        <a href="viewMyMaintenance">View My Maintenance</a>
        <% } %>

        <a href="#contact">Contact</a>
        <a href="blogs">Blogs</a>

        <%-- Chỉ hiện "User List" nếu là Admin --%>
        <% if (user != null && user.getRole() != null && "Admin".equalsIgnoreCase(user.getRole().getName())) { %>
        <a href="admin-user">User List</a>
        <% } %>
    </div>

    <div class="auth">
        <% if (user == null) { %>
        <a class="login-btn" href="login.jsp">Login</a>
        <a class="register-btn" href="register.jsp">Register</a>
        <% } else { %>
        <span>Hello, <a href="userprofile" style="text-decoration:none; color:inherit;">
            <%= user.getFullName() %>
        </a>!</span>
        <form action="logout" method="post" style="display:inline;">
            <input type="submit" value="Logout">
        </form>
        <% } %>
    </div>
</div>


<!-- Spacer tránh bị che -->
<div style="height: 70px;"></div>

<!-- Hero Section -->
<div class="hero">
    <div class="hero-content">
        <h4>POOL DECK RESURFACING</h4>
        <h1>Making Waves in Pool Excellence</h1>
        <p>Regular pool cleaning is recommended at least once a week to maintain water clarity and hygiene.</p>
        <button class="btn btn-primary">DISCOVER MORE</button>
        <button class="btn btn-outline">CONTACT US</button>
    </div>
</div>


<!-- About Us -->
<div class="section" id="about">
    <div class="flex-row reverse">
        <div class="image-box">
            <img src="https://images.pexels.com/photos/5663203/pexels-photo-5663203.jpeg" alt="Pool Staff">
        </div>
        <div class="text-box">
            <h2>About Our Swimming Pool</h2>
            <p>We provide modern, hygienic and professionally maintained swimming pool services for individuals and
                families.</p>
            <p>Our pool is designed to offer both recreation and training, with safety and cleanliness as top
                priorities.</p>
            <ul>
                <li>Certified lifeguards on duty</li>
                <li>Weekly water quality checks</li>
                <li>Custom pool packages available</li>
                <li>Relaxing poolside lounge area</li>
            </ul>
        </div>
    </div>
</div>

<!-- Services -->
<div class="section" id="services">
    <div class="flex-row">
        <div class="image-box">
            <img src="https://images.pexels.com/photos/261102/pexels-photo-261102.jpeg" alt="Pool Services">
        </div>
        <div class="text-box">
            <h2>Our Services</h2>
            <p>Explore our offerings to enhance your swimming experience:</p>
            <ul>
                <li>Professional Swimming Training for all ages</li>
                <li>Private Pool Booking for Events & Families</li>
                <li>Water Aerobics & Therapy Sessions</li>
                <li>Maintenance & Pool Cleaning Services</li>
                <li><a href="ticketPurchase.jsp" style="color: #005caa; font-weight: bold;">Ticket Purchase</a></li>
            </ul>
        </div>
    </div>
</div>

<!-- Contact -->
<div class="section" id="contact">
    <h2 style="text-align:center; color:#005caa;">Contact Us</h2>
    <div style="text-align:center;" class="hero-content">
        <button class="btn btn-primary" onclick="window.location.href='feedback';">Send us a feedback</button>
    </div>

    <h2 style="text-align:center; color:#005caa;">See your old feedback</h2>
    <div style="text-align:center;" class="hero-content">
        <button class="btn btn-primary" onclick="window.location.href='feedback?mode=list';">Feedback History</button>
    </div>
</div>

<!-- Footer -->
<footer>
    <p>&copy; 2025 SwimmingPool. All rights reserved.</p>
    <p>Contact us: contact@swimmingpool.com | +84 123 456 789</p>
</footer>

</body>
</html>


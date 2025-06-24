<%@ page import="model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<<<<<<< HEAD
  <title>Swimming Pool - Home Page</title>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" type="text/css" href="Resources/CSS/home.css">
=======
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
>>>>>>> origin/hiepthhe173531
</head>

<body>
<!-- Navbar -->
<div class="navbar">
<<<<<<< HEAD
  <div class="logo">SwimmingPool</div>
  <div class="nav-links">
    <a href="#">Home</a>
    <a href="#about">About Us</a>
    <a href="#services">Services</a>
    <a href="blogs">Community Blogs</a>
    <a href="#gallery">Gallery</a>
    <a href="#contact">Contact</a>
  </div>
  <div class="auth">
    <% if (user == null) { %>
    <a class="login-btn" href="login.jsp">Login</a>
    <a class="register-btn" href="register.jsp">Register</a>
    <% } else { %>
    <span>Hello, <a href="userprofile" style="text-decoration:none; color:inherit;">
=======
    <div class="logo">SwimmingPool</div>
    <div class="nav-links">
        <a href="#">Home</a>
        <a href="#about">About Us</a>
        <a href="#services">Services</a>

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
>>>>>>> origin/hiepthhe173531
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
<<<<<<< HEAD
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

<!-- Community Blog Section -->
<div class="section" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white;">
  <div style="text-align: center; padding: 50px 20px;">
    <h2 style="color: white; margin-bottom: 20px; font-size: 2.5em;">Join Our Swimming Community!</h2>
    <p style="font-size: 1.2em; margin-bottom: 30px; max-width: 600px; margin-left: auto; margin-right: auto;">
      Connect with fellow swimmers, share your experiences, read swimming tips, and learn from our community of pool enthusiasts.
    </p>
    <div style="display: flex; gap: 20px; justify-content: center; flex-wrap: wrap; margin-bottom: 30px;">
      <div style="background: rgba(255,255,255,0.1); padding: 20px; border-radius: 12px; min-width: 200px;">
        <i class="fas fa-blog" style="font-size: 2em; margin-bottom: 10px;"></i>
        <h4>Read & Share</h4>
        <p>Browse swimming tips, techniques, and stories</p>
      </div>
      <div style="background: rgba(255,255,255,0.1); padding: 20px; border-radius: 12px; min-width: 200px;">
        <i class="fas fa-users" style="font-size: 2em; margin-bottom: 10px;"></i>
        <h4>Community</h4>
        <p>Connect with swimmers of all skill levels</p>
      </div>
      <div style="background: rgba(255,255,255,0.1); padding: 20px; border-radius: 12px; min-width: 200px;">
        <i class="fas fa-comments" style="font-size: 2em; margin-bottom: 10px;"></i>
        <h4>Discuss</h4>
        <p>Comment and engage in meaningful conversations</p>
      </div>
    </div>
    <% if (user == null) { %>
    <p style="font-size: 1.1em; margin-bottom: 20px;">
      <strong>Browse as a guest</strong> or <strong>sign in to participate!</strong>
    </p>
    <div style="display: flex; gap: 15px; justify-content: center; flex-wrap: wrap;">
      <a href="blogs" style="background: rgba(255,255,255,0.9); color: #667eea; padding: 15px 30px; border-radius: 25px; text-decoration: none; font-weight: bold; transition: all 0.3s ease;">
        <i class="fas fa-eye"></i> Browse Blogs
      </a>
      <a href="login.jsp" style="background: white; color: #667eea; padding: 15px 30px; border-radius: 25px; text-decoration: none; font-weight: bold; transition: all 0.3s ease;">
        <i class="fas fa-sign-in-alt"></i> Sign In to Join
      </a>
    </div>
    <% } else { %>
    <p style="font-size: 1.1em; margin-bottom: 20px;">
      <strong>Welcome back, <%= user.getFullName() %>!</strong> Ready to share your swimming knowledge?
    </p>
    <a href="blogs" style="background: white; color: #667eea; padding: 15px 30px; border-radius: 25px; text-decoration: none; font-weight: bold; transition: all 0.3s ease;">
      <i class="fas fa-blog"></i> Visit Community Blogs
    </a>
    <% } %>
  </div>
</div>

<!-- Gallery -->
<div class="section" id="gallery">
  <h2 style="text-align:center; color:#005caa;">Gallery</h2>
  <p style="text-align:center;">Coming soon...</p>
=======
>>>>>>> origin/hiepthhe173531
</div>

<!-- Contact -->
<div class="section" id="contact">
    <h2 style="text-align:center; color:#005caa;">Contact Us</h2>
    <div style="text-align:center;" class="hero-content">
        <button class="btn btn-primary" onclick="window.location.href='feedback';">Send us a feedback</button>
    </div>
</div>

<!-- Footer -->
<footer>
    <p>&copy; 2025 SwimmingPool. All rights reserved.</p>
    <p>Contact us: contact@swimmingpool.com | +84 123 456 789</p>
</footer>

</body>
</html>


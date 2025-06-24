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

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="Resources/CSS/home.css">
</head>

<body>
<jsp:include page="header.jsp" />


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


<%@ page import="model.User" %>
<%
  User user = (User) session.getAttribute("user");
  if (user == null) {
    response.sendRedirect("login.jsp");
    return;
  }
%>
<html>
<body>
<<<<<<< Updated upstream
<h2>Xin chào, <%= user.getFullName() %> (Vai trò: <%= user.getRole().getName() %>)</h2>
=======

<!-- Navbar -->
<div class="navbar">
  <div class="logo">SwimmingPool</div>
  <div class="nav-links">
    <a href="#">Home</a>
    <a href="#about">About Us</a>
    <a href="#services">Services</a>
    <a href="#gallery">Gallery</a>
    <a href="#contact">Contact</a>
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
      <p>We provide modern, hygienic and professionally maintained swimming pool services for individuals and families.</p>
      <p>Our pool is designed to offer both recreation and training, with safety and cleanliness as top priorities.</p>
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

<!-- Gallery -->
<div class="section" id="gallery">
  <h2 style="text-align:center; color:#005caa;">Gallery</h2>
  <p style="text-align:center;">Coming soon...</p>
</div>

<!-- Contact -->
<div class="section" id="contact">
  <h2 style="text-align:center; color:#005caa;">Contact Us</h2>
  <p style="text-align:center;">Contact form will be available soon.</p>
</div>

<!-- Footer -->
<footer>
  <p>&copy; 2025 SwimmingPool. All rights reserved.</p>
  <p>Contact us: contact@swimmingpool.com | +84 123 456 789</p>
</footer>

>>>>>>> Stashed changes
</body>
</html>

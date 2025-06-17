<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Equipment Rental</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            margin: 0;
            background-color: #f8f9fa;
        }
        .header {
            background-color: #007bff;
            color: white;
            padding: 10px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .hero-section {
            background: url('https://images.pexels.com/photos/863988/pexels-photo-863988.jpeg') center/cover no-repeat;
            padding: 100px 20px 60px;
            color: white;
            text-align: center;
        }
        .hero-section h1 {
            font-size: 48px;
            margin: 0;
        }
        .main-content {
            display: flex;
            padding: 40px 60px;
        }
        .sidebar {
            width: 250px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            padding: 20px;
            margin-right: 30px;
        }
        .sidebar h3 {
            margin-bottom: 10px;
        }
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 30px;
            flex-grow: 1;
        }
        .product-card {
            background-color: white;
            border-radius: 10px;
            overflow: hidden;
            text-align: center;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            padding: 15px;
        }
        .product-card img {
            width: 100%;
            height: 150px;
            object-fit: cover;
            border-radius: 8px;
        }
        .product-card h4 {
            margin: 10px 0 5px;
            font-size: 16px;
        }
        .product-card p {
            margin: 0;
            color: #28a745;
            font-weight: bold;
        }
        .footer {
            background-color: #343a40;
            color: white;
            text-align: center;
            padding: 40px;
            margin-top: 60px;
        }
    </style>
</head>
<body>
<div class="header">
    <div class="logo"><strong>SwimmingPool</strong></div>
    <div class="nav-links">
        <a href="home.jsp" style="color:white; margin-right: 20px;">Home</a>
        <a href="#" style="color:white;">Contact</a>
    </div>
</div>
<div class="hero-section">
    <h1>Rent Swimming Equipment</h1>
</div>
<div class="main-content">
    <div class="sidebar">
        <h3>Categories</h3>
        <ul>
            <li><a href="#">Goggles</a></li>
            <li><a href="#">Swim Hats</a></li>
            <li><a href="#">Clothes</a></li>
        </ul>
    </div>
    <div class="product-grid">
        <div class="product-card">
            <img src="https://images.pexels.com/photos/1263423/pexels-photo-1263423.jpeg" alt="Goggles">
            <h4>Swimming Goggles</h4>
            <p>$8/day</p>
        </div>
        <div class="product-card">
            <img src="https://images.pexels.com/photos/414029/pexels-photo-414029.jpeg" alt="Hat">
            <h4>Swim Hat</h4>
            <p>$3/day</p>
        </div>
        <div class="product-card">
            <img src="https://images.pexels.com/photos/3758127/pexels-photo-3758127.jpeg" alt="Suit">
            <h4>Swim Suit</h4>
            <p>$10/day</p>
        </div>
    </div>
</div>
<div class="footer">
    <p>&copy; 2025 SwimmingPool. All rights reserved.</p>
    <p>Contact: info@swimmingpool.com | +84 123 456 789</p>
</div>
</body>
</html>

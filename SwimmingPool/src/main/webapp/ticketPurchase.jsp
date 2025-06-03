<%@ page import="model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ticket Purchase</title>
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;600&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; }
        html, body {
            margin: 0;
            padding: 0;
            height: 100%;
            font-family: 'Quicksand', sans-serif;
        }
        .navbar {
            background: rgba(0, 92, 170, 0.9);
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 30px;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            z-index: 999;
            backdrop-filter: blur(4px);
        }
        .nav-links a, .auth a {
            color: white;
            text-decoration: none;
            margin: 0 10px;
            font-weight: 500;
        }
        .auth input[type="submit"] {
            background: white;
            color: #005caa;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
        }
        .bg-cover {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('https://images.pexels.com/photos/6437583/pexels-photo-6437583.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2') center/cover no-repeat;
            z-index: -1;
            filter: brightness(0.8);
        }
        .hero {
            background: transparent;
            height: 280px;
            display: flex;
            justify-content: center;
            align-items: center;
            color: white;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }
        .hero h1 { font-size: 36px; }
        .container {
            width: 90%;
            max-width: 850px;
            background: rgba(255, 255, 255, 0.95);
            margin: -80px auto 40px;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 12px 32px rgba(0,0,0,0.1);
            margin-bottom: 100px; /* ✅ Đẩy nút lên khỏi footer */
        }
        h2 {
            text-align: center;
            margin-bottom: 30px;
            color: #007bff;
        }
        form table {
            width: 100%;
            max-width: 600px;
            margin: 0 auto;
            table-layout: auto;
            border-spacing: 0 16px;
        }
        th {
            background-color: #007bff;
            color: white;
            padding: 10px 14px;
            width: 180px;
            vertical-align: top;
            text-align: left;
            border-radius: 6px 0 0 6px;
        }
        td {
            padding: 10px 14px;
            vertical-align: middle;
        }
        td input, td select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        .btn {
            background-color: #007bff;
            color: white;
            padding: 12px 30px;
            border: none;
            font-size: 16px;
            border-radius: 6px;
            cursor: pointer;
            transition: background 0.3s ease;
            margin-top: 10px;
            float: right;
        }
        .btn:hover { background-color: #0056b3; }
        .message {
            margin-top: 20px;
            font-weight: 500;
            max-width: 800px;
            margin-left: auto;
            margin-right: auto;
        }
        .success { color: green; }
        .error { color: red; }
        .footer {
            background-color: #002b5b;
            color: white;
            padding: 40px 20px;
            text-align: center; /* 👉 căn giữa nội dung */
        }

        .footer p {
            margin: 6px 0;
            font-size: 14px;
        }
        .footer div {
            flex: 1 1 300px;
            padding: 10px;
        }
        .footer h4 {
            font-size: 18px;
            margin-bottom: 10px;
            color: #aad4ff;
        }
        .footer p {
            margin: 6px 0;
            font-size: 14px;
        }
        .footer a {
            color: #aad4ff;
            text-decoration: none;
        }
        .footer a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="bg-cover"></div>

<div class="navbar">
    <div class="logo">SwimmingPool</div>
    <div class="nav-links">
        <a href="home.jsp">Home</a>
        <a href="about">About Us</a>
        <a href="home.jsp">Services</a>
        <a href="gallery">Gallery</a>
        <a href="contact">Contact</a>
    </div>
    <div class="auth">
        <span>Hello, <%= user.getFullName() %>!</span>
        <form action="logout" method="post">
            <input type="submit" value="Logout">
        </form>
    </div>
</div>

<div style="height: 80px;"></div>

<div class="hero">
    <h1>Buy Swimming Ticket</h1>
</div>

<div class="container">
    <h2>Ticket Purchase Form</h2>
    <form action="purchase" method="post">
        <table>
            <tr><th>Ticket Type</th><td>
                <select name="ticketType" id="ticketType" onchange="updateEndDate()" required>
                    <option value="Single">Single (1 day)</option>
                    <option value="Monthly">Monthly (30 days)</option>
                    <option value="ThreeMonthly">ThreeMonths</option>
                    <option value="SixMonthly">SixMonths</option>
                    <option value="Year">Year</option>
                </select></td></tr>
            <tr><th>Quantity</th><td><input type="number" name="quantity" value="1" min="1" required></td></tr>
            <tr><th>Start Date</th><td><input type="date" id="startDate" name="startDate" required readonly></td></tr>
            <tr><th>End Date</th><td><input type="date" id="endDate" name="endDate" required readonly></td></tr>
            <tr><td colspan="2" style="text-align:right;"><button type="submit" class="btn">Confirm Purchase</button></td></tr>
        </table>
        <div class="message">
            <p class="success"><%= request.getAttribute("success") != null ? request.getAttribute("success") : "" %></p>
            <p class="error"><%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %></p>
        </div>
    </form>
</div>

<div class="footer">
    <p>&copy; 2025 SwimmingPool. All rights reserved.</p>
    <p>Contact us: contact@swimmingpool.com | +84 123 456 789</p>
</div>

<script>
    window.onload = function () {
        const startDateInput = document.getElementById("startDate");
        const today = new Date().toISOString().split("T")[0];
        startDateInput.value = today;
        updateEndDate();
    };
    function updateEndDate() {
        const ticketType = document.getElementById("ticketType").value;
        const startDate = new Date(document.getElementById("startDate").value);
        const endDateInput = document.getElementById("endDate");
        let daysToAdd = 0;
        switch (ticketType) {
            case "Single": daysToAdd = 1; break;
            case "Monthly": daysToAdd = 30; break;
            case "ThreeMonthly": daysToAdd = 90; break;
            case "SixMonthly": daysToAdd = 180; break;
            case "Year": daysToAdd = 365; break;
        }
        const endDate = new Date(startDate);
        endDate.setDate(endDate.getDate() + daysToAdd);
        endDateInput.value = endDate.toISOString().split("T")[0];
    }
</script>

</body>
</html>

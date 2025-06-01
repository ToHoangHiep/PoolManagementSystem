<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page language="java" %>
<%@ page import="model.User" %>

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
            text-shadow: 0 2px 4px rgba(0,0,0,0.3); /* giữ chữ rõ mà không làm nền tối */
        }
        .hero h1 { font-size: 36px; }
        .navbar {
            background-color: white;
            display: flex;
            justify-content: space-between;
            padding: 10px 40px;
            align-items: center;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }
        .navbar a {
            text-decoration: none;
            color: white;
            background-color: #007bff;
            padding: 8px 18px;
            margin: 0 5px;
            border-radius: 6px;
            font-weight: 500;
        }
        .navbar .right {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .navbar .right input {
            padding: 5px 8px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .container {
            width: 90%;
            max-width: 850px;
            background: rgba(255, 255, 255, 0.95);
            margin: -80px auto 40px;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 12px 32px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            margin-bottom: 30px;
            color: #007bff;
        }
        form table {
            width: 100%;
            max-width: 600px; /* hoặc thử 550px nếu bạn muốn gọn nữa */
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
            margin-top: 60px;
            padding: 80px 40px;
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
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
    <div class="left">
        <a href="#">Home</a>
        <a href="#">My Ticket</a>
        <a href="#">Bookings</a>
        <a href="#">Contact Us</a>
    </div>
    <div class="right">
        <%
            User user = (User) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }
        %>
        <span>Welcome, <%= user.getFullName() %></span>
        <a href="#">[Logout]</a>
        <input type="text" placeholder="Search...">
    </div>
</div>

<div class="hero">
    <h1>Buy Swimming Ticket</h1>
</div>

<div class="container">
    <h2>Ticket Purchase Form</h2>

    <form action="purchase" method="post">
        <table>
            <tr>
                <th>Ticket Type</th>
                <td>
                    <select name="ticketType" id="ticketType" onchange="updateEndDate()" required>
                        <option value="Single">Single (1 day)</option>
                        <option value="Monthly">Monthly (30 days)</option>
                        <option value="ThreeMonthly">ThreeMonths</option>
                        <option value="SixMonthly">SixMonths</option>
                        <option value="Year">Year</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th>Quantity</th>
                <td><input type="number" name="quantity" value="1" min="1" required></td>
            </tr>
            <tr>
                <th>Start Date</th>
                <td><input type="date" id="startDate" name="startDate" required readonly></td>
            </tr>
            <tr>
                <th>End Date</th>
                <td><input type="date" id="endDate" name="endDate" required readonly></td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: right; padding-right: 20px;">
                    <button type="submit" class="btn">Confirm Purchase</button>
                </td>
            </tr>
        </table>

        <div class="message">
            <p class="success"><%= request.getAttribute("success") != null ? request.getAttribute("success") : "" %></p>
            <p class="error"><%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %></p>
        </div>
    </form>
</div>

<div class="footer">
    <div>
        <h4>About Us</h4>
        <p>We provide pool services and seasonal maintenance to keep your experience safe and refreshing.</p>
    </div>
    <div>
        <h4>Contact</h4>
        <p>📞 +468 254 76243</p>
        <p>📧 info@poolax.com</p>
    </div>
    <div>
        <h4>Working Hours</h4>
        <p>Monday – Friday: 9:00 AM – 6:00 PM</p>
        <p>Saturday – Sunday: Closed</p>
    </div>
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

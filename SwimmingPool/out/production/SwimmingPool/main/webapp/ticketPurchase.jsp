<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page language="java" %>
<%@ page import="model.User" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ticket Purchase</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            margin: 0;
            background: #f4f9fc;
        }

        .hero {
            background: url('https://images.unsplash.com/photo-1572276596234-6601fc5f9f46?auto=format&fit=crop&w=1600&q=80') center/cover no-repeat;
            height: 280px;
            display: flex;
            justify-content: center;
            align-items: center;
            color: white;
            text-shadow: 0 2px 4px rgba(0,0,0,0.5);
        }

        .hero h1 {
            font-size: 36px;
        }

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
            max-width: 900px;
            background-color: white;
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

        table {
            width: 100%;
            border-spacing: 0 10px;
        }

        th, td {
            text-align: left;
            padding: 10px;
        }

        th {
            background-color: #007bff;
            color: white;
            border-top-left-radius: 6px;
            border-top-right-radius: 6px;
        }

        td input, td select {
            width: 100%;
            padding: 10px;
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
            float: right;
            transition: background 0.3s ease;
            margin-top: 20px;
        }

        .btn:hover {
            background-color: #0056b3;
        }

        .message {
            margin-top: 20px;
            font-weight: 500;
        }

        .success { color: green; }
        .error { color: red; }
    </style>
</head>
<body>

<div class="navbar">
    <div class="left">
        <a href="#">Home</a>
        <a href="#">My Tickets</a>
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
        <span>Welcome,  <%= user.getFullName() %></span>
        <a href="#">[Logout]</a>
        <input type="text" placeholder="Search...">
    </div>
</div>

<div class="hero">
    <h1>Buy Swimming Tickets</h1>
</div>

<div class="container">
    <h2>Ticket Purchase Form</h2>

    <form action="purchase" method="post">
        <table>
            <tr>
                <th>Ticket Type</th>
                <td>
                    <select name="ticketType" required>
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
                <td><input type="date" name="startDate" required></td>
            </tr>
            <tr>
                <th>End Date</th>
                <td><input type="date" name="endDate" required></td>
            </tr>
        </table>

        <button type="submit" class="btn">Confirm Purchase</button>

        <div class="message">
            <p class="success"><%= request.getAttribute("success") != null ? request.getAttribute("success") : "" %></p>
            <p class="error"><%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %></p>
        </div>
    </form>
</div>

</body>
</html>

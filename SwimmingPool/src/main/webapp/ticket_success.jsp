<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Success - Ticket Purchased</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            margin: 0;
            background: linear-gradient(to right, #dff2fd, #e6f7ff);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            text-align: center;
        }
        .success-box {
            background: white;
            padding: 60px 40px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 123, 255, 0.2);
            max-width: 500px;
        }
        .success-box h1 {
            color: #28a745;
            font-size: 36px;
            margin-bottom: 20px;
        }
        .success-box p {
            font-size: 18px;
            margin-bottom: 30px;
            color: #333;
        }
        .btn-home {
            background-color: #007bff;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            text-decoration: none;
            font-weight: bold;
            display: inline-block;
            transition: background-color 0.3s ease;
        }
        .btn-home:hover {
            background-color: #0056b3;
        }
        .checkmark {
            font-size: 64px;
            color: #28a745;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
<div class="success-box">
    <div class="checkmark">✔</div>
    <h1>Purchase Successful!</h1>
    <p>Thank you for your purchase. Your ticket has been successfully confirmed.</p>
    <a href="home.jsp" class="btn-home">⟵ Back to Home</a>
</div>
</body>
</html>

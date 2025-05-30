<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Xác minh Email</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html, body {
            font-family: Arial, sans-serif;
            height: 100%;
            background: url('https://images.pexels.com/photos/221457/pexels-photo-221457.jpeg?auto=compress&cs=tinysrgb&w=1600') no-repeat center center fixed;
            background-size: cover;
            scroll-behavior: smooth;
        }

        .overlay {
            position: absolute;
            top: 0; left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6);
            z-index: 0;
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
            color: white;
        }

        .logo {
            font-size: 24px;
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

        .container {
            position: relative;
            z-index: 1;
            max-width: 400px;
            margin: 120px auto 40px;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.3);
            text-align: center;
        }

        .container h2 {
            color: #005caa;
            margin-bottom: 20px;
        }

        input[type="text"] {
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 16px;
        }

        .btn {
            background-color: #005caa;
            color: white;
            border: none;
            padding: 12px;
            font-size: 16px;
            border-radius: 6px;
            width: 100%;
            cursor: pointer;
            margin-top: 10px;
        }

        .btn:hover {
            background-color: #004080;
        }

        .error {
            color: red;
            margin-top: 10px;
        }

        .back-link {
            margin-top: 20px;
        }

        .back-link a {
            color: #005caa;
            font-weight: bold;
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="overlay"></div>

<!-- Navbar -->
<div class="navbar">
    <div class="logo">SwimmingPool</div>
    <div class="nav-links">
        <a href="home.jsp">Home</a>
        <a href="register.jsp">Register</a>
    </div>
</div>

<!-- Xác minh form -->
<div class="container">
    <h2>Nhập mã xác minh</h2>
    <form action="verify" method="post">
        <input type="text" name="code" placeholder="Mã xác minh" required maxlength="6" />
        <input type="submit" value="Xác minh" class="btn" />
    </form>
    <div class="error">
        <%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %>
    </div>
    <div class="back-link">
        <a href="home.jsp">← Quay lại Trang chủ</a>
    </div>
</div>

</body>
</html>

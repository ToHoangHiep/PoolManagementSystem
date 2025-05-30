<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login Page</title>
    <style>
        html, body {
            height: 100%;
            margin: 0;
            font-family: Arial, sans-serif;
        }

        body {
            background-image: url('https://images.pexels.com/photos/221457/pexels-photo-221457.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            position: relative;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .overlay {
            position: absolute;
            top: 0; left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 0;
        }

        .login-container {
            z-index: 1;
            position: relative;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.3);
            width: 320px;
        }

        .login-container h2 {
            margin-bottom: 20px;
            text-align: center;
            color: #005caa;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }

        .form-group input[type="text"],
        .form-group input[type="password"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }

        .form-group input[type="checkbox"] {
            margin-right: 5px;
        }

        .form-actions {
            text-align: center;
            margin-top: 15px;
        }

        .form-actions input[type="submit"] {
            padding: 10px 20px;
            background-color: #005caa;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
        }

        .form-actions input[type="submit"]:hover {
            background-color: #003e73;
        }

        .links {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
        }

        .links a {
            color: #005caa;
            text-decoration: none;
            margin: 0 5px;
        }

        .links a:hover {
            text-decoration: underline;
        }

        .error {
            color: red;
            text-align: center;
            margin-top: 10px;
        }
    </style>
    <script>
        function togglePassword() {
            const passwordInput = document.getElementById("password");
            passwordInput.type = passwordInput.type === "password" ? "text" : "password";
        }
    </script>
</head>
<body>

<div class="overlay"></div>

<div class="login-container">
    <h2>Login</h2>
    <form action="login" method="post">
        <div class="form-group">
            <label for="email">Email</label>
            <input type="text" name="email" id="email" required />
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" name="password" id="password" required />
            <div>
                <input type="checkbox" onclick="togglePassword()" /> Show Password
            </div>
        </div>
        <div class="form-actions">
            <input type="submit" value="Login" />
        </div>
    </form>

    <div class="links">
        <div>
            <a href="forgot_password.jsp">Forgot Password?</a> |
            <a href="register.jsp">User Registration</a>
        </div>
        <div style="margin-top: 10px;">
            <a href="home.jsp" style="font-weight: bold;">Home Page</a>
        </div>
    </div>

    <div class="error">
        <%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %>
    </div>
</div>

</body>
</html>

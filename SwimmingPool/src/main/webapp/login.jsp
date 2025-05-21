<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .login-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            width: 320px;
        }
        .login-container h2 {
            margin-bottom: 20px;
            text-align: center;
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
            padding: 8px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 4px;
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
            background-color: #4285f4;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .form-actions input[type="submit"]:hover {
            background-color: #357ae8;
        }
        .links {
            text-align: center;
            margin-top: 10px;
            font-size: 14px;
        }
        .links a {
            color: #4285f4;
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
<div class="login-container">
    <h2>Login</h2>
    <form action="login" method="post">
        <div class="form-group">
            <label for="email">Username or Email</label>
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
        <a href="forgot_password.jsp">Forgot Password?</a> |
        <a href="register.jsp">User Registration</a>
    </div>
    <div class="error">
        <%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %>
    </div>
</div>
</body>
</html>

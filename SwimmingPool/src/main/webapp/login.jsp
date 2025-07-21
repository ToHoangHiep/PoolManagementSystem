<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login Page</title>
    <link rel="stylesheet" type="text/css" href="Resources/CSS/login.css">
    <script src="Resources/JavaScript/login.js"></script>
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
            <a href="home.jsp">Back to Home</a>
        </div>
    </div>

    <% if (request.getParameter("error") != null) { %>
        <div class="error">
            <%= request.getParameter("error") %>
        </div>
    <% } %>
</div>

</body>
</html>

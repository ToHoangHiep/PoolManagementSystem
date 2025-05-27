<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Reset Password</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f5f5f5;
        margin: 0;
        padding: 20px;
        display: flex;
        flex-direction: column;
        align-items: center;
        min-height: 100vh;
    }

    .container {
        background-color: white;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        width: 90%;
        max-width: 500px;
        padding: 30px;
        margin-top: 40px;
    }

    h2 {
        color: #333;
        margin-bottom: 20px;
        text-align: center;
    }

    form {
        width: 100%;
    }

    label {
        display: block;
        margin-bottom: 8px;
        font-weight: bold;
    }

    input {
        width: 100%;
        padding: 12px;
        margin-bottom: 20px;
        border: 1px solid #ddd;
        border-radius: 4px;
        box-sizing: border-box;
        font-size: 16px;
    }

    button {
        background-color: #4CAF50;
        color: white;
        border: none;
        padding: 14px 20px;
        border-radius: 4px;
        cursor: pointer;
        font-size: 16px;
        width: 100%;
    }

    button:hover {
        background-color: #45a049;
    }

    .error {
        color: #f44336;
        margin: 5px 0 15px;
        font-size: 14px;
        padding: 10px;
        background-color: rgba(244, 67, 54, 0.1);
        border-radius: 4px;
        display: <%= request.getAttribute("error") != null ? "block" : "none" %>;
    }

    .password-requirements {
        margin-bottom: 20px;
        color: #666;
        font-size: 14px;
        background-color: #f9f9f9;
        padding: 15px;
        border-radius: 4px;
        border-left: 3px solid #4CAF50;
    }

    a {
        display: block;
        text-align: center;
        margin-top: 20px;
        color: #2196F3;
        text-decoration: none;
    }

    a:hover {
        text-decoration: underline;
    }

    .password-container {
        display: flex;
        margin-bottom: 20px;
    }

    .password-container input {
        flex: 1;
        margin-bottom: 0;
        border-radius: 4px 0 0 4px;
    }

    .password-toggle {
        width: 40px;
        background-color: #e9e9e9;
        border: 1px solid #ddd;
        border-left: none;
        border-radius: 0 4px 4px 0;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #666;
    }

    .password-toggle:hover {
        background-color: #d9d9d9;
        color: #333;
    }
</style>

<%
    if (request.getParameter("email") == null) {
        response.sendRedirect("forgot_password.jsp");
        return;
    }
    String email = request.getParameter("email");

%>

<div class="container">
    <h2>Reset Your Password</h2>

    <div class="password-requirements">
        <strong>Password must:</strong>
        <ul>
            <li>Be at least 8 characters long</li>
            <li>Include at least one uppercase letter</li>
            <li>Include at least one lowercase letter</li>
            <li>Include at least one number</li>
            <li>Include at least one special character (@$!%*?&)</li>
        </ul>
    </div>

    <form method="post">
        <input type="hidden" name="email" value="<%= email %>">

        <div class="password-field">
            <label for="newPass">New Password</label>
            <div class="password-container">
                <input type="password" name="newPassword" id="newPass" required placeholder="Enter new password"/>
                <button type="button" class="password-toggle" onclick="togglePasswords()">
                    <i id="passwordIcon" class="fas fa-eye-slash"></i>
                </button>
            </div>
        </div>

        <div class="password-field">
            <label for="confirmPass">Confirm Password</label>
            <div class="password-container">
                <input type="password" name="confirmPassword" id="confirmPass" required
                       placeholder="Confirm new password"/>
            </div>
        </div>

        <div class="error">
            <%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %>
        </div>

        <button type="submit">Reset Password</button>
    </form>
</div>

<a href="login.jsp">Remembered your password?</a>

</body>

<script>
    function togglePasswords() {
        const newPassword = document.getElementById('newPass');
        const confirmPassword = document.getElementById('confirmPass');
        const icon = document.getElementById('passwordIcon');

        if (newPassword.type === 'password') {
            newPassword.type = 'text';
            confirmPassword.type = 'text';
            icon.className = 'fas fa-eye';
        } else {
            newPassword.type = 'password';
            confirmPassword.type = 'password';
            icon.className = 'fas fa-eye-slash';
        }
    }
</script>
</html>
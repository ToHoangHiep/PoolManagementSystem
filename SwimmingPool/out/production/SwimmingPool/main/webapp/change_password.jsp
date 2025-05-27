<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Change Password</title>

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

    .button-group {
        display: flex;
        gap: 15px;
        margin-top: 10px;
    }

    button {
        padding: 14px 20px;
        border-radius: 4px;
        cursor: pointer;
        font-size: 16px;
        border: none;
    }

    button[type="submit"] {
        background-color: #4CAF50;
        color: white;
        flex: 2;
    }

    button[type="submit"]:hover {
        background-color: #45a049;
    }

    button[type="button"] {
        background-color: #f1f1f1;
        color: #333;
        flex: 1;
    }

    button[type="button"]:hover {
        background-color: #e1e1e1;
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

    .user-info {
        text-align: center;
        color: #666;
        margin-bottom: 20px;
        padding-bottom: 15px;
        border-bottom: 1px solid #eee;
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
        flex: 0 !important;
    }

    .password-toggle:hover {
        background-color: #d9d9d9;
        color: #333;
    }
</style>

<div class="container">
    <h2>Change Password</h2>

    <div class="user-info">
        <%= user.getFullName() %> (Email: <%= user.getEmail() %>)
    </div>

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

    <form method="post" action="change-password">
        <div class="password-field">
            <label for="oldPass">Old Password</label>
            <div class="password-container">
                <input type="password" name="oldPass" id="oldPass" required placeholder="Enter old password"/>
                <button type="button" class="password-toggle" onclick="toggleOldPassword()">
                    <i id="oldPasswordIcon" class="fas fa-eye-slash"></i>
                </button>
            </div>
        </div>

        <div class="password-field">
            <label for="newPass">New Password</label>
            <div class="password-container">
                <input type="password" name="newPass" id="newPass" required placeholder="Enter new password"/>
                <button type="button" class="password-toggle" onclick="toggleNewPasswords()">
                    <i id="newPasswordIcon" class="fas fa-eye-slash"></i>
                </button>
            </div>
        </div>

        <div class="password-field">
            <label for="confirmPass">Confirm Password</label>
            <div class="password-container">
                <input type="password" name="confirmPass" id="confirmPass" required placeholder="Confirm new password"/>
            </div>
        </div>

        <div class="error">
            <%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %>
        </div>

        <div class="button-group">
            <button type="submit">Change Password</button>
            <button type="button" onclick="window.location.href='home.jsp'">Cancel</button>
        </div>
    </form>
</div>

</body>

<script>
    function toggleOldPassword() {
        const oldPassword = document.getElementById('oldPass');
        const icon = document.getElementById('oldPasswordIcon');

        if (oldPassword.type === 'password') {
            oldPassword.type = 'text';
            icon.className = 'fas fa-eye';
        } else {
            oldPassword.type = 'password';
            icon.className = 'fas fa-eye-slash';
        }
    }

    function toggleNewPasswords() {
        const newPassword = document.getElementById('newPass');
        const confirmPassword = document.getElementById('confirmPass');
        const icon = document.getElementById('newPasswordIcon');

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
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Reset Password</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="./Resources/CSS/ChangePassword.css">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>

<%
    if (request.getParameter("email") == null) {
        response.sendRedirect("forgot_password.jsp");
        return;
    }
    String email = request.getParameter("email");

%>

<div class="container">
    <h2><i class="fas fa-key"></i> Reset Your Password</h2>

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

    <form method="post" action="reset-password">
        <input type="hidden" name="email" value="<%= email %>">

        <div class="form-group">
            <label for="newPass">New Password</label>
            <div class="password-container">
                <input type="password" name="newPassword" id="newPass" required placeholder="Enter new password"/>
                <button type="button" class="password-toggle" onclick="togglePasswords()">
                    <i id="passwordIcon" class="fas fa-eye-slash"></i>
                </button>
            </div>
        </div>

        <div class="form-group">
            <label for="confirmPass">Confirm Password</label>
            <div class="password-container">
                <input type="password" name="confirmPassword" id="confirmPass" required
                       placeholder="Confirm new password"/>
            </div>
        </div>

        <div class="error" style="display: <%= request.getAttribute("error") != null ? "block" : "none" %>;">
            <%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %>
        </div>

        <div class="">
            <button type="submit">Reset Password</button>
        </div>
    </form>
</div>

<a href="login.jsp" class="remember-link">Remembered your password?</a>

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

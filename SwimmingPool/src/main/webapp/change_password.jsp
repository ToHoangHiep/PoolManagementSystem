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
    <link rel="stylesheet" href="./Resources/CSS/ChangePassword.css">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>

<div class="container">
    <h2><i class="fas fa-lock"></i> Change Password</h2>

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
        <div class="success" style="display: <%= request.getAttribute("message") != null ? "block" : "none" %>;">
            <%= request.getAttribute("message") != null ? request.getAttribute("message") : "" %>
        </div>
        
        <div class="form-group">
            <label for="oldPass">Old Password</label>
            <div class="password-container">
                <input type="password" name="oldPass" id="oldPass" required placeholder="Enter old password"/>
                <button type="button" class="password-toggle" onclick="toggleOldPassword()">
                    <i id="oldPasswordIcon" class="fas fa-eye-slash"></i>
                </button>
            </div>
        </div>

        <div class="form-group">
            <label for="newPass">New Password</label>
            <div class="password-container">
                <input type="password" name="newPass" id="newPass" required placeholder="Enter new password"/>
                <button type="button" class="password-toggle" onclick="toggleNewPasswords()">
                    <i id="newPasswordIcon" class="fas fa-eye-slash"></i>
                </button>
            </div>
        </div>

        <div class="form-group">
            <label for="confirmPass">Confirm Password</label>
            <div class="password-container">
                <input type="password" name="confirmPass" id="confirmPass" required placeholder="Confirm new password"/>
            </div>
        </div>

        <div class="error" style="display: <%= request.getAttribute("error") != null ? "block" : "none" %>;">
            <%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %>
        </div>

        <div class="button-group">
            <button type="submit">Change Password</button>
            <%
                String return_link = switch (user.getRole().getId()) {
                    case 1, 2 -> "admin_dashboard.jsp";
                    case 4 -> "home.jsp";
                    case 5 -> "staff_dashboard.jsp";
                    default -> throw new IllegalStateException("Unexpected value: " + user.getRole().getId());
                };
            %>
            <button type="button" onclick="window.location.href='<%= return_link %>'"> Return</button>
        </div>
    </form>
</div>

</body>

<script rel="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script rel="text/javascript" src="./Resources/JavaScript/ChangePassword.js"></script>

</html>

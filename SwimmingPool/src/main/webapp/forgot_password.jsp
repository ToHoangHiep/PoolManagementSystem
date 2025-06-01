<%@ page import="java.lang.String" %><%--
  Created by IntelliJ IDEA.
  User: LAPTOP
  Date: 23-May-25
  Time: 08:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Forgot Password</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="./Resources/CSS/ChangePassword.css">
    <link rel="stylesheet" href="./Resources/CSS/ForgotPassword.css">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>

<div class="container">
    <div class="form-section">
        <h3><i class="fas fa-search"></i> Let's find your account</h3>
        <%
            String step = request.getParameter("step");
            if (step == null) {
                step = "email";
            } // Default to first step

            boolean isEmailStep = step.equals("email");
        %>

        <form class="<%= !isEmailStep ? "inactive-form" : "" %>" method="post" action="forgot-password">
            <div class="form-group">
                <label for="email">Account Email: </label>
                <input type="email" id="email" name="email" required placeholder="Enter your email"/>
            </div>

            <div class="error" style="display: <%= request.getAttribute("error_p1") != null ? "block" : "none" %>" >
                <%= request.getAttribute("error_p1") != null ? request.getAttribute("error_p1") : "" %>
            </div>

            <div class="">
                <button type="submit">Send Reset Password Code</button>
                <input type="hidden" name="action" value="sendCode"/>
            </div>
        </form>
    </div>

    <div class="divider"></div>

    <div class="form-section">
        <h3><i class="fas fa-key"></i> Got a code?</h3>
        <form class="<%= isEmailStep ? "inactive-form" : "" %>" method="post" action="forgot-password">
            <% if (!isEmailStep) { %>
            <div class="form-group success-message">
                Vui lòng kiểm tra email của bạn!
            </div>
            <% } %>

            <div style="display: none">
                <%
                    String emailParam = request.getParameter("email");
                    if (emailParam != null && !emailParam.isEmpty()) {
                %>
                <label>
                    <input type="email" id="email" name="email" value="<%= emailParam %>" readonly/>
                </label>
                <%
                    }
                %>
            </div>

            <div class="form-group">
                <label for="code">Verification Code: </label>
                <input type="text" id="code" name="code" required placeholder="Enter your code sent to email"/>
            </div>

            <div class="error" style="display: <%= request.getAttribute("error_p2") != null ? "block" : "none" %>">
                <%= request.getAttribute("error_p2") != null ? request.getAttribute("error_p2") : "" %>
            </div>

            <div class="">
                <button type="submit">Reset Password</button>
                <input type="hidden" name="action" value="checkCode"/>
            </div>
        </form>
    </div>
</div>

<a href="login.jsp" class="remember-link">Remembered Your Password?</a>
</body>

</html>

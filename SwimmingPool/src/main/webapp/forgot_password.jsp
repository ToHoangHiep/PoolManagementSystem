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
        max-width: 800px;
        padding: 30px;
        display: flex;
        position: relative;
    }

    .form-section {
        flex: 1;
        padding: 20px;
    }

    .divider {
        width: 1px;
        background-color: #ddd;
        position: absolute;
        top: 10%;
        bottom: 10%;
        left: 50%;
    }

    h2 {
        color: #333;
        margin-bottom: 20px;
    }

    label {
        display: block;
        margin-bottom: 8px;
        font-weight: bold;
    }

    input {
        width: 100%;
        padding: 10px;
        margin-bottom: 15px;
        border: 1px solid #ddd;
        border-radius: 4px;
        box-sizing: border-box;
    }

    button {
        background-color: #4CAF50;
        color: white;
        border: none;
        padding: 12px 20px;
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
</style>

<div class="container">
    <div class="form-section">
        <h2>Let's find your account</h2>
        <%
            String step = request.getParameter("step");
            if (step == null) {
                step = "email";
            } // Default to first step

            boolean isEmailStep = step.equals("email");
        %>

        <form style="<%= !isEmailStep ? "pointer-events: none; opacity: 0.5;" : "" %>" method="post">
            <label for="email">Account Email: </label>
            <input type="email" id="email" name="email" required placeholder="Enter your email"/>

            <div class="error">
                <%= request.getAttribute("error_p1") != null ? request.getAttribute("error_p1") : "" %>
            </div>

            <button type="submit">Send Reset Password Code</button>
            <input type="hidden" name="action" value="sendCode"/>
        </form>
    </div>

    <div class="divider"></div>

    <div class="form-section">
        <h2>Got a code?</h2>
        <form style="<%= isEmailStep ? "pointer-events: none; opacity: 0.5;" : "" %>" method="post">
            <% if (!isEmailStep) { %>
            <div style="color: green; font-weight: bold; margin-bottom: 15px;">
                Vui lòng kiểm tra email của bạn!
            </div>
            <% } %>

            <label for="code">Verification Code: </label>
            <input type="text" id="code" name="code" required placeholder="Enter your code sent to email"/>

            <div class="error">
                <%= request.getAttribute("error_p2") != null ? request.getAttribute("error_p2") : "" %>
            </div>

            <button type="submit">Reset Password</button>
            <input type="hidden" name="action" value="checkCode"/>
        </form>
    </div>
</div>

<a href="login.jsp">Remembered Your Password?</a>
</body>

</html>

<%--
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

<div>
    <%
        String step = request.getParameter("step");
        if (step == null) {
            step = "email";
        } // Default to first step

        boolean isEmailStep = step.equals("email");
    %>

    <form style="<%= isEmailStep ? "pointer-events: none; opacity: 0.5;" : "" %>" method="post" action="sendCode">
        <label for="email">Account Email: </label>
        <input type="email" id="email" name="email" required placeholder="Enter your email"/>

        <div class="error_p1">
            <%= request.getAttribute("error_p1") != null ? request.getAttribute("error_p1") : "" %>
        </div>

        <button type="submit" value="Send Reset Password Verification Code"/>
    </form>

    <form style="<%= !isEmailStep ? "pointer-events: none; opacity: 0.5;" : "" %>" method="post" action="checkCode">
        <% if (!isEmailStep) { %>
        <div style="color: green; font-weight: bold;">
            Vui lòng kiểm tra email của bạn!
        </div>
        <% } %>

        <label for="code">Verifcation Code: </label>
        <input type="text" id="code" name="code" required placeholder="Enter your code sent to email"/>

        <div class="error_p2">
            <%= request.getAttribute("error_p2") != null ? request.getAttribute("error_p2") : "" %>
        </div>

        <button type="submit" value="Reset Password"/>
    </form>
</div>

<a href="login.jsp">Remembered Your Password ?</a>

</body>
</html>

<%--
  Created by IntelliJ IDEA.
  User: LAPTOP
  Date: 23-May-25
  Time: 08:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Reset Password</title>
</head>
<body>

<%
    if (request.getParameter("email") == null) {
        response.sendRedirect("forgot_password.jsp");
        return;
    }
%>

<form method="post">
    <label for="newPass">New Password: </label>
    <input type="password" name="newPass" id="newPass" required placeholder="Enter New Password"/>

    <label for="confirmPass">Confirm Password: </label>
    <input type="password" name="confirmPass" id="confirmPass" required placeholder="Confirm New Password"/>

    <div class="error">
        <%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %>
    </div>

    <button type="submit">Reset Password</button>
</form>

<a href="login.jsp">Remembered Your Password ?</a>

</body>
</html>

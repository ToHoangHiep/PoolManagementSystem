<%--
  Created by IntelliJ IDEA.
  User: LAPTOP
  Date: 24-May-25
  Time: 19:39
  To change this template use File | Settings | File Templates.
--%>

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
</head>
<body>

<h2>
    Change Password for <%= user.getFullName() %> (Email: <%= user.getEmail() %>)
</h2>

<form method="post">
    <label for="oldPass">Old Password: </label>
    <input type="password" name="oldPass" id="oldPass" required placeholder="Enter Old Password"/>
    <br><br>

    <label for="newPass">New Password: </label>
    <input type="password" name="newPass" id="newPass" required placeholder="Enter New Password"/>
    <label for="confirmPass">Confirm Password: </label>
    <input type="password" name="confirmPass" id="confirmPass" required placeholder="Confirm New Password"/>
    <br><br>

    <div class="error">
        <%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %>
    </div>

    <button type="submit">Change Password</button>
    <button type="button" onclick="window.location.href='home.jsp'">Cancel</button>
</form>

</body>
</html>

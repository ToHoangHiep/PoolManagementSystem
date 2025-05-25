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

</body>
</html>

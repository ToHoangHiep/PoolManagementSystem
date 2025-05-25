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

<%
    String step = request.getParameter("step");
    if (step == null) {
        step = "email";
    } // Default to first step
%>

</body>
</html>

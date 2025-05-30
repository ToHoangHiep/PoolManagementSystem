<%--
  Created by IntelliJ IDEA.
  User: LAPTOP
  Date: 30-May-25
  Time: 10:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="model.User" %>
<%@ page import="model.Feedback" %>
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
    <title>Title</title>
</head>
<body>

<%
  Feedback feedback = (Feedback) request.getAttribute("feedback");

  boolean existing = feedback != null;
%>

<form action="feedback/<%  %>">

</form>

</body>
</html>

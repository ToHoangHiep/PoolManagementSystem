<%@ page import="model.User" %>
<%
  User user = (User) session.getAttribute("user");
  if (user == null) {
    response.sendRedirect("login.jsp");
    return;
  }
%>
<html>
<body>
<h2>Xin chào, <%= user.getFullName() %> (Vai trò: <%= user.getRole().getName() %>)</h2>
</body>
</html>

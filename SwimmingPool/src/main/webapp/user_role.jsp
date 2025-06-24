<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%@ page import="model.Role" %>
<%
    List<User> users = (List<User>) request.getAttribute("users");
    List<Role> roles = (List<Role>) request.getAttribute("roles");
%>
<html>
<head>
    <title>User Role Management</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f1f6fb; margin: 0; padding: 20px; }
        h2 { color: #0066cc; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; background: #fff; box-shadow: 0 0 5px rgba(0,0,0,0.1); }
        th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #e6f2ff; }
        select, button { padding: 5px 10px; }
        form { margin: 0; }
    </style>
</head>
<body>
<h2>User Role Management</h2>
<table>
    <tr>
        <th>User ID</th>
        <th>Full Name</th>
        <th>Email</th>
        <th>Current Role</th>
        <th>Change Role</th>
    </tr>
    <%
        if (users != null) {
            for (User u : users) {
    %>
    <tr>
        <td><%= u.getId() %></td>
        <td><%= u.getFullName() %></td>
        <td><%= u.getEmail() %></td>
        <td><%= u.getRole().getName() %></td>
        <td>
            <form method="post" action="user-role">
                <input type="hidden" name="userId" value="<%= u.getId() %>" />
                <select name="roleId">
                    <%
                        for (Role r : roles) {
                            String selected = (r.getId() == u.getRole().getId()) ? "selected" : "";
                    %>
                    <option value="<%= r.getId() %>" <%= selected %>><%= r.getName() %></option>
                    <%
                        }
                    %>
                </select>
                <button type="submit">Update</button>
            </form>
        </td>
    </tr>
    <%
            }
        }
    %>
</table>
</body>
</html>

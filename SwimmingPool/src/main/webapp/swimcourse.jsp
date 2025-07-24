<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, model.SwimCourse" %>
<html>
<head>
    <title>Course Management</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f9f9f9;
            margin: 0;
            padding: 40px;
        }

        h2 {
            color: #333;
            margin-bottom: 25px;
        }

        .filter-form {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 1px 6px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        input[type="text"], select {
            padding: 8px 12px;
            border: 1px solid #ccc;
            border-radius: 5px;
            width: 200px;
            font-size: 14px;
        }

        .header-controls {
            display: flex;
            align-items: flex-end;
            gap: 10px;
            margin-left: auto;
        }

        button {
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            background-color: #007bff;
            color: white;
            cursor: pointer;
            font-size: 14px;
        }

        button:hover {
            background-color: #0056b3;
        }

        .table-scroll-container {
            overflow-x: auto;
            border-radius: 8px;
            box-shadow: 0 1px 6px rgba(0,0,0,0.1);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
        }

        th, td {
            padding: 12px 16px;
            border-bottom: 1px solid #eee;
            text-align: left;
            font-size: 14px;
        }

        th {
            background-color: #f1f3f5;
            font-weight: bold;
        }

        tr:hover {
            background-color: #f9f9f9;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .action-buttons button {
            background-color: #6c757d;
            font-size: 13px;
            padding: 6px 12px;
        }

        .action-buttons button:hover {
            background-color: #5a6268;
        }

        .action-buttons a button:first-child {
            background-color: #28a745;
        }

        .action-buttons a button:first-child:hover {
            background-color: #218838;
        }

        .action-buttons a button:last-child {
            background-color: #dc3545;
        }

        .action-buttons a button:last-child:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>

<h2>Admin - Course Management</h2>

<%
    String keyword = request.getParameter("keyword");
    String status = request.getParameter("status");
    if (keyword == null) keyword = "";
    if (status == null) status = "";
%>

<form class="filter-form" method="get" action="swimcourse">
    <div class="filter-group">
        <label for="keyword">Course Name</label>
        <input type="text" id="keyword" name="keyword" value="<%= keyword %>" placeholder="Enter course name...">
    </div>

    <div class="filter-group">
        <label for="status">Status</label>
        <select name="status" id="status" onchange="this.form.submit()">
            <option value="">All</option>
            <option value="Active" <%= "Active".equals(status) ? "selected" : "" %>>Active</option>
            <option value="Inactive" <%= "Inactive".equals(status) ? "selected" : "" %>>Inactive</option>
        </select>
    </div>

    <div class="header-controls">
        <button type="submit">Filter</button>
        <button type="button" onclick="window.location.href='swimcourse'">Refresh</button>
    </div>
</form>

<div class="table-scroll-container">
    <table>
        <thead>
        <tr>
            <th>Course Name</th>
            <th>Description</th>
            <th>Price</th>
            <th>Duration (min)</th>
            <th>Status</th>
            <th>Coach</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <%
            List<SwimCourse> courses = (List<SwimCourse>) request.getAttribute("courses");
            if (courses != null && !courses.isEmpty()) {
                for (SwimCourse course : courses) {
        %>
        <tr>
            <td><%= course.getName() %></td>
            <td><%= course.getDescription() %></td>
            <td>$<%= course.getPrice() %></td>
            <td><%= course.getDuration() %></td>
            <td><%= course.getStatus() %></td>
            <td><%= course.getCoach() != null ? course.getCoach() : "---" %></td>
            <td class="action-buttons">
                <a href="swimcourse?action=toggleStatus&id=<%= course.getId() %>">
                    <button type="button">
                        <%= "Active".equals(course.getStatus()) ? "Deactivate" : "Activate" %>
                    </button>
                </a>
                <a href="swimcourse?action=delete&id=<%= course.getId() %>" onclick="return confirm('Are you sure to delete this course?')">
                    <button type="button">Delete</button>
                </a>
            </td>
        </tr>
        <%
            }
        } else {
        %>
        <tr><td colspan="7" style="text-align: center; color: #777;">No courses found.</td></tr>
        <%
            }
        %>
        </tbody>
    </table>
</div>

</body>
</html>

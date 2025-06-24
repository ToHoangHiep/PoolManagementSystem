<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, model.SwimCourse" %>
<html>
<head>
    <title>Course List</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f7fc;
            padding: 40px;
            margin: 0;
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
            color: #2c3e50;
        }

        .header-controls {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 20px;
        }

        .header-controls button {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 18px;
            font-size: 14px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.2s ease;
        }

        .header-controls button:hover {
            background-color: #0056b3;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
            border-radius: 8px;
            overflow: hidden;
        }

        th, td {
            padding: 14px 18px;
            border-bottom: 1px solid #e0e0e0;
            text-align: left;
        }

        th {
            background-color: #f0f2f7;
            color: #333;
        }

        tr:hover {
            background-color: #f9fcff;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
        }

        .action-buttons button {
            background-color: #6c757d;
            color: white;
            border: none;
            padding: 7px 14px;
            font-size: 13px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.2s ease;
        }

        .action-buttons button:hover {
            background-color: #495057;
        }

        .delete-btn {
            background-color: #dc3545;
        }

        .delete-btn:hover {
            background-color: #a71d2a;
        }
    </style>
</head>
<body>

<h2>Coach - My Courses</h2>

<div class="header-controls">
    <form action="coachcourse" method="get">
        <input type="hidden" name="action" value="add" />
        <button type="submit">+ Add New Course</button>
    </form>
</div>

<%
    List<SwimCourse> courses = (List<SwimCourse>) request.getAttribute("courses");
%>

<table>
    <thead>
    <tr>
        <th>Course Name</th>
        <th>Description</th>
        <th>Price ($)</th>
        <th>Duration (min)</th>
        <th>Status</th>
        <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <%
        if (courses != null && !courses.isEmpty()) {
            for (SwimCourse course : courses) {
    %>
    <tr>
        <td><%= course.getName() %></td>
        <td><%= course.getDescription() %></td>
        <td><%= course.getPrice() %></td>
        <td><%= course.getDuration() %></td>
        <td><%= course.getStatus() %></td>
        <td class="action-buttons">
            <form action="coachcourse" method="get" style="display:inline;">
                <input type="hidden" name="action" value="edit" />
                <input type="hidden" name="id" value="<%= course.getId() %>" />
                <button type="submit">Edit</button>
            </form>
            <form action="coachcourse" method="get" style="display:inline;"
                  onsubmit="return confirm('Are you sure you want to delete this course?');">
                <input type="hidden" name="action" value="delete" />
                <input type="hidden" name="id" value="<%= course.getId() %>" />
                <button type="submit" class="delete-btn">Delete</button>
            </form>
        </td>
    </tr>
    <%
        }
    } else {
    %>
    <tr><td colspan="6" style="text-align: center;">No courses found.</td></tr>
    <%
        }
    %>
    </tbody>
</table>

</body>
</html>

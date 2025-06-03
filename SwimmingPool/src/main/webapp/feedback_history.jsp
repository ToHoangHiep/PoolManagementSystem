<%--
  Created by IntelliJ IDEA.
  User: LAPTOP
  Date: 30-May-25
  Time: 10:28
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
    <title>Feedback History - Swimming Pool Management System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="./Resources/CSS/FeedbackHistory.css">
</head>
<body>

<form action="feedback?action=sort" method="post" class="filter-form">
    <div class="form-group">
        <label for="feedback_type">Feedback Type:</label>
        <select name="feedback_type" id="feedback_type" required onchange="showHideFields()">
            <option value="all" selected>Select feedback type</option>
            <option value="Coach" disabled title="Coach feedback is currently unavailable">Coach (Unavailable)</option>
            <option value="Course" disabled title="Course feedback is currently unavailable">Course (Unavailable)</option>
            <option value="General">General</option>
        </select>
    </div>

    <div class="form-group" id="coach_id_group" style="display: none;">
        <label for="coach_id">Coach:</label>
        <select name="coach_id" id="coach_id" required>
            <option value="all" selected>All Coach</option>
            <!-- Temporary static options for testing -->
            <option value="1">Coach 1</option>
            <option value="2">Coach 2</option>
            <option value="3">Coach 3</option>
        </select>
    </div>

    <div class="form-group" id="course_id_group" style="display: none;">
        <label for="course_id">Course:</label>
        <select name="course_id" id="course_id" required>
            <option value="all" selected>All Course</option>
            <!-- Temporary static options for testing -->
            <option value="1">Swimming Basics</option>
            <option value="2">Advanced Swimming</option>
            <option value="3">Water Safety</option>
        </select>
    </div>

    <div class="form-group" id="general_feedback_type_group" style="display: none;">
        <label for="general_feedback_type">General Feedback Type:</label>
        <select name="general_feedback_type" id="general_feedback_type">
            <option value="all" selected>All</option>
            <option value="Food">Food</option>
            <option value="Service">Service</option>
            <option value="Facility">Facility</option>
            <option value="Other">Other</option>
        </select>
    </div>

    <div class="form-group" id="sort_by_group">
        <label for="sort_by">Sort By:</label>
        <select name="sort_by" id="sort_by">
            <option value="none" selected>None</option>
            <option value="created_at">Created Date</option>
            <option value="updated_at">Update Date</option>
            <option value="rating">Feedback Rating</option>
        </select>
    </div>

    <div class="form-group" id="sort_order_group">
        <label for="sort_order">Sort Order:</label>
        <select name="sort_order" id="sort_order">
            <option value="ASC" selected>Ascending</option>
            <option value="DESC">Descending</option>
        </select>
    </div>

    <input type="submit" value="Filter & Sort" class="btn btn-primary">
</form>

<!-- Feedback History Section -->
<div class="feedback-controls">
    <button id="deleteSelectedBtn" class="btn btn-danger" disabled>Delete Selected</button>
</div>

<div class="feedback-list">
    <form id="deleteForm" action="feedback?action=delete_multiple" method="post">
        <table class="feedback-table">
            <thead>
            <tr>
                <th><input type="checkbox" id="selectAll"></th>
                <th>Type</th>
                <th>Rating</th>
                <th>Content</th>
                <th>Date</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <%@ page import="model.Feedback" %>
            <%@ page import="java.util.List" %>
            <%
                List<Feedback> feedbackList = (List<Feedback>) request.getAttribute("feedback_list");
                if (feedbackList != null && !feedbackList.isEmpty()) {
                    for (Feedback feedback : feedbackList) {
            %>
            <tr>
                <td><input type="checkbox" name="selectedIds" value="<%= feedback.getId() %>" class="feedback-checkbox"></td>
                <td><%= feedback.getFeedbackType() %></td>
                <td>
                    <div class="star-display">
                        <%
                            int fullStars = feedback.getRating() / 2;
                            boolean hasHalfStar = feedback.getRating() % 2 == 1;

                            for (int i = 0; i < fullStars; i++) { %>
                        <i class="fa fa-star"></i>
                        <% }

                            if (hasHalfStar) { %>
                        <i class="fa fa-star-half-o"></i>
                        <% }

                            for (int i = 0; i < (5 - fullStars - (hasHalfStar ? 1 : 0)); i++) { %>
                        <i class="fa fa-star-o"></i>
                        <% } %>
                    </div>
                </td>
                <td><%= feedback.getContent().length() > 50 ? feedback.getContent().substring(0, 47) + "..." : feedback.getContent() %></td>
                <td><%= feedback.getCreatedAt() %></td>
                <td>
                    <a href="feedback?action=pre_edit&postId=<%= feedback.getId() %>" class="btn-icon"><i class="fa fa-edit"></i></a>
                    <a href="javascript:void(0)" onclick="confirmDelete(<%= feedback.getId() %>)" class="btn-icon"><i class="fa fa-trash"></i></a>
                </td>
            </tr>
            <%
                }
            } else {
            %>
            <tr>
                <td colspan="6" class="no-feedback">No feedback records found</td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </form>
</div>

<script rel="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script rel="text/javascript" src="./Resources/JavaScript/FeedbackHistory.js"></script>

</body>
</html>

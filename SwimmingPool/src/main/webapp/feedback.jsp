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
    <title>Swimming Pool Feedback Form</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="./Resources/CSS/FeedbackForm.css">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>

<%
  Feedback feedback = (Feedback) request.getAttribute("feedback");
  boolean existing = feedback != null;
%>

<h1><i class="fa fa-comments-o" aria-hidden="true"></i> <%=existing ? "Edit" : "Submit" %> Feedback</h1>

<form action="feedback/<%= existing ? "edit" : "create" %>" method="post">
    <%
      if (existing) {
    %>
      <input type="hidden" name="postId" value="<%= feedback.getId() %>"/>
    <%
      }
    %>

    <div class="form-group">
        <label for="feedback_type">Feedback Type:</label>
        <select name="feedback_type" id="feedback_type" required onchange="showHideFields()">
            <option value="" disabled <%= !existing ? "selected" : "" %>>Select feedback type</option>
            <option value="Coach" <%= existing && "Coach".equals(feedback.getFeedbackType()) ? "selected" : "" %>>Coach</option>
            <option value="Course" <%= existing && "Course".equals(feedback.getFeedbackType()) ? "selected" : "" %>>Course</option>
            <option value="General" <%= existing && "General".equals(feedback.getFeedbackType()) ? "selected" : "" %>>General</option>
        </select>
    </div>

    <div class="form-group" id="coach_id_group" style="display: none;">
        <label for="coach_id">Coach:</label>
        <select name="coach_id" id="coach_id" required>
            <option value="" disabled <%= !existing || feedback.getCoachId() == 0 ? "selected" : "" %>>Select coach</option>
            <!-- Temporary static options for testing -->
            <option value="1">Coach 1</option>
            <option value="2">Coach 2</option>
            <option value="3">Coach 3</option>
        </select>
    </div>

    <div class="form-group" id="course_id_group" style="display: none;">
        <label for="course_id">Course:</label>
        <select name="course_id" id="course_id" required>
            <option value="" disabled <%= !existing || feedback.getCourseId() == 0 ? "selected" : "" %>>Select course</option>
            <!-- Temporary static options for testing -->
            <option value="1">Swimming Basics</option>
            <option value="2">Advanced Swimming</option>
            <option value="3">Water Safety</option>
        </select>
    </div>

    <div class="form-group" id="general_feedback_type_group" style="display: none;">
        <label for="general_feedback_type">General Feedback Type:</label>
        <select name="general_feedback_type" id="general_feedback_type">
            <option value="" disabled <%= !existing || feedback.getGeneralFeedbackType() == null ? "selected" : "" %>>Select general feedback type</option>
            <option value="Food" <%= existing && "Food".equals(feedback.getGeneralFeedbackType()) ? "selected" : "" %>>Food</option>
            <option value="Service" <%= existing && "Service".equals(feedback.getGeneralFeedbackType()) ? "selected" : "" %>>Service</option>
            <option value="Facility" <%= existing && "Facility".equals(feedback.getGeneralFeedbackType()) ? "selected" : "" %>>Facility</option>
            <option value="Other" <%= existing && "Other".equals(feedback.getGeneralFeedbackType()) ? "selected" : "" %>>Other</option>
        </select>
    </div>

    <div class="form-group">
        <label for="content">Content:</label>
        <textarea name="content" id="content" rows="5" required><%= existing ? feedback.getContent() : "" %></textarea>
    </div>

    <div class="form-group">
        <label for="rating">Rating:</label>
        <div class="star-rating">
            <div class="stars">
                <!-- 5 stars = 10 points total, each star = 2 points, half star = 1 point -->
                <i class="star fa fa-star-o" data-value="2"></i>
                <i class="star fa fa-star-o" data-value="4"></i>
                <i class="star fa fa-star-o" data-value="6"></i>
                <i class="star fa fa-star-o" data-value="8"></i>
                <i class="star fa fa-star-o" data-value="10"></i>
            </div>
            <div class="rating-text">0 stars</div>
            <input type="hidden" name="rating" id="rating" value="<%= existing ? feedback.getRating() : 0 %>" required>
        </div>
    </div>

    <div class="form-group">
        <button type="submit" class="btn btn-primary">Submit Feedback</button>
    </div>
</form>

<script rel="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script rel="text/javascript" src="./Resources/JavaScript/FeedbackForm.js"></script>
</body>
</html>

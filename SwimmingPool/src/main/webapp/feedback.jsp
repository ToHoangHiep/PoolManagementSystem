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

<!-- Style block for better readability and appearance -->
<style>
/* Enhanced feedback form styles */
body {
    font-family: 'Poppins', Arial, sans-serif;
    background: #f4f8fb;
    margin: 0;
    padding: 0;
}
h1 {
    text-align: center;
    color: #0077b6;
    margin-top: 30px;
    font-weight: 600;
}
form {
    background: #fff;
    max-width: 500px;
    margin: 30px auto;
    padding: 30px 40px 20px 40px;
    border-radius: 12px;
    box-shadow: 0 4px 24px rgba(0,0,0,0.08);
}
.form-group {
    margin-bottom: 22px;
}
label {
    display: block;
    margin-bottom: 7px;
    color: #333;
    font-weight: 500;
}
input[type="text"], select, textarea {
    width: 100%;
    padding: 10px 12px;
    border: 1px solid #cfd8dc;
    border-radius: 6px;
    font-size: 1em;
    background: #f9fafb;
    transition: border 0.2s;
}
input[type="text"]:focus, select:focus, textarea:focus {
    border-color: #0077b6;
    outline: none;
}
textarea {
    resize: vertical;
}
.star-rating {
    display: flex;
    align-items: center;
    gap: 12px;
}
.stars {
    display: flex;
    gap: 3px;
}
.star {
    font-size: 1.7em;
    color: #b0bec5;
    cursor: pointer;
    transition: color 0.2s;
}
.star.selected, .star:hover, .star.selected ~ .star {
    color: #ffd700;
}
.rating-text {
    font-size: 1em;
    color: #555;
    margin-left: 10px;
}
.btn {
    padding: 10px 22px;
    border: none;
    border-radius: 6px;
    font-size: 1em;
    cursor: pointer;
    font-weight: 500;
    transition: background 0.2s;
}
.btn-primary {
    background: #0077b6;
    color: #fff;
}
.btn-primary:hover {
    background: #005f8a;
}
.btn-secondary {
    background: #b0bec5;
    color: #333;
}
.btn-secondary:hover {
    background: #90a4ae;
}
@media (max-width: 600px) {
    form {
        padding: 18px 8px 12px 8px;
    }
}
</style>

<%
  Feedback feedback = (Feedback) request.getAttribute("feedback");
  boolean existing = feedback != null;
%>

<h1><i class="fa fa-comments-o" aria-hidden="true"></i> <%=existing ? "Edit" : "Submit" %> Feedback</h1>

<form action="feedback?action=<%= existing ? "edit" : "create" %>" method="post">
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
            <option value="Coach" disabled title="Coach feedback is currently unavailable">Coach (Unavailable)</option>
            <option value="Course" disabled title="Course feedback is currently unavailable">Course (Unavailable)</option>
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

    <div class="form-group" style="display: flex; justify-content: space-between;">
        <button type="submit" class="btn btn-primary">Submit Feedback</button>
        <button type="button" class="btn btn-secondary" onclick="window.location.href='home.jsp'">Cancel</button>
    </div>
</form>

<!-- Move scripts to just before closing body tag for better readability -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="./Resources/JavaScript/FeedbackForm.js"></script>
</body>
</html>

<%@ page import="model.User" %>
<%@ page import="model.Feedback" %>
<%@ page import="model.Course" %>
<%@ page import="model.Coach" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    Feedback feedback = (Feedback) request.getAttribute("feedback");
    boolean existing = feedback != null;

    // --- Data for Dropdowns (from Servlet) ---
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    List<Coach> coaches = (List<Coach>) request.getAttribute("coaches");
%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback Form</title>
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .card {
            border: 1px solid #dee2e6;
        }
        /* Custom styles for the colored slider track */
        .form-range {
            --track-color: #0d6efd; /* Default Bootstrap primary blue */
        }
        .form-range::-webkit-slider-runnable-track {
            background-color: var(--track-color);
        }
        .form-range::-moz-range-track {
            background-color: var(--track-color);
        }
    </style>
</head>
<body>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h1 class="h3 mb-0"><%= existing ? "Edit Your Feedback" : "Share Your Experience" %></h1>
                </div>
                <div class="card-body">
                    <%-- Display any alert messages passed from the servlet --%>
                    <% if (request.getAttribute("alert_message") != null) { %>
                    <script>
                        alert('<%= request.getAttribute("alert_message") %>');
                    </script>
                    <% } %>

                    <form action="feedback?action=<%= existing ? "edit" : "create" %>" method="post">
                        <% if (existing) { %>
                        <input type="hidden" name="postId" value="<%= feedback.getId() %>"/>
                        <% } %>

                        <!-- Feedback Category -->
                        <div class="mb-3">
                            <label for="feedback_type" class="form-label">Feedback Category</label>
                            <select name="feedback_type" id="feedback_type" class="form-select" required onchange="showHideFields()">
                                <option value="" disabled <%= !existing ? "selected" : "" %>>Select a category...</option>
                                <option value="General" <%= existing && "General".equals(feedback.getFeedbackType()) ? "selected" : "" %>>
                                    General Feedback
                                </option>
                                <%-- UPDATED: Enabled Course and Coach options --%>
                                <option value="Course" <%= existing && "Course".equals(feedback.getFeedbackType()) ? "selected" : "" %>>
                                    Course Feedback
                                </option>
                                <option value="Coach" <%= existing && "Coach".equals(feedback.getFeedbackType()) ? "selected" : "" %>>
                                    Coach Feedback
                                </option>
                            </select>
                        </div>

                        <!-- Specific Category (for General feedback) -->
                        <div class="mb-3 d-none" id="general_feedback_type_group">
                            <label for="general_feedback_type" class="form-label">Specific Category</label>
                            <select name="general_feedback_type" id="general_feedback_type" class="form-select">
                                <option value="" disabled <%= !existing || feedback.getGeneralFeedbackType() == null ? "selected" : "" %>>Select specific category...</option>
                                <option value="Food" <%= existing && "Food".equals(feedback.getGeneralFeedbackType()) ? "selected" : "" %>>Food & Dining</option>
                                <option value="Service" <%= existing && "Service".equals(feedback.getGeneralFeedbackType()) ? "selected" : "" %>>Customer Service</option>
                                <option value="Facility" <%= existing && "Facility".equals(feedback.getGeneralFeedbackType()) ? "selected" : "" %>>Facilities & Amenities</option>
                                <option value="Other" <%= existing && "Other".equals(feedback.getGeneralFeedbackType()) ? "selected" : "" %>>Other</option>
                            </select>
                        </div>

                        <%-- NEW: Dropdown for Course Feedback --%>
                        <div class="mb-3 d-none" id="course_feedback_group">
                            <label for="course_id" class="form-label">Select Course</label>
                            <select name="course_id" id="course_id" class="form-select">
                                <option value="" disabled selected>-- Choose a course --</option>
                                <% if (courses != null) {
                                    for (Course c : courses) { %>
                                <option value="<%= c.getId() %>" <%= existing && feedback.getCourseId() != null && feedback.getCourseId() == c.getId() ? "selected" : "" %>><%= c.getName() %></option>
                                <%  }
                                } %>
                            </select>
                        </div>

                        <%-- NEW: Dropdown for Coach Feedback --%>
                        <div class="mb-3 d-none" id="coach_feedback_group">
                            <label for="coach_id" class="form-label">Select Coach</label>
                            <select name="coach_id" id="coach_id" class="form-select">
                                <option value="" disabled selected>-- Choose a coach --</option>
                                <% if (coaches != null) {
                                    for (Coach c : coaches) { %>
                                <option value="<%= c.getId() %>" <%= existing && feedback.getCoachId() != null && feedback.getCoachId() == c.getId() ? "selected" : "" %>><%= c.getFullName() %></option>
                                <%  }
                                } %>
                            </select>
                        </div>

                        <!-- Feedback Content -->
                        <div class="mb-3">
                            <label for="content" class="form-label">Your Detailed Feedback</label>
                            <textarea name="content" id="content" rows="5" class="form-control" required placeholder="Please share your thoughts..."><%= existing ? feedback.getContent() : "" %></textarea>
                        </div>

                        <!-- Rating Slider -->
                        <div class="mb-4">
                            <label for="rating" class="form-label">
                                Overall Rating: <span id="ratingValueDisplay" class="fw-bold"><%= existing ? feedback.getRating() : 5 %></span>/10
                            </label>
                            <input type="range" class="form-range" id="rating" name="rating" min="0" max="10" step="1" value="<%= existing ? feedback.getRating() : 5 %>">
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex justify-content-end gap-2">
                            <a href="home.jsp" class="btn btn-secondary">Cancel</a>
                            <button type="submit" class="btn btn-primary">
                                <%= existing ? "Update Feedback" : "Submit Feedback" %>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="Resources/bootstrap/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Get all the elements we need to interact with
        const feedbackTypeSelect = document.getElementById('feedback_type');
        const generalGroup = document.getElementById('general_feedback_type_group');
        const generalSelect = document.getElementById('general_feedback_type');
        const courseGroup = document.getElementById('course_feedback_group');
        const courseSelect = document.getElementById('course_id');
        const coachGroup = document.getElementById('coach_feedback_group');
        const coachSelect = document.getElementById('coach_id');
        const ratingSlider = document.getElementById('rating');
        const ratingValueDisplay = document.getElementById('ratingValueDisplay');

        // Function to show/hide the specific category dropdowns
        window.showHideFields = function() {
            const selectedType = feedbackTypeSelect.value;

            // Hide all groups first and remove their 'required' attribute
            generalGroup.classList.add('d-none');
            generalSelect.required = false;
            courseGroup.classList.add('d-none');
            courseSelect.required = false;
            coachGroup.classList.add('d-none');
            coachSelect.required = false;

            // Show the relevant group based on selection and make it required
            if (selectedType === 'General') {
                generalGroup.classList.remove('d-none');
                generalSelect.required = true;
            } else if (selectedType === 'Course') {
                courseGroup.classList.remove('d-none');
                courseSelect.required = true;
            } else if (selectedType === 'Coach') {
                coachGroup.classList.remove('d-none');
                coachSelect.required = true;
            }
        };

        // Function to update the slider's value display and track color
        function updateRating() {
            const value = ratingSlider.value;
            ratingValueDisplay.textContent = value; // Update the number display

            let color;
            if (value <= 3) {
                color = '#dc3545'; // Bootstrap Danger Red
            } else if (value <= 7) {
                color = '#ffc107'; // Bootstrap Warning Yellow
            } else {
                color = '#198754'; // Bootstrap Success Green
            }
            // Set the CSS variable which the stylesheet uses
            ratingSlider.style.setProperty('--track-color', color);
        }

        // Add event listener for the slider
        ratingSlider.addEventListener('input', updateRating);

        // Initial setup on page load to ensure correct fields are shown
        showHideFields();
        updateRating();
    });
</script>

</body>
</html>
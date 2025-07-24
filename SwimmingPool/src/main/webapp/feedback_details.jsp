<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Feedback" %>
<%@ page import="model.Course" %>
<%@ page import="model.Coach" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // --- Data Retrieval from Servlet ---
    Feedback feedback = (Feedback) request.getAttribute("feedback");
    if (feedback == null) {
        session.setAttribute("alert_message", "The requested feedback could not be found.");
        response.sendRedirect("feedback?action=list");
        return;
    }

    // Get related objects passed from the servlet
    Course relatedCourse = (Course) request.getAttribute("relatedCourse");
    Coach relatedCoach = (Coach) request.getAttribute("relatedCoach");

    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM, yyyy 'at' HH:mm");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback Details</title>
    <!-- Bootstrap CSS -->
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .details-label { font-weight: bold; color: #6c757d; }
        .rating-display { font-size: 1.5rem; font-weight: bold; }
        .rating-bar {
            height: 10px;
            border-radius: 5px;
            background-color: #e9ecef;
        }
        .rating-bar-inner {
            height: 100%;
            border-radius: 5px;
            transition: width 0.5s ease-in-out;
        }
    </style>
</head>
<body>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-9">
            <div class="card shadow-sm">
                <div class="card-header bg-white py-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <h3 class="mb-0">
                            <i class="fas fa-comment-dots me-2 text-primary"></i>Feedback Details
                        </h3>
                        <a href="feedback?action=list" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-1"></i>Back to Feedback List
                        </a>
                    </div>
                </div>

                <div class="card-body p-4">
                    <!-- User and Date Info -->
                    <div class="d-flex flex-wrap justify-content-between text-muted mb-4 pb-3 border-bottom">
                        <div>
                            <span class="details-label">Submitted by:</span>
                            <%= feedback.getUserName() %> (<a href="mailto:<%= feedback.getUserEmail() %>"><%= feedback.getUserEmail() %></a>)
                        </div>
                        <div>
                            <span class="details-label">Date:</span>
                            <%= sdf.format(feedback.getCreatedAt()) %>
                        </div>
                    </div>

                    <div class="row">
                        <!-- Feedback Target -->
                        <div class="col-md-7 mb-4">
                            <h5 class="mb-3">Feedback Target</h5>
                            <%-- This block dynamically shows the feedback target --%>
                            <% if ("Course".equals(feedback.getFeedbackType()) && relatedCourse != null) { %>
                            <p class="mb-1"><strong class="details-label">Type:</strong> Course</p>
                            <p><strong class="details-label">Name:</strong> <%= relatedCourse.getName() %></p>
                            <% } else if ("Coach".equals(feedback.getFeedbackType()) && relatedCoach != null) { %>
                            <p class="mb-1"><strong class="details-label">Type:</strong> Coach</p>
                            <p><strong class="details-label">Name:</strong> <%= relatedCoach.getFullName() %></p>
                            <% } else { %>
                            <p class="mb-1"><strong class="details-label">Type:</strong> General</p>
                            <p><strong class="details-label">Category:</strong> <%= feedback.getGeneralFeedbackType() %></p>
                            <% } %>
                        </div>

                        <!-- Rating -->
                        <div class="col-md-5 mb-4">
                            <h5 class="mb-3">Overall Rating</h5>
                            <div class="d-flex align-items-center">
                                <span class="rating-display me-3"><%= feedback.getRating() %> / 10</span>
                                <div class="flex-grow-1">
                                    <div class="rating-bar">
                                        <div id="ratingBarInner" class="rating-bar-inner"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <hr class="my-3">

                    <!-- Content -->
                    <div>
                        <h5 class="mb-3">Feedback Content</h5>
                        <p class="text-secondary" style="white-space: pre-wrap;"><%= feedback.getContent() %></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="Resources/bootstrap/js/bootstrap.bundle.min.js"></script>
<script>
    // This script dynamically colors the rating bar based on the score
    document.addEventListener('DOMContentLoaded', function() {
        const rating = <%= feedback.getRating() %>;
        const ratingBarInner = document.getElementById('ratingBarInner');
        const percentage = rating * 10; // Convert rating to percentage

        let color;
        if (rating <= 3) {
            color = 'var(--bs-danger)';
        } else if (rating <= 7) {
            color = 'var(--bs-warning)';
        } else {
            color = 'var(--bs-success)';
        }

        ratingBarInner.style.width = percentage + '%';
        ratingBarInner.style.backgroundColor = color;
    });
</script>
</body>
</html>
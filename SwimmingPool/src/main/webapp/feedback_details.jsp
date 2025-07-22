<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Feedback" %>

<%
    // --- Security & Data Retrieval ---
    User user = (User) session.getAttribute("user");
    if (user == null) {
        // Redirect unauthenticated users to the login page.
        response.sendRedirect("login.jsp");
        return;
    }

    Feedback feedback = (Feedback) request.getAttribute("feedback");
    if (feedback == null) {
        // If feedback is not found, set an alert and redirect to the history page.
        // This is a more robust way to handle missing data.
        session.setAttribute("alert_message", "The requested feedback could not be found.");
        response.sendRedirect("feedback?action=list");
        return;
    }
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
        body {
            background-color: #f8f9fa;
        }
        .rating-stars .fa-star {
            color: #ffc107; /* Bootstrap Warning Yellow */
        }
        .feedback-content {
            white-space: pre-wrap; /* Preserves whitespace and line breaks from user input */
            background-color: #f8f9fa;
            font-family: 'Courier New', Courier, monospace;
        }
        .avatar-circle {
            width: 48px;
            height: 48px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            font-size: 1.25rem;
        }
    </style>
</head>

<body>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-9">
            <div class="card shadow-sm">
                <!-- Card Header -->
                <div class="card-header bg-white py-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <h3 class="mb-0">
                            <i class="fas fa-file-alt me-2 text-primary"></i>Feedback Details
                        </h3>
                        <a href="feedback?action=list" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-1"></i>Back to List
                        </a>
                        <a href="feedback?action=delete&id=<%= feedback.getId() %>" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this feedback?');">
                            <i class="fas fa-trash me-1"></i>Delete
                        </a>
                    </div>
                </div>

                <!-- Card Body with Feedback Info -->
                <div class="card-body p-4">
                    <!-- Feedback Metadata -->
                    <div class="d-flex flex-wrap align-items-center gap-4 mb-4 pb-3 border-bottom">
                        <div>
                            <small class="text-muted">Feedback ID</small>
                            <p class="fw-bold mb-0">#<%= feedback.getId() %></p>
                        </div>
                        <div>
                            <small class="text-muted">Category</small>
                            <p class="mb-0">
                                <span class="badge fs-6 bg-<%= feedback.getFeedbackType().toLowerCase().equals("general") ? "success" :
                                                           feedback.getFeedbackType().toLowerCase().equals("coach") ? "info" : "warning" %>">
                                    <%= feedback.getFeedbackType() %>
                                </span>
                            </p>
                        </div>
                        <div>
                            <small class="text-muted">Submitted On</small>
                            <p class="fw-bold mb-0"><%= feedback.getCreatedAt() %></p>
                        </div>
                    </div>

                    <!-- User Information -->
                    <div class="d-flex align-items-center mb-4">
                        <div class="avatar-circle bg-primary text-white me-3">
                            <i class="fas fa-user"></i>
                        </div>
                        <div>
                            <h5 class="mb-0"><%= feedback.getUserName() %></h5>
                            <a href="mailto:<%= feedback.getUserEmail() %>" class="text-muted text-decoration-none">
                                <%= feedback.getUserEmail() %>
                            </a>
                        </div>
                    </div>

                    <!-- Rating -->
                    <div class="mb-4">
                        <h6 class="text-muted">Rating</h6>
                        <div class="d-flex align-items-center">
                            <div class="rating-stars fs-5 me-2">
                                <%
                                    int rating = feedback.getRating();
                                    // Loop 10 times to represent the 1-10 scale
                                    for (int i = 1; i <= 10; i++) {
                                        // Show a solid star if 'i' is less than or equal to the rating
                                        if (i <= rating) {
                                %>
                                <i class="fas fa-star"></i>
                                <%
                                } else {
                                    // Otherwise, show an empty star
                                %>
                                <i class="far fa-star"></i>
                                <%
                                        }
                                    }
                                %>
                            </div>
                            <span class="fw-bold fs-5">(<%= rating %>/10)</span>
                        </div>
                    </div>

                    <!-- Content -->
                    <div>
                        <h6 class="text-muted">Feedback Content</h6>
                        <div class="feedback-content p-3 border rounded">
                            <%= feedback.getContent() %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="Resources/bootstrap/js/bootstrap.bundle.min.js"></script>

</body>
</html>
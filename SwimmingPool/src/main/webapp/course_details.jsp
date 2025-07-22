<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Course" %>
<%@ page import="java.util.Arrays" %>

<%
    // --- Data Retrieval & Authorization ---
    // User can be null, allowing guests to view the page.
    User user = (User) session.getAttribute("user");

    Course course = (Course) request.getAttribute("course");
    if (course == null) {
        // If the course object is missing, redirect to the list with an alert.
        session.setAttribute("alert_message", "The requested course could not be found.");
        response.sendRedirect("course"); // Redirect to the main course list
        return;
    }

    // --- Authorization Check for Admin Actions ---
    // Admin buttons will only show if the user is logged in and has an admin role.
    boolean isAdmin = false;
    if (user != null) {
        // Based on your other servlets, role 3 (Coach) and 4 (Customer) are non-admins.
        isAdmin = !Arrays.asList(3, 4).contains(user.getRole().getId());
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Details: <%= course.getName() %></title>
    <!-- Bootstrap CSS -->
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .details-card {
            border: none;
            border-radius: 0.75rem;
        }
        .details-header {
            background-color: #0056b3;
            color: white;
            padding: 2rem;
            border-top-left-radius: 0.75rem;
            border-top-right-radius: 0.75rem;
        }
        .details-header h1 {
            font-weight: 300;
        }
        .details-label {
            font-weight: bold;
            color: #6c757d;
        }
        .details-value {
            font-size: 1.1rem;
        }
        .description-text {
            white-space: pre-wrap; /* Preserves line breaks from the description */
            font-size: 1.05rem;
            line-height: 1.7;
        }
    </style>
</head>
<body>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="card shadow-lg details-card">
                <!-- Card Header with Title and Back Button -->
                <div class="details-header text-center">
                    <a href="course" class="btn btn-light position-absolute top-0 start-0 m-3">
                        <i class="fas fa-arrow-left me-1"></i> Back to List
                    </a>
                    <h1 class="display-5 mb-1"><%= course.getName() %></h1>
                    <p class="lead mb-0">Explore the details of this course offering.</p>
                </div>

                <!-- Card Body with Course Info -->
                <div class="card-body p-4 p-md-5">
                    <!-- Course Description -->
                    <div class="mb-5">
                        <h4 class="mb-3">Course Description</h4>
                        <p class="description-text text-secondary"><%= course.getDescription() %></p>
                    </div>

                    <hr class="my-4">

                    <!-- Key Details Section -->
                    <div class="row g-4">
                        <div class="col-md-6 col-lg-4">
                            <div class="details-label"><i class="fas fa-dollar-sign fa-fw me-2"></i>Price</div>
                            <div class="details-value">$<%= String.format("%.2f", course.getPrice()) %></div>
                        </div>
                        <div class="col-md-6 col-lg-4">
                            <div class="details-label"><i class="fas fa-calendar-alt fa-fw me-2"></i>Duration</div>
                            <div class="details-value"><%= course.getDuration() %> sessions</div>
                        </div>
                        <div class="col-md-6 col-lg-4">
                            <div class="details-label"><i class="fas fa-clock fa-fw me-2"></i>Session Time</div>
                            <div class="details-value"><%= course.getEstimated_session_time() %></div>
                        </div>
                        <div class="col-md-6 col-lg-8">
                            <div class="details-label"><i class="fas fa-calendar-check fa-fw me-2"></i>Schedule</div>
                            <div class="details-value"><%= course.getSchedule_description() %></div>
                        </div>
                        <div class="col-md-6 col-lg-4">
                            <div class="details-label"><i class="fas fa-info-circle fa-fw me-2"></i>Status</div>
                            <div class="details-value">
                                <span class="badge fs-6 <%= "Active".equals(course.getStatus()) ? "bg-success" : "bg-secondary" %>">
                                    <%= course.getStatus() %>
                                </span>
                            </div>
                        </div>
                    </div>

                    <hr class="my-4">

                    <!-- Action Buttons -->
                    <div class="d-flex flex-wrap justify-content-center justify-content-md-end align-items-center gap-2">
                        <%-- The Register button is only shown if the course is Active --%>
                        <% if ("Active".equals(course.getStatus())) { %>
                        <a href="course?action=create_form&courseId=<%= course.getId() %>" class="btn btn-primary btn-lg">
                            <i class="fas fa-user-plus me-2"></i>Register for this Course
                        </a>
                        <% } else { %>
                        <button class="btn btn-secondary btn-lg" disabled>
                            <i class="fas fa-times-circle me-2"></i>Currently Unavailable
                        </button>
                        <% } %>

                        <!-- Admin-only Buttons -->
                        <% if (isAdmin) { %>
                        <div class="btn-group ms-md-3">
                            <a href="course?action=edit&courseId=<%= course.getId() %>" class="btn btn-outline-secondary">
                                <i class="fas fa-edit me-1"></i> Edit
                            </a>
                            <a href="course?action=delete&courseId=<%= course.getId() %>" class="btn btn-outline-danger">
                                <i class="fas fa-trash me-1"></i> Delete
                            </a>
                        </div>
                        <% } %>
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
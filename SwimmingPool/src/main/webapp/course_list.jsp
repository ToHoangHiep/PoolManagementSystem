<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Course" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Arrays" %>

<%
    // --- User & Role Check ---
    // User can be null, allowing guests to view the page.
    User user = (User) session.getAttribute("user");

    // Check if the user is an admin to show management buttons.
    boolean isAdmin = false;
    if (user != null) {
        // Assuming roles other than 3 (Coach) and 4 (Customer) are admins.
        isAdmin = !Arrays.asList(3, 4).contains(user.getRole().getId());
    }

    // --- Data Retrieval ---
    List<Course> courses = (List<Course>) request.getAttribute("courses");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Available Courses</title>
    <!-- Bootstrap CSS -->
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f0f2f5; /* A lighter gray for a softer look */
        }
        .course-card {
            transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
            border: none;
        }
        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15) !important;
        }
        .card-title {
            color: #0056b3;
        }
        .card-footer {
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>

<%-- Session-based alert message handler (for redirects from other pages) --%>
<%
    String alertMessage = (String) session.getAttribute("alert_message");
    if (alertMessage != null) {
        session.removeAttribute("alert_message"); // Clear after reading
%>
<script>
    alert('<%= alertMessage.replace("'", "\\'") %>');
</script>
<%
    }
%>

<div class="container my-5">
    <!-- Page Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h2">Our Swimming Courses</h1>
        <%-- Admin-only buttons --%>
        <% if (isAdmin) { %>
        <div class="d-flex gap-2">
            <a href="course?action=list_form" class="btn btn-outline-primary">
                <i class="fas fa-tasks me-2"></i>Manage Registrations
            </a>
            <a href="course?action=create" class="btn btn-primary">
                <i class="fas fa-plus-circle me-2"></i>Create New Course
            </a>
        </div>
        <% } %>
    </div>

    <% if (courses == null || courses.isEmpty()) { %>
    <div class="alert alert-info text-center">
        There are currently no courses available. Please check back later!
    </div>
    <% } else { %>
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
        <% for (Course course : courses) { %>
        <div class="col">
            <div class="card h-100 shadow-sm course-card">
                <div class="card-body d-flex flex-column">
                    <div class="mb-2">
                        <span class="badge <%= "Active".equals(course.getStatus()) ? "bg-success" : "bg-secondary" %>">
                            <%= course.getStatus() %>
                        </span>
                    </div>
                    <h5 class="card-title"><%= course.getName() %></h5>
                    <p class="card-text text-muted flex-grow-1">
                        <%-- Truncate long descriptions for a cleaner look --%>
                        <%= course.getDescription().length() > 100 ? course.getDescription().substring(0, 100) + "..." : course.getDescription() %>
                    </p>
                    <ul class="list-unstyled text-secondary mb-4">
                        <li><i class="fas fa-dollar-sign fa-fw me-2"></i><strong>Price:</strong> $<%= String.format("%.2f", course.getPrice()) %></li>
                        <li><i class="fas fa-calendar-alt fa-fw me-2"></i><strong>Duration:</strong> <%= course.getDuration() %> sessions</li>
                    </ul>
                </div>
                <div class="card-footer d-grid gap-2 d-md-flex justify-content-end">
                    <a href="course?action=view&courseId=<%= course.getId() %>" class="btn btn-outline-secondary btn-sm">
                        <i class="fas fa-info-circle me-1"></i>Details
                    </a>
                    <%-- The Register button is only active if the course is available --%>
                    <% if ("Active".equals(course.getStatus())) { %>
                    <a href="course?action=create_form&courseId=<%= course.getId() %>" class="btn btn-primary btn-sm">
                        <i class="fas fa-user-plus me-1"></i>Register Now
                    </a>
                    <% } else { %>
                    <button class="btn btn-secondary btn-sm" disabled>
                        <i class="fas fa-times-circle me-1"></i>Unavailable
                    </button>
                    <% } %>
                </div>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>
</div>

<!-- Bootstrap JS -->
<script src="Resources/bootstrap/js/bootstrap.bundle.min.js"></script>

</body>
</html>
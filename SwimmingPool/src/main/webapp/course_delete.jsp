<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Course" %>
<%
    // --- Security & Data Retrieval ---
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    // Safeguard: Ensure only authorized users can access this.
    if (user.getRole().getId() == 4) { // Assuming role 4 is a standard customer
        session.setAttribute("alert_message", "You do not have permission to access this page.");
        response.sendRedirect("course");
        return;
    }

    Course course = (Course) request.getAttribute("course");
    if (course == null) {
        // If the course object is missing, we can't display the page.
        // Redirect to the list with a session-based alert.
        session.setAttribute("alert_message", "The requested course could not be found for deletion.");
        response.sendRedirect("course"); // Redirect to the main course list
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirm Delete Course</title>
    <!-- Bootstrap CSS -->
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .details-label {
            font-weight: bold;
            color: #6c757d; /* Bootstrap secondary color */
        }
        .details-value {
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>

<%-- This block handles pop-up alert messages and actions sent from the servlet --%>
<%
    String alertMessage = (String) request.getAttribute("alert_message");
    if (alertMessage != null) {
        String alertAction = (String) request.getAttribute("alert_action");
%>
<script>
    (function() {
        alert('<%= alertMessage.replace("'", "\\'") %>');
        <% if (alertAction != null && !alertAction.isEmpty()) { %>
        window.location.href = '<%= request.getContextPath() %>/<%= alertAction %>';
        <% } %>
    })();
</script>
<%
    }
%>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow-sm border-danger">
                <div class="card-header bg-danger text-white">
                    <h2 class="mb-0 h4">
                        <i class="fas fa-exclamation-triangle me-2"></i>Confirm Course Deletion
                    </h2>
                </div>

                <div class="card-body p-4">
                    <p class="lead">Are you sure you want to permanently delete the following course?</p>
                    <p class="text-muted">This action cannot be undone.</p>

                    <%-- This block handles on-page error messages (e.g., if deletion fails) --%>
                    <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <%= request.getAttribute("error") %>
                    </div>
                    <% } %>

                    <hr>

                    <!-- Course Details -->
                    <h5 class="mb-3">Course Information</h5>
                    <div class="row">
                        <div class="col-md-12">
                            <p class="details-label">Course Name</p>
                            <p class="details-value fs-5"><%= course.getName() %></p>
                        </div>
                        <div class="col-md-12">
                            <p class="details-label">Description</p>
                            <p class="details-value" style="white-space: pre-wrap;"><%= course.getDescription() %></p>
                        </div>
                        <div class="col-md-4">
                            <p class="details-label">Price</p>
                            <p class="details-value">$<%= String.format("%.2f", course.getPrice()) %></p>
                        </div>
                        <div class="col-md-4">
                            <p class="details-label">Duration</p>
                            <p class="details-value"><%= course.getDuration() %> sessions</p>
                        </div>
                        <div class="col-md-4">
                            <p class="details-label">Status</p>
                            <p class="details-value">
                                <span class="badge <%= "Active".equals(course.getStatus()) ? "bg-success" : "bg-secondary" %>">
                                    <%= course.getStatus() %>
                                </span>
                            </p>
                        </div>
                    </div>

                    <hr>

                    <!-- Action Form -->
                    <form action="course?action=delete" method="post">
                        <input type="hidden" name="courseId" value="<%= course.getId() %>">

                        <div class="d-flex justify-content-end gap-2 mt-3">
                            <a href="course" class="btn btn-secondary">
                                <i class="fas fa-times me-1"></i>Cancel
                            </a>
                            <button type="submit" class="btn btn-danger">
                                <i class="fas fa-trash-alt me-1"></i>Yes, Delete Course
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="Resources/bootstrap/js/bootstrap.bundle.min.js"></script>

</body>
</html>
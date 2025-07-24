<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%
    // --- Security Check ---
    // Ensures only logged-in, authorized users can see this page.
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    // Example: Role 4 (Customer) cannot create courses.
    // This check should also be in your servlet for stronger security.
    if (user.getRole().getId() == 4) {
        session.setAttribute("alert_message", "You do not have permission to access this page.");
        response.sendRedirect("course");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create New Course</title>
    <!-- Bootstrap CSS -->
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
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
    // Use a self-invoking function to avoid polluting the global scope
    (function() {
        // Display the alert message. We escape single quotes to prevent JS errors.
        alert('<%= alertMessage.replace("'", "\\'") %>');

        // If an action URL is provided, redirect the user after they close the alert.
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
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h2 class="mb-0 h4">
                        <i class="fas fa-plus-circle me-2"></i>Create New Course
                    </h2>
                </div>

                <div class="card-body p-4">
                    <%-- This block handles on-page error messages (e.g., for validation) --%>
                    <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <%= request.getAttribute("error") %>
                    </div>
                    <% } %>

                    <form action="course?action=create" method="post">
                        <!-- Course Name -->
                        <div class="mb-3">
                            <label for="name" class="form-label fw-bold">Course Name</label>
                            <input type="text" class="form-control" id="name" name="name" placeholder="e.g., Beginner's Freestyle" required>
                        </div>

                        <!-- Description -->
                        <div class="mb-3">
                            <label for="description" class="form-label fw-bold">Description</label>
                            <textarea class="form-control" id="description" name="description" rows="4" placeholder="Detailed information about the course content and goals." required></textarea>
                        </div>

                        <div class="row">
                            <!-- Price -->
                            <div class="col-md-6 mb-3">
                                <label for="price" class="form-label fw-bold">Price ($)</label>
                                <input type="number" class="form-control" id="price" name="price" step="0.01" min="0" placeholder="e.g., 150.00" required>
                            </div>
                            <!-- Duration -->
                            <div class="col-md-6 mb-3">
                                <label for="duration" class="form-label fw-bold">Duration (sessions)</label>
                                <input type="number" class="form-control" id="duration" name="duration" min="1" placeholder="e.g., 8" required>
                            </div>
                        </div>

                        <div class="row">
                            <!-- Estimated Session Time -->
                            <div class="col-md-6 mb-3">
                                <label for="estimated_session_time" class="form-label fw-bold">Session Time</label>
                                <input type="text" class="form-control" id="estimated_session_time" name="estimated_session_time" placeholder="e.g., 60 minutes" required>
                            </div>
                            <!-- Status -->
                            <div class="col-md-6 mb-3">
                                <label for="status" class="form-label fw-bold">Status</label>
                                <select class="form-select" id="status" name="status" required>
                                    <option value="Active" selected>Active</option>
                                    <option value="Inactive">Inactive</option>
                                </select>
                            </div>
                        </div>

                        <!-- Schedule Description -->
                        <div class="mb-4">
                            <label for="schedule_description" class="form-label fw-bold">Schedule Description</label>
                            <input type="text" class="form-control" id="schedule_description" name="schedule_description" placeholder="e.g., Mon, Wed, Fri from 5 PM to 6 PM" required>
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex justify-content-end gap-2 border-top pt-3 mt-3">
                            <a href="course" class="btn btn-secondary">
                                <i class="fas fa-times me-1"></i>Cancel
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-1"></i>Save Course
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
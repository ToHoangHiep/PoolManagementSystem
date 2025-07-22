<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Course" %>
<%@ page import="model.Coach" %>
<%@ page import="model.CourseForm" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // --- Security & Data Retrieval ---
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    // Ensure only authorized staff can view this page (e.g., not customers)
    if (adminUser.getRole().getId() == 4) {
        session.setAttribute("alert_message", "You do not have permission to access this page.");
        response.sendRedirect("course");
        return;
    }

    CourseForm form = (CourseForm) request.getAttribute("courseForm");
    Course course = (Course) request.getAttribute("course");
    Coach coach = (Coach) request.getAttribute("coach");

    // If any required data is missing, redirect safely
    if (form == null || course == null || coach == null) {
        session.setAttribute("alert_message", "Could not retrieve complete registration details.");
        response.sendRedirect("course?action=list_form");
        return;
    }

    boolean isGuest = form.getUser_id() <= 0;
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM, yyyy 'at' HH:mm");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration Details</title>
    <!-- Bootstrap CSS -->
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .details-label { font-weight: bold; color: #6c757d; }
        .details-value { margin-bottom: 1rem; }
        .avatar-circle {
            width: 64px; height: 64px;
            display: flex; align-items: center; justify-content: center;
            border-radius: 50%; font-size: 2rem;
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
        <div class="col-lg-9">
            <div class="card shadow-sm">
                <!-- Card Header -->
                <div class="card-header bg-white py-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <h3 class="mb-0">
                            <i class="fas fa-clipboard-list me-2 text-primary"></i>Registration Details
                        </h3>
                        <a href="course?action=list_form" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-1"></i>Back to Form List
                        </a>
                    </div>
                </div>

                <!-- Card Body -->
                <div class="card-body p-4">
                    <%-- This block handles on-page error messages (e.g., if confirmation fails) --%>
                    <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <%= request.getAttribute("error") %>
                    </div>
                    <% } %>

                    <!-- Form Metadata -->
                    <div class="d-flex flex-wrap align-items-center gap-4 mb-4 pb-3 border-bottom">
                        <div>
                            <p class="details-label mb-1">Form ID</p>
                            <p class="details-value fw-bold mb-0">#<%= form.getId() %></p>
                        </div>
                        <div>
                            <p class="details-label mb-1">Request Date</p>
                            <p class="details-value fw-bold mb-0"><%= sdf.format(form.getRequest_date()) %></p>
                        </div>
                        <div>
                            <p class="details-label mb-1">Status</p>
                            <p class="details-value mb-0">
                                <span class="badge fs-6 <%= form.isHas_processed() ? "bg-success" : "bg-warning text-dark" %>">
                                    <%= form.isHas_processed() ? "Confirmed" : "Pending Confirmation" %>
                                </span>
                            </p>
                        </div>
                    </div>

                    <div class="row">
                        <!-- User Information Section -->
                        <div class="col-md-6 mb-4 mb-md-0">
                            <h5 class="mb-3">Applicant Information</h5>
                            <div class="d-flex align-items-center">
                                <div class="avatar-circle <%= isGuest ? "bg-secondary" : "bg-primary" %> text-white me-3">
                                    <i class="fas <%= isGuest ? "fa-user-secret" : "fa-user-check" %>"></i>
                                </div>
                                <div>
                                    <h5 class="mb-0"><%= form.getUser_fullName() %></h5>
                                    <a href="mailto:<%= form.getUser_email() %>" class="text-muted text-decoration-none"><%= form.getUser_email() %></a>
                                    <% if (isGuest) { %>
                                    <p class="mb-0 text-muted"><%= form.getUser_phone() %></p>
                                    <% } %>
                                    <p class="mb-0 mt-1">
                                        <span class="badge <%= isGuest ? "bg-info text-dark" : "bg-success" %>">
                                            <%= isGuest ? "Guest User" : "System User" %>
                                        </span>
                                    </p>
                                </div>
                            </div>
                        </div>

                        <!-- Course & Coach Section -->
                        <div class="col-md-6">
                            <h5 class="mb-3">Registration For</h5>
                            <div class="mb-3">
                                <p class="details-label mb-0">Course</p>
                                <p class="details-value fs-5"><%= course.getName() %></p>
                            </div>
                            <div class="mb-3">
                                <p class="details-label mb-0">Assigned Coach</p>
                                <p class="details-value fs-5"><%= coach.getFullName() %></p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Card Footer with Action Button -->
                <%-- The confirm button only shows if the form has not been processed yet --%>
                <% if (!form.isHas_processed()) { %>
                <div class="card-footer text-end bg-light p-3">
                    <form action="course?action=form_confirmed" method="post" onsubmit="return confirm('Are you sure you want to confirm this registration? This will send emails to the user and the coach.');">
                        <input type="hidden" name="formId" value="<%= form.getId() %>">
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-check-circle me-1"></i>Confirm Registration
                        </button>
                    </form>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="Resources/bootstrap/js/bootstrap.bundle.min.js"></script>

</body>
</html>
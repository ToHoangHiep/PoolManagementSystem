<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.CourseForm" %>
<%@ page import="dal.CourseDAO" %>
<%@ page import="dal.UserDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // --- Security Check ---
    // Ensures only logged-in, authorized users can see this page.
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    // Example: Role 4 (Customer) cannot manage forms.
    if (adminUser.getRole().getId() == 4) {
        session.setAttribute("alert_message", "You do not have permission to access this page.");
        response.sendRedirect("home.jsp");
        return;
    }

    // --- Data Retrieval ---
    List<CourseForm> courseForms = (List<CourseForm>) request.getAttribute("courseForms");
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM, yyyy");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Course Registrations</title>
    <!-- Bootstrap CSS -->
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .table-hover tbody tr:hover {
            background-color: #e9ecef;
        }
    </style>
</head>
<body>

<%-- This is a "flash message" that shows once from the session and then is removed. --%>
<%
    String alertMessage = (String) session.getAttribute("alert_message");
    if (alertMessage != null) {
        session.removeAttribute("alert_message"); // Clear the message after reading it
%>
<script>
    alert('<%= alertMessage.replace("'", "\\'") %>');
</script>
<%
    }
%>

<div class="container my-5">
    <div class="card shadow-sm">
        <div class="card-header bg-white py-3">
            <h2 class="mb-0 h4">
                <i class="fas fa-tasks me-2 text-primary"></i>Manage Course Registrations
            </h2>
        </div>
        <div class="card-body">
            <% if (courseForms == null || courseForms.isEmpty()) { %>
            <div class="alert alert-info text-center">
                There are no registration forms to display at the moment.
            </div>
            <% } else { %>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Applicant Name</th>
                        <th>Applicant Email</th>
                        <th>Course</th>
                        <th>Request Date</th>
                        <th class="text-center">Status</th>
                        <th class="text-end">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (CourseForm form : courseForms) { %>
                    <tr>
                        <td>#<%= form.getId() %></td>
                        <td>
                            <%--
                                This logic fetches the name from the User table if it's a registered user,
                                otherwise it uses the name from the form itself.
                            --%>
                            <% if (form.getUser_id() > 0) { %>
                            <i class="fas fa-user-check text-success me-1" title="System User"></i>
                            <%= UserDAO.getFullNameById(form.getUser_id()) %>
                            <% } else { %>
                            <i class="fas fa-user-secret text-info me-1" title="Guest User"></i>
                            <%= form.getUser_fullName() %>
                            <% } %>
                        </td>
                        <td><%= form.getUser_email() %></td>
                        <td><%= CourseDAO.getCourseById(form.getCourse_id()).getName() %></td>
                        <td><%= sdf.format(form.getRequest_date()) %></td>
                        <td class="text-center">
                            <% if (form.isHas_processed()) { %>
                            <span class="badge bg-success">Confirmed</span>
                            <% } else { %>
                            <span class="badge bg-warning text-dark">Pending</span>
                            <% } %>
                        </td>
                        <td class="text-end">
                            <a href="course-signup?action=view_form&formId=<%= form.getId() %>" class="btn btn-sm btn-outline-primary">
                                <i class="fas fa-eye me-1"></i>View Details
                            </a>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="Resources/bootstrap/js/bootstrap.bundle.min.js"></script>

</body>
</html>
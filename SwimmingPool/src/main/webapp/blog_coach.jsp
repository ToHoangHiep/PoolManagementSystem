<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Coach" %>
<%@ page import="java.util.List" %>

<%
    // --- Data Retrieval from Servlet ---
    Coach coach = (Coach) request.getAttribute("coach");

    // --- Safeguard ---
    if (coach == null) {
        session.setAttribute("alert_message", "The requested coach could not be found.");
        response.sendRedirect("blogs"); // Redirect to the main directory
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Coach Profile: <%= coach.getFullName() %></title>
    <!-- Bootstrap CSS -->
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .profile-card {
            border-radius: 0.75rem;
        }
        .profile-header {
            background: linear-gradient(to right, #0056b3, #007bff);
            color: white;
            padding: 2rem;
            border-top-left-radius: 0.75rem;
            border-top-right-radius: 0.75rem;
        }
        .profile-picture {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            border: 5px solid white;
            object-fit: cover;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        }
        .bio-text {
            white-space: pre-wrap; /* Preserves line breaks from the bio */
            font-size: 1.05rem;
            line-height: 1.7;
        }
        .details-list {
            list-style: none;
            padding-left: 0;
        }
        .details-list li {
            font-size: 1.1rem;
        }
    </style>
</head>
<body>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="card shadow-lg profile-card">
                <!-- Profile Header -->
                <div class="profile-header text-center">
                    <a href="blogs" class="btn btn-light position-absolute top-0 start-0 m-3">
                        <i class="fas fa-arrow-left me-1"></i> Back to Directory
                    </a>
                    <img src="<%= coach.getProfilePicture() != null && !coach.getProfilePicture().isEmpty() ? coach.getProfilePicture() : "https://via.placeholder.com/150" %>"
                         alt="Profile picture of <%= coach.getFullName() %>" class="profile-picture mb-3">
                    <h1 class="display-5 mb-1"><%= coach.getFullName() %></h1>
                </div>

                <!-- Profile Body -->
                <div class="card-body p-4 p-md-5">
                    <div class="row">
                        <!-- Bio Section -->
                        <div class="col-lg-8 border-end-lg">
                            <h4 class="mb-3"><i class="fas fa-user-circle me-2"></i>About Me</h4>
                            <p class="bio-text text-secondary"><%= coach.getBio() != null ? coach.getBio() : "No biography provided." %></p>
                        </div>

                        <!-- Details Section -->
                        <div class="col-lg-4 mt-4 mt-lg-0">
                            <h4 class="mb-3"><i class="fas fa-info-circle me-2"></i>Details</h4>
                            <ul class="details-list">
                                <li class="mb-3">
                                    <strong class="d-block text-muted">Email</strong>
                                    <a href="mailto:<%= coach.getEmail() %>"><%= coach.getEmail() %></a>
                                </li>
                                <li class="mb-3">
                                    <strong class="d-block text-muted">Phone</strong>
                                    <%= coach.getPhone() %>
                                </li>
                                <li class="mb-3">
                                    <strong class="d-block text-muted">Gender</strong>
                                    <%= coach.getGender() %>
                                </li>
                            </ul>
                        </div>
                    </div>

                    <%-- NEW: Button to register with this coach --%>
                    <hr class="my-4">
                    <div class="text-center">
                        <a href="course?action=create_form&coachId=<%= coach.getId() %>" class="btn btn-success btn-lg">
                            <i class="fas fa-user-plus me-2"></i>Register with this Coach
                        </a>
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
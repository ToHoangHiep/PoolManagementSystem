<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Course" %>
<%@ page import="model.Coach" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Arrays" %>

<%
    // --- User & Role Check ---
    User user = (User) session.getAttribute("user");
    boolean isAdmin = false;
    if (user != null) {
        // Assuming roles other than 3 (Coach) and 4 (Customer) are admins
        isAdmin = !Arrays.asList(3, 4).contains(user.getRole().getId());
    }

    // --- Data Retrieval from Servlet ---
    // The servlet must provide all these attributes for the page to work
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    List<Coach> coaches = (List<Coach>) request.getAttribute("coaches");
    Map<Integer, Integer> courseCounts = (Map<Integer, Integer>) request.getAttribute("courseCounts");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Courses & Coaches Directory</title>
    <!-- Bootstrap CSS -->
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .accordion-button:not(.collapsed) {
            color: #0c63e4;
            background-color: #e7f1ff;
        }
        .list-group-item-action {
            transition: background-color 0.2s ease-in-out;
        }
    </style>
</head>
<body>

<div class="container my-5">
    <!-- Page Header -->
    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
        <h1 class="h2">Directory</h1>
        <%-- Admin-only "Create" buttons can go here if needed --%>
        <% if (isAdmin) { %>
        <div class="d-flex gap-2">
            <a href="course?action=create" class="btn btn-primary">
                <i class="fas fa-plus-circle me-2"></i>New Course
            </a>
            <%-- You can add a link to create a new coach here in the future --%>
        </div>
        <% } %>
    </div>

    <p class="lead text-muted mb-4">
        Browse our available courses and get to know our professional coaches. Click on any item to see more details.
    </p>

    <div class="accordion" id="directoryAccordion">

        <!-- Courses Section -->
        <div class="accordion-item">
            <h2 class="accordion-header" id="headingCourses">
                <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseCourses" aria-expanded="true" aria-controls="collapseCourses">
                    <i class="fas fa-book-open fa-fw me-2"></i>Available Courses
                </button>
            </h2>
            <div id="collapseCourses" class="accordion-collapse collapse show" aria-labelledby="headingCourses">
                <div class="list-group list-group-flush">
                    <% if (courses != null && !courses.isEmpty()) { %>
                    <% for (Course course : courses) { %>
                    <a href="blogs?action=view_course&courseId=<%= course.getId() %>" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="mb-1"><%= course.getName() %></h6>
                            <small class="text-muted"><%= course.getSchedule_description() %></small>
                        </div>
                        <span class="badge bg-primary rounded-pill" title="Registered Students">
                                    <%= courseCounts.getOrDefault(course.getId(), 0) %> <i class="fas fa-user-graduate ms-1"></i>
                                </span>
                    </a>
                    <% } %>
                    <% } else { %>
                    <div class="list-group-item">No courses available at the moment.</div>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- Coaches Section -->
        <div class="accordion-item">
            <h2 class="accordion-header" id="headingCoaches">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseCoaches" aria-expanded="false" aria-controls="collapseCoaches">
                    <i class="fas fa-user-tie fa-fw me-2"></i>Our Professional Coaches
                </button>
            </h2>
            <div id="collapseCoaches" class="accordion-collapse collapse" aria-labelledby="headingCoaches">
                <div class="list-group list-group-flush">
                    <% if (coaches != null && !coaches.isEmpty()) { %>
                    <% for (Coach coach : coaches) { %>
                    <%-- This link can be pointed to a future coach details page --%>
                    <a href="blogs?action=view_coach&coachId=<%= coach.getId() %>" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="mb-1"><%= coach.getFullName() %></h6>
                            <small class="text-muted"><%= coach.getEmail() %></small>
                        </div>
                    </a>
                    <% } %>
                    <% } else { %>
                    <div class="list-group-item">No coaches available at the moment.</div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="Resources/bootstrap/js/bootstrap.bundle.min.js"></script>

</body>
</html>
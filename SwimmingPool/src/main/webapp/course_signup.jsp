<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Course" %>
<%@ page import="model.Coach" %>
<%@ page import="java.util.List" %>

<%
    // --- User & Data Retrieval ---
    User user = (User) session.getAttribute("user");
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    List<Coach> coaches = (List<Coach>) request.getAttribute("coaches");

    // Get pre-selected IDs from the servlet
    Integer preselectedCourseId = (Integer) request.getAttribute("preselectedCourseId");
    Integer preselectedCoachId = (Integer) request.getAttribute("preselectedCoachId");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Registration</title>
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
    </style>
</head>
<body>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h2 class="mb-0 h4"><i class="fas fa-user-plus me-2"></i>Register for a Course</h2>
                </div>
                <div class="card-body p-4">

                    <%-- On-page error display --%>
                    <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger" role="alert">
                        <%= request.getAttribute("error") %>
                    </div>
                    <% } %>

                    <form action="course-signup?action=create_form" method="post">
                        <%-- Show user info or guest fields --%>
                        <% if (user != null) { %>
                        <div class="alert alert-info">
                            You are registering as: <strong><%= user.getFullName() %></strong> (<%= user.getEmail() %>)
                        </div>
                        <% } else { %>
                        <h5 class="mb-3">Your Information (Guest)</h5>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="name" class="form-label">Full Name</label>
                                <input type="text" class="form-control" id="name" name="name" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="email" class="form-label">Email Address</label>
                                <input type="email" class="form-control" id="email" name="email" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="phone" class="form-label">Phone Number</label>
                            <input type="tel" class="form-control" id="phone" name="phone" required>
                        </div>
                        <hr class="my-4">
                        <% } %>

                        <h5 class="mb-3">Select Your Course and Coach</h5>
                        <!-- Course Selection -->
                        <div class="mb-3">
                            <label for="courseId" class="form-label fw-bold">Course</label>
                            <select class="form-select" id="courseId" name="courseId" required>
                                <option value="" disabled <%= (preselectedCourseId == null) ? "selected" : "" %>>-- Select a Course --</option>
                                <% for (Course c : courses) { %>
                                <option value="<%= c.getId() %>" <%= (preselectedCourseId != null && preselectedCourseId == c.getId()) ? "selected" : "" %>>
                                    <%= c.getName() %> ($<%= String.format("%.2f", c.getPrice()) %>)
                                </option>
                                <% } %>
                            </select>
                        </div>

                        <!-- Coach Selection -->
                        <div class="mb-4">
                            <label for="coachId" class="form-label fw-bold">Coach</label>
                            <select class="form-select" id="coachId" name="coachId" required>
                                <option value="" disabled <%= (preselectedCoachId == null) ? "selected" : "" %>>-- Select a Coach --</option>
                                <% for (Coach c : coaches) { %>
                                <option value="<%= c.getId() %>" <%= (preselectedCoachId != null && preselectedCoachId == c.getId()) ? "selected" : "" %>>
                                    <%= c.getFullName() %>
                                </option>
                                <% } %>
                            </select>
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex justify-content-end gap-2 border-top pt-3 mt-3">
                            <a href="course-signup" class="btn btn-secondary">
                                <i class="fas fa-times me-1"></i>Cancel
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-check-circle me-1"></i>Submit Registration
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="Resources/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Feedback" %>
<%@ page import="model.Course" %>
<%@ page import="model.Coach" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // --- Security & Data Retrieval ---
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    // Example: Role 4 (Customer) cannot manage feedback.
    if (adminUser.getRole().getId() == 4) {
        session.setAttribute("alert_message", "You do not have permission to access this page.");
        response.sendRedirect("home.jsp");
        return;
    }

    // Data from Servlet
    List<Feedback> feedbackList = (List<Feedback>) request.getAttribute("feedbackList");
    Map<Integer, Course> courseMap = (Map<Integer, Course>) request.getAttribute("courseMap");
    Map<Integer, Coach> coachMap = (Map<Integer, Coach>) request.getAttribute("coachMap");
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM, yyyy");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Feedback</title>
    <!-- Bootstrap CSS -->
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .table-hover tbody tr:hover { background-color: #e9ecef; }
        .rating-star { color: #ffc107; }
    </style>
</head>
<body>

<%-- Session-based alert message handler --%>
<%
    String alertMessage = (String) session.getAttribute("alert_message");
    if (alertMessage != null) {
        session.removeAttribute("alert_message");
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
                <i class="fas fa-comments me-2 text-primary"></i>Manage User Feedback
            </h2>
        </div>
        <div class="card-body">
            <% if (feedbackList == null || feedbackList.isEmpty()) { %>
            <div class="alert alert-info text-center">
                There is no feedback to display at the moment.
            </div>
            <% } else { %>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Submitted By</th>
                        <th class="text-center">Type</th>
                        <th>Target</th>
                        <th class="text-center">Rating</th>
                        <th>Date</th>
                        <th class="text-end">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Feedback feedback : feedbackList) { %>
                    <tr>
                        <td>#<%= feedback.getId() %></td>
                        <td><%= feedback.getUserName() %></td>
                        <td class="text-center">
                            <%
                                String type = feedback.getFeedbackType();
                                String badgeClass = "bg-secondary";
                                if ("Course".equals(type)) badgeClass = "bg-warning text-dark";
                                if ("Coach".equals(type)) badgeClass = "bg-info text-dark";
                                if ("General".equals(type)) badgeClass = "bg-success";
                            %>
                            <span class="badge <%= badgeClass %>"><%= type %></span>
                        </td>
                        <td>
                            <%-- Dynamically display the feedback target --%>
                            <% if ("Course".equals(type) && courseMap.containsKey(feedback.getCourseId())) { %>
                            <%= courseMap.get(feedback.getCourseId()).getName() %>
                            <% } else if ("Coach".equals(type) && coachMap.containsKey(feedback.getCoachId())) { %>
                            <%= coachMap.get(feedback.getCoachId()).getFullName() %>
                            <% } else { %>
                            <%= feedback.getGeneralFeedbackType() %>
                            <% } %>
                        </td>
                        <td class="text-center">
                            <span class="rating-star"><i class="fas fa-star"></i></span>
                            <%= feedback.getRating() %>
                        </td>
                        <td><%= sdf.format(feedback.getCreatedAt()) %></td>
                        <td class="text-end">
                            <a href="feedback?action=details&id=<%= feedback.getId() %>" class="btn btn-sm btn-outline-primary">
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
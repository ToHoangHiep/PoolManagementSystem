<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Feedback" %>
<%@ page import="java.util.List" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback History - Swimming Pool Management</title>
    <!-- Bootstrap 5.3.7 CSS -->
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="Resources/CSS/FeedbackHistory.css">
</head>

<body class="bg-light">
<%
    if (request.getAttribute("alert_message") != null) {
        String alertMessage = (String) request.getAttribute("alert_message");
        String alertAction = (String) request.getAttribute("alert_action");
        boolean existPostAction = request.getAttribute("alert_action") != null;
%>
<!-- Bootstrap Alert -->
<div class="position-fixed top-0 end-0 p-3" style="z-index: 11000;">
    <div class="toast show" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="toast-header">
            <i class="fas fa-info-circle text-primary me-2"></i>
            <strong class="me-auto">Notification</strong>
            <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
        <div class="toast-body">
            <%= alertMessage %>
        </div>
    </div>
</div>
<script>
    <% if (existPostAction) { %>
    setTimeout(() => {
        window.location.href = "${pageContext.request.contextPath}<%= alertAction %>";
    }, 2000);
    <% } %>
</script>
<%
    }
%>

<div class="container-fluid py-4">
    <!-- Header Section -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card border-0 shadow-sm bg-gradient-primary text-white">
                <div class="card-body text-center py-5">
                    <h1 class="display-5 fw-bold mb-3">
                        <i class="fas fa-comments me-3"></i>Feedback History
                    </h1>
                    <p class="lead mb-0">View and manage your feedback submissions</p>
                    
                    <%
                        // Check if user is admin (not roles 3 or 4)
                        boolean isAdmin = !java.util.Arrays.asList(3, 4).contains(user.getRole().getId());
                        boolean showAll = request.getParameter("show_all") != null && request.getParameter("show_all").equals("true");

                        if (isAdmin) {
                    %>
                    <!-- Admin Toggle Section -->
                    <div class="mt-4">
                        <div class="d-flex justify-content-center align-items-center">
                            <span class="me-3 <%= !showAll ? "text-warning fw-bold" : "" %>">
                                <i class="fas fa-user me-1"></i> Personal
                            </span>
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" 
                                       id="viewToggle" <%= showAll ? "checked" : "" %> 
                                       onchange="toggleView(this.checked)">
                            </div>
                            <span class="ms-3 <%= showAll ? "text-warning fw-bold" : "" %>">
                                <i class="fas fa-users me-1"></i> All Users
                            </span>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <!-- Filters Section -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white py-3">
                    <h5 class="card-title mb-0">
                        <i class="fas fa-filter me-2 text-primary"></i>Filters & Search
                    </h5>
                </div>
                <div class="card-body">
                    <form action="feedback?action=sort" method="post">
                        <!-- Hidden field to maintain show_all state during filtering -->
                        <% if (isAdmin) { %>
                        <input type="hidden" name="show_all" value="<%= showAll ? "true" : "false" %>">
                        <% } %>

                        <div class="row g-3">
                            <!-- Feedback Type Filter -->
                            <div class="col-md-6 col-lg-3">
                                <label for="feedback_type" class="form-label fw-semibold">Feedback Type</label>
                                <select name="feedback_type" id="feedback_type" class="form-select" 
                                        onchange="toggleFilterFields()">
                                    <option value="all">All Types</option>
                                    <option value="General">General</option>
                                    <option value="Coach">Coach</option>
                                    <option value="Course">Course</option>
                                </select>
                            </div>

                            <!-- General Type Filter (Hidden by default) -->
                            <div class="col-md-6 col-lg-3 d-none" id="general_type_group">
                                <label for="general_feedback_type" class="form-label fw-semibold">General Type</label>
                                <select name="general_feedback_type" id="general_feedback_type" class="form-select">
                                    <option value="all">All</option>
                                    <option value="Food">Food</option>
                                    <option value="Service">Service</option>
                                    <option value="Facility">Facility</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>

                            <!-- Coach Filter (Hidden by default) -->
                            <div class="col-md-6 col-lg-3 d-none" id="coach_group">
                                <label for="coach_id" class="form-label fw-semibold">Coach</label>
                                <select name="coach_id" id="coach_id" class="form-select">
                                    <option value="all">All Coaches</option>
                                    <!-- Dynamic coach options would go here -->
                                </select>
                            </div>

                            <!-- Course Filter (Hidden by default) -->
                            <div class="col-md-6 col-lg-3 d-none" id="course_group">
                                <label for="course_id" class="form-label fw-semibold">Course</label>
                                <select name="course_id" id="course_id" class="form-select">
                                    <option value="all">All Courses</option>
                                    <!-- Dynamic course options would go here -->
                                </select>
                            </div>

                            <!-- Sort By Filter -->
                            <div class="col-md-6 col-lg-3">
                                <label for="sort_by" class="form-label fw-semibold">Sort By</label>
                                <select name="sort_by" id="sort_by" class="form-select">
                                    <option value="created_at">Date Created</option>
                                    <option value="updated_at">Date Updated</option>
                                    <option value="rating">Rating</option>
                                </select>
                            </div>

                            <!-- Sort Order Filter -->
                            <div class="col-md-6 col-lg-3">
                                <label for="sort_order" class="form-label fw-semibold">Order</label>
                                <select name="sort_order" id="sort_order" class="form-select">
                                    <option value="DESC">Newest First</option>
                                    <option value="ASC">Oldest First</option>
                                </select>
                            </div>

                            <!-- Apply Filters Button -->
                            <div class="col-md-6 col-lg-3">
                                <label class="form-label">&nbsp;</label>
                                <button type="submit" class="btn btn-primary w-100">
                                    <i class="fas fa-filter me-2"></i>Apply Filters
                                </button>
                            </div>
                        </div>

                        <!-- Error Message -->
                        <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger mt-3" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <%= request.getAttribute("error") %>
                        </div>
                        <% } %>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Controls Section -->
    <div class="row mb-3">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" id="selectAll">
                    <label class="form-check-label fw-semibold" for="selectAll">
                        Select All
                    </label>
                </div>
                <button id="deleteSelectedBtn" class="btn btn-outline-danger" disabled>
                    <i class="fas fa-trash me-2"></i>Delete Selected
                </button>
            </div>
        </div>
    </div>

    <!-- Feedback Table -->
    <div class="row">
        <div class="col-12">
            <div class="card border-0 shadow-sm">
                <div class="card-body p-0">
                    <form id="deleteForm" action="feedback?action=delete_multiple" method="post">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-dark">
                                    <tr>
                                        <th style="width: 50px;" class="text-center">
                                            <i class="fas fa-check"></i>
                                        </th>
                                        <th style="width: 200px;">User</th>
                                        <th style="width: 120px;">Type</th>
                                        <th style="width: 150px;">Rating</th>
                                        <th>Content</th>
                                        <th style="width: 130px;">Date</th>
                                        <th style="width: 150px;" class="text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <%
                                    // Determine which feedback list to display based on admin status and toggle
                                    List<Feedback> feedbackToDisplay = null;

                                    if (isAdmin) {
                                        // For admins: choose between personal and all feedback based on toggle
                                        List<Feedback> personalFeedback = (List<Feedback>) request.getAttribute("personal_feedback_list");
                                        List<Feedback> allFeedback = (List<Feedback>) request.getAttribute("all_feedback_list");

                                        feedbackToDisplay = showAll ? allFeedback : personalFeedback;
                                    } else {
                                        // For non-admins: use the regular feedback list
                                        feedbackToDisplay = (List<Feedback>) request.getAttribute("feedback_list");
                                    }

                                    if (feedbackToDisplay != null && !feedbackToDisplay.isEmpty()) {
                                        for (Feedback feedback : feedbackToDisplay) {
                                %>
                                <tr>
                                    <!-- Checkbox Column -->
                                    <td class="text-center">
                                        <input type="checkbox" class="form-check-input feedback-checkbox"
                                               name="selectedIds" value="<%= feedback.getId() %>">
                                    </td>

                                    <!-- User Information Column -->
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="avatar-circle bg-primary text-white me-2">
                                                <i class="fas fa-user"></i>
                                            </div>
                                            <div>
                                                <div class="fw-semibold text-dark">
                                                    <%= feedback.getUserName() != null ? feedback.getUserName() : "N/A" %>
                                                </div>
                                                <small class="text-muted">
                                                    <%= feedback.getUserEmail() != null ? feedback.getUserEmail() : "" %>
                                                </small>
                                            </div>
                                        </div>
                                    </td>

                                    <!-- Feedback Type Column -->
                                    <td>
                                        <span class="badge bg-<%= feedback.getFeedbackType().toLowerCase().equals("general") ? "success" : 
                                                                   feedback.getFeedbackType().toLowerCase().equals("coach") ? "info" : "warning" %> 
                                                     fs-6 px-3 py-2">
                                            <%= feedback.getFeedbackType() %>
                                        </span>
                                    </td>

                                    <!-- Rating Column -->
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="text-warning me-2">
                                                <%
                                                    int fullStars = feedback.getRating() / 2;
                                                    boolean hasHalfStar = feedback.getRating() % 2 == 1;

                                                    for (int i = 0; i < fullStars; i++) {
                                                %>
                                                <i class="fas fa-star"></i>
                                                <%
                                                    }

                                                    if (hasHalfStar) {
                                                %>
                                                <i class="fas fa-star-half-alt"></i>
                                                <%
                                                    }

                                                    for (int i = 0; i < (5 - fullStars - (hasHalfStar ? 1 : 0)); i++) {
                                                %>
                                                <i class="far fa-star"></i>
                                                <%
                                                    }
                                                %>
                                            </div>
                                            <small class="text-muted">(<%= feedback.getRating() %>/10)</small>
                                        </div>
                                    </td>

                                    <!-- Content Preview Column -->
                                    <td>
                                        <div class="content-preview" title="<%= feedback.getContent() %>">
                                            <%= feedback.getContent().length() > 80 ?
                                                    feedback.getContent().substring(0, 77) + "..." :
                                                    feedback.getContent() %>
                                        </div>
                                    </td>

                                    <!-- Date Column -->
                                    <td>
                                        <small class="text-muted">
                                            <%= feedback.getCreatedAt() %>
                                        </small>
                                    </td>

                                    <!-- Actions Column -->
                                    <td class="text-center">
                                        <div class="btn-group" role="group" aria-label="Actions">
                                            <!-- Preview Button -->
                                            <button type="button" class="btn btn-outline-success btn-sm"
                                                    onclick="previewFeedback({
                                                            id: <%= feedback.getId() %>,
                                                            type: '<%= feedback.getFeedbackType() %>',
                                                            rating: <%= feedback.getRating() %>,
                                                            date: '<%= feedback.getCreatedAt() %>',
                                                            content: '<%= feedback.getContent().replace("'", "\\'").replace("\n", "\\n") %>',
                                                            userName: '<%= feedback.getUserName() != null ? feedback.getUserName().replace("'", "\\'") : "N/A" %>',
                                                            userEmail: '<%= feedback.getUserEmail() != null ? feedback.getUserEmail().replace("'", "\\'") : "" %>'
                                                            }, <%= feedback.getUserId() == user.getId() %>)"
                                                    title="Preview" data-bs-toggle="tooltip">
                                                <i class="fas fa-eye"></i>
                                            </button>

                                            <!-- Reply Button -->
                                            <a href="feedback?action=chat&id=<%= feedback.getId() %>"
                                               class="btn btn-outline-info btn-sm"
                                               title="Chat/Reply" data-bs-toggle="tooltip">
                                                <i class="fas fa-comment"></i>
                                            </a>

                                            <%
                                                User currentUser = (User) session.getAttribute("user");
                                                if (currentUser.getId() == feedback.getUserId()) {
                                            %>
                                            <!-- Edit Button -->
                                            <a href="feedback?action=edit&id=<%= feedback.getId() %>"
                                               class="btn btn-outline-warning btn-sm"
                                               title="Edit" data-bs-toggle="tooltip">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <%
                                                }
                                            %>

                                            <!-- Delete Button -->
                                            <button type="button" class="btn btn-outline-danger btn-sm"
                                                    onclick="confirmDelete(<%= feedback.getId() %>)"
                                                    title="Delete" data-bs-toggle="tooltip">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                    }
                                } else {
                                %>
                                <!-- No Feedback Found Row -->
                                <tr>
                                    <td colspan="7" class="text-center py-5">
                                        <div class="text-muted">
                                            <i class="fas fa-comments fa-3x mb-3 opacity-50"></i>
                                            <h5>No feedback records found</h5>
                                            <p class="mb-0">Try adjusting your filters or submit some feedback!</p>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                        }
                                %>
                                </tbody>
                            </table>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap Modal for Preview -->
<div class="modal fade" id="previewModal" tabindex="-1" aria-labelledby="previewModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="previewModalLabel">
                    <i class="fas fa-eye me-2"></i>Feedback Preview
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <!-- User Information -->
                <div class="row mb-3">
                    <div class="col-md-6">
                        <div class="card bg-light">
                            <div class="card-body">
                                <h6 class="card-subtitle mb-2 text-muted">User Information</h6>
                                <div class="d-flex align-items-center">
                                    <div class="avatar-circle bg-primary text-white me-3">
                                        <i class="fas fa-user"></i>
                                    </div>
                                    <div>
                                        <div class="fw-semibold" id="modalUserName">-</div>
                                        <small class="text-muted" id="modalUserEmail">-</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card bg-light">
                            <div class="card-body">
                                <h6 class="card-subtitle mb-2 text-muted">Feedback Details</h6>
                                <div class="mb-2">
                                    <strong>Type:</strong> <span id="modalFeedbackType">-</span>
                                </div>
                                <div class="mb-2">
                                    <strong>Rating:</strong> <span id="modalRating">-</span>
                                </div>
                                <div>
                                    <strong>Date:</strong> <span id="modalDate">-</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Feedback Content -->
                <div class="mb-3">
                    <h6 class="text-muted mb-2">Content</h6>
                    <div class="border rounded p-3 bg-light" id="modalContent">
                        Loading content...
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <a href="#" id="modalReplyBtn" class="btn btn-info">
                    <i class="fas fa-comment me-2"></i>Chat/Reply
                </a>
                <a href="#" id="modalEditBtn" class="btn btn-warning">
                    <i class="fas fa-edit me-2"></i>Edit
                </a>
                <button type="button" id="modalDeleteBtn" class="btn btn-danger">
                    <i class="fas fa-trash me-2"></i>Delete
                </button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="Resources/bootstrap/js/bootstrap.bundle.min.js"></script>
<!-- Custom JavaScript -->
<script src="Resources/JavaScript/FeedbackHistory.js"></script>

<script>
// Initialize Bootstrap tooltips
document.addEventListener('DOMContentLoaded', function() {
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
});
</script>

</body>
</html>

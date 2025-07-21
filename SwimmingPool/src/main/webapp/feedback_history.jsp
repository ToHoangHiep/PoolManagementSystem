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
    boolean isAdmin = !java.util.Arrays.asList(3, 4).contains(user.getRole().getId());
    if (!isAdmin) {
        response.sendRedirect("home.jsp");
        return;
    }
    boolean showAll = request.getParameter("show_all") != null && request.getParameter("show_all").equals("true");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback History - Swimming Pool Management</title>
    <!-- Bootstrap CSS -->
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons (minimal usage) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* Simple custom styles */
        body {
            background-color: #f8f9fa;
        }
        .rating-slider {
            height: 10px;
            width: 100px;
            background-color: #e9ecef;
            border-radius: 5px;
            position: relative;
            margin-right: 10px;
        }
        .rating-slider-fill {
            height: 100%;
            border-radius: 5px;
            background-color: #ffc107;
            position: absolute;
            left: 0;
            top: 0;
        }
    </style>
</head>

<body>
<%
    if (request.getAttribute("alert_message") != null) {
        String alertMessage = (String) request.getAttribute("alert_message");
        String alertAction = (String) request.getAttribute("alert_action");
        boolean existPostAction = request.getAttribute("alert_action") != null;
%>
    <script>
        alert('<%= alertMessage %>');
        <% if (existPostAction) { %>
        window.location.href = "${pageContext.request.contextPath}<%= alertAction %>";
        <% } %>
    </script>
<%
    }
%>

<div class="container-fluid py-4">
    <!-- Header Section -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card">
                <div class="card-body text-center py-3">
                    <h1 class="mb-3">
                        <i class="fas fa-comments me-2"></i>Feedback History
                    </h1>
                    <p class="mb-0">View and manage your feedback submissions</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Filters Section -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title mb-0">
                        <i class="fas fa-filter me-2"></i>Filters & Search
                    </h5>
                </div>
                <div class="card-body">
                    <form action="feedback?action=sort" method="post">
                        <!-- Hidden field to maintain show_all state during filtering -->
                        <input type="hidden" name="show_all" value="<%= showAll ? "true" : "false" %>">

                        <div class="row g-3">
                            <!-- Feedback Type Filter -->
                            <div class="col-md-6 col-lg-3">
                                <label for="feedback_type" class="form-label">Feedback Type</label>
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
                                <label for="general_feedback_type" class="form-label">General Type</label>
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
                                <label for="coach_id" class="form-label">Coach</label>
                                <select name="coach_id" id="coach_id" class="form-select">
                                    <option value="all">All Coaches</option>
                                    <!-- Dynamic coach options would go here -->
                                </select>
                            </div>

                            <!-- Course Filter (Hidden by default) -->
                            <div class="col-md-6 col-lg-3 d-none" id="course_group">
                                <label for="course_id" class="form-label">Course</label>
                                <select name="course_id" id="course_id" class="form-select">
                                    <option value="all">All Courses</option>
                                    <!-- Dynamic course options would go here -->
                                </select>
                            </div>

                            <!-- Sort By Filter -->
                            <div class="col-md-6 col-lg-3">
                                <label for="sort_by" class="form-label">Sort By</label>
                                <select name="sort_by" id="sort_by" class="form-select">
                                    <option value="created_at">Date Created</option>
                                    <option value="updated_at">Date Updated</option>
                                    <option value="rating">Rating</option>
                                </select>
                            </div>

                            <!-- Sort Order Filter -->
                            <div class="col-md-6 col-lg-3">
                                <label for="sort_order" class="form-label">Order</label>
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
                    <label class="form-check-label" for="selectAll">
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
            <div class="card">
                <div class="card-body p-0">
                    <form id="deleteForm" action="feedback?action=delete_multiple" method="post">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
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
                                    // For admins: choose between personal and all feedback based on toggle
                                    List<Feedback> feedbackToDisplay = (List<Feedback>) request.getAttribute("feedback_list");

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
                                            <div class="bg-light text-dark rounded-circle p-2 me-2 text-center" style="width: 36px; height: 36px;">
                                                <i class="fas fa-user"></i>
                                            </div>
                                            <div>
                                                <div class="text-dark">
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
                                        <span class="badge <%= feedback.getFeedbackType().toLowerCase().equals("general") ? "bg-success" : 
                                                               feedback.getFeedbackType().toLowerCase().equals("coach") ? "bg-info" : "bg-warning" %>">
                                            <%= feedback.getFeedbackType() %>
                                        </span>
                                    </td>

                                    <!-- Rating Column - REPLACED STARS WITH SLIDER -->
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="rating-slider">
                                                <div class="rating-slider-fill" style="width: <%= (feedback.getRating() * 10) %>%;"></div>
                                            </div>
                                            <small class="text-muted">(<%= feedback.getRating() %>/10)</small>
                                        </div>
                                    </td>

                                    <!-- Content Preview Column -->
                                    <td>
                                        <div title="<%= feedback.getContent() %>">
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
                                            <button type="button" class="btn btn-outline-secondary btn-sm"
                                                    onclick="previewFeedback({
                                                            id: <%= feedback.getId() %>,
                                                            type: '<%= feedback.getFeedbackType() %>',
                                                            rating: <%= feedback.getRating() %>,
                                                            date: '<%= feedback.getCreatedAt() %>',
                                                            content: '<%= feedback.getContent().replace("'", "\\'").replace("\n", "\\n") %>',
                                                            userName: '<%= feedback.getUserName() != null ? feedback.getUserName().replace("'", "\\'") : "N/A" %>',
                                                            userEmail: '<%= feedback.getUserEmail() != null ? feedback.getUserEmail().replace("'", "\\'") : "" %>'
                                                            }, <%= feedback.getUserId() == user.getId() %>)"
                                                    title="Preview">
                                                <i class="fas fa-eye"></i>
                                            </button>

                                            <!-- Reply Button -->
                                            <a href="feedback?action=chat&id=<%= feedback.getId() %>"
                                               class="btn btn-outline-secondary btn-sm"
                                               title="Chat/Reply">
                                                <i class="fas fa-comment"></i>
                                            </a>

                                            <%
                                                User currentUser = (User) session.getAttribute("user");
                                                if (currentUser.getId() == feedback.getUserId()) {
                                            %>
                                            <!-- Edit Button -->
                                            <a href="feedback?action=edit&id=<%= feedback.getId() %>"
                                               class="btn btn-outline-secondary btn-sm"
                                               title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <%
                                                }
                                            %>

                                            <!-- Delete Button -->
                                            <button type="button" class="btn btn-outline-secondary btn-sm"
                                                    onclick="confirmDelete(<%= feedback.getId() %>)"
                                                    title="Delete">
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
                                    <td colspan="7" class="text-center py-4">
                                        <div class="text-muted">
                                            <i class="fas fa-comments fa-2x mb-2"></i>
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
            <div class="modal-header">
                <h5 class="modal-title" id="previewModalLabel">
                    <i class="fas fa-eye me-2"></i>Feedback Preview
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <!-- User Information -->
                <div class="row mb-3">
                    <div class="col-md-6">
                        <div class="card bg-light">
                            <div class="card-body">
                                <h6 class="card-subtitle mb-2 text-muted">User Information</h6>
                                <div class="d-flex align-items-center">
                                    <div class="bg-light text-dark rounded-circle p-2 me-2 text-center" style="width: 36px; height: 36px;">
                                        <i class="fas fa-user"></i>
                                    </div>
                                    <div>
                                        <div id="modalUserName">-</div>
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
                                    <strong>Rating:</strong> 
                                    <div class="d-flex align-items-center mt-1">
                                        <div class="rating-slider">
                                            <div class="rating-slider-fill" id="modalRatingSlider"></div>
                                        </div>
                                        <small class="text-muted" id="modalRating">-</small>
                                    </div>
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
                <a href="#" id="modalReplyBtn" class="btn btn-outline-secondary">
                    <i class="fas fa-comment me-2"></i>Chat/Reply
                </a>
                <a href="#" id="modalEditBtn" class="btn btn-outline-secondary">
                    <i class="fas fa-edit me-2"></i>Edit
                </a>
                <button type="button" id="modalDeleteBtn" class="btn btn-outline-danger">
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
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[title]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
    
    // Update modal preview to use slider
    window.previewFeedback = function(feedback, isOwner) {
        document.getElementById('modalUserName').textContent = feedback.userName;
        document.getElementById('modalUserEmail').textContent = feedback.userEmail;
        document.getElementById('modalFeedbackType').textContent = feedback.type;
        document.getElementById('modalRating').textContent = '(' + feedback.rating + '/10)';
        document.getElementById('modalRatingSlider').style.width = (feedback.rating * 10) + '%';
        document.getElementById('modalDate').textContent = feedback.date;
        document.getElementById('modalContent').textContent = feedback.content;
        
        // Set up action buttons
        document.getElementById('modalReplyBtn').href = 'feedback?action=chat&id=' + feedback.id;
        document.getElementById('modalEditBtn').href = 'feedback?action=edit&id=' + feedback.id;
        document.getElementById('modalEditBtn').style.display = isOwner ? 'inline-block' : 'none';
        document.getElementById('modalDeleteBtn').onclick = function() {
            confirmDelete(feedback.id);
            bootstrap.Modal.getInstance(document.getElementById('previewModal')).hide();
        };
        
        // Show the modal
        var previewModal = new bootstrap.Modal(document.getElementById('previewModal'));
        previewModal.show();
    };
});

// Toggle view function for admin
function toggleView(showAll) {
    window.location.href = 'feedback?action=history&show_all=' + showAll;
}

// Toggle filter fields based on feedback type
function toggleFilterFields() {
    var feedbackType = document.getElementById('feedback_type').value;
    
    // Hide all specific filter groups first
    document.getElementById('general_type_group').classList.add('d-none');
    document.getElementById('coach_group').classList.add('d-none');
    document.getElementById('course_group').classList.add('d-none');
    
    // Show the appropriate filter group based on selection
    if (feedbackType === 'General') {
        document.getElementById('general_type_group').classList.remove('d-none');
    } else if (feedbackType === 'Coach') {
        document.getElementById('coach_group').classList.remove('d-none');
    } else if (feedbackType === 'Course') {
        document.getElementById('course_group').classList.remove('d-none');
    }
}

// Confirm delete function
function confirmDelete(id) {
    if (confirm('Are you sure you want to delete this feedback?')) {
        window.location.href = 'feedback?action=delete&id=' + id;
    }
}

// Select all checkboxes functionality
document.getElementById('selectAll').addEventListener('change', function() {
    var checkboxes = document.querySelectorAll('.feedback-checkbox');
    var checked = this.checked;
    
    checkboxes.forEach(function(checkbox) {
        checkbox.checked = checked;
    });
    
    document.getElementById('deleteSelectedBtn').disabled = !checked && document.querySelectorAll('.feedback-checkbox:checked').length === 0;
});

// Enable/disable delete selected button based on checkbox selection
document.addEventListener('click', function(e) {
    if (e.target && e.target.classList.contains('feedback-checkbox')) {
        document.getElementById('deleteSelectedBtn').disabled = document.querySelectorAll('.feedback-checkbox:checked').length === 0;
        
        // Update select all checkbox
        var allCheckboxes = document.querySelectorAll('.feedback-checkbox');
        var checkedCheckboxes = document.querySelectorAll('.feedback-checkbox:checked');
        document.getElementById('selectAll').checked = allCheckboxes.length === checkedCheckboxes.length && allCheckboxes.length > 0;
    }
});

// Delete selected functionality
document.getElementById('deleteSelectedBtn').addEventListener('click', function() {
    if (confirm('Are you sure you want to delete all selected feedback?')) {
        document.getElementById('deleteForm').submit();
    }
});

// Initialize any filter fields based on current selection
document.addEventListener('DOMContentLoaded', function() {
    toggleFilterFields();
});
</script>

</body>
</html>
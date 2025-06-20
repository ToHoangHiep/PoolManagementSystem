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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="Resources/CSS/FeedbackHistory.css">
</head>

<body>
    <div class="container">
        <!-- Header Section -->
        <div class="header">
            <h1><i class="fas fa-comments"></i> Feedback History</h1>
            <p>View and manage your feedback submissions</p>
        </div>

        <div class="content">
            <!-- Filter Section -->
            <form action="feedback?action=sort" method="post" class="filters">
                <div class="filter-row">
                    <!-- Feedback Type Filter -->
                    <div class="form-group">
                        <label for="feedback_type">Feedback Type</label>
                        <select name="feedback_type" id="feedback_type" onchange="toggleFilterFields()">
                            <option value="all">All Types</option>
                            <option value="General">General</option>
                            <option value="Coach">Coach</option>
                            <option value="Course">Course</option>
                        </select>
                    </div>

                    <!-- General Type Filter (Hidden by default) -->
                    <div class="form-group hidden" id="general_type_group">
                        <label for="general_feedback_type">General Type</label>
                        <select name="general_feedback_type" id="general_feedback_type">
                            <option value="all">All</option>
                            <option value="Food">Food</option>
                            <option value="Service">Service</option>
                            <option value="Facility">Facility</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>

                    <!-- Coach Filter (Hidden by default) -->
                    <div class="form-group hidden" id="coach_group">
                        <label for="coach_id">Coach</label>
                        <select name="coach_id" id="coach_id">
                            <option value="all">All Coaches</option>
                            <!-- Dynamic coach options would go here -->
                        </select>
                    </div>

                    <!-- Course Filter (Hidden by default) -->
                    <div class="form-group hidden" id="course_group">
                        <label for="course_id">Course</label>
                        <select name="course_id" id="course_id">
                            <option value="all">All Courses</option>
                            <!-- Dynamic course options would go here -->
                        </select>
                    </div>

                    <!-- Sort By Filter -->
                    <div class="form-group">
                        <label for="sort_by">Sort By</label>
                        <select name="sort_by" id="sort_by">
                            <option value="created_at">Date Created</option>
                            <option value="updated_at">Date Updated</option>
                            <option value="rating">Rating</option>
                        </select>
                    </div>

                    <!-- Sort Order Filter -->
                    <div class="form-group">
                        <label for="sort_order">Order</label>
                        <select name="sort_order" id="sort_order">
                            <option value="DESC">Newest First</option>
                            <option value="ASC">Oldest First</option>
                        </select>
                    </div>

                    <!-- Apply Filters Button -->
                    <div class="form-group">
                        <label>&nbsp;</label>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-filter"></i> Apply Filters
                        </button>
                    </div>
                </div>
            </form>

            <!-- Controls Section -->
            <div class="controls">
                <div class="checkbox-container">
                    <input type="checkbox" id="selectAll">
                    <label for="selectAll">Select All</label>
                </div>
                <button id="deleteSelectedBtn" class="btn btn-danger" disabled>
                    <i class="fas fa-trash"></i> Delete Selected
                </button>
            </div>

            <!-- Feedback Table -->
            <div class="table-container">
                <form id="deleteForm" action="feedback?action=delete_multiple" method="post">
                    <table class="feedback-table">
                        <!-- Table Header -->
                        <thead>
                            <tr>
                                <th style="width: 5%;"></th>
                                <th style="width: 12%;">User</th>
                                <th style="width: 12%;">Type</th>
                                <th style="width: 12%;">Rating</th>
                                <th style="width: 29%;">Content</th>
                                <th style="width: 15%;">Date</th>
                                <th style="width: 15%;">Actions</th>
                            </tr>
                        </thead>

                        <!-- Table Body -->
                        <tbody>
                            <%
                                List<Feedback> feedbackList = (List<Feedback>) request.getAttribute("feedback_list");
                                if (feedbackList != null && !feedbackList.isEmpty()) {
                                    for (Feedback feedback : feedbackList) {
                            %>
                            <!-- Feedback Row -->
                            <tr>
                                <!-- Checkbox Column -->
                                <td>
                                    <input type="checkbox" 
                                           name="selectedIds" 
                                           value="<%= feedback.getId() %>" 
                                           class="feedback-checkbox">
                                </td>

                                <!-- User Information Column -->
                                <td>
                                    <div class="user-info">
                                        <div class="user-name">
                                            <i class="fas fa-user"></i>
                                            <%= feedback.getUserName() != null ? feedback.getUserName() : "N/A" %>
                                        </div>
                                        <div class="user-email">
                                            <%= feedback.getUserEmail() != null ? feedback.getUserEmail() : "" %>
                                        </div>
                                    </div>
                                </td>

                                <!-- Feedback Type Column -->
                                <td>
                                    <span class="badge badge-<%= feedback.getFeedbackType().toLowerCase() %>">
                                        <%= feedback.getFeedbackType() %>
                                    </span>
                                </td>

                                <!-- Rating Column -->
                                <td>
                                    <div class="star-rating">
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
                                        <span style="margin-left: 8px; color: #6c757d;">
                                            (<%= feedback.getRating() %>/10)
                                        </span>
                                    </div>
                                </td>

                                <!-- Content Preview Column -->
                                <td>
                                    <div class="content-preview" title="<%= feedback.getContent() %>">
                                        <%= feedback.getContent().length() > 50 ? 
                                            feedback.getContent().substring(0, 47) + "..." : 
                                            feedback.getContent() %>
                                    </div>
                                </td>

                                <!-- Date Column -->
                                <td><%= feedback.getCreatedAt() %></td>

                                <!-- Actions Column -->
                                <td>
                                    <div class="action-buttons">
                                        <!-- Preview Button -->
                                        <button type="button" 
                                                class="btn-icon btn-preview" 
                                                onclick="previewFeedback({
                                                    id: <%= feedback.getId() %>,
                                                    type: '<%= feedback.getFeedbackType() %>',
                                                    rating: <%= feedback.getRating() %>,
                                                    date: '<%= feedback.getCreatedAt() %>',
                                                    content: '<%= feedback.getContent() %>',
                                                    userName: '<%= feedback.getUserName() != null ? feedback.getUserName() : "N/A" %>',
                                                    userEmail: '<%= feedback.getUserEmail() != null ? feedback.getUserEmail() : "" %>'
                                                }, <%= feedback.getUserId() == user.getId() %>)"
                                                title="Preview">
                                            <i class="fas fa-eye"></i>
                                        </button>

                                        <%
                                            User currentUser = (User) session.getAttribute("user");
                                            if (currentUser.getId() == feedback.getUserId()) {
                                        %>
                                        <!-- Edit Button -->
                                        <a href="feedback?action=edit&id=<%= feedback.getId() %>" 
                                           class="btn-icon btn-edit" 
                                           title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <% 
                                            }
                                        %>

                                        <!-- Delete Button -->
                                        <button type="button" 
                                                class="btn-icon btn-delete" 
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
                                <td colspan="7" class="no-feedback">
                                    <i class="fas fa-comments"></i><br>
                                    No feedback records found<br>
                                    <small>Try adjusting your filters or submit some feedback!</small>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </form>
            </div>
        </div>
    </div>

    <!-- Preview Modal -->
    <div id="previewModal" class="modal">
        <div class="modal-content">
            <!-- Modal Header -->
            <div class="modal-header">
                <h2><i class="fas fa-eye"></i> Feedback Preview</h2>
                <button class="close" onclick="closeModal()">&times;</button>
            </div>

            <!-- Modal Body -->
            <div class="modal-body">
                <!-- Feedback Information Section -->
                <div class="feedback-info">
                    <h3>Feedback Details</h3>
                    <div class="feedback-meta">
                        <!-- User Information -->
                        <div class="meta-item">
                            <span class="meta-label">User</span>
                            <div class="meta-value" id="modalUser">
                                <div class="user-info">
                                    <div class="user-name">
                                        <i class="fas fa-user"></i>
                                        <span id="modalUserName">-</span>
                                    </div>
                                    <div class="user-email" id="modalUserEmail">-</div>
                                </div>
                            </div>
                        </div>

                        <!-- Feedback Type -->
                        <div class="meta-item">
                            <span class="meta-label">Type</span>
                            <span class="meta-value" id="modalFeedbackType">-</span>
                        </div>

                        <!-- Rating -->
                        <div class="meta-item">
                            <span class="meta-label">Rating</span>
                            <div class="meta-value" id="modalRating">-</div>
                        </div>

                        <!-- Date -->
                        <div class="meta-item">
                            <span class="meta-label">Date</span>
                            <span class="meta-value" id="modalDate">-</span>
                        </div>
                    </div>
                </div>
                
                <!-- Feedback Content -->
                <div class="feedback-content" id="modalContent">
                    Loading content...
                </div>
                
                <!-- Modal Actions -->
                <div class="modal-actions">
                    <a href="#" id="modalEditBtn" class="modal-btn modal-btn-edit">
                        <i class="fas fa-edit"></i> Edit
                    </a>

                    <button type="button" id="modalDeleteBtn" class="modal-btn modal-btn-delete">
                        <i class="fas fa-trash"></i> Delete
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="Resources/JavaScript/FeedbackHistory.js"></script>
</body>
</html>

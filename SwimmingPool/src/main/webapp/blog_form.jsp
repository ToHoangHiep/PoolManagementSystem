<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Blogs" %>
<%@ page import="model.User" %>
<%@ page import="model.SwimCourse" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%=request.getAttribute("is_edit") != null ? "Edit Blog" : "Create New Blog"%> - Swimming Pool Management</title>
    <!-- Bootstrap 5.3.7 CSS -->
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="Resources/CSS/BlogsForm.css">
</head>

<body class="bg-light">
    <%
        // Get attributes from request
        Blogs blog = (Blogs) request.getAttribute("blog");
        List<SwimCourse> courses = (List<SwimCourse>) request.getAttribute("courses");
        User currentUser = (User) request.getSession().getAttribute("user");
        boolean isLoggedIn = currentUser != null;
        boolean isEditMode = request.getAttribute("is_edit") != null;
        
        String success = (String) request.getAttribute("success");
        String error = (String) request.getAttribute("error");
        
        // Redirect if not logged in
        if (!isLoggedIn) {
            response.sendRedirect("login.jsp");
            return;
        }
    %>

    <%
        if (request.getAttribute("alert_message") != null) {
            String alertMessage = (String) request.getAttribute("alert_message");
            String alertAction = (String) request.getAttribute("alert_action");
            boolean existPostAction = request.getAttribute("alert_action") != null;
    %>
    <!-- Bootstrap Toast Notification -->
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
            window.location.href = "<%= alertAction %>";
        }, 2000);
        <% } %>
    </script>
    <%
        }
    %>

    <div class="container-fluid py-4">
        <div class="row justify-content-center">
            <div class="col-12 col-xl-10">
                <!-- Header Section -->
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-body py-4 bg-gradient-primary text-white">
                        <div class="row align-items-center">
                            <div class="col">
                                <nav aria-label="breadcrumb">
                                    <ol class="breadcrumb mb-2 text-white-50">
                                        <li class="breadcrumb-item">
                                            <a href="home.jsp" class="text-white text-decoration-none">
                                                <i class="fas fa-home me-1"></i>Home
                                            </a>
                                        </li>
                                        <li class="breadcrumb-item">
                                            <a href="blogs?action=list" class="text-white text-decoration-none">
                                                <i class="fas fa-blog me-1"></i>Blogs
                                            </a>
                                        </li>
                                        <li class="breadcrumb-item active text-white" aria-current="page">
                                            <%= isEditMode ? "Edit Blog" : "Create Blog" %>
                                        </li>
                                    </ol>
                                </nav>
                                <h1 class="h2 mb-1 fw-bold">
                                    <i class="fas fa-<%= isEditMode ? "edit" : "pen-nib" %> me-3"></i>
                                    <%= isEditMode ? "Edit Blog Post" : "Create New Blog Post" %>
                                </h1>
                                <p class="mb-0 opacity-75">
                                    <%= isEditMode ? "Update your blog post content and settings" : "Share your swimming knowledge with the community" %>
                                </p>
                                <% if (isEditMode && blog != null) { %>
                                <small class="opacity-50 d-block mt-2">
                                    <i class="fas fa-clock me-1"></i>
                                    Last updated: <%= new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm").format(blog.getPublishedAt()) %>
                                </small>
                                <% } %>
                            </div>
                            <div class="col-auto">
                                <div class="text-center">
                                    <i class="fas fa-blog fa-3x opacity-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <!-- Main Form -->
                    <div class="col-lg-8">
                        <div class="card border-0 shadow-sm">
                            <div class="card-body p-4">
                                <!-- Display success/error messages -->
                                <% if (success != null) { %>
                                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                                        <i class="fas fa-check-circle me-2"></i><%= success %>
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                <% } %>
                                
                                <% if (error != null) { %>
                                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                        <i class="fas fa-exclamation-triangle me-2"></i><%= error %>
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                <% } %>

                                <form method="post" action="blogs?action=<%= isEditMode ? "update" : "create" %>" id="blogForm">
                                    <% if (isEditMode && blog != null) { %>
                                        <input type="hidden" name="id" value="<%= blog.getId() %>">
                                    <% } %>

                                    <!-- Title Field -->
                                    <div class="mb-4">
                                        <label for="title" class="form-label fw-semibold">
                                            <i class="fas fa-heading me-2 text-primary"></i>Blog Title
                                        </label>
                                        <input type="text" class="form-control form-control-lg" id="title" name="title" 
                                               value="<%= blog != null ? blog.getTitle() : "" %>" 
                                               required maxlength="255"
                                               placeholder="Enter an engaging and descriptive title...">
                                        <div class="form-text d-flex justify-content-between">
                                            <span><i class="fas fa-info-circle me-1"></i>Create a compelling title that describes your content</span>
                                            <span id="titleCount" class="text-muted">0/255</span>
                                        </div>
                                    </div>

                                    <!-- Content Field -->
                                    <div class="mb-4">
                                        <label for="content" class="form-label fw-semibold">
                                            <i class="fas fa-file-text me-2 text-primary"></i>Blog Content
                                        </label>
                                        <div class="position-relative">
                                            <textarea class="form-control" id="content" name="content" rows="15" 
                                                      required maxlength="10000"
                                                      placeholder="Write your blog content here. Share your knowledge, tips, and experiences with the swimming community..."><%= blog != null ? blog.getContent() : "" %></textarea>
                                            <div class="position-absolute bottom-0 end-0 p-2">
                                                <small id="contentCount" class="text-muted bg-white px-2 py-1 rounded">0/10000</small>
                                            </div>
                                        </div>
                                        <div class="form-text">
                                            <i class="fas fa-lightbulb me-1"></i>Use clear paragraphs and detailed explanations to help other swimmers
                                        </div>
                                    </div>

                                    <!-- Course Selection -->
                                    <div class="mb-4">
                                        <label for="course_id" class="form-label fw-semibold">
                                            <i class="fas fa-graduation-cap me-2 text-success"></i>Related Course (Optional)
                                        </label>
                                        <select class="form-select form-select-lg" id="course_id" name="course_id">
                                            <option value="">Select a course (optional)</option>
                                            <% if (courses != null) {
                                                for (SwimCourse course : courses) { %>
                                                    <option value="<%= course.getId() %>"
                                                            <%= (blog != null && blog.getCourseId() == course.getId()) ? "selected" : "" %>>
                                                        <%= course.getName() %>
                                                    </option>
                                            <% } } %>
                                        </select>
                                        <div class="form-text">
                                            <i class="fas fa-link me-1"></i>Link this blog to a specific swimming course if it's relevant to the content
                                        </div>
                                    </div>

                                    <!-- Tags Field -->
                                    <div class="mb-4">
                                        <label for="tags" class="form-label fw-semibold">
                                            <i class="fas fa-tags me-2 text-warning"></i>Tags (Optional)
                                        </label>
                                        <input type="text" class="form-control form-control-lg" id="tags" name="tags" 
                                               value="<%= blog != null && blog.getTags() != null ? blog.getTags() : "" %>" 
                                               placeholder="swimming, technique, beginner, training, tips, safety">
                                        <div class="form-text">
                                            <i class="fas fa-hashtag me-1"></i>Separate tags with commas. Good tags help others find your content
                                        </div>
                                        <div id="tagSuggestions" class="mt-2"></div>
                                    </div>

                                    <!-- Error Display -->
                                    <div id="errorAlert" class="alert alert-danger d-none" role="alert">
                                        <i class="fas fa-exclamation-triangle me-2"></i>
                                        <span id="errorMessage"></span>
                                    </div>

                                    <!-- Action Buttons -->
                                    <div class="d-flex gap-2 flex-wrap justify-content-between">
                                        <div class="d-flex gap-2 flex-wrap">
                                            <button type="submit" class="btn btn-primary btn-lg px-4" id="submitBtn">
                                                <i class="fas fa-<%= isEditMode ? "save" : "rocket" %> me-2"></i>
                                                <%= isEditMode ? "Update Blog" : "Publish Blog" %>
                                            </button>
                                            
                                            <% if (!isEditMode) { %>
                                                <button type="button" class="btn btn-outline-secondary btn-lg" onclick="saveDraft()">
                                                    <i class="fas fa-save me-2"></i>Save Draft
                                                </button>
                                            <% } %>
                                        </div>
                                        
                                        <div class="d-flex gap-2 flex-wrap">
                                            <a href="blogs?action=list" class="btn btn-secondary btn-lg">
                                                <i class="fas fa-times me-2"></i>Cancel
                                            </a>
                                            
                                            <% if (isEditMode && blog != null) { %>
                                                <a href="blogs?action=view&id=<%= blog.getId() %>" class="btn btn-info btn-lg">
                                                    <i class="fas fa-eye me-2"></i>Preview
                                                </a>
                                            <% } %>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Sidebar -->
                    <div class="col-lg-4">
                        <!-- Help & Tips Card -->
                        <div class="card border-0 shadow-sm mb-4">
                            <div class="card-header bg-light">
                                <h6 class="card-title mb-0">
                                    <i class="fas fa-lightbulb me-2 text-warning"></i>Writing Tips
                                </h6>
                            </div>
                            <div class="card-body">
                                <div class="list-group list-group-flush">
                                    <div class="list-group-item border-0 px-0">
                                        <i class="fas fa-check-circle text-success me-2"></i>
                                        <small>Use clear, descriptive titles</small>
                                    </div>
                                    <div class="list-group-item border-0 px-0">
                                        <i class="fas fa-check-circle text-success me-2"></i>
                                        <small>Break content into paragraphs</small>
                                    </div>
                                    <div class="list-group-item border-0 px-0">
                                        <i class="fas fa-check-circle text-success me-2"></i>
                                        <small>Share personal experiences</small>
                                    </div>
                                    <div class="list-group-item border-0 px-0">
                                        <i class="fas fa-check-circle text-success me-2"></i>
                                        <small>Include safety considerations</small>
                                    </div>
                                    <div class="list-group-item border-0 px-0">
                                        <i class="fas fa-check-circle text-success me-2"></i>
                                        <small>Use relevant tags for discovery</small>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Popular Tags Card -->
                        <div class="card border-0 shadow-sm mb-4">
                            <div class="card-header bg-light">
                                <h6 class="card-title mb-0">
                                    <i class="fas fa-fire me-2 text-danger"></i>Popular Tags
                                </h6>
                            </div>
                            <div class="card-body">
                                <div class="d-flex flex-wrap gap-2">
                                    <span class="badge bg-primary cursor-pointer" onclick="addTag('swimming')">swimming</span>
                                    <span class="badge bg-secondary cursor-pointer" onclick="addTag('technique')">technique</span>
                                    <span class="badge bg-success cursor-pointer" onclick="addTag('beginner')">beginner</span>
                                    <span class="badge bg-warning cursor-pointer" onclick="addTag('training')">training</span>
                                    <span class="badge bg-info cursor-pointer" onclick="addTag('safety')">safety</span>
                                    <span class="badge bg-dark cursor-pointer" onclick="addTag('tips')">tips</span>
                                    <span class="badge bg-primary cursor-pointer" onclick="addTag('advanced')">advanced</span>
                                    <span class="badge bg-secondary cursor-pointer" onclick="addTag('freestyle')">freestyle</span>
                                </div>
                                <small class="text-muted mt-2 d-block">Click to add to your tags</small>
                            </div>
                        </div>

                        <!-- Auto-save Status -->
                        <div class="card border-0 shadow-sm">
                            <div class="card-body text-center">
                                <div id="autoSaveStatus" class="text-muted">
                                    <i class="fas fa-cloud me-2"></i>
                                    <small>Auto-save enabled</small>
                                </div>
                                <% if (isEditMode && blog != null) { %>
                                <div class="mt-3">
                                    <button type="button" class="btn btn-outline-danger btn-sm w-100" 
                                            onclick="confirmDelete()">
                                        <i class="fas fa-trash me-2"></i>Delete Blog
                                    </button>
                                </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <% if (isEditMode && blog != null) { %>
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header border-0">
                    <h5 class="modal-title" id="deleteModalLabel">
                        <i class="fas fa-exclamation-triangle text-danger me-2"></i>Delete Blog Post
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete this blog post?</p>
                    <div class="alert alert-warning">
                        <i class="fas fa-warning me-2"></i>
                        <strong>This action cannot be undone.</strong> The blog post and all its content will be permanently removed.
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <a href="blogs?action=delete&id=<%= blog.getId() %>" class="btn btn-danger">
                        <i class="fas fa-trash me-2"></i>Delete Blog
                    </a>
                </div>
            </div>
        </div>
    </div>
    <% } %>

    <!-- Bootstrap 5.3.7 JS -->
    <script src="Resources/bootstrap/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JavaScript -->
    <script src="Resources/JavaScript/BlogsForm.js"></script>

    <script>
    // Initialize on page load
    document.addEventListener('DOMContentLoaded', function() {
        // Initialize Bootstrap tooltips
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
        
        // Load draft if creating new blog
        <% if (!isEditMode) { %>
        loadDraft();
        <% } %>
    });

    // Confirm delete function
    function confirmDelete() {
        const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
        deleteModal.show();
    }
    </script>
</body>
</html>
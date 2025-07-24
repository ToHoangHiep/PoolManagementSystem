<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Blogs" %>
<%@ page import="model.BlogsComment" %>
<%@ page import="model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="dal.BlogsCommentDAO" %>
<%@ page import="java.util.Arrays" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Blog Detail - Swimming Pool Community</title>
    <!-- Bootstrap 5.3.7 CSS -->
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f8f9fa;
            line-height: 1.6;
        }
        .blog-header {
            background: linear-gradient(135deg, #007bff 0%, #6610f2 100%);
            color: white;
            padding: 60px 0;
            margin-bottom: 0;
        }
        .blog-meta {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            padding: 20px;
            margin-top: 30px;
        }
        .blog-content {
            font-size: 1.1rem;
            line-height: 1.8;
            color: #333;
        }
        .tag {
            background: linear-gradient(135deg, #007bff, #6610f2);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
            margin: 5px;
            display: inline-block;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .tag:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        .comment-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }
        .comment-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 20px rgba(0,0,0,0.12);
        }
        .comment-author {
            font-weight: 600;
            color: #007bff;
        }
        .guest-notice {
            background: linear-gradient(135deg, #17a2b8, #20c997);
            border-radius: 15px;
            border: none;
        }
        .stats-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 20px;
            margin: 20px 0;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .btn-gradient {
            background: linear-gradient(135deg, #007bff, #6610f2);
            border: none;
            border-radius: 25px;
            padding: 12px 30px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .btn-gradient:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        .section-divider {
            height: 3px;
            background: linear-gradient(135deg, #007bff, #6610f2);
            border-radius: 10px;
            margin: 40px 0;
        }
    </style>
</head>

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
            <strong class="me-auto">Blog System</strong>
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

<body>
    <%
        Blogs blog = (Blogs) request.getAttribute("blog");
        List<BlogsComment> comments = (List<BlogsComment>) request.getAttribute("comments");
        User currentUser = (User) request.getSession().getAttribute("user");
        boolean isLoggedIn = currentUser != null;
        boolean canEdit = (blog != null && (isLoggedIn && (currentUser.getId() == blog.getAuthorId())));
        boolean isAdmin = isLoggedIn && !Arrays.asList(3,4,5).contains(currentUser.getRole().getId());
        
        String success = (String) request.getAttribute("success");
        String error = (String) request.getAttribute("error");
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy 'at' HH:mm");
        SimpleDateFormat shortDateFormat = new SimpleDateFormat("MMM dd, yyyy");
    %>

    <!-- Blog Header Section -->
    <div class="blog-header">
        <div class="container">
            <!-- Breadcrumb -->
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-4 text-white-50">
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
                        <%= blog.getTitle().length() > 50 ? blog.getTitle().substring(0, 50) + "..." : blog.getTitle() %>
                    </li>
                </ol>
            </nav>

            <div class="row">
                <div class="col-lg-8">
                    <h1 class="display-5 fw-bold mb-3"><%= blog.getTitle() %></h1>
                    
                    <div class="blog-meta">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <div class="d-flex align-items-center mb-3">
                                    <div class="bg-white bg-opacity-20 rounded-circle p-2 me-3">
                                        <i class="fas fa-user-circle fa-2x"></i>
                                    </div>
                                    <div>
                                        <h5 class="mb-0"><%= blog.getAuthorName() %></h5>
                                        <small class="opacity-75">
                                            <i class="fas fa-calendar me-1"></i>
                                            <%= shortDateFormat.format(blog.getPublishedAt()) %>
                                        </small>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="text-md-end">
                                    <div class="d-flex flex-column gap-2">
                                        <div class="d-flex align-items-center justify-content-md-end">
                                            <i class="fas fa-heart text-danger me-2"></i>
                                            <span><%= blog.getLikes() %> likes</span>
                                        </div>
                                        <div class="d-flex align-items-center justify-content-md-end">
                                            <i class="fas fa-comments me-2"></i>
                                            <span><%= comments != null ? comments.size() : 0 %> comments</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <% if (isLoggedIn && (canEdit || isAdmin)) { %>
                    <div class="text-lg-end mt-4">
                        <div class="btn-group-vertical d-grid gap-2">
                            <% if (canEdit) { %>
                            <a href="blogs?action=edit&id=<%= blog.getId() %>" class="btn btn-light btn-lg">
                                <i class="fas fa-edit me-2"></i>Edit Blog
                            </a>
                            <% } %>
                            <% if (canEdit || isAdmin) { %>
                            <button onclick="confirmDelete(<%= blog.getId() %>)" class="btn btn-outline-light btn-lg">
                                <i class="fas fa-trash me-2"></i>Delete Blog
                            </button>
                            <% } %>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <div class="container my-5">
        <!-- Guest Notice -->
        <% if (!isLoggedIn) { %>
        <div class="alert guest-notice alert-dismissible fade show" role="alert">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h5 class="alert-heading text-white mb-2">
                        <i class="fas fa-info-circle me-2"></i>Reading as Guest
                    </h5>
                    <p class="text-white mb-0">You can read this blog post. Sign in to comment and interact with the community!</p>
                </div>
                <div class="col-md-4 text-md-end mt-3 mt-md-0">
                    <a href="login.jsp" class="btn btn-light me-2">
                        <i class="fas fa-sign-in-alt me-1"></i>Sign In
                    </a>
                    <a href="register.jsp" class="btn btn-outline-light">
                        <i class="fas fa-user-plus me-1"></i>Register
                    </a>
                </div>
            </div>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% } %>

        <!-- Success/Error Messages -->
        <% if (success != null) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i><%= success %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>
        
        <% if (error != null) { %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i><%= error %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <div class="row">
            <div class="col-lg-8">
                <!-- Blog Content -->
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-body p-5">
                        <div class="blog-content">
                            <%= blog.getContent().replaceAll("\n", "<br>") %>
                        </div>

                        <!-- Tags -->
                        <% if (blog.getTags() != null && !blog.getTags().trim().isEmpty()) { %>
                        <div class="section-divider"></div>
                        <div class="mb-4">
                            <h6 class="text-muted mb-3">
                                <i class="fas fa-tags me-2"></i>Related Topics
                            </h6>
                            <% String[] tags = blog.getTags().split(",");
                               for (String tag : tags) { 
                                   if (!tag.trim().isEmpty()) { %>
                            <span class="tag"><%= tag.trim() %></span>
                            <% } } %>
                        </div>
                        <% } %>
                    </div>
                </div>

                <!-- Comments Section -->
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-primary text-white py-3">
                        <h4 class="mb-0">
                            <i class="fas fa-comments me-2"></i>
                            Comments (<%= comments != null ? comments.size() : 0 %>)
                        </h4>
                    </div>
                    <div class="card-body p-4">
                        <!-- Add Comment Form -->
                        <% if (isLoggedIn) { %>
                        <div class="mb-4">
                            <h5 class="mb-3">Add Your Comment</h5>
                            <form action="blogs?action=add_comment&id=<%= blog.getId() %>" method="post">
                                
                                <div class="mb-3">
                                    <label for="content" class="form-label">Your thoughts</label>
                                    <textarea name="content" id="content" class="form-control" rows="4"
                                              required placeholder="Share your thoughts about this blog post..."></textarea>
                                </div>
                                
                                <button type="submit" class="btn btn-gradient text-white">
                                    <i class="fas fa-comment me-2"></i>Post Comment
                                </button>
                            </form>
                        </div>
                        <hr>
                        <% } else { %>
                        <div class="mb-4 p-4 bg-light rounded">
                            <h5 class="mb-3">Add Your Comment</h5>
                            <textarea class="form-control mb-3" rows="4" disabled 
                                      placeholder="Sign in to share your thoughts..."></textarea>
                            <button type="button" onclick="showSignInModal()" class="btn btn-secondary">
                                <i class="fas fa-sign-in-alt me-2"></i>Sign In to Comment
                            </button>
                        </div>
                        <hr>
                        <% } %>

                        <!-- Comments List -->
                        <% if (comments != null && !comments.isEmpty()) {
                            for (BlogsComment comment : comments) { %>
                        <div class="comment-card card mb-3" id="comment-<%= comment.getId() %>">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div class="d-flex align-items-center">
                                        <div class="bg-primary bg-opacity-10 rounded-circle p-2 me-3">
                                            <i class="fas fa-user-circle fa-lg text-primary"></i>
                                        </div>
                                        <div>
                                            <h6 class="comment-author mb-0"><%= comment.getUserName() %></h6>
                                            <small class="text-muted">
                                                <i class="fas fa-clock me-1"></i>
                                                <%= dateFormat.format(comment.getCreatedAt()) %>
                                            </small>
                                        </div>
                                    </div>
                                    
                                    <% if (isLoggedIn && (isAdmin || comment.getUserId() == currentUser.getId())) { %>
                                    <div class="dropdown">
                                        <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" 
                                                data-bs-toggle="dropdown" aria-expanded="false">
                                            <i class="fas fa-ellipsis-v"></i>
                                        </button>
                                        <ul class="dropdown-menu">
                                            <% if (comment.getUserId() == currentUser.getId()) { %>
                                            <li>
                                                <button class="dropdown-item" onclick="toggleEditComment(<%= comment.getId() %>)">
                                                    <i class="fas fa-edit me-2"></i>Edit
                                                </button>
                                            </li>
                                            <% } %>
                                            <% if (isAdmin || comment.getUserId() == currentUser.getId()) { %>
                                            <li>
                                                <button class="dropdown-item text-danger" 
                                                        onclick="confirmDeleteComment(<%= comment.getId() %>, <%= blog.getId() %>)">
                                                    <i class="fas fa-trash me-2"></i>Delete
                                                </button>
                                            </li>
                                            <% } %>
                                        </ul>
                                    </div>
                                    <% } %>
                                </div>
                                
                                <div class="comment-content" id="content-<%= comment.getId() %>">
                                    <p class="mb-0"><%= comment.getContent().replaceAll("\n", "<br>") %></p>
                                </div>
                                
                                <!-- Edit Comment Form -->
                                <div class="edit-form mt-3 d-none" id="edit-form-<%= comment.getId() %>">
                                    <form action="blogs?action=edit_comment&id=<%= comment.getId() %>&comment_id=<%= comment.getId() %>" method="post">

                                        <div class="mb-3">
                                            <textarea name="content" class="form-control" rows="3" required><%= comment.getContent() %></textarea>
                                        </div>
                                        
                                        <div class="d-flex gap-2">
                                            <button type="submit" class="btn btn-primary btn-sm">
                                                <i class="fas fa-save me-1"></i>Save
                                            </button>
                                            <button type="button" onclick="toggleEditComment(<%= comment.getId() %>)" 
                                                    class="btn btn-secondary btn-sm">
                                                <i class="fas fa-times me-1"></i>Cancel
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                        <% } } else { %>
                        <div class="text-center py-5">
                            <i class="fas fa-comments fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">No comments yet</h5>
                            <p class="text-muted">Be the first to share your thoughts on this blog!</p>
                            <% if (!isLoggedIn) { %>
                            <button onclick="showSignInModal()" class="btn btn-gradient text-white">
                                <i class="fas fa-comment me-2"></i>Sign In to Comment
                            </button>
                            <% } %>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Sidebar -->
            <div class="col-lg-4">
                <!-- Blog Stats -->
                <div class="stats-card">
                    <h5 class="mb-3">
                        <i class="fas fa-chart-bar me-2 text-primary"></i>Blog Statistics
                    </h5>
                    <div class="row text-center">
                        <div class="col-6">
                            <div class="border-end">
                                <h3 class="text-danger mb-1"><%= blog.getLikes() %></h3>
                                <small class="text-muted">Likes</small>
                            </div>
                        </div>
                        <div class="col-6">
                            <h3 class="text-primary mb-1"><%= comments != null ? comments.size() : 0 %></h3>
                            <small class="text-muted">Comments</small>
                        </div>
                    </div>
                </div>

                <!-- Share Section -->
                <div class="card border-0 shadow-sm">
                    <div class="card-body text-center">
                        <h5 class="mb-3">
                            <i class="fas fa-share-alt me-2 text-primary"></i>Share this Blog
                        </h5>
                        <div class="d-grid gap-2">
                            <button onclick="copyToClipboard()" class="btn btn-outline-primary">
                                <i class="fas fa-copy me-2"></i>Copy Link
                            </button>
                            <a href="blogs?action=list" class="btn btn-primary">
                                <i class="fas fa-arrow-left me-2"></i>Back to Blogs
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Sign In Modal -->
    <div class="modal fade" id="signInModal" tabindex="-1" aria-labelledby="signInModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header border-0">
                    <h5 class="modal-title" id="signInModalLabel">
                        <i class="fas fa-lock me-2"></i>Sign In Required
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center">
                    <p class="mb-4">Please sign in to interact with blog posts and join the conversation.</p>
                    <div class="d-grid gap-2 d-md-flex justify-content-md-center">
                        <a href="login.jsp" class="btn btn-primary">
                            <i class="fas fa-sign-in-alt me-2"></i>Sign In
                        </a>
                        <a href="register.jsp" class="btn btn-outline-primary">
                            <i class="fas fa-user-plus me-2"></i>Create Account
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5.3.7 JS -->
    <script src="Resources/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script>
        function showSignInModal() {
            const modal = new bootstrap.Modal(document.getElementById('signInModal'));
            modal.show();
        }

        function toggleEditComment(commentId) {
            const content = document.getElementById('content-' + commentId);
            const editForm = document.getElementById('edit-form-' + commentId);
            
            if (editForm.classList.contains('d-none')) {
                content.classList.add('d-none');
                editForm.classList.remove('d-none');
            } else {
                content.classList.remove('d-none');
                editForm.classList.add('d-none');
            }
        }

        function confirmDelete(blogId) {
            if (confirm('Are you sure you want to delete this blog post? This action cannot be undone.')) {
                window.location.href = 'blogs?action=delete&id=' + blogId;
            }
        }

        function confirmDeleteComment(commentId, blogId) {
            if (confirm('Are you sure you want to delete this comment? This action cannot be undone.')) {
                window.location.href = 'blogs?action=delete_comment&comment_id=' + commentId + '&blog_id=' + blogId;
            }
        }

        function copyToClipboard() {
            navigator.clipboard.writeText(window.location.href).then(function() {
                const toast = new bootstrap.Toast(document.querySelector('.toast'));
                document.querySelector('.toast-body').textContent = 'Blog link copied to clipboard!';
                toast.show();
            });
        }

        // Initialize tooltips
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
    </script>
</body>
</html>
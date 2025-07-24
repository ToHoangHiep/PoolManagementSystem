<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Blogs" %>
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
    <title>Swimming Pool Blog Community</title>
    <!-- Bootstrap CSS -->
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome CDN -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .hero-section {
            background: linear-gradient(135deg, #007bff 0%, #6610f2 100%);
            color: white;
            padding: 60px 0;
            margin-bottom: 30px;
        }
        .blog-card {
            transition: all 0.3s ease;
            border: none;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            height: 100%;
        }
        .blog-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }
        .tag-badge {
            background-color: #e9ecef;
            color: #495057;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.75rem;
            margin: 2px;
            display: inline-block;
        }
        .filter-section {
            background: white;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        .guest-banner {
            background: linear-gradient(45deg, #17a2b8, #20c997);
            color: white;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 30px;
        }
        .stat-info {
            background-color: #f8f9fa;
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 0.85rem;
            color: #6c757d;
        }
        .btn-action {
            padding: 6px 12px;
            font-size: 0.875rem;
        }
    </style>
</head>
<body>
<%
    List<Blogs> blogsList = (List<Blogs>) request.getAttribute("blogs_list");
    User currentUser = (User) request.getSession().getAttribute("user");
    boolean isLoggedIn = currentUser != null;
    boolean isAdmin = isLoggedIn && !Arrays.asList(3, 4).contains(currentUser.getRole().getId());

    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
    String message = request.getParameter("message");

    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
%>

<%
    if (request.getAttribute("alert_message") != null) {
        String alertMessage = (String) request.getAttribute("alert_message");
        String alertAction = (String) request.getAttribute("alert_action");
        boolean existPostAction = request.getAttribute("alert_action") != null;
%>
<script>
    alert("<%= alertMessage %>");
    if (<%= existPostAction %>) {
        window.location.href = "<%= alertAction %>";
    }
</script>
<%
    }
%>

<!-- Hero Section -->
<div class="hero-section">
    <div class="container">
        <div class="row">
            <div class="col-12 text-center">
                <h1 class="display-4 mb-3">
                    <i class="fas fa-swimming-pool me-3"></i>Swimming Pool Blog
                </h1>
                <p class="lead">Share your swimming knowledge and experiences</p>
            </div>
        </div>
    </div>
</div>

<div class="container">
    <!-- Guest Banner -->
    <% if (!isLoggedIn) { %>
    <div class="guest-banner">
        <div class="row align-items-center">
            <div class="col-md-8">
                <h4><i class="fas fa-info-circle me-2"></i>Welcome, Guest!</h4>
                <p class="mb-0">Browse and read blog posts. Sign in to create posts and interact with the community.</p>
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
    </div>
    <% } %>

    <!-- Alert Messages -->
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

    <% if (message != null) { %>
    <div class="alert alert-info alert-dismissible fade show" role="alert">
        <i class="fas fa-info-circle me-2"></i><%= message %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <!-- Header Actions -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-1">Community Blogs</h2>
            <% if (isLoggedIn) { %>
            <small class="text-muted">Welcome back, <%= currentUser.getFullName() %>!</small>
            <% } else { %>
            <small class="text-muted">Browsing as guest</small>
            <% } %>
        </div>
        <div>
            <% if (isLoggedIn) { %>
            <a href="blogs?action=create" class="btn btn-primary me-2">
                <i class="fas fa-plus me-1"></i>Create Blog
            </a>
            <% } %>
            <a href="home.jsp" class="btn btn-outline-secondary">
                <i class="fas fa-home me-1"></i>Home
            </a>
        </div>
    </div>

    <!-- Filter Section -->
    <div class="filter-section">
        <h5 class="mb-3"><i class="fas fa-filter me-2"></i>Filter & Sort</h5>
        <form action="blogs?action=sort" method="get">
            <div class="row g-3">
                <div class="col-md-6 col-lg-3">
                    <label for="min_likes" class="form-label">Min Likes</label>
                    <input type="number" name="min_likes" id="min_likes" class="form-control" placeholder="0" min="0"
                           value="<%= request.getAttribute("min_likes") != null ? request.getAttribute("min_likes") : "" %>">
                </div>
                <div class="col-md-6 col-lg-3">
                    <label for="start_date" class="form-label">From Date</label>
                    <input type="date" name="start_date" id="start_date" class="form-control"
                           value="<%= request.getAttribute("start_date") != null ? request.getAttribute("start_date") : "" %>">
                </div>
                <div class="col-md-6 col-lg-3">
                    <label for="end_date" class="form-label">To Date</label>
                    <input type="date" name="end_date" id="end_date" class="form-control"
                           value="<%= request.getAttribute("end_date") != null ? request.getAttribute("end_date") : "" %>">
                </div>
                <div class="col-md-6 col-lg-3">
                    <label for="sort_by" class="form-label">Sort By</label>
                    <select name="sort_by" id="sort_by" class="form-select">
                        <option value="published_at" <%= "published_at".equals(request.getAttribute("sort_by")) ? "selected" : "" %>>Date</option>
                        <option value="likes" <%= "likes".equals(request.getAttribute("sort_by")) ? "selected" : "" %>>Likes</option>
                        <option value="title" <%= "title".equals(request.getAttribute("sort_by")) ? "selected" : "" %>>Title</option>
                    </select>
                </div>
            </div>
            <div class="row mt-3">
                <div class="col-md-6 col-lg-3">
                    <label for="sort_order" class="form-label">Order</label>
                    <select name="sort_order" id="sort_order" class="form-select">
                        <option value="desc" <%= "desc".equals(request.getAttribute("sort_order")) ? "selected" : "" %>>Newest First</option>
                        <option value="asc" <%= "asc".equals(request.getAttribute("sort_order")) ? "selected" : "" %>>Oldest First</option>
                    </select>
                </div>
                <div class="col-md-6 col-lg-3 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-search me-1"></i>Apply Filters
                    </button>
                </div>
            </div>
        </form>
    </div>

    <!-- Blog Posts Grid -->
    <div class="row g-4">
        <% if (blogsList != null && !blogsList.isEmpty()) {
            // Temporarily show all blogs (remove .filter(Blogs::isActive) for testing)
            List<Blogs> sortedBlogs = blogsList; // Show all blogs
            for (Blogs blog : sortedBlogs) { %>
        <div class="col-lg-4 col-md-6">
            <div class="card blog-card">
                <div class="card-header bg-white">
                    <h5 class="card-title mb-2"><%= blog.getTitle() %></h5>
                    <div class="d-flex justify-content-between align-items-center">
                        <small class="text-muted">
                            <i class="fas fa-user me-1"></i><%= blog.getAuthorName() %>
                        </small>
                        <small class="text-muted"><%= dateFormat.format(blog.getPublishedAt()) %></small>
                    </div>
                </div>

                <div class="card-body">
                    <p class="card-text text-muted">
                        <%= blog.getContent().length() > 120 ? 
                            blog.getContent().substring(0, 120) + "..." : 
                            blog.getContent() %>
                    </p>

                    <% if (blog.getTags() != null && !blog.getTags().trim().isEmpty()) { %>
                    <div class="mb-3">
                        <% String[] tags = blog.getTags().split(",");
                            for (String tag : tags) {
                                if (!tag.trim().isEmpty()) { %>
                        <span class="tag-badge"><%= tag.trim() %></span>
                        <% }
                        } %>
                    </div>
                    <% } %>

                    <div class="d-flex justify-content-between align-items-center">
                        <div class="d-flex gap-2">
                            <span class="stat-info">
                                <i class="fas fa-heart text-danger me-1"></i><%= blog.getLikes() %>
                            </span>
                            <span class="stat-info">
                                <i class="fas fa-comment text-primary me-1"></i><%= BlogsCommentDAO.getCommentsCount(blog.getId()) %>
                            </span>
                        </div>
                    </div>
                </div>

                <div class="card-footer bg-white">
                    <div class="d-flex gap-2 flex-wrap">
                        <a href="${pageContext.request.contextPath}/blogs?action=view&id=<%= blog.getId() %>" 
                           class="btn btn-outline-primary btn-action flex-fill">
                            <i class="fas fa-eye me-1"></i>Read
                        </a>

                        <% if (isLoggedIn) {
                            if (blog.getAuthorId() == currentUser.getId()) {
                        %>
                        <a href="blogs?action=edit&id=<%= blog.getId() %>" 
                           class="btn btn-outline-secondary btn-action">
                            <i class="fas fa-edit me-1"></i>Edit
                        </a>
                        <%
                            }

                            if ((isAdmin || blog.getAuthorId() == currentUser.getId())) {
                        %>
                        <button onclick="confirmDelete(<%= blog.getId() %>)" 
                                class="btn btn-outline-danger btn-action">
                            <i class="fas fa-trash me-1"></i>Delete
                        </button>
                        <%
                            }

                        } else { %>
                        <button onclick="showSignInPrompt()" 
                                class="btn btn-outline-secondary btn-action">
                            <i class="fas fa-edit me-1"></i>Edit
                        </button>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
        <% }
        } else { %>
        <div class="col-12">
            <div class="text-center py-5">
                <i class="fas fa-blog fa-4x text-muted mb-4"></i>
                <h3 class="text-muted">No blogs found</h3>
                <p class="text-muted mb-4">Be the first to share your swimming knowledge!</p>
                <% if (isLoggedIn && isAdmin) { %>
                <a href="blogs?action=create" class="btn btn-primary btn-lg">
                    <i class="fas fa-plus me-2"></i>Create First Blog
                </a>
                <% } else if (!isLoggedIn) { %>
                <button class="btn btn-secondary btn-lg" onclick="showSignInPrompt()">
                    <i class="fas fa-plus me-2"></i>Create First Blog
                </button>
                <% } %>
            </div>
        </div>
        <% } %>
    </div>
</div>

<!-- Sign In Modal -->
<div class="modal fade" id="signInModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-lock me-2"></i>Sign In Required
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body text-center">
                <p>Please sign in to interact with blog posts.</p>
                <div class="d-grid gap-2 d-md-flex justify-content-md-center">
                    <a href="login.jsp" class="btn btn-primary">
                        <i class="fas fa-sign-in-alt me-1"></i>Sign In
                    </a>
                    <a href="register.jsp" class="btn btn-outline-primary">
                        <i class="fas fa-user-plus me-1"></i>Register
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="Resources/bootstrap/js/bootstrap.bundle.min.js"></script>
<script>
    function showSignInPrompt() {
        const modal = new bootstrap.Modal(document.getElementById('signInModal'));
        modal.show();
    }

    function confirmDelete(blogId) {
        if (confirm('Are you sure you want to delete this blog post? This action cannot be undone.')) {
            window.location.href = 'blogs?action=delete&id=' + blogId;
        }
    }
</script>

</body>
</html>
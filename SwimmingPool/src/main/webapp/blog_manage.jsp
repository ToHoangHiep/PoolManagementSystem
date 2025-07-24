<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Blogs" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("/login");
        return;
    }
    
    // Check if user is admin or manager
    boolean isAdminOrManager = java.util.Arrays.asList(1, 2).contains(user.getRole().getId());
    if (!isAdminOrManager) {
        response.sendRedirect("/blogs");
        return;
    }
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy HH:mm");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Blog Management - Swimming Pool Management</title>
    <!-- Bootstrap 5.3.7 CSS -->
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="Resources/CSS/BlogsManagement.css">
</head>

<body class="bg-light">
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
                <strong class="me-auto">Blog Management</strong>
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

    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-gradient-primary shadow-sm">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="home.jsp">
                <i class="fas fa-swimming-pool me-2"></i>
                Swimming Pool Management
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="home.jsp">
                            <i class="fas fa-home me-1"></i>Home
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="blogs">
                            <i class="fas fa-blog me-1"></i>Public Blogs
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="blogs?action=manage">
                            <i class="fas fa-cogs me-1"></i>Manage Blogs
                        </a>
                    </li>
                </ul>
                
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user-circle me-1"></i>
                            <%= user.getFullName() %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="userprofile.jsp">
                                <i class="fas fa-user me-2"></i>Profile
                            </a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="logout">
                                <i class="fas fa-sign-out-alt me-2"></i>Logout
                            </a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container-fluid py-4">
        <!-- Header Section -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card border-0 shadow-sm">
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
                                            <a href="blogs" class="text-white text-decoration-none">
                                                <i class="fas fa-blog me-1"></i>Blogs
                                            </a>
                                        </li>
                                        <li class="breadcrumb-item active text-white" aria-current="page">Management</li>
                                    </ol>
                                </nav>
                                <h1 class="h2 mb-1 fw-bold">
                                    <i class="fas fa-cogs me-3"></i>Blog Management Dashboard
                                </h1>
                                <p class="mb-0 opacity-75">
                                    Manage blog posts, review submissions, and control publication status
                                </p>
                            </div>
                            <div class="col-auto">
                                <div class="text-center">
                                    <i class="fas fa-clipboard-list fa-3x opacity-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Statistics -->
        <%
            List<Blogs> allBlogs = (List<Blogs>) request.getAttribute("all_blogs");
            List<Blogs> inactiveBlogs = (List<Blogs>) request.getAttribute("inactive_blogs");
            
            int totalBlogs = allBlogs != null ? allBlogs.size() : 0;
            int totalInactive = inactiveBlogs != null ? inactiveBlogs.size() : 0;
            int totalActive = totalBlogs - totalInactive;
        %>
        
        <div class="row mb-4">
            <div class="col-md-4 mb-3">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-body text-center">
                        <div class="d-flex justify-content-center align-items-center mb-3">
                            <div class="bg-primary bg-opacity-10 rounded-circle p-3">
                                <i class="fas fa-blog fa-2x text-primary"></i>
                            </div>
                        </div>
                        <h3 class="fw-bold text-primary mb-1"><%= totalBlogs %></h3>
                        <p class="text-muted mb-0">Total Blogs</p>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4 mb-3">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-body text-center">
                        <div class="d-flex justify-content-center align-items-center mb-3">
                            <div class="bg-success bg-opacity-10 rounded-circle p-3">
                                <i class="fas fa-check-circle fa-2x text-success"></i>
                            </div>
                        </div>
                        <h3 class="fw-bold text-success mb-1"><%= totalActive %></h3>
                        <p class="text-muted mb-0">Active Blogs</p>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4 mb-3">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-body text-center">
                        <div class="d-flex justify-content-center align-items-center mb-3">
                            <div class="bg-warning bg-opacity-10 rounded-circle p-3">
                                <i class="fas fa-clock fa-2x text-warning"></i>
                            </div>
                        </div>
                        <h3 class="fw-bold text-warning mb-1"><%= totalInactive %></h3>
                        <p class="text-muted mb-0">Pending Approval</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filter and Search Controls -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card border-0 shadow-sm">
                    <div class="card-body">
                        <div class="row align-items-center">
                            <div class="col-md-6">
                                <div class="d-flex gap-2">
                                    <button class="btn btn-outline-primary" id="showAll" onclick="filterBlogs('all')">
                                        <i class="fas fa-list me-2"></i>All Blogs
                                    </button>
                                    <button class="btn btn-outline-success" id="showActive" onclick="filterBlogs('active')">
                                        <i class="fas fa-check me-2"></i>Active
                                    </button>
                                    <button class="btn btn-outline-warning" id="showPending" onclick="filterBlogs('pending')">
                                        <i class="fas fa-clock me-2"></i>Pending
                                    </button>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0">
                                        <i class="fas fa-search text-muted"></i>
                                    </span>
                                    <input type="text" class="form-control border-start-0" id="searchInput" 
                                           placeholder="Search blogs by title or author...">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Inactive Blogs Section -->
        <div class="row mb-4" id="pendingSection">
            <div class="col-12">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-light border-0 py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="card-title mb-0">
                                <i class="fas fa-exclamation-triangle text-warning me-2"></i>
                                Blogs Pending Approval (<%= totalInactive %>)
                            </h5>
                            <% if (totalInactive > 0) { %>
                            <button class="btn btn-success btn-sm" onclick="approveAllPending()">
                                <i class="fas fa-check-double me-2"></i>Approve All
                            </button>
                            <% } %>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <% if (inactiveBlogs != null && !inactiveBlogs.isEmpty()) { %>
                            <div class="table-responsive">
                                <table class="table table-hover mb-0" id="pendingBlogsTable">
                                    <thead class="table-light">
                                        <tr>
                                            <th class="ps-4">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" id="selectAllPending" onchange="toggleSelectAll('pending')">
                                                </div>
                                            </th>
                                            <th>Title</th>
                                            <th>Author</th>
                                            <th>Created Date</th>
                                            <th>Status</th>
                                            <th class="text-center">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (Blogs blog : inactiveBlogs) { %>
                                            <tr class="blog-row" data-status="pending" data-title="<%= blog.getTitle().toLowerCase() %>" data-author="<%= blog.getAuthorName().toLowerCase() %>">
                                                <td class="ps-4">
                                                    <div class="form-check">
                                                        <input class="form-check-input blog-checkbox" type="checkbox" value="<%= blog.getId() %>">
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="fw-semibold text-truncate" style="max-width: 300px;" title="<%= blog.getTitle() %>">
                                                        <%= blog.getTitle() %>
                                                    </div>
                                                    <small class="text-muted">ID: <%= blog.getId() %> | <i class="fas fa-heart text-danger"></i> <%= blog.getLikes() %></small>
                                                </td>
                                                <td>
                                                    <div class="fw-medium"><%= blog.getAuthorName() %></div>
                                                    <small class="text-muted">ID: <%= blog.getAuthorId() %></small>
                                                </td>
                                                <td>
                                                    <div><%= dateFormat.format(blog.getPublishedAt()) %></div>
                                                </td>
                                                <td>
                                                    <span class="badge bg-warning">
                                                        <i class="fas fa-clock me-1"></i>Pending
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="d-flex gap-1 justify-content-center">
                                                        <a href="blogs?action=view&id=<%= blog.getId() %>" 
                                                           class="btn btn-outline-primary btn-sm" 
                                                           data-bs-toggle="tooltip" title="View Blog">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <button type="button" 
                                                                class="btn btn-success btn-sm" 
                                                                onclick="activateBlog(<%= blog.getId() %>)"
                                                                data-bs-toggle="tooltip" title="Approve Blog">
                                                            <i class="fas fa-check"></i>
                                                        </button>
                                                        <button type="button" 
                                                                class="btn btn-danger btn-sm" 
                                                                onclick="deleteBlog(<%= blog.getId() %>)"
                                                                data-bs-toggle="tooltip" title="Delete Blog">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        <% } else { %>
                            <div class="text-center py-5">
                                <i class="fas fa-check-circle fa-3x text-success mb-3"></i>
                                <h5>No blogs pending approval</h5>
                                <p class="text-muted">All submitted blogs have been reviewed and processed.</p>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <!-- All Blogs Section -->
        <div class="row" id="allBlogsSection">
            <div class="col-12">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-light border-0 py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="card-title mb-0">
                                <i class="fas fa-list text-primary me-2"></i>
                                All Blogs (<%= totalBlogs %>)
                            </h5>
                            <div class="d-flex gap-2">
                                <button class="btn btn-outline-secondary btn-sm" onclick="exportBlogs()">
                                    <i class="fas fa-download me-2"></i>Export
                                </button>
                                <a href="blogs" class="btn btn-primary btn-sm">
                                    <i class="fas fa-arrow-left me-2"></i>Back to Public Blogs
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <% if (allBlogs != null && !allBlogs.isEmpty()) { %>
                            <div class="table-responsive">
                                <table class="table table-hover mb-0" id="allBlogsTable">
                                    <thead class="table-light">
                                        <tr>
                                            <th class="ps-4">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" id="selectAllBlogs" onchange="toggleSelectAll('all')">
                                                </div>
                                            </th>
                                            <th>Title</th>
                                            <th>Author</th>
                                            <th>Created Date</th>
                                            <th>Status</th>
                                            <th class="text-center">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (Blogs blog : allBlogs) { %>
                                            <tr class="blog-row" data-status="<%= blog.isActive() ? "active" : "pending" %>" data-title="<%= blog.getTitle().toLowerCase() %>" data-author="<%= blog.getAuthorName().toLowerCase() %>">
                                                <td class="ps-4">
                                                    <div class="form-check">
                                                        <input class="form-check-input blog-checkbox" type="checkbox" value="<%= blog.getId() %>">
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="fw-semibold text-truncate" style="max-width: 300px;" title="<%= blog.getTitle() %>">
                                                        <%= blog.getTitle() %>
                                                    </div>
                                                    <small class="text-muted">ID: <%= blog.getId() %> | <i class="fas fa-heart text-danger"></i> <%= blog.getLikes() %></small>
                                                </td>
                                                <td>
                                                    <div class="fw-medium"><%= blog.getAuthorName() %></div>
                                                    <small class="text-muted">ID: <%= blog.getAuthorId() %></small>
                                                </td>
                                                <td>
                                                    <div><%= dateFormat.format(blog.getPublishedAt()) %></div>
                                                </td>
                                                <td>
                                                    <% if (blog.isActive()) { %>
                                                        <span class="badge bg-success">
                                                            <i class="fas fa-check-circle me-1"></i>Active
                                                        </span>
                                                    <% } else { %>
                                                        <span class="badge bg-warning">
                                                            <i class="fas fa-clock me-1"></i>Pending
                                                        </span>
                                                    <% } %>
                                                </td>
                                                <td>
                                                    <div class="d-flex gap-1 justify-content-center">
                                                        <a href="blogs?action=view&id=<%= blog.getId() %>" 
                                                           class="btn btn-outline-primary btn-sm" 
                                                           data-bs-toggle="tooltip" title="View Blog">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <% if (blog.isActive()) { %>
                                                            <button type="button" 
                                                                    class="btn btn-warning btn-sm" 
                                                                    onclick="deactivateBlog(<%= blog.getId() %>)"
                                                                    data-bs-toggle="tooltip" title="Deactivate Blog">
                                                                <i class="fas fa-pause"></i>
                                                            </button>
                                                        <% } else { %>
                                                            <button type="button" 
                                                                    class="btn btn-success btn-sm" 
                                                                    onclick="activateBlog(<%= blog.getId() %>)"
                                                                    data-bs-toggle="tooltip" title="Activate Blog">
                                                                <i class="fas fa-play"></i>
                                                            </button>
                                                        <% } %>
                                                        <button type="button" 
                                                                class="btn btn-danger btn-sm" 
                                                                onclick="deleteBlog(<%= blog.getId() %>)"
                                                                data-bs-toggle="tooltip" title="Delete Blog">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        <% } else { %>
                            <div class="text-center py-5">
                                <i class="fas fa-blog fa-3x text-muted mb-3"></i>
                                <h5>No blogs found</h5>
                                <p class="text-muted">No blog posts have been created yet.</p>
                                <a href="blogs?action=create" class="btn btn-primary">
                                    <i class="fas fa-plus me-2"></i>Create First Blog
                                </a>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bulk Actions Modal -->
    <div class="modal fade" id="bulkActionsModal" tabindex="-1" aria-labelledby="bulkActionsModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header border-0">
                    <h5 class="modal-title" id="bulkActionsModalLabel">
                        <i class="fas fa-tasks me-2"></i>Bulk Actions
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Select an action to apply to <span id="selectedCount">0</span> selected blog(s):</p>
                    <div class="d-grid gap-2">
                        <button type="button" class="btn btn-success" onclick="bulkActivate()">
                            <i class="fas fa-check me-2"></i>Activate Selected
                        </button>
                        <button type="button" class="btn btn-warning" onclick="bulkDeactivate()">
                            <i class="fas fa-pause me-2"></i>Deactivate Selected
                        </button>
                        <button type="button" class="btn btn-danger" onclick="bulkDelete()">
                            <i class="fas fa-trash me-2"></i>Delete Selected
                        </button>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header border-0">
                    <h5 class="modal-title" id="deleteModalLabel">
                        <i class="fas fa-exclamation-triangle text-danger me-2"></i>Confirm Delete
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete this blog post?</p>
                    <div class="alert alert-warning">
                        <i class="fas fa-warning me-2"></i>
                        <strong>This action cannot be undone.</strong> The blog post will be permanently removed.
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <a href="#" id="confirmDeleteBtn" class="btn btn-danger">
                        <i class="fas fa-trash me-2"></i>Delete Blog
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5.3.7 JS -->
    <script src="Resources/bootstrap/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JavaScript -->
    <script src="Resources/JavaScript/BlogsManagement.js"></script>
    
    <script>
    // Initialize on page load
    document.addEventListener('DOMContentLoaded', function() {
        // Initialize Bootstrap tooltips
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
        
        // Initialize filter buttons
        filterBlogs('all');
    });
    </script>
</body>
</html>
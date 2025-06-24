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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="Resources/CSS/BlogsManagement.css">
</head>

<%
    if (request.getAttribute("alert_message") != null) {
        String alertMessage = (String) request.getAttribute("alert_message");
        String alertAction = (String) request.getAttribute("alert_action");
        boolean existPostAction = request.getAttribute("alert_action") != null;
%>
<script>
    alert("<%= alertMessage %>");
    if (<%= existPostAction %>) {
        window.location.href = "${pageContext.request.contextPath}<%= alertAction %>";
    }
</script>
<%
    }
%>

<body>
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="nav-container">
            <div class="logo">
                <i class="fas fa-swimming-pool"></i>
                Swimming Pool Management
            </div>
            <div class="nav-links">
                <a href="home.jsp"><i class="fas fa-home"></i> Home</a>
                <a href="blogs"><i class="fas fa-blog"></i> Public Blogs</a>
                <a href="blogs?action=manage"><i class="fas fa-cogs"></i> Manage Blogs</a>
                <span>Welcome, <%= user.getFullName() %></span>
                <a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <!-- Alert Messages -->
        <%
            if (request.getAttribute("alert_message") != null) {
                String alertMessage = (String) request.getAttribute("alert_message");
                boolean isError = request.getAttribute("error") != null;
        %>
            <div class="alert <%= isError ? "alert-error" : "alert-success" %>">
                <i class="fas <%= isError ? "fa-exclamation-triangle" : "fa-check-circle" %>"></i>
                <%= alertMessage %>
            </div>
        <% } %>

        <!-- Header -->
        <div class="header">
            <h1>
                <i class="fas fa-cogs"></i>
                Blog Management Dashboard
            </h1>
            <p>Manage blog posts and their activation status. Only admins and managers can access this page.</p>
        </div>

        <!-- Statistics -->
        <%
            List<Blogs> allBlogs = (List<Blogs>) request.getAttribute("all_blogs");
            List<Blogs> inactiveBlogs = (List<Blogs>) request.getAttribute("inactive_blogs");
            
            int totalBlogs = allBlogs != null ? allBlogs.size() : 0;
            int totalInactive = inactiveBlogs != null ? inactiveBlogs.size() : 0;
            int totalActive = totalBlogs - totalInactive;
        %>
        
        <div class="stats-row">
            <div class="stat-card">
                <div class="stat-number"><%= totalBlogs %></div>
                <div class="stat-label">Total Blogs</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= totalActive %></div>
                <div class="stat-label">Active Blogs</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= totalInactive %></div>
                <div class="stat-label">Pending Approval</div>
            </div>
        </div>

        <!-- Inactive Blogs Section -->
        <div class="content-section">
            <div class="section-header">
                <div class="section-title">
                    <i class="fas fa-exclamation-triangle"></i>
                    Blogs Pending Approval (<%= totalInactive %>)
                </div>
            </div>
            
            <div class="table-container">
                <% if (inactiveBlogs != null && !inactiveBlogs.isEmpty()) { %>
                    <table class="blog-table">
                        <thead>
                            <tr>
                                <th data-sortable>Title</th>
                                <th data-sortable>Author</th>
                                <th data-sortable>Created Date</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Blogs blog : inactiveBlogs) { %>
                                <tr>
                                    <td>
                                        <div class="blog-title" title="<%= blog.getTitle() %>">
                                            <%= blog.getTitle() %>
                                        </div>
                                        <div class="blog-meta">
                                            ID: <%= blog.getId() %> | Likes: <%= blog.getLikes() %>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="blog-author"><%= blog.getAuthorName() %></div>
                                        <div class="blog-meta">Author ID: <%= blog.getAuthorId() %></div>
                                    </td>
                                    <td>
                                        <div><%= dateFormat.format(blog.getPublishedAt()) %></div>
                                    </td>
                                    <td>
                                        <span class="status-badge status-inactive">
                                            <i class="fas fa-clock"></i> Inactive
                                        </span>
                                    </td>
                                    <td>
                                        <div class="actions">
                                            <a href="blogs?action=view&id=<%= blog.getId() %>" class="btn btn-primary btn-sm" title="View Blog">
                                                <i class="fas fa-eye"></i> View
                                            </a>
                                            <a href="blogs?action=activate&id=<%= blog.getId() %>&status=activate" 
                                               class="btn btn-success btn-sm" 
                                               onclick="return confirm('Are you sure you want to activate this blog?')"
                                               title="Activate Blog">
                                                <i class="fas fa-check"></i> Activate
                                            </a>
                                            <a href="blogs?action=delete&id=<%= blog.getId() %>" 
                                               class="btn btn-danger btn-sm"
                                               onclick="return confirm('Are you sure you want to delete this blog? This action cannot be undone.')"
                                               title="Delete Blog">
                                                <i class="fas fa-trash"></i> Delete
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } else { %>
                    <div class="empty-state">
                        <i class="fas fa-check-circle"></i>
                        <h3>No blogs pending approval</h3>
                        <p>All submitted blogs have been reviewed and processed.</p>
                    </div>
                <% } %>
            </div>
        </div>

        <!-- All Blogs Section -->
        <div class="content-section">
            <div class="section-header">
                <div class="section-title">
                    <i class="fas fa-list"></i>
                    All Blogs (<%= totalBlogs %>)
                </div>
                <a href="blogs" class="btn btn-primary">
                    <i class="fas fa-arrow-left"></i> Back to Public Blogs
                </a>
            </div>
            
            <div class="table-container">
                <% if (allBlogs != null && !allBlogs.isEmpty()) { %>
                    <table class="blog-table">
                        <thead>
                            <tr>
                                <th data-sortable>Title</th>
                                <th data-sortable>Author</th>
                                <th data-sortable>Created Date</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Blogs blog : allBlogs) { %>
                                <tr>
                                    <td>
                                        <div class="blog-title" title="<%= blog.getTitle() %>">
                                            <%= blog.getTitle() %>
                                        </div>
                                        <div class="blog-meta">
                                            ID: <%= blog.getId() %> | Likes: <%= blog.getLikes() %>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="blog-author"><%= blog.getAuthorName() %></div>
                                        <div class="blog-meta">Author ID: <%= blog.getAuthorId() %></div>
                                    </td>
                                    <td>
                                        <div><%= dateFormat.format(blog.getPublishedAt()) %></div>
                                    </td>
                                    <td>
                                        <% if (blog.isActive()) { %>
                                            <span class="status-badge status-active">
                                                <i class="fas fa-check-circle"></i> Active
                                            </span>
                                        <% } else { %>
                                            <span class="status-badge status-inactive">
                                                <i class="fas fa-clock"></i> Inactive
                                            </span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <div class="actions">
                                            <a href="blogs?action=view&id=<%= blog.getId() %>" class="btn btn-primary btn-sm" title="View Blog">
                                                <i class="fas fa-eye"></i> View
                                            </a>
                                            <% if (blog.isActive()) { %>
                                                <a href="blogs?action=activate&id=<%= blog.getId() %>&status=deactivate" 
                                                   class="btn btn-warning btn-sm"
                                                   onclick="return confirm('Are you sure you want to deactivate this blog?')"
                                                   title="Deactivate Blog">
                                                    <i class="fas fa-pause"></i> Deactivate
                                                </a>
                                            <% } else { %>
                                                <a href="blogs?action=activate&id=<%= blog.getId() %>&status=activate" 
                                                   class="btn btn-success btn-sm"
                                                   onclick="return confirm('Are you sure you want to activate this blog?')"
                                                   title="Activate Blog">
                                                    <i class="fas fa-play"></i> Activate
                                                </a>
                                            <% } %>
                                            <a href="blogs?action=delete&id=<%= blog.getId() %>" 
                                               class="btn btn-danger btn-sm"
                                               onclick="return confirm('Are you sure you want to delete this blog? This action cannot be undone.')"
                                               title="Delete Blog">
                                                <i class="fas fa-trash"></i> Delete
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } else { %>
                    <div class="empty-state">
                        <i class="fas fa-blog"></i>
                        <h3>No blogs found</h3>
                        <p>No blog posts have been created yet.</p>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <script src="Resources/JavaScript/BlogsManagement.js"></script>
</body>
</html>
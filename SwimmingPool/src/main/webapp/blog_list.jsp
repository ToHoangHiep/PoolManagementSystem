<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Blogs" %>
<%@ page import="model.User" %>
<%--<%@ page import="model.Course" %>--%>
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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="Resources/CSS/BlogsList.css">
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

<div class="container">
    <!-- Header -->
    <div class="header">
        <h1><i class="fas fa-blog"></i> Swimming Pool Blog Community</h1>
        <p>Share knowledge, tips, and experiences with fellow swimmers</p>
    </div>

    <!-- Authentication Notice for Guests -->
    <% if (!isLoggedIn) { %>
    <div class="auth-notice">
        <h3><i class="fas fa-info-circle"></i> Welcome, Guest!</h3>
        <p>You can browse and read all our amazing blog posts. To create posts, comment, or interact, please sign
            in.</p>
        <div class="auth-buttons">
            <a href="login.jsp" class="btn-login">
                <i class="fas fa-sign-in-alt"></i> Sign In
            </a>
            <a href="register.jsp" class="btn-register">
                <i class="fas fa-user-plus"></i> Create Account
            </a>
        </div>
    </div>
    <% } %>

    <!-- Success/Error Messages -->
    <% if (success != null) { %>
    <div class="alert alert-success">
        <i class="fas fa-check-circle"></i> <%= success %>
    </div>
    <% } %>

    <% if (error != null) { %>
    <div class="alert alert-error">
        <i class="fas fa-exclamation-circle"></i> <%= error %>
    </div>
    <% } %>

    <% if (message != null) { %>
    <div class="alert alert-error">
        <i class="fas fa-info-circle"></i> <%= message %>
    </div>
    <% } %>

    <!-- Toolbar -->
    <div class="toolbar">
        <div>
            <h2>Community Blogs</h2>
            <% if (isLoggedIn) { %>
            <small>Welcome, <%= currentUser.getFullName() %>!</small>
            <% } else { %>
            <small>Browsing as guest - Sign in to interact</small>
            <% } %>
        </div>
        <div style="display: flex; gap: 10px; flex-wrap: wrap;">
            <% if (isLoggedIn) { %>
            <button class="btn btn-primary" onclick="window.location.href='blogs?action=create'">
                <i class="fas fa-plus"></i> Create Blog
            </button>
            <% } %>
            <a href="home.jsp" class="btn btn-outline-secondary">
                <i class="fas fa-home"></i> Home
            </a>
        </div>
    </div>

    <!-- Filter Section -->
    <div class="filter-section">
        <form action="blogs" method="get" class="filter-form">
            <input type="hidden" name="action" value="sort">

            <div class="form-group">
                <label for="min_likes">Minimum Likes</label>
                <input type="number" name="min_likes" id="min_likes" class="form-control"
                       placeholder="0" min="0"
                       value="<%= request.getAttribute("min_likes") != null ? request.getAttribute("min_likes") : "" %>">
            </div>

            <div class="form-group">
                <label for="start_date">From Date</label>
                <input type="date" name="start_date" id="start_date" class="form-control"
                       value="<%= request.getAttribute("start_date") != null ? request.getAttribute("start_date") : "" %>">
            </div>

            <div class="form-group">
                <label for="end_date">To Date</label>
                <input type="date" name="end_date" id="end_date" class="form-control"
                       value="<%= request.getAttribute("end_date") != null ? request.getAttribute("end_date") : "" %>">
            </div>

            <div class="form-group">
                <label for="sort_by">Sort By</label>
                <select name="sort_by" id="sort_by" class="form-control">
                    <option value="published_at" <%= "published_at".equals(request.getAttribute("sort_by")) ? "selected" : "" %>>
                        Published Date
                    </option>
                    <option value="likes" <%= "likes".equals(request.getAttribute("sort_by")) ? "selected" : "" %>>
                        Likes
                    </option>
                    <option value="title" <%= "title".equals(request.getAttribute("sort_by")) ? "selected" : "" %>>
                        Title
                    </option>
                </select>
            </div>

            <div class="form-group">
                <label for="sort_order">Order</label>
                <select name="sort_order" id="sort_order" class="form-control">
                    <option value="desc" <%= "desc".equals(request.getAttribute("sort_order")) ? "selected" : "" %>>
                        Descending
                    </option>
                    <option value="asc" <%= "asc".equals(request.getAttribute("sort_order")) ? "selected" : "" %>>
                        Ascending
                    </option>
                </select>
            </div>

            <div class="form-group">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-filter"></i> Apply Filters
                </button>
            </div>
        </form>
    </div>


    <!-- Blogs Grid -->
    <div class="blogs-grid">
        <% if (blogsList != null && !blogsList.isEmpty()) {
            List<Blogs> sortedBlogs = blogsList.stream().filter(Blogs::isActive).toList();
            for (Blogs blog : sortedBlogs) { %>
        <div class="blog-card <%= !isLoggedIn ? "guest-mode" : "" %>">
            <div class="blog-header">
                <h3 class="blog-title"><%= blog.getTitle() %>
                </h3>
                <div class="blog-meta">
                    <div class="author-info">
                        <i class="fas fa-user"></i>
                        <span><%= blog.getAuthorName() %></span>
                    </div>
                    <span><%= dateFormat.format(blog.getPublishedAt()) %></span>
                </div>
            </div>

            <div class="blog-content">
                <div class="blog-excerpt">
                    <%= blog.getContent().length() > 150 ?
                            blog.getContent().substring(0, 150) + "..." :
                            blog.getContent() %>
                </div>

                <% if (blog.getTags() != null && !blog.getTags().trim().isEmpty()) { %>
                <div class="blog-tags">
                    <% String[] tags = blog.getTags().split(",");
                        for (String tag : tags) {
                            if (!tag.trim().isEmpty()) { %>
                    <span class="tag"><%= tag.trim() %></span>
                    <% }
                    } %>
                </div>
                <% } %>
            </div>

            <div class="blog-footer">
                <div class="blog-stats">
                    <div class="stat-item">
                        <i class="fas fa-heart"></i>
                        <span><%= blog.getLikes() %></span>
                    </div>
                    <div class="stat-item">
                        <i class="fas fa-comments"></i>
                        <span><%= BlogsCommentDAO.getCommentsCount(blog.getId()) %></span>
                    </div>
                </div>

                <div class="blog-actions">
                    <a href="${pageContext.request.contextPath}/blogs?action=view&id=<%= blog.getId() %>"
                       class="btn btn-sm btn-outline-primary">
                        <i class="fas fa-eye"></i> Read
                    </a>

                    <% if (isLoggedIn && (isAdmin || blog.getAuthorId() == currentUser.getId())) { %>
                    <a href="blogs?action=edit&id=<%= blog.getId() %>"
                       class="btn btn-sm btn-outline-secondary">
                        <i class="fas fa-edit"></i> Edit
                    </a>
                    <button onclick="confirmDelete(<%= blog.getId() %>)"
                            class="btn btn-sm btn-outline-danger">
                        <i class="fas fa-trash"></i> Delete
                    </button>
                    <% } else if (!isLoggedIn) { %>
                    <button onclick="showInteractionModal('edit')"
                            class="btn btn-sm btn-outline-secondary guest-action">
                        <i class="fas fa-edit"></i> Edit
                    </button>
                    <% } %>
                </div>
            </div>
        </div>
        <% }
        } else { %>
        <div class="no-blogs">
            <i class="fas fa-blog"></i>
            <h3>No blogs found</h3>
            <p>Be the first to share your swimming knowledge!</p>
            <% if (isLoggedIn && isAdmin) { %>
            <button class="btn btn-primary" onclick="toggleCreateForm()">
                <i class="fas fa-plus"></i> Create First Blog
            </button>
            <% } else if (!isLoggedIn) { %>
            <button class="btn btn-secondary" onclick="showInteractionModal('create')">
                <i class="fas fa-plus"></i> Create First Blog
            </button>
            <% } %>
        </div>
        <% } %>
    </div>
</div>

<!-- Interaction Modal for Guests -->
<div class="interaction-overlay" id="interactionModal">
    <div class="interaction-modal">
        <h3><i class="fas fa-lock"></i> Sign In Required</h3>
        <p id="modalMessage">Please sign in to interact with blog posts.</p>
        <div class="auth-buttons">
            <a href="login.jsp" class="btn-login">
                <i class="fas fa-sign-in-alt"></i> Sign In
            </a>
            <a href="register.jsp" class="btn-register">
                <i class="fas fa-user-plus"></i> Create Account
            </a>
        </div>
        <br><br>
        <button onclick="hideInteractionModal()" class="btn btn-outline-secondary">
            <i class="fas fa-times"></i> Continue Browsing
        </button>
    </div>
</div>

<script src="Resources/JavaScript/BlogsList.js"></script>
<script>
    // JSP-specific initialization with server-side data
    <% if (!isLoggedIn) { %>
    // Prevent right-click context menu for guest users (optional)
    document.addEventListener('contextmenu', function (e) {
        if (e.target.closest('.blog-card')) {
            e.preventDefault();
            showInteractionModal('general');
        }
    });
    <% } %>
</script>
</body>
</html>
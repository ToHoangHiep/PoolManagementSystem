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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="Resources/CSS/BlogsDetail.css">
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
        window.location.href = "<%= alertAction %>";
    }
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

    <div class="container">
        <!-- Header -->
        <div class="header">
            <h1><i class="fas fa-blog"></i> Blog Detail</h1>
        </div>

        <!-- Authentication Notice for Guests -->
        <% if (!isLoggedIn) { %>
        <div class="auth-notice">
            <h3><i class="fas fa-info-circle"></i> Reading as Guest</h3>
            <p>You can read the full blog post below. To comment or interact, please sign in.</p>
            <div class="auth-buttons">
                <a href="login" class="btn-login">
                    <i class="fas fa-sign-in-alt"></i> Sign In
                </a>
                <a href="register" class="btn-register">
                    <i class="fas fa-user-plus"></i> Create Account
                </a>
            </div>
        </div>
        <% } %>

        <!-- Breadcrumb -->
        <div class="breadcrumb">
            <a href="home.jsp"><i class="fas fa-home"></i> Home</a> /
            <a href="blogs?action=list"><i class="fas fa-blog"></i> Blogs</a> /
            <span><%= blog.getTitle() %></span>
        </div>

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

        <!-- Blog Content -->
        <div class="blog-container">
            <div class="blog-header">
                <h1 class="blog-title"><%= blog.getTitle() %></h1>
                
                <div class="blog-meta">
                    <div class="author-info">
                        <i class="fas fa-user-circle" style="font-size: 1.2em;"></i>
                        <span><strong><%= blog.getAuthorName() %></strong></span>
                        <span>•</span>
                        <span><%= shortDateFormat.format(blog.getPublishedAt()) %></span>
                    </div>
                    
                    <div class="blog-stats">
                        <div class="stat-item">
                            <i class="fas fa-heart"></i>
                            <span><%= blog.getLikes() %> likes</span>
                        </div>
                        <div class="stat-item">
                            <i class="fas fa-comments"></i>
                            <span><%= comments != null ? comments.size() : 0 %> comments</span>
                        </div>
                    </div>
                </div>

                <% if (isLoggedIn && canEdit) { %>
                <div class="blog-actions">
                    <a href="blogs?action=edit&id=<%= blog.getId() %>" class="btn btn-outline-secondary">
                        <i class="fas fa-edit"></i> Edit Blog
                    </a>
                    <button onclick="confirmDelete(<%= blog.getId() %>)" class="btn btn-outline-danger">
                        <i class="fas fa-trash"></i> Delete Blog
                    </button>
                </div>
                <% } else if (!isLoggedIn) { %>
                <div class="blog-actions">
                    <button onclick="showInteractionModal('edit')" class="btn btn-secondary guest-action">
                        <i class="fas fa-edit"></i> Edit Blog
                    </button>
                </div>
                <% } %>
            </div>

            <!-- Blog Content -->
            <div class="blog-content">
                <%= blog.getContent().replaceAll("\n", "<br>") %>
            </div>

            <!-- Tags -->
            <% if (blog.getTags() != null && !blog.getTags().trim().isEmpty()) { %>
            <div class="blog-tags">
                <% String[] tags = blog.getTags().split(",");
                   for (String tag : tags) { 
                       if (!tag.trim().isEmpty()) { %>
                <span class="tag"><%= tag.trim() %></span>
                <% } } %>
            </div>
            <% } %>

            <!-- Comments Section -->
            <div class="comments-section">
                <div class="comments-header">
                    <h3>Comments (<%= comments != null ? comments.size() : 0 %>)</h3>
                </div>

                <!-- Add Comment Form -->
                <% if (isLoggedIn) { %>
                <div class="comment-form">
                    <h4>Add a Comment</h4>
                    <form action="blogs" method="post">
                        <input type="hidden" name="action" value="add_comment">
                        <input type="hidden" name="blog_id" value="<%= blog.getId() %>">
                        
                        <div class="form-group">
                            <label for="content">Your Comment</label>
                            <textarea name="content" id="content" class="form-control textarea" 
                                      required placeholder="Share your thoughts..."></textarea>
                        </div>
                        
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-comment"></i> Post Comment
                        </button>
                    </form>
                </div>
                <% } else { %>
                <div class="comment-form guest-overlay" onclick="showInteractionModal('comment')">
                    <h4>Add a Comment</h4>
                    <div class="form-group">
                        <label for="content-guest">Your Comment</label>
                        <textarea id="content-guest" class="form-control textarea" 
                                  disabled placeholder="Sign in to share your thoughts..."></textarea>
                    </div>
                    
                    <button type="button" onclick="showInteractionModal('comment')" class="btn btn-secondary">
                        <i class="fas fa-comment"></i> Sign In to Comment
                    </button>
                </div>
                <% } %>

                <!-- Comments List -->
                <div class="comments-list">
                    <% if (comments != null && !comments.isEmpty()) {
                        for (BlogsComment comment : comments) { %>
                    <div class="comment-item" id="comment-<%= comment.getId() %>">
                        <div class="comment-header">
                            <div class="comment-author">
                                <i class="fas fa-user-circle"></i>
                                <span><%= comment.getUserName() %></span>
                            </div>
                            <div class="comment-date">
                                <%= dateFormat.format(comment.getCreatedAt()) %>
                            </div>
                        </div>
                        
                        <div class="comment-content" id="content-<%= comment.getId() %>">
                            <%= comment.getContent().replaceAll("\n", "<br>") %>
                        </div>
                        
                        <% if (isLoggedIn && (isAdmin || comment.getUserId() == currentUser.getId())) { %>
                        <div class="comment-actions">
                            <button onclick="toggleEditComment(<%= comment.getId() %>)" 
                                    class="btn btn-sm btn-outline-secondary">
                                <i class="fas fa-edit"></i> Edit
                            </button>
                            <button onclick="confirmDeleteComment(<%= comment.getId() %>, <%= blog.getId() %>)" 
                                    class="btn btn-sm btn-outline-danger">
                                <i class="fas fa-trash"></i> Delete
                            </button>
                        </div>
                        
                        <!-- Edit Comment Form -->
                        <div class="edit-form" id="edit-form-<%= comment.getId() %>">
                            <form action="blogs" method="post">
                                <input type="hidden" name="action" value="edit_comment">
                                <input type="hidden" name="comment_id" value="<%= comment.getId() %>">
                                <input type="hidden" name="blog_id" value="<%= blog.getId() %>">
                                
                                <div class="form-group">
                                    <textarea name="content" class="form-control textarea" required><%= comment.getContent() %></textarea>
                                </div>
                                
                                <div style="display: flex; gap: 10px;">
                                    <button type="submit" class="btn btn-sm btn-primary">
                                        <i class="fas fa-save"></i> Save
                                    </button>
                                    <button type="button" onclick="toggleEditComment(<%= comment.getId() %>)" 
                                            class="btn btn-sm btn-outline-secondary">
                                        <i class="fas fa-times"></i> Cancel
                                    </button>
                                </div>
                            </form>
                        </div>
                        <% } else if (!isLoggedIn) { %>
                        <div class="comment-actions">
                            <button onclick="showInteractionModal('edit')" 
                                    class="btn btn-sm btn-secondary guest-action">
                                <i class="fas fa-edit"></i> Edit
                            </button>
                        </div>
                        <% } %>
                    </div>
                    <% } } else { %>
                    <div class="no-comments">
                        <i class="fas fa-comments"></i>
                        <h4>No comments yet</h4>
                        <p>Be the first to share your thoughts on this blog!</p>
                        <% if (!isLoggedIn) { %>
                        <button onclick="showInteractionModal('comment')" class="btn btn-secondary">
                            <i class="fas fa-comment"></i> Sign In to Comment
                        </button>
                        <% } %>
                    </div>
                    <% } %>
                </div>
            </div>
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
                <i class="fas fa-times"></i> Continue Reading
            </button>
        </div>
    </div>

    <script src="Resources/JavaScript/BlogsDetail.js"></script>
</body>
</html>
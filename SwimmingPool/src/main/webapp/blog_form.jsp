<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Blogs" %>
<%@ page import="model.User" %>
<%--<%@ page import="model.Course" %>--%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%=request.getAttribute("is_edit") != null ? "Edit Blog" : "Create New Blog"%> - Swimming Pool Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="Resources/CSS/BlogsForm.css">
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
        // Get attributes from request
        Blogs blog = (Blogs) request.getAttribute("blog");
        // List<Course> courses = (List<Course>) request.getAttribute("courses");
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

    <!-- Navigation Breadcrumb -->
    <nav class="breadcrumb-nav" style="background: #f8f9fa; padding: 10px 0; margin-bottom: 20px;">
        <div class="container">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="home.jsp"><i class="fas fa-home"></i> Home</a></li>
                    <li class="breadcrumb-item"><a href="blogs?action=list"><i class="fas fa-blog"></i> Blogs</a></li>
                    <li class="breadcrumb-item active" aria-current="page">
                        <%= isEditMode ? "Edit Blog" : "Create Blog" %>
                    </li>
                </ol>
            </nav>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h3 class="mb-0">
                            <i class="fas fa-<%= isEditMode ? "edit" : "plus" %>"></i>
                            <%= isEditMode ? "Edit Blog" : "Create New Blog" %>
                        </h3>
                        <% if (isEditMode && blog != null) { %>
                        <small class="text-muted">Last updated: <%= new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm").format(blog.getPublishedAt()) %></small>
                        <% } %>
                    </div>
                    <div class="card-body">
                        <!-- Display success/error messages -->
                        <% if (success != null) { %>
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle"></i> <%= success %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <% } %>
                        
                        <% if (error != null) { %>
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-triangle"></i> <%= error %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <% } %>

                        <form method="post" action="blogs">
                            <input type="hidden" name="action" value="<%= isEditMode ? "update" : "create" %>">
                            <% if (isEditMode && blog != null) { %>
                                <input type="hidden" name="id" value="<%= blog.getId() %>">
                            <% } %>

                            <div class="mb-3">
                                <label for="title" class="form-label">
                                    <i class="fas fa-heading"></i> Title *
                                </label>
                                <input type="text" class="form-control" id="title" name="title" 
                                       value="<%= blog != null ? blog.getTitle() : "" %>" 
                                       required maxlength="255"
                                       placeholder="Enter an engaging blog title">
                            </div>

                            <div class="mb-3">
                                <label for="content" class="form-label">
                                    <i class="fas fa-file-text"></i> Content *
                                </label>
                                <textarea class="form-control" id="content" name="content" rows="12" 
                                          required placeholder="Write your blog content here. Share your knowledge, tips, and experiences with the swimming community..."><%= blog != null ? blog.getContent() : "" %></textarea>
                                <div class="form-text">Use clear paragraphs and detailed explanations to help other swimmers.</div>
                            </div>

<%--                            <div class="mb-3">--%>
<%--                                <label for="course_id" class="form-label">--%>
<%--                                    <i class="fas fa-graduation-cap"></i> Related Course (Optional)--%>
<%--                                </label>--%>
<%--                                <select class="form-select" id="course_id" name="course_id">--%>
<%--                                    <option value="">Select a course (optional)</option>--%>
<%--                                    <% if (courses != null) {--%>
<%--                                        for (Course course : courses) { %>--%>
<%--                                            <option value="<%= course.getId() %>" --%>
<%--                                                    <%= (blog != null && blog.getCourseId() == course.getId()) ? "selected" : "" %>>--%>
<%--                                                <%= course.getCourseName() %>--%>
<%--                                            </option>--%>
<%--                                    <% } } %>--%>
<%--                                </select>--%>
<%--                                <div class="form-text">Link this blog to a specific swimming course if it's relevant to the content.</div>--%>
<%--                            </div>--%>

                            <div class="mb-3">
                                <label for="tags" class="form-label">
                                    <i class="fas fa-tags"></i> Tags (Optional)
                                </label>
                                <input type="text" class="form-control" id="tags" name="tags" 
                                       value="<%= blog != null && blog.getTags() != null ? blog.getTags() : "" %>" 
                                       placeholder="swimming, technique, beginner, training, tips">
                                <div class="form-text">Separate tags with commas. Good tags help others find your content.</div>
                            </div>

                            <div class="d-flex gap-2 flex-wrap">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-<%= isEditMode ? "save" : "plus" %>"></i>
                                    <%= isEditMode ? "Update Blog" : "Publish Blog" %>
                                </button>
                                
                                <a href="blogs?action=list" class="btn btn-secondary">
                                    <i class="fas fa-times"></i> Cancel
                                </a>
                                
                                <% if (isEditMode && blog != null) { %>
                                    <a href="blogs?action=view&id=<%= blog.getId() %>" class="btn btn-info">
                                        <i class="fas fa-eye"></i> View Blog
                                    </a>
                                    <button type="button" class="btn btn-outline-danger" 
                                            onclick="if(confirm('Are you sure you want to delete this blog? This action cannot be undone.')) { window.location.href='blogs?action=delete&id=<%= blog.getId() %>'; }">
                                        <i class="fas fa-trash"></i> Delete
                                    </button>
                                <% } %>
                                
                                <% if (!isEditMode) { %>
                                    <button type="button" class="btn btn-outline-secondary" onclick="saveDraft()">
                                        <i class="fas fa-save"></i> Save Draft
                                    </button>
                                <% } %>
                            </div>
                        </form>
                        
                        <!-- Help Section -->
                        <div class="mt-4 p-3 bg-light rounded">
                            <h6><i class="fas fa-lightbulb"></i> Writing Tips:</h6>
                            <ul class="mb-0 small">
                                <li>Use clear, descriptive titles that tell readers what they'll learn</li>
                                <li>Break up content with paragraphs for easy reading</li>
                                <li>Share personal experiences and practical tips</li>
                                <li>Include safety considerations when relevant</li>
                                <li>Use tags to help others discover your content</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="Resources/JavaScript/BlogsForm.js"></script>
    
    <script>
        // Additional functionality for draft saving
        function saveDraft() {
            const title = document.getElementById('title').value;
            const content = document.getElementById('content').value;
            const tags = document.getElementById('tags').value;
            
            if (!title.trim() && !content.trim()) {
                alert('Please add some content before saving a draft.');
                return;
            }
            
            // Save to localStorage
            const draft = {
                title: title,
                content: content,
                tags: tags,
                timestamp: new Date().toISOString()
            };
            
            localStorage.setItem('blog_draft', JSON.stringify(draft));
            
            // Show notification
            const alert = document.createElement('div');
            alert.className = 'alert alert-success alert-dismissible fade show';
            alert.innerHTML = `
                <i class="fas fa-check"></i> Draft saved successfully!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            `;
            
            document.querySelector('.card-body').insertBefore(alert, document.querySelector('form'));
            
            // Auto-hide after 3 seconds
            setTimeout(() => {
                if (alert.parentNode) {
                    alert.remove();
                }
            }, 3000);
        }
    </script>
</body>
</html>
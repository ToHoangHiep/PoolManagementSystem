<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Feedback" %>
<%@ page import="model.FeedbackReplies" %>
<%@ page import="java.util.List" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Feedback feedback = (Feedback) request.getAttribute("feedback");
    List<FeedbackReplies> replies = (List<FeedbackReplies>) request.getAttribute("replies");
    
    if (feedback == null) {
        response.sendRedirect("feedback?mode=list");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback Chat - Swimming Pool Management</title>
    <!-- Bootstrap 5.3.7 CSS -->
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="Resources/CSS/FeedbackChat.css">
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
        window.location.href = "${pageContext.request.contextPath}<%= alertAction %>";
    }, 2000);
    <% } %>
</script>
<%
    }
%>

<div class="container-fluid h-100">
    <div class="row h-100">
        <div class="col-12">
            <div class="chat-container card border-0 shadow h-100">
                <!-- Header -->
                <div class="card-header bg-gradient-primary text-white py-3">
                    <div class="row align-items-center">
                        <div class="col-auto">
                            <a href="feedback?mode=list" class="btn btn-outline-light btn-sm">
                                <i class="fas fa-arrow-left me-1"></i>Back
                            </a>
                        </div>
                        <div class="col">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-comments me-3 fs-4"></i>
                                <div>
                                    <h4 class="mb-1">Feedback Chat</h4>
                                    <div class="d-flex align-items-center flex-wrap gap-3">
                                        <small class="opacity-75">
                                            <i class="fas fa-hashtag me-1"></i>ID: <%= feedback.getId() %>
                                        </small>
                                        <span class="badge bg-<%= feedback.getFeedbackType().toLowerCase().equals("general") ? "success" : 
                                                                   feedback.getFeedbackType().toLowerCase().equals("coach") ? "info" : "warning" %> 
                                                     fs-6 px-2 py-1">
                                            <%= feedback.getFeedbackType() %>
                                        </span>
                                        <small class="opacity-75">
                                            <i class="fas fa-calendar me-1"></i><%= feedback.getCreatedAt() %>
                                        </small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Original Feedback Card -->
                <div class="original-feedback p-3 border-bottom bg-white">
                    <div class="card bg-light border-0">
                        <div class="card-body">
                            <div class="row align-items-center mb-3">
                                <div class="col">
                                    <div class="d-flex align-items-center">
                                        <div class="avatar-circle bg-primary text-white me-3">
                                            <i class="fas fa-user"></i>
                                        </div>
                                        <div>
                                            <h6 class="mb-1 fw-semibold"><%= feedback.getUserName() %></h6>
                                            <small class="text-muted"><%= feedback.getUserEmail() %></small>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-auto">
                                    <div class="d-flex align-items-center">
                                        <div class="text-warning me-2">
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
                                        </div>
                                        <small class="text-muted">(<%= feedback.getRating() %>/10)</small>
                                    </div>
                                </div>
                            </div>
                            <div class="feedback-content p-3 bg-white rounded border">
                                <%= feedback.getContent() %>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Chat Messages Area -->
                <div class="chat-messages flex-grow-1 p-3" id="chatMessages" style="height: 400px; overflow-y: auto;">
                    <%
                        if (replies != null && !replies.isEmpty()) {
                            for (FeedbackReplies reply : replies) {
                                boolean isCurrentUser = reply.getUserId() == user.getId();
                    %>
                    <div class="message mb-3 <%= isCurrentUser ? "text-end" : "text-start" %>">
                        <div class="d-inline-block position-relative" style="max-width: 70%;">
                            <!-- Message bubble -->
                            <div class="message-bubble p-3 rounded-3 <%= isCurrentUser ? "bg-primary text-white" : "bg-light border" %>">
                                <div class="message-header mb-2">
                                    <div class="d-flex align-items-center justify-content-between">
                                        <small class="<%= isCurrentUser ? "text-white-50" : "text-muted" %> fw-semibold">
                                            <i class="fas fa-user me-1"></i><%= reply.getUserName() %>
                                        </small>
                                        <small class="<%= isCurrentUser ? "text-white-50" : "text-muted" %>">
                                            <i class="fas fa-clock me-1"></i><%= reply.getCreatedAt() %>
                                        </small>
                                    </div>
                                </div>
                                <div class="message-content">
                                    <%= reply.getContent() %>
                                </div>
                            </div>
                            <!-- Message tail -->
                            <div class="message-tail position-absolute top-0 <%= isCurrentUser ? "end-0" : "start-0" %>">
                                <div class="triangle-<%= isCurrentUser ? "right" : "left" %> <%= isCurrentUser ? "bg-primary" : "bg-light" %>"></div>
                            </div>
                        </div>
                    </div>
                    <%
                            }
                        } else {
                    %>
                    <div class="no-messages text-center py-5">
                        <div class="text-muted">
                            <i class="fas fa-comments fa-3x mb-3 opacity-50"></i>
                            <h5>No replies yet</h5>
                            <p class="mb-0">Be the first to respond to this feedback!</p>
                        </div>
                    </div>
                    <%
                        }
                    %>
                </div>

                <!-- Reply Form -->
                <div class="card-footer bg-white border-top">
                    <form action="feedback?action=reply&id=<%= feedback.getId() %>" method="post" id="replyForm">
                        <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger alert-dismissible fade show mb-3" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <%= request.getAttribute("error") %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <% } %>
                        
                        <div class="row g-2 align-items-end">
                            <div class="col">
                                <div class="position-relative">
                                    <textarea name="reply_content" 
                                              id="replyContent" 
                                              class="form-control" 
                                              placeholder="Type your reply here..." 
                                              required
                                              maxlength="500"
                                              rows="3"
                                              style="resize: none; padding-bottom: 35px;"></textarea>
                                    <div class="position-absolute bottom-0 end-0 p-2">
                                        <small class="text-muted">
                                            <span id="charCount">0</span>/500
                                        </small>
                                    </div>
                                </div>
                            </div>
                            <div class="col-auto">
                                <button type="submit" class="btn btn-primary btn-lg px-4">
                                    <i class="fas fa-paper-plane me-2"></i>Send
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap 5.3.7 JS -->
<script src="Resources/bootstrap/js/bootstrap.bundle.min.js"></script>
<!-- Custom JavaScript -->
<script src="Resources/JavaScript/FeedbackChat.js"></script>

<script>
// Auto-scroll to bottom of messages
document.addEventListener('DOMContentLoaded', function() {
    const chatMessages = document.getElementById('chatMessages');
    if (chatMessages) {
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }
    
    // Initialize Bootstrap tooltips
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
});
</script>

</body>
</html>
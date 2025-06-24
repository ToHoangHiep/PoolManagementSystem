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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="Resources/CSS/FeedbackChat.css">
</head>

<body>
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

<div class="chat-container">
    <!-- Header -->
    <div class="chat-header">
        <div class="header-content">
            <div class="back-button">
                <a href="feedback?mode=list" class="btn-back">
                    <i class="fas fa-arrow-left"></i> Back to Feedback
                </a>
            </div>
            <div class="feedback-info">
                <h1><i class="fas fa-comments"></i> Feedback Chat</h1>
                <div class="feedback-meta">
                    <span class="feedback-id">ID: #<%= feedback.getId() %></span>
                    <span class="feedback-type badge badge-<%= feedback.getFeedbackType().toLowerCase() %>">
                        <%= feedback.getFeedbackType() %>
                    </span>
                    <span class="feedback-date">
                        <i class="fas fa-calendar"></i> <%= feedback.getCreatedAt() %>
                    </span>
                </div>
            </div>
        </div>
    </div>

    <!-- Original Feedback -->
    <div class="original-feedback">
        <div class="feedback-card">
            <div class="feedback-header">
                <div class="user-info">
                    <div class="user-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <div class="user-details">
                        <div class="username"><%= feedback.getUserName() %></div>
                        <div class="user-email"><%= feedback.getUserEmail() %></div>
                    </div>
                </div>
                <div class="feedback-rating">
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
                        <span class="rating-value">(<%= feedback.getRating() %>/10)</span>
                    </div>
                </div>
            </div>
            <div class="feedback-content">
                <%= feedback.getContent() %>
            </div>
        </div>
    </div>

    <!-- Chat Messages -->
    <div class="chat-messages" id="chatMessages">
        <%
            if (replies != null && !replies.isEmpty()) {
                for (FeedbackReplies reply : replies) {
                    boolean isCurrentUser = reply.getUserId() == user.getId();
        %>
        <div class="message <%= isCurrentUser ? "message-sent" : "message-received" %>">
            <div class="message-bubble">
                <div class="message-header">
                    <span class="message-author">
                        <i class="fas fa-user"></i>
                        <%= reply.getUserName() %>
                    </span>
                    <span class="message-time">
                        <i class="fas fa-clock"></i>
                        <%= reply.getCreatedAt() %>
                    </span>
                </div>
                <div class="message-content">
                    <%= reply.getContent() %>
                </div>
            </div>
        </div>
        <%
                }
            } else {
        %>
        <div class="no-messages">
            <i class="fas fa-comments"></i>
            <p>No replies yet. Be the first to respond!</p>
        </div>
        <%
            }
        %>
    </div>

    <!-- Reply Form -->
    <div class="reply-form">
        <form action="feedback?action=reply&id=<%= feedback.getId() %>" method="post" id="replyForm">
            <div class="form-container">
                <div class="textarea-container">
                    <textarea name="reply_content" 
                              id="replyContent" 
                              placeholder="Type your reply here..." 
                              required
                              maxlength="500"
                              rows="3"></textarea>
                    <div class="char-counter">
                        <span id="charCount">0</span>/500
                    </div>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn-send">
                        <i class="fas fa-paper-plane"></i>
                        Send Reply
                    </button>
                </div>
            </div>
            
            <%
                if (request.getAttribute("error") != null) {
            %>
            <div class="error-message">
                <i class="fas fa-exclamation-triangle"></i>
                <%= request.getAttribute("error") %>
            </div>
            <%
                }
            %>
        </form>
    </div>
</div>

<!-- Scripts -->
<script src="Resources/JavaScript/FeedbackChat.js"></script>
</body>
</html>
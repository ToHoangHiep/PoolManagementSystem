package model;

import java.util.Date;

public class FeedbackReplies {
    private int id;
    private int feedbackId;
    private int userId;
    private String content;
    private Date createdAt;
    
    // User details
    private String userName;

    public FeedbackReplies(int id, int feedbackId, int userId, String content) {
        this.id = id;
        this.feedbackId = feedbackId;
        this.userId = userId;
        this.content = content;
    }

    public FeedbackReplies() {

    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getFeedbackId() {
        return feedbackId;
    }

    public void setFeedbackId(int feedbackId) {
        this.feedbackId = feedbackId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }
}

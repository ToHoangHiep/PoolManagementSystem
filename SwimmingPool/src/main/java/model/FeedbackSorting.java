package model;

public class FeedbackSorting {
    private String feedbackType;
    private Integer coachId;
    private Integer courseId;
    private String generalFeedbackType;
    private String sortBy;
    private boolean sortOrder;

    public FeedbackSorting(String feedbackType, Integer coachId, Integer courseId, String generalFeedbackType, String sortBy, boolean sortOrder) {
        this.feedbackType = feedbackType;
        this.coachId = coachId;
        this.courseId = courseId;
        this.generalFeedbackType = generalFeedbackType;
        this.sortBy = sortBy;
        this.sortOrder = sortOrder;
    }

    // Getters and setters

    public String getFeedbackType() {
        return feedbackType;
    }

    public void setFeedbackType(String feedbackType) {
        this.feedbackType = feedbackType;
    }

    public Integer getCoachId() {
        return coachId;
    }

    public void setCoachId(Integer coachId) {
        this.coachId = coachId;
    }

    public Integer getCourseId() {
        return courseId;
    }

    public void setCourseId(Integer courseId) {
        this.courseId = courseId;
    }

    public String getGeneralFeedbackType() {
        return generalFeedbackType;
    }

    public void setGeneralFeedbackType(String generalFeedbackType) {
        this.generalFeedbackType = generalFeedbackType;
    }

    public String getSortBy() {
        return sortBy;
    }

    public void setSortBy(String sortBy) {
        this.sortBy = sortBy;
    }

    public boolean isSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(boolean sortOrder) {
        this.sortOrder = sortOrder;
    }
}

package model;

import java.util.Date;

public class CourseForm {
    private int id;
    private int user_id;
    private int coach_id;
    private int course_id;
    private Date request_date;
    private boolean has_processed;

    public CourseForm() {
    }

    public CourseForm(int id, int user_id, int coach_id, int course_id, Date request_date, boolean has_processed) {
        this.id = id;
        this.user_id = user_id;
        this.coach_id = coach_id;
        this.course_id = course_id;
        this.request_date = request_date;
        this.has_processed = has_processed;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public int getCoach_id() {
        return coach_id;
    }

    public void setCoach_id(int coach_id) {
        this.coach_id = coach_id;
    }

    public int getCourse_id() {
        return course_id;
    }

    public void setCourse_id(int course_id) {
        this.course_id = course_id;
    }

    public Date getRequest_date() {
        return request_date;
    }

    public void setRequest_date(Date request_date) {
        this.request_date = request_date;
    }

    public boolean isHas_processed() {
        return has_processed;
    }

    public void setHas_processed(boolean has_processed) {
        this.has_processed = has_processed;
    }
}

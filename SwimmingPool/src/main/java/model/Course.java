package model;

import java.util.Date;

public class Course {
//    id INT PRIMARY KEY AUTO_INCREMENT,
//    name VARCHAR(100),
//    description TEXT,
//    price DECIMAL(10, 2),
//    duration INT,
//    estimated_session_time VARCHAR(50),
//    student_description VARCHAR(100),
//    schedule_description VARCHAR(100),
//    status ENUM('Active', 'Inactive') DEFAULT 'Inactive',
//    created_at DATETIME DEFAULT CURRENT_TIMESTAMP

    private int id;
    private String name;
    private String description;
    private double price;
    private int duration;
    private String estimated_session_time;
    private String schedule_description;
    private String status;
    private Date created_at;

    public Course() {
    }

    public Course(int id, String name, String description, double price, int duration, String estimated_session_time, String schedule_description, String status, Date created_at) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.price = price;
        this.duration = duration;
        this.estimated_session_time = estimated_session_time;
        this.schedule_description = schedule_description;
        this.status = status;
        this.created_at = created_at;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public String getEstimated_session_time() {
        return estimated_session_time;
    }

    public void setEstimated_session_time(String estimated_session_time) {
        this.estimated_session_time = estimated_session_time;
    }

    public String getSchedule_description() {
        return schedule_description;
    }

    public void setSchedule_description(String schedule_description) {
        this.schedule_description = schedule_description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Date created_at) {
        this.created_at = created_at;
    }
}

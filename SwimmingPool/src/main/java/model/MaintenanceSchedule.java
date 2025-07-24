package model;

import java.sql.Time;
import java.sql.Timestamp;

public class MaintenanceSchedule {
    private int id;
    private String title;
    private String description;
    private String frequency; // Daily, Weekly, Monthly
    private int assignedStaffId;
    private Time scheduledTime;
    private String status; // Scheduled, Completed, Missed
    private int createdBy;
    private Timestamp createdAt;

    // Thêm để hiển thị tên người phụ trách và người tạo (JOIN với Users table)
    private String assignedStaffName;
    private String createdByName;

    // Constructors
    public MaintenanceSchedule() {
    }

    public MaintenanceSchedule(int id, String title, String description, String frequency,
                               int assignedStaffId, Time scheduledTime, String status,
                               int createdBy, Timestamp createdAt,
                               String assignedStaffName, String createdByName) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.frequency = frequency;
        this.assignedStaffId = assignedStaffId;
        this.scheduledTime = scheduledTime;
        this.status = status;
        this.createdBy = createdBy;
        this.createdAt = createdAt;
        this.assignedStaffName = assignedStaffName;
        this.createdByName = createdByName;
    }

    // Getter & Setter
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getFrequency() {
        return frequency;
    }

    public void setFrequency(String frequency) {
        this.frequency = frequency;
    }

    public int getAssignedStaffId() {
        return assignedStaffId;
    }

    public void setAssignedStaffId(int assignedStaffId) {
        this.assignedStaffId = assignedStaffId;
    }

    public Time getScheduledTime() {
        return scheduledTime;
    }

    public void setScheduledTime(Time scheduledTime) {
        this.scheduledTime = scheduledTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getAssignedStaffName() {
        return assignedStaffName;
    }

    public void setAssignedStaffName(String assignedStaffName) {
        this.assignedStaffName = assignedStaffName;
    }

    public String getCreatedByName() {
        return createdByName;
    }

    public void setCreatedByName(String createdByName) {
        this.createdByName = createdByName;
    }
}

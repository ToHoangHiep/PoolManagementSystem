package model;

import java.sql.Time;
import java.sql.Timestamp;

public class MaintenanceSchedule {
    private int id;
    private String title;
    private String description;
    private String frequency;
    private int assignedStaffId;
    private Time scheduledTime;
    private String status;
    private int createdBy;
    private Timestamp createdAt;

    // Constructor
    public MaintenanceSchedule() {}

    // Getter & Setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getFrequency() { return frequency; }
    public void setFrequency(String frequency) { this.frequency = frequency; }

    public int getAssignedStaffId() { return assignedStaffId; }
    public void setAssignedStaffId(int assignedStaffId) { this.assignedStaffId = assignedStaffId; }

    public Time getScheduledTime() { return scheduledTime; }
    public void setScheduledTime(Time scheduledTime) { this.scheduledTime = scheduledTime; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}

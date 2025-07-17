package model;

import java.sql.Time;

public class MaintenanceSchedule {
    private int id;
    private String title;
    private String description;
    private String frequency;
    private Time scheduledTime;
    private int createdBy;
    private String createdByName;

    // Khi tạo log:
    private int staffId;
    private int poolAreaId;

    public MaintenanceSchedule() { }

    // Dùng để hiển thị template
    public MaintenanceSchedule(int id, String title, String description, String frequency) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.frequency = frequency;
    }

    // Dùng để lấy lịch chi tiết
    public MaintenanceSchedule(int id, String title, String description, String frequency,
                               Time scheduledTime, String createdByName) {
        this(id, title, description, frequency);
        this.scheduledTime = scheduledTime;
        this.createdByName = createdByName;
    }

    // Getters & Setters

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getFrequency() { return frequency; }
    public void setFrequency(String frequency) { this.frequency = frequency; }

    public Time getScheduledTime() { return scheduledTime; }
    public void setScheduledTime(Time scheduledTime) { this.scheduledTime = scheduledTime; }

    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }

    public String getCreatedByName() { return createdByName; }
    public void setCreatedByName(String createdByName) { this.createdByName = createdByName; }

    public int getStaffId() { return staffId; }
    public void setStaffId(int staffId) { this.staffId = staffId; }

    public int getPoolAreaId() { return poolAreaId; }
    public void setPoolAreaId(int poolAreaId) { this.poolAreaId = poolAreaId; }

    @Override
    public String toString() {
        return "MaintenanceSchedule{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", frequency='" + frequency + '\'' +
                ", scheduledTime=" + scheduledTime +
                ", createdByName='" + createdByName + '\'' +
                '}';
    }
}

package model;

import java.sql.Time;
import java.sql.Timestamp; // Thêm import này

public class MaintenanceSchedule {
    private int id;
    private String title;
    private String description;
    private String frequency;
    private Time scheduledTime;
    private int createdBy;
    private String createdByName;
    private Timestamp createdAt;

    private String status; // <--- THÊM DÒNG NÀY

    // Khi tạo log:
    private int staffId;
    private int poolAreaId;

    public MaintenanceSchedule() { }

    // Dùng để hiển thị template (có thể bổ sung createdBy nếu cần)
    public MaintenanceSchedule(int id, String title, String description, String frequency) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.frequency = frequency;
    }

    // Dùng để lấy lịch chi tiết (có thể bổ sung createdBy nếu cần)
    public MaintenanceSchedule(int id, String title, String description, String frequency,
                               Time scheduledTime, String createdByName) {
        this(id, title, description, frequency);
        this.scheduledTime = scheduledTime;
        this.createdByName = createdByName;
    }

    // Constructor mới nếu bạn muốn tạo đối tượng với createdAt ban đầu
    public MaintenanceSchedule(int id, String title, String description, String frequency, Time scheduledTime, int createdBy, String createdByName, Timestamp createdAt) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.frequency = frequency;
        this.scheduledTime = scheduledTime;
        this.createdBy = createdBy;
        this.createdByName = createdByName;
        this.createdAt = createdAt;
        // status có thể cần được khởi tạo mặc định hoặc truyền vào nếu bạn có các constructor khác
        this.status = "Active"; // Mặc định là Active nếu không được truyền vào
    }

    // Nếu bạn có constructor đầy đủ tham số, hãy cập nhật nó để bao gồm 'status'
    public MaintenanceSchedule(int id, String title, String description, String frequency, Time scheduledTime, int createdBy, String createdByName, Timestamp createdAt, String status) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.frequency = frequency;
        this.scheduledTime = scheduledTime;
        this.createdBy = createdBy;
        this.createdByName = createdByName;
        this.createdAt = createdAt;
        this.status = status; // <--- Cập nhật constructor đầy đủ
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

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    // <--- THÊM GETTER VÀ SETTER NÀY CHO 'status'
    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    // End new getters & setters

    @Override
    public String toString() {
        return "MaintenanceSchedule{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", frequency='" + frequency + '\'' +
                ", scheduledTime=" + scheduledTime +
                ", createdBy=" + createdBy +
                ", createdByName='" + createdByName + '\'' +
                ", createdAt=" + createdAt +
                ", status='" + status + '\'' + // <--- Thêm vào toString để dễ debug
                ", staffId=" + staffId + // Thêm vào toString nếu muốn
                ", poolAreaId=" + poolAreaId + // Thêm vào toString nếu muốn
                '}';
    }
}
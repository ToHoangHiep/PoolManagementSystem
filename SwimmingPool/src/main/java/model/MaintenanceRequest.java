package model;

import java.sql.Timestamp;

public class MaintenanceRequest {
    private int id;
    private String description;
    private String status;
    private int createdBy;
    private int staffId; // Thêm trường này
    private int poolAreaId;
    private Timestamp createdAt;
    private Timestamp updatedAt; // Thêm trường này

    // transient fields for display
    private String createdByName;
    private String poolAreaName;

    public MaintenanceRequest() {
    }

    public MaintenanceRequest(int createdBy, String description, int poolAreaId) {
        this.createdBy = createdBy;
        this.description = description;
        this.poolAreaId = poolAreaId;
    }

    // --- Getters and Setters ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }

    public int getStaffId() { return staffId; }
    public void setStaffId(int staffId) { this.staffId = staffId; }

    public int getPoolAreaId() { return poolAreaId; }
    public void setPoolAreaId(int poolAreaId) { this.poolAreaId = poolAreaId; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getCreatedByName() { return createdByName; }
    public void setCreatedByName(String createdByName) { this.createdByName = createdByName; }

    public String getPoolAreaName() { return poolAreaName; }
    public void setPoolAreaName(String poolAreaName) { this.poolAreaName = poolAreaName; }
}
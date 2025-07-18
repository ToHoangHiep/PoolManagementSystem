package model;

import java.util.Date;

public class MaintenanceRequest {
    private int id;
    private String description;
    private String status;
    private int createdBy;
    private Date createdAt;
    private int poolAreaId; // <-- Thêm dòng này

    public MaintenanceRequest() { }

    public MaintenanceRequest(int createdBy, String description, int poolAreaId) { // <-- Sửa constructor
        this.createdBy = createdBy;
        this.description = description;
        this.poolAreaId = poolAreaId; // <-- Thêm dòng này
        this.status = "Open";
    }

    // Getters & Setters

    public int getPoolAreaId() { // <-- Thêm getter/setter
        return poolAreaId;
    }

    public void setPoolAreaId(int poolAreaId) {
        this.poolAreaId = poolAreaId;
    }

    // ... Giữ nguyên các getter/setter còn lại ...
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
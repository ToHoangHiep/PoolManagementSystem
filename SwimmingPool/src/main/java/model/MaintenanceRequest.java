package model;

import java.util.Date;

public class MaintenanceRequest {
    private int id;
    private String description;
    private String status;
    private int createdBy;
    private Date createdAt;

    public MaintenanceRequest() { }

    // Khi insert request mới
    public MaintenanceRequest(int createdBy, String description) {
        this.createdBy = createdBy;
        this.description = description;
        this.status = "Open";
    }

    // Getters & Setters

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

    @Override
    public String toString() {
        return "MaintenanceRequest{" +
                "id=" + id +
                ", description='" + description + '\'' +
                ", status='" + status + '\'' +
                ", createdBy=" + createdBy +
                ", createdAt=" + createdAt +
                '}';
    }
}

package model;

import java.util.Date;
import java.sql.Timestamp; // Cần import Timestamp

public class MaintenanceLog {
    private int id;
    private int scheduleId;
    private int staffId;
    private String staffName; // <-- Cần THÊM VÀO model
    private int poolAreaId;
    private Date maintenanceDate; // Giữ nguyên java.util.Date
    private String status;
    private String note;
    private String areaName; // <-- Cần THÊM VÀO model
    private String scheduleTitle; // <-- Cần THÊM VÀO model
    private String frequency; // Đã có trong code của bạn
    private Timestamp updatedAt; // <-- Cần THÊM VÀO model

    public MaintenanceLog() { }

    // Giữ nguyên constructor hiện có của bạn
    public MaintenanceLog(int id, int scheduleId, int staffId, int poolAreaId,
                          Date maintenanceDate, String status, String note,
                          String areaName, String scheduleTitle, String frequency) {
        this.id = id;
        this.scheduleId = scheduleId;
        this.staffId = staffId;
        this.poolAreaId = poolAreaId;
        this.maintenanceDate = maintenanceDate;
        this.status = status;
        this.note = note;
        this.areaName = areaName;
        this.scheduleTitle = scheduleTitle;
        this.frequency = frequency;
    }

    // THÊM constructor đầy đủ nếu bạn muốn (tùy chọn)
    public MaintenanceLog(int id, int scheduleId, int staffId, String staffName, int poolAreaId,
                          Date maintenanceDate, String status, String note,
                          String areaName, String scheduleTitle, String frequency, Timestamp updatedAt) {
        this.id = id;
        this.scheduleId = scheduleId;
        this.staffId = staffId;
        this.staffName = staffName;
        this.poolAreaId = poolAreaId;
        this.maintenanceDate = maintenanceDate;
        this.status = status;
        this.note = note;
        this.areaName = areaName;
        this.scheduleTitle = scheduleTitle;
        this.frequency = frequency;
        this.updatedAt = updatedAt;
    }

    // Getters & Setters (Đảm bảo có đủ cho tất cả các trường, đặc biệt là các trường mới)
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getScheduleId() { return scheduleId; }
    public void setScheduleId(int scheduleId) { this.scheduleId = scheduleId; }
    public int getStaffId() { return staffId; }
    public void setStaffId(int staffId) { this.staffId = staffId; }

    // NEW Getters & Setters
    public String getStaffName() { return staffName; }
    public void setStaffName(String staffName) { this.staffName = staffName; }

    public int getPoolAreaId() { return poolAreaId; }
    public void setPoolAreaId(int poolAreaId) { this.poolAreaId = poolAreaId; }

    // NEW Getters & Setters
    public String getAreaName() { return areaName; }
    public void setAreaName(String areaName) { this.areaName = areaName; }

    public Date getMaintenanceDate() { return maintenanceDate; }
    public void setMaintenanceDate(Date maintenanceDate) { this.maintenanceDate = maintenanceDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    // NEW Getters & Setters
    public String getScheduleTitle() { return scheduleTitle; }
    public void setScheduleTitle(String scheduleTitle) { this.scheduleTitle = scheduleTitle; }

    public String getFrequency() { return frequency; }
    public void setFrequency(String frequency) { this.frequency = frequency; }

    // NEW Getters & Setters
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    @Override
    public String toString() {
        return "MaintenanceLog{" +
                "id=" + id +
                ", scheduleId=" + scheduleId +
                ", staffId=" + staffId +
                ", staffName='" + staffName + '\'' + // Thêm vào toString
                ", poolAreaId=" + poolAreaId +
                ", maintenanceDate=" + maintenanceDate +
                ", status='" + status + '\'' +
                ", note='" + note + '\'' +
                ", areaName='" + areaName + '\'' +
                ", scheduleTitle='" + scheduleTitle + '\'' +
                ", frequency='" + frequency + '\'' +
                ", updatedAt=" + updatedAt + // Thêm vào toString
                '}';
    }
}
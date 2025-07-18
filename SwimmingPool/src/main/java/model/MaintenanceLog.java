package model;

import java.util.Date;

public class MaintenanceLog {
    private int id;
    private int scheduleId;
    private int staffId;
    private int poolAreaId;
    private Date maintenanceDate;
    private String status;
    private String note;
    private String areaName;
    private String scheduleTitle;

    public MaintenanceLog() { }

    public MaintenanceLog(int id, int scheduleId, int staffId, int poolAreaId,
                          Date maintenanceDate, String status, String note,
                          String areaName, String scheduleTitle) {
        this.id = id;
        this.scheduleId = scheduleId;
        this.staffId = staffId;
        this.poolAreaId = poolAreaId;
        this.maintenanceDate = maintenanceDate;
        this.status = status;
        this.note = note;
        this.areaName = areaName;
        this.scheduleTitle = scheduleTitle;
    }

    // Getters & Setters

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(int scheduleId) {
        this.scheduleId = scheduleId;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public int getPoolAreaId() {
        return poolAreaId;
    }

    public void setPoolAreaId(int poolAreaId) {
        this.poolAreaId = poolAreaId;
    }

    public Date getMaintenanceDate() {
        return maintenanceDate;
    }

    public void setMaintenanceDate(Date maintenanceDate) {
        this.maintenanceDate = maintenanceDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getAreaName() {
        return areaName;
    }

    public void setAreaName(String areaName) {
        this.areaName = areaName;
    }

    public String getScheduleTitle() {
        return scheduleTitle;
    }

    public void setScheduleTitle(String scheduleTitle) {
        this.scheduleTitle = scheduleTitle;
    }

    @Override
    public String toString() {
        return "MaintenanceLog{" +
                "id=" + id +
                ", scheduleId=" + scheduleId +
                ", staffId=" + staffId +
                ", poolAreaId=" + poolAreaId +
                ", maintenanceDate=" + maintenanceDate +
                ", status='" + status + '\'' +
                ", note='" + note + '\'' +
                ", areaName='" + areaName + '\'' +
                ", scheduleTitle='" + scheduleTitle + '\'' +
                '}';
    }
}

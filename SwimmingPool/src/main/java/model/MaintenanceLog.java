package model;

import java.util.Date;

public class MaintenanceLog {
    private int id;
    private Date maintenanceDate;
    private String status;
    private String note;
    private String areaName;
    private String scheduleTitle;

    public MaintenanceLog() { }

    public MaintenanceLog(int id, Date maintenanceDate, String status,
                          String note, String areaName, String scheduleTitle) {
        this.id = id;
        this.maintenanceDate = maintenanceDate;
        this.status = status;
        this.note = note;
        this.areaName = areaName;
        this.scheduleTitle = scheduleTitle;
    }

    // Getters & Setters

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Date getMaintenanceDate() { return maintenanceDate; }
    public void setMaintenanceDate(Date maintenanceDate) { this.maintenanceDate = maintenanceDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public String getAreaName() { return areaName; }
    public void setAreaName(String areaName) { this.areaName = areaName; }

    public String getScheduleTitle() { return scheduleTitle; }
    public void setScheduleTitle(String scheduleTitle) { this.scheduleTitle = scheduleTitle; }

    @Override
    public String toString() {
        return "MaintenanceLog{" +
                "id=" + id +
                ", maintenanceDate=" + maintenanceDate +
                ", status='" + status + '\'' +
                ", note='" + note + '\'' +
                ", areaName='" + areaName + '\'' +
                ", scheduleTitle='" + scheduleTitle + '\'' +
                '}';
    }
}

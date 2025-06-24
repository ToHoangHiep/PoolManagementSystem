package model;

import java.sql.Date;
import java.sql.Timestamp;

public class MaintenanceLog {
    private int id;
    private int scheduleId;
    private int staffId;
    private Date maintenanceDate;
    private String note;
    private String status; // Done, Missed, Rescheduled
    private Timestamp logTime;

    // Thêm tên lịch và tên nhân viên (khi cần JOIN)
    private String scheduleTitle;
    private String staffName;

    // Constructors
    public MaintenanceLog() {}

    public MaintenanceLog(int id, int scheduleId, int staffId, Date maintenanceDate, String note,
                          String status, Timestamp logTime, String scheduleTitle, String staffName) {
        this.id = id;
        this.scheduleId = scheduleId;
        this.staffId = staffId;
        this.maintenanceDate = maintenanceDate;
        this.note = note;
        this.status = status;
        this.logTime = logTime;
        this.scheduleTitle = scheduleTitle;
        this.staffName = staffName;
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

    public Date getMaintenanceDate() {
        return maintenanceDate;
    }

    public void setMaintenanceDate(Date maintenanceDate) {
        this.maintenanceDate = maintenanceDate;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getLogTime() {
        return logTime;
    }

    public void setLogTime(Timestamp logTime) {
        this.logTime = logTime;
    }

    public String getScheduleTitle() {
        return scheduleTitle;
    }

    public void setScheduleTitle(String scheduleTitle) {
        this.scheduleTitle = scheduleTitle;
    }

    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }
}

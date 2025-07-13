package model;

public class SwimCourse {
    private int id;
    private String name;
    private String description;
    private double price;
    private int duration; // số buổi học
    private String estimatedSessionTime; // thời gian mỗi buổi học
    private String studentDescription;   // mô tả số học viên
    private String scheduleDescription;  // mô tả lịch học
    private String status; // có thể có nếu bạn dùng

    // Constructors
    public SwimCourse() {}

    public SwimCourse(int id, String name, String description, double price, int duration,
                      String estimatedSessionTime, String studentDescription, String scheduleDescription, String status) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.price = price;
        this.duration = duration;
        this.estimatedSessionTime = estimatedSessionTime;
        this.studentDescription = studentDescription;
        this.scheduleDescription = scheduleDescription;
        this.status = status;
    }

    // Getters & Setters

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public String getEstimatedSessionTime() {
        return estimatedSessionTime;
    }

    public void setEstimatedSessionTime(String estimatedSessionTime) {
        this.estimatedSessionTime = estimatedSessionTime;
    }

    public String getStudentDescription() {
        return studentDescription;
    }

    public void setStudentDescription(String studentDescription) {
        this.studentDescription = studentDescription;
    }

    public String getScheduleDescription() {
        return scheduleDescription;
    }

    public void setScheduleDescription(String scheduleDescription) {
        this.scheduleDescription = scheduleDescription;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}

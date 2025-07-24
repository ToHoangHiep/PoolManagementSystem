package model;

// Import java.sql.Time nếu bạn muốn thêm giờ mở cửa/đóng cửa, nhưng yêu cầu đã bỏ qua.

public class PoolArea {
    private int id;
    private String name;
    private String description;
    private String type; // Loại khu: Standard, Trẻ em, VIP, Tập luyện
    private double waterDepth; // Độ sâu nước (m)
    private double length; // Chiều dài (m)
    private double width; // Chiều rộng (m)
    private int maxCapacity; // Sức chứa tối đa

    // Constructor
    public PoolArea() {
    }

    public PoolArea(int id, String name, String description, String type, double waterDepth, double length, double width, int maxCapacity) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.type = type;
        this.waterDepth = waterDepth;
        this.length = length;
        this.width = width;
        this.maxCapacity = maxCapacity;
    }

    public PoolArea(String name, String description, String type, double waterDepth, double length, double width, int maxCapacity) {
        this.name = name;
        this.description = description;
        this.type = type;
        this.waterDepth = waterDepth;
        this.length = length;
        this.width = width;
        this.maxCapacity = maxCapacity;
    }

    // Getters and Setters
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

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public double getWaterDepth() {
        return waterDepth;
    }

    public void setWaterDepth(double waterDepth) {
        this.waterDepth = waterDepth;
    }

    public double getLength() {
        return length;
    }

    public void setLength(double length) {
        this.length = length;
    }

    public double getWidth() {
        return width;
    }

    public void setWidth(double width) {
        this.width = width;
    }

    public int getMaxCapacity() {
        return maxCapacity;
    }

    public void setMaxCapacity(int maxCapacity) {
        this.maxCapacity = maxCapacity;
    }
}
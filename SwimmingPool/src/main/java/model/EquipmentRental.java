package model;

import java.sql.Date;
import java.sql.Timestamp;

public class EquipmentRental {
    private int rentalId;
    private String customerName;
    private String customerIdCard;
    private int staffId;
    private int inventoryId;
    private int quantity;
    private Date rentalDate;
    private double rentPrice;
    private double totalAmount;
    private String status;
    private Timestamp createdAt;
    private Timestamp returnTime;
    private Date dueDate;
    private String notes;

    // Additional fields for display
    private String itemName;
    private String category;
    private String unit;
    private double salePrice;
    private int usageId;

    // Constructors
    public EquipmentRental() {}

    public EquipmentRental(String customerName, String customerIdCard, int staffId,
                           int inventoryId, int quantity, Date rentalDate,
                           double rentPrice, double totalAmount) {
        this.customerName = customerName;
        this.customerIdCard = customerIdCard;
        this.staffId = staffId;
        this.inventoryId = inventoryId;
        this.quantity = quantity;
        this.rentalDate = rentalDate;
        this.rentPrice = rentPrice;
        this.totalAmount = totalAmount;
        this.status = "active";
    }

    // Getters
    public int getRentalId() { return rentalId; }
    public String getCustomerName() { return customerName; }
    public String getCustomerIdCard() { return customerIdCard; }
    public int getStaffId() { return staffId; }
    public int getInventoryId() { return inventoryId; }
    public int getQuantity() { return quantity; }
    public Date getRentalDate() { return rentalDate; }
    public double getRentPrice() { return rentPrice; }
    public double getTotalAmount() { return totalAmount; }
    public String getStatus() { return status; }
    public Timestamp getCreatedAt() { return createdAt; }
    public Timestamp getReturnTime() { return returnTime; }
    public Date getDueDate() { return dueDate; }
    public String getNotes() { return notes; }
    public String getItemName() { return itemName; }
    public String getCategory() { return category; }
    public String getUnit() { return unit; }
    public double getSalePrice() { return salePrice; }
    public int getUsageId() { return usageId; }

    // Setters
    public void setRentalId(int rentalId) { this.rentalId = rentalId; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public void setCustomerIdCard(String customerIdCard) { this.customerIdCard = customerIdCard; }
    public void setStaffId(int staffId) { this.staffId = staffId; }
    public void setInventoryId(int inventoryId) { this.inventoryId = inventoryId; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public void setRentalDate(Date rentalDate) { this.rentalDate = rentalDate; }
    public void setRentPrice(double rentPrice) { this.rentPrice = rentPrice; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
    public void setStatus(String status) { this.status = status; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public void setReturnTime(Timestamp returnTime) { this.returnTime = returnTime; }
    public void setDueDate(Date dueDate) { this.dueDate = dueDate; }
    public void setNotes(String notes) { this.notes = notes; }
    public void setItemName(String itemName) { this.itemName = itemName; }
    public void setCategory(String category) { this.category = category; }
    public void setUnit(String unit) { this.unit = unit; }
    public void setSalePrice(double salePrice) { this.salePrice = salePrice; }
    public void setUsageId(int usageId) { this.usageId = usageId; }

    // Helper methods
    public boolean isActive() { return "active".equalsIgnoreCase(status); }
    public boolean isReturned() { return "returned".equalsIgnoreCase(status); }
}
package model;

import java.sql.Timestamp;

public class EquipmentSale {
    private int saleId;
    private String customerName;
    private int staffId;
    private int inventoryId;
    private int quantity;
    private double salePrice;
    private double totalAmount;
    private Timestamp createdAt;

    // Additional fields from Inventory
    private String itemName;
    private String category;
    private String unit;
    private int usageId;

    // Constructors
    public EquipmentSale() {}

    public EquipmentSale(String customerName, int staffId, int inventoryId,
                         int quantity, double salePrice, double totalAmount) {
        this.customerName = customerName;
        this.staffId = staffId;
        this.inventoryId = inventoryId;
        this.quantity = quantity;
        this.salePrice = salePrice;
        this.totalAmount = totalAmount;
    }

    // Getters
    public int getSaleId() {
        return saleId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public int getStaffId() {
        return staffId;
    }

    public int getInventoryId() {
        return inventoryId;
    }

    public int getQuantity() {
        return quantity;
    }

    public double getSalePrice() {
        return salePrice;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public String getItemName() {
        return itemName;
    }

    public String getCategory() {
        return category;
    }

    public String getUnit() {
        return unit;
    }

    public int getUsageId() {
        return usageId;
    }

    // Setters
    public void setSaleId(int saleId) {
        this.saleId = saleId;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public void setInventoryId(int inventoryId) {
        this.inventoryId = inventoryId;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public void setSalePrice(double salePrice) {
        this.salePrice = salePrice;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public void setUsageId(int usageId) {
        this.usageId = usageId;
    }
}

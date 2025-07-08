
package model;
import java.util.Date;


public class Inventory {
    private int inventoryId;
    private int managerId;
    private String itemName;
    private int categoryID;
    private int quantity;
    private String unit;
    private String status;
    private Date lastUpdated;
    private int thresholdQuantity;
    private int usageId;
    private String usageName;
    private String categoryName;
    private double importPrice;


    // Getters and Setters
    public int getInventoryId() {
        return inventoryId;
    }

    public void setInventoryId(int inventoryId) {
        this.inventoryId = inventoryId;
    }

    public int getManagerId() {
        return managerId;
    }

    public void setManagerId(int managerId) {
        this.managerId = managerId;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = this.categoryID;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getLastUpdated() {
        return lastUpdated;
    }

    public void setLastUpdated(Date lastUpdated) {
        this.lastUpdated = lastUpdated;
    }

    public int getThresholdQuantity() { return thresholdQuantity;}

    public void setThresholdQuantity(int thresholdQuantity) { this.thresholdQuantity = thresholdQuantity;}

    public int getUsageId() {return usageId;}
    public void setUsageId(int usageId) { this.usageId = usageId;}

    public String getUsageName() {return usageName;}
    public void setUsageName(String usageName) { this.usageName = usageName;}

    public String getCategoryName() {return categoryName;}
    public void setCategoryName(String categoryName) { this.categoryName = categoryName;}

    public double getImportPrice() {return importPrice;}
    public void setImportPrice(double importPrice) {this.importPrice = importPrice;}

}

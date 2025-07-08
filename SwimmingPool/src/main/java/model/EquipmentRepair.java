package model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

public class EquipmentRepair {
    private int repairId;
    private int compensationId;
    private int inventoryId;
    private String repairDescription;
    private BigDecimal repairCost;
    private String repairVendor;
    private String repairStatus; // 'pending', 'in_progress', 'completed', 'failed', 'cancelled'
    private Timestamp startedAt;
    private Timestamp completedAt;
    private Date estimatedCompletion;
    private String postRepairCondition; // 'like_new', 'good', 'fair', 'poor'
    private Boolean canReturnToInventory;
    private Timestamp createdAt;

    // Default constructor
    public EquipmentRepair() {
        this.repairStatus = "pending";
        this.createdAt = new Timestamp(System.currentTimeMillis());
    }

    // Constructor with essential fields
    public EquipmentRepair(int compensationId, int inventoryId, String repairDescription, BigDecimal repairCost) {
        this();
        this.compensationId = compensationId;
        this.inventoryId = inventoryId;
        this.repairDescription = repairDescription;
        this.repairCost = repairCost;
    }

    // Getters and Setters
    public int getRepairId() {
        return repairId;
    }

    public void setRepairId(int repairId) {
        this.repairId = repairId;
    }

    public int getCompensationId() {
        return compensationId;
    }

    public void setCompensationId(int compensationId) {
        this.compensationId = compensationId;
    }

    public int getInventoryId() {
        return inventoryId;
    }

    public void setInventoryId(int inventoryId) {
        this.inventoryId = inventoryId;
    }

    public String getRepairDescription() {
        return repairDescription;
    }

    public void setRepairDescription(String repairDescription) {
        this.repairDescription = repairDescription;
    }

    public BigDecimal getRepairCost() {
        return repairCost;
    }

    public void setRepairCost(BigDecimal repairCost) {
        this.repairCost = repairCost;
    }

    public String getRepairVendor() {
        return repairVendor;
    }

    public void setRepairVendor(String repairVendor) {
        this.repairVendor = repairVendor;
    }

    public String getRepairStatus() {
        return repairStatus;
    }

    public void setRepairStatus(String repairStatus) {
        this.repairStatus = repairStatus;
    }

    public Timestamp getStartedAt() {
        return startedAt;
    }

    public void setStartedAt(Timestamp startedAt) {
        this.startedAt = startedAt;
    }

    public Timestamp getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Timestamp completedAt) {
        this.completedAt = completedAt;
    }

    public Date getEstimatedCompletion() {
        return estimatedCompletion;
    }

    public void setEstimatedCompletion(Date estimatedCompletion) {
        this.estimatedCompletion = estimatedCompletion;
    }

    public String getPostRepairCondition() {
        return postRepairCondition;
    }

    public void setPostRepairCondition(String postRepairCondition) {
        this.postRepairCondition = postRepairCondition;
    }

    public Boolean getCanReturnToInventory() {
        return canReturnToInventory;
    }

    public void setCanReturnToInventory(Boolean canReturnToInventory) {
        this.canReturnToInventory = canReturnToInventory;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    // Utility methods
    public boolean isCompleted() {
        return "completed".equals(repairStatus);
    }

    public boolean isInProgress() {
        return "in_progress".equals(repairStatus);
    }

    public boolean isPending() {
        return "pending".equals(repairStatus);
    }
}


package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

// Equipment Compensations Model
public class EquipmentCompensation {
    private int compensationId;
    private int rentalId;
    private String compensationType; // 'damaged', 'lost', 'overdue_fee'
    private String damageDescription;
    private String damageLevel; // 'minor', 'major', 'total'
    private BigDecimal originalPrice;
    private BigDecimal compensationRate;
    private BigDecimal totalAmount;
    private BigDecimal paidAmount;
    private String paymentStatus; // 'pending', 'partial', 'paid', 'waived'
    private Boolean canRepair;
    private Timestamp createdAt;
    private Timestamp resolvedAt;

    // Default constructor
    public EquipmentCompensation() {
        this.paidAmount = BigDecimal.ZERO;
        this.paymentStatus = "pending";
        this.createdAt = new Timestamp(System.currentTimeMillis());
    }

    // Constructor with essential fields
    public EquipmentCompensation(int rentalId, String compensationType, BigDecimal originalPrice,
                                 BigDecimal compensationRate, BigDecimal totalAmount) {
        this();
        this.rentalId = rentalId;
        this.compensationType = compensationType;
        this.originalPrice = originalPrice;
        this.compensationRate = compensationRate;
        this.totalAmount = totalAmount;
    }

    // Getters and Setters
    public int getCompensationId() {
        return compensationId;
    }

    public void setCompensationId(int compensationId) {
        this.compensationId = compensationId;
    }

    public int getRentalId() {
        return rentalId;
    }

    public void setRentalId(int rentalId) {
        this.rentalId = rentalId;
    }

    public String getCompensationType() {
        return compensationType;
    }

    public void setCompensationType(String compensationType) {
        this.compensationType = compensationType;
    }

    public String getDamageDescription() {
        return damageDescription;
    }

    public void setDamageDescription(String damageDescription) {
        this.damageDescription = damageDescription;
    }

    public String getDamageLevel() {
        return damageLevel;
    }

    public void setDamageLevel(String damageLevel) {
        this.damageLevel = damageLevel;
    }

    public BigDecimal getOriginalPrice() {
        return originalPrice;
    }

    public void setOriginalPrice(BigDecimal originalPrice) {
        this.originalPrice = originalPrice;
    }

    public BigDecimal getCompensationRate() {
        return compensationRate;
    }

    public void setCompensationRate(BigDecimal compensationRate) {
        this.compensationRate = compensationRate;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public BigDecimal getPaidAmount() {
        return paidAmount;
    }

    public void setPaidAmount(BigDecimal paidAmount) {
        this.paidAmount = paidAmount;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public Boolean getCanRepair() {
        return canRepair;
    }

    public void setCanRepair(Boolean canRepair) {
        this.canRepair = canRepair;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getResolvedAt() {
        return resolvedAt;
    }

    public void setResolvedAt(Timestamp resolvedAt) {
        this.resolvedAt = resolvedAt;
    }

    // Utility methods
    public BigDecimal getRemainingAmount() {
        return totalAmount.subtract(paidAmount);
    }

    public boolean isFullyPaid() {
        return "paid".equals(paymentStatus);
    }

    public boolean isPending() {
        return "pending".equals(paymentStatus);
    }
}

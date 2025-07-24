package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class EquipmentCompensation {

    // ===================== KHAI BÁO BIẾN =====================

    private int compensationId;
    private int rentalId;
    private String compensationType;  // 'damaged', 'lost', 'overdue_fee'
    private String damageDescription;
    private BigDecimal importPriceTotal;  // tổng giá nhập
    private BigDecimal compensationRate;
    private BigDecimal totalAmount;
    private BigDecimal paidAmount;
    private String paymentStatus;    // 'pending', 'partial', 'paid', 'waived'
    private Boolean canRepair;
    private Timestamp createdAt;
    private Timestamp resolvedAt;

    // ===================== CONSTRUCTORS =====================

    public EquipmentCompensation() {
    }

    public EquipmentCompensation(int compensationId, int rentalId, String compensationType,
                                 String damageDescription, BigDecimal importPriceTotal,
                                 BigDecimal compensationRate, BigDecimal totalAmount, BigDecimal paidAmount,
                                 String paymentStatus, Boolean canRepair, Timestamp createdAt, Timestamp resolvedAt) {
        this.compensationId = compensationId;
        this.rentalId = rentalId;
        this.compensationType = compensationType;
        this.damageDescription = damageDescription;
        this.importPriceTotal = importPriceTotal;
        this.compensationRate = compensationRate;
        this.totalAmount = totalAmount;
        this.paidAmount = paidAmount;
        this.paymentStatus = paymentStatus;
        this.canRepair = canRepair;
        this.createdAt = createdAt;
        this.resolvedAt = resolvedAt;
    }

    // ===================== GETTERS & SETTERS =====================

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

    public BigDecimal getImportPriceTotal() {
        return importPriceTotal;
    }

    public void setImportPriceTotal(BigDecimal importPriceTotal) {
        this.importPriceTotal = importPriceTotal;
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


    //    Tính toán số tiền còn lại cần thanh toán
    public BigDecimal getRemainingAmount() {
        // Kiểm tra null safety
        if (totalAmount == null || paidAmount == null) {
            return BigDecimal.ZERO;
        }

        BigDecimal remaining = totalAmount.subtract(paidAmount);

        // Đảm bảo không trả về số âm (nếu có trả thừa)
        return remaining.compareTo(BigDecimal.ZERO) > 0 ? remaining : BigDecimal.ZERO;
    }


    //     Kiểm tra xem compensation đã được thanh toán đầy đủ chưa
    public boolean isFullyPaid() {
        // Kiểm tra null safety
        if (totalAmount == null || paidAmount == null) {
            return false;
        }

        // So sánh paidAmount với totalAmount
        return paidAmount.compareTo(totalAmount) >= 0;
    }


}
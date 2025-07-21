package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Payment {
    // Thuộc tính chính
    private int paymentId;
    private Integer userId;              // Integer để có thể null
    private String customerName;
    private String customerIdCard;
    private BigDecimal amount;
    private String paymentMethod;         // 'cash', 'transfer', 'card'
    private String paymentFor;            // 'compensation', 'course', 'ticket', 'rental'
    private int referenceId;              // ID của compensation/course/ticket...
    private String status;                // 'pending', 'completed', 'failed', 'cancelled'
    private Timestamp paymentDate;
    private String notes;
    private Integer staffId;              // Integer để có thể null

    // Constructor mặc định
    public Payment() {
        this.status = "pending";
        this.paymentDate = new Timestamp(System.currentTimeMillis());
    }

    // Constructor đầy đủ cho compensation payment
    public Payment(String customerName, String customerIdCard, BigDecimal amount,
                   String paymentFor, int referenceId, Integer staffId) {
        this();
        this.customerName = customerName;
        this.customerIdCard = customerIdCard;
        this.amount = amount;
        this.paymentFor = paymentFor;
        this.referenceId = referenceId;
        this.staffId = staffId;
    }

    // Getters
    public int getPaymentId() {
        return paymentId;
    }

    public Integer getUserId() {
        return userId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public String getCustomerIdCard() {
        return customerIdCard;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public String getPaymentFor() {
        return paymentFor;
    }

    public int getReferenceId() {
        return referenceId;
    }

    public String getStatus() {
        return status;
    }

    public Timestamp getPaymentDate() {
        return paymentDate;
    }

    public String getNotes() {
        return notes;
    }

    public Integer getStaffId() {
        return staffId;
    }

    // Setters
    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public void setCustomerIdCard(String customerIdCard) {
        this.customerIdCard = customerIdCard;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public void setPaymentFor(String paymentFor) {
        this.paymentFor = paymentFor;
    }

    public void setReferenceId(int referenceId) {
        this.referenceId = referenceId;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setPaymentDate(Timestamp paymentDate) {
        this.paymentDate = paymentDate;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public void setStaffId(Integer staffId) {
        this.staffId = staffId;
    }

    // Utility methods
    public boolean isPending() {
        return "pending".equals(this.status);
    }

    public boolean isCompleted() {
        return "completed".equals(this.status);
    }

    public boolean isFailed() {
        return "failed".equals(this.status);
    }

    public boolean isCancelled() {
        return "cancelled".equals(this.status);
    }

    // ToString cho debug
    @Override
    public String toString() {
        return "Payment{" +
                "paymentId=" + paymentId +
                ", customerName='" + customerName + '\'' +
                ", amount=" + amount +
                ", paymentFor='" + paymentFor + '\'' +
                ", referenceId=" + referenceId +
                ", status='" + status + '\'' +
                ", paymentDate=" + paymentDate +
                '}';
    }
}
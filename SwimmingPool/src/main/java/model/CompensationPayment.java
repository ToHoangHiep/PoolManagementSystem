package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class CompensationPayment {
    private int paymentId;
    private int compensationId;
    private BigDecimal paymentAmount;
    private Timestamp paymentDate;
    private String notes;

    // Default constructor
    public CompensationPayment() {
        this.paymentDate = new Timestamp(System.currentTimeMillis());
    }

    // Constructor with essential fields
    public CompensationPayment(int compensationId, BigDecimal paymentAmount) {
        this();
        this.compensationId = compensationId;
        this.paymentAmount = paymentAmount;
    }

    // Getters and Setters
    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public int getCompensationId() {
        return compensationId;
    }

    public void setCompensationId(int compensationId) {
        this.compensationId = compensationId;
    }

    public BigDecimal getPaymentAmount() {
        return paymentAmount;
    }

    public void setPaymentAmount(BigDecimal paymentAmount) {
        this.paymentAmount = paymentAmount;
    }

    public Timestamp getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(Timestamp paymentDate) {
        this.paymentDate = paymentDate;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }
}





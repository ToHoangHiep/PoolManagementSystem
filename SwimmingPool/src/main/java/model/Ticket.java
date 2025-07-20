package model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class Ticket {
    private int ticketId;
    private int userId;
    private int ticketTypeId;
    private String ticketTypeName; // Optional, useful for displaying
    private BigDecimal price;
    private int quantity;
    private LocalDate startDate;
    private LocalDate endDate;
    private TicketStatus ticketStatus;
    private PaymentStatus paymentStatus;
    private Integer paymentId;
    private BigDecimal total;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String customerName;    // Thêm: Tên khách hàng
    private String customerIdCard;  // Thêm: CMND/CCCD khách hàng

    public enum TicketTypeName {
        Single, Monthly, ThreeMonthly, SixMonthly, Year
    }
    public enum TicketStatus {
        Active, Expired, Cancelled
    }

    public enum PaymentStatus {
        Paid, Unpaid
    }

    public Ticket() {}

    public Ticket(int ticketId, int userId, int ticketTypeId, String ticketTypeName, BigDecimal price, int quantity,
                  LocalDate startDate, LocalDate endDate, TicketStatus ticketStatus,
                  PaymentStatus paymentStatus, Integer paymentId, BigDecimal total,
                  LocalDateTime createdAt, LocalDateTime updatedAt, String customerName, String customerIdCard) {
        this.ticketId = ticketId;
        this.userId = userId;
        this.ticketTypeId = ticketTypeId;
        this.ticketTypeName = ticketTypeName;
        this.price = price;
        this.quantity = quantity;
        this.startDate = startDate;
        this.endDate = endDate;
        this.ticketStatus = ticketStatus;
        this.paymentStatus = paymentStatus;
        this.paymentId = paymentId;
        this.total = total;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.customerName = customerName;
        this.customerIdCard = customerIdCard;
    }

    // Getters và Setters
    public int getTicketId() {
        return ticketId;
    }

    public void setTicketId(int ticketId) {
        this.ticketId = ticketId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getTicketTypeId() {
        return ticketTypeId;
    }

    public void setTicketTypeId(int ticketTypeId) {
        this.ticketTypeId = ticketTypeId;
    }

    public String getTicketTypeName() {
        return ticketTypeName;
    }

    public void setTicketTypeName(String ticketTypeName) {
        this.ticketTypeName = ticketTypeName;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public TicketStatus getTicketStatus() {
        return ticketStatus;
    }

    public void setTicketStatus(TicketStatus ticketStatus) {
        this.ticketStatus = ticketStatus;
    }

    public PaymentStatus getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(PaymentStatus paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public Integer getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(Integer paymentId) {
        this.paymentId = paymentId;
    }

    public BigDecimal getTotal() {
        return total;
    }

    public void setTotal(BigDecimal total) {
        this.total = total;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerIdCard() {
        return customerIdCard;
    }

    public void setCustomerIdCard(String customerIdCard) {
        this.customerIdCard = customerIdCard;
    }
}
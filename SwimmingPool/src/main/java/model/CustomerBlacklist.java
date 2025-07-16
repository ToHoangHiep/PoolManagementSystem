package model;

import java.sql.Timestamp;

public class CustomerBlacklist {
    private int blacklistId;
    private String customerIdCard;
    private String customerName;
    private String reason; // 'frequent_damage', 'lost_items', 'payment_issues', 'other'
    private String description;
    private String severity; // 'warning', 'restricted', 'banned'
    private Timestamp blacklistedAt;
    private Timestamp expiresAt;
    private boolean isActive;

    // Default constructor
    public CustomerBlacklist() {
        this.blacklistedAt = new Timestamp(System.currentTimeMillis());
        this.isActive = true;
    }

    // Constructor with essential fields
    public CustomerBlacklist(String customerIdCard, String customerName, String reason,
                             String description, String severity) {
        this();
        this.customerIdCard = customerIdCard;
        this.customerName = customerName;
        this.reason = reason;
        this.description = description;
        this.severity = severity;
    }

    // Getters and Setters
    public int getBlacklistId() {
        return blacklistId;
    }

    public void setBlacklistId(int blacklistId) {
        this.blacklistId = blacklistId;
    }

    public String getCustomerIdCard() {
        return customerIdCard;
    }

    public void setCustomerIdCard(String customerIdCard) {
        this.customerIdCard = customerIdCard;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getSeverity() {
        return severity;
    }

    public void setSeverity(String severity) {
        this.severity = severity;
    }

    public Timestamp getBlacklistedAt() {
        return blacklistedAt;
    }

    public void setBlacklistedAt(Timestamp blacklistedAt) {
        this.blacklistedAt = blacklistedAt;
    }

    public Timestamp getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(Timestamp expiresAt) {
        this.expiresAt = expiresAt;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    // Utility methods
    public boolean isBanned() {
        return "banned".equals(severity);
    }

    public boolean isRestricted() {
        return "restricted".equals(severity);
    }

    public boolean isWarning() {
        return "warning".equals(severity);
    }

    public boolean isExpired() {
        if (expiresAt == null) return false;
        return expiresAt.before(new Timestamp(System.currentTimeMillis()));
    }

    public boolean isCurrentlyBlacklisted() {
        return isActive && !isExpired();
    }
}

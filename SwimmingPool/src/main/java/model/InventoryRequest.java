package model;

import java.sql.Timestamp;
import java.util.Date;

public class InventoryRequest {
    private int requestId;
    private int inventoryId;
    private int requestedQuantity;
    private String status;
    private Date requestDate;
    private String itemName;
    private String reason;
    private Timestamp requestedAt;
    private Timestamp approvedAt;
    // getters, setters

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public int getInventoryId() {
        return inventoryId;
    }

    public void setInventoryId(int inventoryId) {
        this.inventoryId = inventoryId;
    }

    public int getRequestedQuantity() {
        return requestedQuantity;
    }

    public void setRequestedQuantity(int requestedQuantity) {
        this.requestedQuantity = requestedQuantity;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(Date requestDate) {
        this.requestDate = requestDate;
    }
    public String getItemName() {
        return itemName;
    }
    public void setItemName(String itemName) {
        this.itemName = itemName;
    }


    public String getReason() {
        return reason;
    }
    public void setReason(String reason) {
        this.reason = reason;
    }

    public Timestamp getRequestedAt() {
        return requestedAt;
    }
    public void setRequestedAt(Timestamp requestedAt) {
        this.requestedAt = requestedAt;
    }

    public Timestamp getApprovedAt() {
        return approvedAt;
    }
    public void setApprovedAt(Timestamp approvedAt) {
        this.approvedAt = approvedAt;
    }
}


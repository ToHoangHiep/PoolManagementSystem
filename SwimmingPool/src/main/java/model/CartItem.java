package model;

import java.math.BigDecimal;

public class CartItem {
    private String type;
    private String itemName;
    private int qty;
    private BigDecimal price;
    private BigDecimal subtotal;
    private int inventoryId = -1;

    // Constructor for ticket (giữ nguyên)
    public CartItem(Ticket.TicketTypeName type, int qty, BigDecimal price) {
        this.type = "Ticket_" + type.name();
        this.itemName = "Ticket " + type.name();
        this.qty = qty;
        this.price = price;
        updateSubtotal();
    }

    // *** XÓA 2 constructor cũ, CHỈ GIỮ Universal constructor ***
    // Universal constructor for equipment (rental hoặc buy)
    public CartItem(int inventoryId, int qty, BigDecimal price, String type, String itemName) {
        this.inventoryId = inventoryId;
        this.qty = qty;
        this.price = price;
        this.type = type;  // "EquipmentRental" hoặc "EquipmentBuy"
        this.itemName = itemName;
        updateSubtotal();

        System.out.println("[DEBUG CartItem] Universal constructor - Type: " + type + ", Name: " + itemName);
    }

    private void updateSubtotal() {
        this.subtotal = price.multiply(BigDecimal.valueOf(qty));
    }

    // Getters/Setters (giữ nguyên)
    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getQty() {
        return qty;
    }

    public void setQty(int qty) {
        if (qty > 0) {
            this.qty = qty;
            updateSubtotal();
        }
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
        updateSubtotal();
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public int getInventoryId() {
        return inventoryId;
    }

    public void setInventoryId(int inventoryId) {
        this.inventoryId = inventoryId;
    }
}
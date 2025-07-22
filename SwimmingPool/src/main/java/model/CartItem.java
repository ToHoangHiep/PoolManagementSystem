package model;

import java.math.BigDecimal;

/**
 * Model cho từng item trong giỏ hàng. Đại diện cho một loại vé với số lượng.
 * Liên kết với Ticket.TicketTypeName từ model Ticket của bạn.
 */
public class CartItem {
    private Ticket.TicketTypeName type; // Loại vé (Single, Monthly, ...)
    private int qty;                     // Số lượng
    private BigDecimal price;            // Giá đơn vị (lấy từ DAO)
    private BigDecimal subtotal;         // Tiền phụ = price * qty

    // Constructor
    public CartItem(Ticket.TicketTypeName type, int qty, BigDecimal price) {
        this.type = type;
        this.qty = qty;
        this.price = price;
        updateSubtotal();
    }

    // Cập nhật subtotal khi qty thay đổi
    public void updateSubtotal() {
        this.subtotal = price.multiply(BigDecimal.valueOf(qty));
    }

    // Getters và Setters
    public Ticket.TicketTypeName getType() {
        return type;
    }

    public void setType(Ticket.TicketTypeName type) {
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
}
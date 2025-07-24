package model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class Cart {
    private List<CartItem> items;
    private BigDecimal total;
    private String customerName;
    private String customerIdCard;

    public Cart() {
        this.items = new ArrayList<>();
        this.total = BigDecimal.ZERO;
    }

    public void addItem(CartItem item) {
        boolean found = false;
        for (CartItem existing : items) {
            if (existing.getType().equals(item.getType())) {
                if (item.getType().startsWith("Ticket_") && existing.getType().equals(item.getType())) {
                    // Tăng qty cho ticket cùng type
                    existing.setQty(existing.getQty() + item.getQty());
                    found = true;
                } else if (item.getType().equals("EquipmentRental") && existing.getInventoryId() == item.getInventoryId()) {
                    // Tăng qty cho equipment cùng inventoryId
                    existing.setQty(existing.getQty() + item.getQty());
                    found = true;
                }
            }
        }
        if (!found) {
            items.add(item);
        }
        updateTotal();
    }

    private void updateTotal() {
        total = items.stream()
                .map(CartItem::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    // Các method khác giữ nguyên (removeItem, updateItemQty, clear, getters/setters)
    public void removeItem(int index) {
        if (index >= 0 && index < items.size()) {
            items.remove(index);
            updateTotal();
        }
    }

    public void updateItemQty(int index, int newQty) {
        if (index >= 0 && index < items.size() && newQty > 0) {
            CartItem item = items.get(index);
            item.setQty(newQty);
            updateTotal();
        }
    }

    public void clear() {
        items.clear();
        total = BigDecimal.ZERO;
    }

    public List<CartItem> getItems() {
        return items;
    }

    public BigDecimal getTotal() {
        return total;
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

    public boolean isEmpty() {
        return items.isEmpty();
    }
}
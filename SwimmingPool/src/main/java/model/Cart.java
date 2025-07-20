package model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * Model cho giỏ hàng (Cart). Lưu danh sách các item vé, tổng tiền, và thông tin khách hàng chung.
 * Sử dụng để lưu tạm trong session.
 */
public class Cart {
    private List<CartItem> items;
    private BigDecimal total;
    private String customerName;
    private String customerIdCard;

    // Constructor mặc định
    public Cart() {
        this.items = new ArrayList<>();
        this.total = BigDecimal.ZERO;
    }

    // Thêm item vào giỏ
    public void addItem(CartItem item) {
        // Kiểm tra nếu item với type tương tự đã tồn tại, thì update qty thay vì add mới
        boolean found = false;
        for (CartItem existingItem : items) {
            if (existingItem.getType() == item.getType()) {
                existingItem.setQty(existingItem.getQty() + item.getQty());
                existingItem.updateSubtotal();
                found = true;
                break;
            }
        }
        if (!found) {
            items.add(item);
        }
        updateTotal();
    }

    // Xóa item theo index (hoặc type nếu cần)
    public void removeItem(int index) {
        if (index >= 0 && index < items.size()) {
            items.remove(index);
            updateTotal();
        }
    }

    // Update qty của item theo index
    public void updateItemQty(int index, int newQty) {
        if (index >= 0 && index < items.size() && newQty > 0) {
            CartItem item = items.get(index);
            item.setQty(newQty);
            item.updateSubtotal();
            updateTotal();
        }
    }

    // Cập nhật tổng tiền giỏ
    private void updateTotal() {
        total = items.stream()
                .map(CartItem::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    // Getters và Setters
    public List<CartItem> getItems() {
        return items;
    }

    public void setItems(List<CartItem> items) {
        this.items = items;
        updateTotal();
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

    // Kiểm tra giỏ rỗng
    public boolean isEmpty() {
        return items.isEmpty();
    }

    // Xóa toàn bộ giỏ sau checkout
    public void clear() {
        items.clear();
        total = BigDecimal.ZERO;
    }
}
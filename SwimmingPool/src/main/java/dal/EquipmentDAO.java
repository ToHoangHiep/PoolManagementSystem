package dal;

import model.EquipmentRental;
import model.EquipmentSale;
import utils.DBConnect;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class EquipmentDAO {


    public List<Map<String, Object>> getEquipmentStatus() throws SQLException {
        String sql = """
        SELECT 
            i.inventory_id,
            i.item_name,
            i.category,
            i.quantity AS total_quantity,
            i.rent_price,
            i.sale_price,
            i.unit,
            i.usage_id,
            i.status,
            iu.usage_name,
            (i.quantity - COALESCE(SUM(CASE WHEN er.status = 'active' THEN er.quantity ELSE 0 END), 0)) AS available_quantity
        FROM Inventory i
        LEFT JOIN Equipment_Rentals er ON i.inventory_id = er.inventory_id
        LEFT JOIN Inventory_usage iu ON i.usage_id = iu.usage_id
        WHERE i.status = 'Available'
        GROUP BY i.inventory_id, i.item_name, i.category, i.quantity, i.rent_price,
                 i.sale_price, i.unit, i.usage_id, i.status, iu.usage_name
        ORDER BY i.item_name
    """;

        List<Map<String, Object>> result = new ArrayList<>();

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                int available = rs.getInt("available_quantity");

                item.put("inventoryId", rs.getInt("inventory_id"));
                item.put("itemName", rs.getString("item_name"));
                item.put("category", rs.getString("category"));
                item.put("totalQuantity", rs.getInt("total_quantity"));
                item.put("availableQuantity", available);
                item.put("rentPrice", rs.getDouble("rent_price"));
                item.put("salePrice", rs.getDouble("sale_price"));
                item.put("unit", rs.getString("unit"));
                item.put("usageId", rs.getInt("usage_id"));
                item.put("usageName", rs.getString("usage_name"));
                item.put("status", rs.getString("status"));

                // Tính trạng thái kho
                if (available == 0) {
                    item.put("stockStatus", "out-stock");
                } else if (available <= 5) {
                    item.put("stockStatus", "low-stock");
                } else {
                    item.put("stockStatus", "in-stock");
                }

                result.add(item);
            }
        }

        return result;
    }




    // DEBUG METHOD: Kiểm tra data thô từ database
    public List<Map<String, Object>> debugAllInventory() throws SQLException {
        String sql = """
            SELECT 
                inventory_id,
                item_name,
                usage_id,
                rent_price,
                sale_price,
                status,
                quantity
            FROM Inventory 
            ORDER BY usage_id, item_name
            """;

        List<Map<String, Object>> result = new ArrayList<>();

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("inventoryId", rs.getInt("inventory_id"));
                item.put("itemName", rs.getString("item_name"));
                item.put("usageId", rs.getInt("usage_id"));
                item.put("rentPrice", rs.getDouble("rent_price"));
                item.put("salePrice", rs.getDouble("sale_price"));
                item.put("status", rs.getString("status"));
                item.put("quantity", rs.getInt("quantity"));
                result.add(item);
            }
        }
        return result;
    }

    // Method mới: Lấy số lượng available của một thiết bị cụ thể
    public int getAvailableQuantity(int inventoryId) throws SQLException {
        String sql = """
            SELECT 
                i.quantity - COALESCE(SUM(CASE WHEN er.status = 'active' THEN er.quantity ELSE 0 END), 0) as available_quantity
            FROM Inventory i
            LEFT JOIN Equipment_Rentals er ON i.inventory_id = er.inventory_id
            WHERE i.inventory_id = ?
            GROUP BY i.inventory_id, i.quantity
            """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, inventoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("available_quantity");
                }
            }
        }
        return 0;
    }

    // Kiểm tra thiết bị còn đủ số lượng để bán/cho thuê không
    public boolean checkAvailability(int inventoryId, int requestedQty) throws SQLException {
        return getAvailableQuantity(inventoryId) >= requestedQty;
    }

    // Thực hiện tạo đơn thuê thiết bị mới
    public boolean processRental(EquipmentRental rental) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // Kiểm tra lại availability trong transaction để tránh race condition
            int available = getAvailableQuantityInTransaction(conn, rental.getInventoryId());
            if (available < rental.getQuantity()) {
                conn.rollback();
                return false;
            }

            String sql = """
                INSERT INTO Equipment_Rentals (customer_name, customer_id_card, staff_id, inventory_id, 
                                             quantity, rental_date, rent_price, total_amount, status) 
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'active')
                """;

            try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setString(1, rental.getCustomerName());
                stmt.setString(2, rental.getCustomerIdCard());
                stmt.setInt(3, rental.getStaffId());
                stmt.setInt(4, rental.getInventoryId());
                stmt.setInt(5, rental.getQuantity());
                stmt.setDate(6, rental.getRentalDate());
                stmt.setDouble(7, rental.getRentPrice());
                stmt.setDouble(8, rental.getTotalAmount());

                int rows = stmt.executeUpdate();
                if (rows > 0) {
                    try (ResultSet rs = stmt.getGeneratedKeys()) {
                        if (rs.next()) {
                            rental.setRentalId(rs.getInt(1));
                        }
                    }
                    conn.commit();
                    return true;
                } else {
                    conn.rollback();
                    return false;
                }
            }

        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    // Helper method cho transaction
    private int getAvailableQuantityInTransaction(Connection conn, int inventoryId) throws SQLException {
        String sql = """
            SELECT 
                i.quantity - COALESCE(SUM(CASE WHEN er.status = 'active' THEN er.quantity ELSE 0 END), 0) as available_quantity
            FROM Inventory i
            LEFT JOIN Equipment_Rentals er ON i.inventory_id = er.inventory_id
            WHERE i.inventory_id = ?
            GROUP BY i.inventory_id, i.quantity
            """;

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, inventoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("available_quantity");
                }
            }
        }
        return 0;
    }

    // Cập nhật trạng thái đơn thuê sang 'returned' khi trả thiết bị
    public boolean processReturn(int rentalId) throws SQLException {
        String sql = "UPDATE Equipment_Rentals SET status = 'returned', return_time = CURRENT_TIMESTAMP WHERE rental_id = ? AND status = 'active'";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, rentalId);
            return stmt.executeUpdate() > 0;
        }
    }

    // Thực hiện bán thiết bị và trừ tồn kho
    public boolean processSale(EquipmentSale sale) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false); // bắt đầu transaction

            // Kiểm tra lại availability trong transaction
            int available = getAvailableQuantityInTransaction(conn, sale.getInventoryId());
            if (available < sale.getQuantity()) {
                conn.rollback();
                return false;
            }

            // 1. Tạo đơn bán - REMOVED sale_date field
            String sql = """
                INSERT INTO Equipment_Sales (customer_name, staff_id, inventory_id, quantity, 
                                           sale_price, total_amount) 
                VALUES (?, ?, ?, ?, ?, ?)
                """;

            try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setString(1, sale.getCustomerName());
                stmt.setInt(2, sale.getStaffId());
                stmt.setInt(3, sale.getInventoryId());
                stmt.setInt(4, sale.getQuantity());
                stmt.setDouble(5, sale.getSalePrice());
                stmt.setDouble(6, sale.getTotalAmount());

                int rows = stmt.executeUpdate();
                if (rows == 0) {
                    conn.rollback();
                    return false;
                }

                // Lấy ID đơn bán
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        sale.setSaleId(rs.getInt(1));
                    }
                }
            }

            // 2. Trừ số lượng trong Inventory (vì bán là permanent)
            String updateSql = "UPDATE Inventory SET quantity = quantity - ? WHERE inventory_id = ?";
            try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                updateStmt.setInt(1, sale.getQuantity());
                updateStmt.setInt(2, sale.getInventoryId());

                if (updateStmt.executeUpdate() == 0) {
                    conn.rollback();
                    return false;
                }
            }

            conn.commit(); // thành công
            return true;

        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    // Lấy danh sách đơn thuê đang active (chưa trả)
    public List<EquipmentRental> getActiveRentals() throws SQLException {
        String sql = """
            SELECT er.rental_id, er.customer_name, er.customer_id_card, er.staff_id, 
                   er.inventory_id, i.item_name, er.quantity, er.rental_date, 
                   er.rent_price, er.total_amount, er.status, er.created_at, er.return_time
            FROM Equipment_Rentals er
            JOIN Inventory i ON er.inventory_id = i.inventory_id
            WHERE er.status = 'active'
            ORDER BY er.rental_date DESC
            """;

        List<EquipmentRental> rentals = new ArrayList<>();

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                EquipmentRental rental = new EquipmentRental();
                rental.setRentalId(rs.getInt("rental_id"));
                rental.setCustomerName(rs.getString("customer_name"));
                rental.setCustomerIdCard(rs.getString("customer_id_card"));
                rental.setStaffId(rs.getInt("staff_id"));
                rental.setInventoryId(rs.getInt("inventory_id"));
                rental.setQuantity(rs.getInt("quantity"));
                rental.setRentalDate(rs.getDate("rental_date"));
                rental.setRentPrice(rs.getDouble("rent_price"));
                rental.setTotalAmount(rs.getDouble("total_amount"));
                rental.setStatus(rs.getString("status"));
                rental.setCreatedAt(rs.getTimestamp("created_at"));
                rental.setReturnTime(rs.getTimestamp("return_time"));

                // Thêm item name để hiển thị trong bảng
                rental.setItemName(rs.getString("item_name"));

                rentals.add(rental);
            }
        }
        return rentals;
    }

    // Truy vấn thông tin chi tiết 1 thiết bị theo inventory_id
    public Map<String, Object> getEquipmentById(int inventoryId) throws SQLException {
        String sql = "SELECT * FROM Inventory WHERE inventory_id = ? AND status = 'Available'";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, inventoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> equipment = new HashMap<>();
                    equipment.put("inventoryId", rs.getInt("inventory_id"));
                    equipment.put("itemName", rs.getString("item_name"));
                    equipment.put("category", rs.getString("category"));
                    equipment.put("quantity", rs.getInt("quantity"));
                    equipment.put("rentPrice", rs.getDouble("rent_price"));
                    equipment.put("salePrice", rs.getDouble("sale_price"));
                    equipment.put("unit", rs.getString("unit"));
                    equipment.put("usageId", rs.getInt("usage_id"));
                    equipment.put("status", rs.getString("status"));
                    return equipment;
                }
            }
        }
        return null;
    }
}
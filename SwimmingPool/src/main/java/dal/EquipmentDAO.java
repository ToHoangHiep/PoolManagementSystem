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

    /**
     * Lấy danh sách thiết bị cho shop - chỉ usage_id: 1, 3, 5
     * Logic đơn giản: quantity trong Inventory = số lượng available
     */
    public List<Map<String, Object>> getEquipmentStatus() throws SQLException {
        String sql = """
            SELECT 
                i.inventory_id,
                i.item_name,
                i.category,
                i.quantity AS available_quantity,
                i.rent_price,
                i.sale_price,
                i.unit,
                i.usage_id,
                i.status,
                iu.usage_name
            FROM Inventory i
            LEFT JOIN Inventory_usage iu ON i.usage_id = iu.usage_id
            WHERE i.status = 'Available' 
                AND i.usage_id IN (1, 3, 5)
            ORDER BY i.item_name
            """;

        List<Map<String, Object>> result = new ArrayList<>();

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                int availableQty = rs.getInt("available_quantity");

                item.put("inventoryId", rs.getInt("inventory_id"));
                item.put("itemName", rs.getString("item_name"));
                item.put("category", rs.getString("category"));
                item.put("quantity", availableQty); // Số lượng hiển thị trên màn hình
                item.put("rentPrice", rs.getDouble("rent_price"));
                item.put("salePrice", rs.getDouble("sale_price"));
                item.put("unit", rs.getString("unit"));
                item.put("usageId", rs.getInt("usage_id"));
                item.put("usageName", rs.getString("usage_name"));
                item.put("status", rs.getString("status"));

                // Xác định trạng thái kho cho hiển thị
                if (availableQty == 0) {
                    item.put("stockStatus", "out-stock");
                } else if (availableQty <= 5) {
                    item.put("stockStatus", "low-stock");
                } else {
                    item.put("stockStatus", "in-stock");
                }

                result.add(item);
            }
        }

        return result;
    }

    /**
     * Lấy thông tin chi tiết của một thiết bị theo ID
     */
    public Map<String, Object> getEquipmentById(int inventoryId) throws SQLException {
        String sql = """
            SELECT 
                i.inventory_id,
                i.item_name,
                i.category,
                i.quantity,
                i.rent_price,
                i.sale_price,
                i.unit,
                i.usage_id,
                i.status,
                iu.usage_name
            FROM Inventory i
            LEFT JOIN Inventory_usage iu ON i.usage_id = iu.usage_id
            WHERE i.inventory_id = ? AND i.status = 'Available'
            """;

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
                    equipment.put("usageName", rs.getString("usage_name"));
                    equipment.put("status", rs.getString("status"));
                    return equipment;
                }
            }
        }
        return null;
    }

    /**
     * XỬ LÝ CHO THUÊ THIẾT BỊ
     * 1. Tạo rental record
     * 2. TRỪ số lượng trong inventory
     */
    public boolean processRental(EquipmentRental rental) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false); // Bắt đầu transaction

            // 1. Kiểm tra số lượng trong kho
            if (!checkInventoryStock(conn, rental.getInventoryId(), rental.getQuantity())) {
                conn.rollback();
                return false;
            }

            // 2. Tạo rental record
            String insertRentalSql = """
                INSERT INTO Equipment_Rentals (customer_name, customer_id_card, staff_id, inventory_id, 
                                             quantity, rental_date, rent_price, total_amount, status) 
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'active')
                """;

            try (PreparedStatement stmt = conn.prepareStatement(insertRentalSql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setString(1, rental.getCustomerName());
                stmt.setString(2, rental.getCustomerIdCard());
                stmt.setInt(3, rental.getStaffId());
                stmt.setInt(4, rental.getInventoryId());
                stmt.setInt(5, rental.getQuantity());
                stmt.setDate(6, rental.getRentalDate());
                stmt.setDouble(7, rental.getRentPrice());
                stmt.setDouble(8, rental.getTotalAmount());

                int rows = stmt.executeUpdate();
                if (rows == 0) {
                    conn.rollback();
                    return false;
                }

                // Lấy rental ID
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        rental.setRentalId(rs.getInt(1));
                    }
                }
            }

            // 3. TRỪ số lượng trong inventory
            if (!updateInventoryQuantity(conn, rental.getInventoryId(), -rental.getQuantity())) {
                conn.rollback();
                return false;
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    e.addSuppressed(rollbackEx);
                }
            }
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException closeEx) {
                    // Log warning if needed
                }
            }
        }
    }

    /**
     * XỬ LÝ BÁN THIẾT BỊ
     * 1. Tạo sale record
     * 2. TRỪ số lượng trong inventory (permanent)
     */
    public boolean processSale(EquipmentSale sale) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false); // Bắt đầu transaction

            // 1. Kiểm tra số lượng trong kho
            if (!checkInventoryStock(conn, sale.getInventoryId(), sale.getQuantity())) {
                conn.rollback();
                return false;
            }

            // 2. Tạo sale record
            String insertSaleSql = """
                INSERT INTO Equipment_Sales (customer_name, staff_id, inventory_id, quantity, 
                                           sale_price, total_amount) 
                VALUES (?, ?, ?, ?, ?, ?)
                """;

            try (PreparedStatement stmt = conn.prepareStatement(insertSaleSql, Statement.RETURN_GENERATED_KEYS)) {
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

                // Lấy sale ID
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        sale.setSaleId(rs.getInt(1));
                    }
                }
            }

            // 3. TRỪ số lượng trong inventory (permanent)
            if (!updateInventoryQuantity(conn, sale.getInventoryId(), -sale.getQuantity())) {
                conn.rollback();
                return false;
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    e.addSuppressed(rollbackEx);
                }
            }
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException closeEx) {
                    // Log warning if needed
                }
            }
        }
    }

    /**
     * XỬ LÝ TRẢ THIẾT BỊ
     * 1. Update rental status thành 'returned'
     * 2. CỘNG lại số lượng vào inventory
     */
    public boolean processReturn(int rentalId) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false); // Bắt đầu transaction

            // 1. Lấy thông tin rental để biết inventory_id và quantity
            String getRentalSql = """
                SELECT inventory_id, quantity 
                FROM Equipment_Rentals 
                WHERE rental_id = ? AND status = 'active'
                """;

            int inventoryId = 0;
            int quantity = 0;

            try (PreparedStatement stmt = conn.prepareStatement(getRentalSql)) {
                stmt.setInt(1, rentalId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        inventoryId = rs.getInt("inventory_id");
                        quantity = rs.getInt("quantity");
                    } else {
                        conn.rollback();
                        return false; // Không tìm thấy rental active
                    }
                }
            }

            // 2. Update rental status
            String updateRentalSql = """
                UPDATE Equipment_Rentals 
                SET status = 'returned', return_time = CURRENT_TIMESTAMP 
                WHERE rental_id = ?
                """;

            try (PreparedStatement stmt = conn.prepareStatement(updateRentalSql)) {
                stmt.setInt(1, rentalId);
                if (stmt.executeUpdate() == 0) {
                    conn.rollback();
                    return false;
                }
            }

            // 3. CỘNG lại số lượng vào inventory
            if (!updateInventoryQuantity(conn, inventoryId, quantity)) {
                conn.rollback();
                return false;
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    e.addSuppressed(rollbackEx);
                }
            }
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException closeEx) {
                    // Log warning if needed
                }
            }
        }
    }

    /**
     * Lấy danh sách rental đang active (chưa trả)
     */
    public List<EquipmentRental> getActiveRentals() throws SQLException {
        String sql = """
            SELECT 
                er.rental_id, er.customer_name, er.customer_id_card, er.staff_id, 
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

                // Thêm item name để hiển thị
                rental.setItemName(rs.getString("item_name"));

                rentals.add(rental);
            }
        }
        return rentals;
    }

    // ============= HELPER METHODS =============

    /**
     * Kiểm tra số lượng trong kho có đủ không
     */
    private boolean checkInventoryStock(Connection conn, int inventoryId, int requestedQty) throws SQLException {
        String sql = "SELECT quantity FROM Inventory WHERE inventory_id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, inventoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int currentQty = rs.getInt("quantity");
                    return currentQty >= requestedQty;
                }
            }
        }
        return false;
    }

    /**
     * Cập nhật số lượng trong inventory
     * @param changeAmount: số lượng thay đổi (âm = trừ, dương = cộng)
     */
    private boolean updateInventoryQuantity(Connection conn, int inventoryId, int changeAmount) throws SQLException {
        String sql = "UPDATE Inventory SET quantity = quantity + ? WHERE inventory_id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, changeAmount);
            stmt.setInt(2, inventoryId);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Lấy số lượng hiện tại trong inventory (public method)
     */
    public int getCurrentQuantity(int inventoryId) throws SQLException {
        String sql = "SELECT quantity FROM Inventory WHERE inventory_id = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, inventoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("quantity");
                }
            }
        }
        return 0;
    }

    /**
     * Kiểm tra thiết bị có available không
     */
    public boolean checkAvailability(int inventoryId, int requestedQty) throws SQLException {
        return getCurrentQuantity(inventoryId) >= requestedQty;
    }
}

//    // Hàm lấy toàn bộ lịch sử bán hàng
//    public List<EquipmentSale> getAllSales() throws SQLException {
//        List<EquipmentSale> sales = new ArrayList<>();
//        String sql = "SELECT es.*, i.item_name, u.full_name as staff_name " +
//                "FROM Equipment_Sales es " +
//                "JOIN Inventory i ON es.inventory_id = i.inventory_id " +
//                "JOIN Users u ON es.staff_id = u.id " +
//                "ORDER BY es.created_at DESC";
//
//        try (Connection conn = DBConnect.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql);
//             ResultSet rs = stmt.executeQuery()) {
//
//            while (rs.next()) {
//                sales.add(mapRowToEquipmentSale(rs));
//            }
//        }
//        return sales;
//    }
//
//    // Hàm lấy đơn hàng theo khoảng thời gian
//    public List<EquipmentSale> getSalesByDateRange(Date startDate, Date endDate) throws SQLException {
//        List<EquipmentSale> sales = new ArrayList<>();
//        String sql = "SELECT es.*, i.item_name, u.full_name as staff_name " +
//                "FROM Equipment_Sales es " +
//                "JOIN Inventory i ON es.inventory_id = i.inventory_id " +
//                "JOIN Users u ON es.staff_id = u.id " +
//                "WHERE es.created_at BETWEEN ? AND ? " +
//                "ORDER BY es.created_at DESC";
//
//        try (Connection conn = DBConnect.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//
//            stmt.setDate(1, new java.sql.Date(startDate.getTime()));
//            stmt.setDate(2, new java.sql.Date(endDate.getTime()));
//
//            try (ResultSet rs = stmt.executeQuery()) {
//                while (rs.next()) {
//                    sales.add(mapRowToEquipmentSale(rs));
//                }
//            }
//        }
//        return sales;
//    }
//
//    // Hàm lấy đơn hàng theo tên khách hàng (tìm kiếm gần đúng)
//    public List<EquipmentSale> getSalesByCustomerName(String customerName) throws SQLException {
//        List<EquipmentSale> sales = new ArrayList<>();
//        String sql = "SELECT es.*, i.item_name, u.full_name as staff_name " +
//                "FROM Equipment_Sales es " +
//                "JOIN Inventory i ON es.inventory_id = i.inventory_id " +
//                "JOIN Users u ON es.staff_id = u.id " +
//                "WHERE es.customer_name LIKE ? " +
//                "ORDER BY es.created_at DESC";
//
//        try (Connection conn = DBConnect.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//
//            stmt.setString(1, "%" + customerName + "%");
//
//            try (ResultSet rs = stmt.executeQuery()) {
//                while (rs.next()) {
//                    sales.add(mapRowToEquipmentSale(rs));
//                }
//            }
//        }
//        return sales;
//    }
//
//    // Hàm lấy đơn hàng theo ID thiết bị
//    public List<EquipmentSale> getSalesByInventoryId(int inventoryId) throws SQLException {
//        List<EquipmentSale> sales = new ArrayList<>();
//        String sql = "SELECT es.*, i.item_name, u.full_name as staff_name " +
//                "FROM Equipment_Sales es " +
//                "JOIN Inventory i ON es.inventory_id = i.inventory_id " +
//                "JOIN Users u ON es.staff_id = u.id " +
//                "WHERE es.inventory_id = ? " +
//                "ORDER BY es.created_at DESC";
//
//        try (Connection conn = DBConnect.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//
//            stmt.setInt(1, inventoryId);
//
//            try (ResultSet rs = stmt.executeQuery()) {
//                while (rs.next()) {
//                    sales.add(mapRowToEquipmentSale(rs));
//                }
//            }
//        }
//        return sales;
//    }
//
//    // Hàm hỗ trợ ánh xạ ResultSet thành đối tượng EquipmentSale
//    private EquipmentSale mapRowToEquipmentSale(ResultSet rs) throws SQLException {
//        EquipmentSale sale = new EquipmentSale();
//        sale.setSaleId(rs.getInt("sale_id"));
//        sale.setCustomerName(rs.getString("customer_name"));
//        sale.setStaffId(rs.getInt("staff_id"));
//        sale.setInventoryId(rs.getInt("inventory_id"));
//        sale.setQuantity(rs.getInt("quantity"));
//        sale.setSalePrice(rs.getDouble("sale_price"));
//        sale.setTotalAmount(rs.getDouble("total_amount"));
//        sale.setCreatedAt(rs.getTimestamp("created_at"));
//        return sale;
//    }
//
//    // Hàm thống kê doanh thu theo khoảng thời gian
//    public double getRevenueByDateRange(Date startDate, Date endDate) throws SQLException {
//        String sql = "SELECT SUM(total_amount) as total_revenue " +
//                "FROM Equipment_Sales " +
//                "WHERE created_at BETWEEN ? AND ?";
//
//        try (Connection conn = DBConnect.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//
//            stmt.setDate(1, new java.sql.Date(startDate.getTime()));
//            stmt.setDate(2, new java.sql.Date(endDate.getTime()));
//
//            try (ResultSet rs = stmt.executeQuery()) {
//                if (rs.next()) {
//                    return rs.getDouble("total_revenue");
//                }
//            }
//        }
//        return 0;
//    }
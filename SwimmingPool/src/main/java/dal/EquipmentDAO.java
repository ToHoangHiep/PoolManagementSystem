package dal;

import model.EquipmentRental;
import model.EquipmentSale;
import utils.DBConnect;

import java.sql.*;
import java.util.*;

public class EquipmentDAO {

    /**
     * Lấy danh sách thiết bị cho shop - chỉ usage_id: 1, 3, 5
     * Logic đơn giản: quantity trong Inventory = số lượng available
     */
    public static List<Map<String, Object>> getEquipmentStatus(String mode, Integer categoryId) throws SQLException {
        String sql = """
            SELECT 
                i.inventory_id, i.item_name, ic.category_id, ic.category_name AS category, i.quantity AS available_quantity,
                i.rent_price, i.sale_price, i.import_price, i.unit, i.usage_id, i.status, iu.usage_name
            FROM Inventory i
            LEFT JOIN Inventory_usage iu ON i.usage_id = iu.usage_id
            LEFT JOIN Inventory_category ic ON i.category_id = ic.category_id
            WHERE i.status = 'Available' AND i.usage_id IN (1, 2)  -- Chỉ 1, 2 (Rental/Sale)
        """;

        List<Object> params = new ArrayList<>();

        if ("rental".equals(mode)) {
            sql += " AND i.rent_price > 0";
        } else if ("buy".equals(mode)) {
            sql += " AND i.sale_price > 0";
        }

        if (categoryId != null) {
            sql += " AND i.category_id = ?";
            params.add(categoryId);
        }

        sql += " ORDER BY i.item_name";

        List<Map<String, Object>> result = new ArrayList<>();
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("inventoryId", rs.getInt("inventory_id"));
                    item.put("itemName", rs.getString("item_name"));
                    item.put("categoryId", rs.getInt("category_id"));
                    item.put("category", rs.getString("category"));
                    item.put("quantity", rs.getInt("available_quantity"));
                    item.put("rentPrice", rs.getDouble("rent_price"));
                    item.put("salePrice", rs.getDouble("sale_price"));
                    item.put("importPrice", rs.getDouble("import_price"));
                    item.put("unit", rs.getString("unit"));
                    item.put("usageId", rs.getInt("usage_id"));
                    item.put("usageName", rs.getString("usage_name"));
                    item.put("status", rs.getString("status"));
                    // Stock status logic (giữ nguyên)
                    int qty = rs.getInt("available_quantity");
                    item.put("stockStatus", qty == 0 ? "out-stock" : qty <= 5 ? "low-stock" : "in-stock");
                    result.add(item);
                }
            }
        }
        return result;
    }

    public static List<Map<String, Object>> getAllCategories(String mode) throws SQLException {
        String sql = """
            SELECT DISTINCT ic.category_id, ic.category_name 
            FROM Inventory_category ic
            JOIN Inventory i ON i.category_id = ic.category_id
            WHERE i.status = 'Available' AND i.usage_id IN (1, 2)
        """;

        if ("rental".equals(mode)) {
            sql += " AND i.rent_price > 0";
        } else if ("buy".equals(mode)) {
            sql += " AND i.sale_price > 0";
        }

        sql += " ORDER BY ic.category_name";

        List<Map<String, Object>> categories = new ArrayList<>();
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> cat = new HashMap<>();
                int catId = rs.getInt("category_id");
                String catName = rs.getString("category_name");
                cat.put("id", catId);
                cat.put("name", catName);
                // Compute category_quantity dynamically
                int quantity = computeCategoryQuantity(catId);
                cat.put("quantity", quantity);
                categories.add(cat);
            }
        }
        return categories;
    }

    // Helper method: Tính tổng quantity cho category_id
    private static int computeCategoryQuantity(int categoryId) throws SQLException {
        String sql = "SELECT SUM(quantity) AS total FROM Inventory WHERE category_id = ? AND status = 'Available'";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, categoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int total = rs.getInt("total");
                    return rs.wasNull() ? 0 : total;  // Trả 0 nếu null
                }
            }
        }
        return 0;
    }
    /**
     * Lấy thông tin chi tiết của một thiết bị theo ID
     */
    public static Map<String, Object> getEquipmentById(int inventoryId) throws SQLException {
        String sql = """
        SELECT 
            i.inventory_id,
            i.item_name,
            ic.category_name AS category,
            i.category_id,
            i.quantity,
            i.unit,
            i.status,
            i.rent_price,
            i.sale_price,
            i.import_price,
            i.usage_id,
            iu.usage_name
        FROM Inventory i
        LEFT JOIN Inventory_usage iu ON i.usage_id = iu.usage_id
        LEFT JOIN Inventory_category ic ON i.category_id = ic.category_id
        WHERE i.inventory_id = ?
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
                    equipment.put("categoryId", rs.getInt("category_id"));
                    equipment.put("quantity", rs.getInt("quantity"));
                    equipment.put("unit", rs.getString("unit"));
                    equipment.put("status", rs.getString("status"));
                    equipment.put("rentPrice", rs.getDouble("rent_price"));
                    equipment.put("salePrice", rs.getDouble("sale_price"));
                    equipment.put("importPrice", rs.getDouble("import_price"));
                    equipment.put("usageId", rs.getInt("usage_id"));
                    equipment.put("usageName", rs.getString("usage_name"));
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
    public static boolean processRental(EquipmentRental rental) throws SQLException {
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
    public static boolean processSale(EquipmentSale sale) throws SQLException {
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
    public static boolean processReturn(int rentalId) throws SQLException {
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
    public static List<EquipmentRental> getActiveRentals() throws SQLException {
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

    // ===================== NEW METHODS FOR COMPENSATION SUPPORT =====================

    /**
     * Lấy rental theo ID (bao gồm cả active và returned)
     * Cần thiết cho CompensationServlet
     */
    public static EquipmentRental getRentalById(int rentalId) throws SQLException {
        String sql = """
            SELECT 
                er.rental_id, er.customer_name, er.customer_id_card, er.staff_id, 
                er.inventory_id, i.item_name, er.quantity, er.rental_date, 
                er.rent_price, er.total_amount, er.status, er.created_at, er.return_time
            FROM Equipment_Rentals er
            JOIN Inventory i ON er.inventory_id = i.inventory_id
            WHERE er.rental_id = ?
            """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, rentalId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
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
                    rental.setItemName(rs.getString("item_name"));

                    return rental;
                }
            }
        }

        return null;
    }

    /**
     * Lấy tất cả rentals (active + returned) với pagination
     * Hữu ích cho compensation management
     */
    public static List<EquipmentRental> getAllRentals(int offset, int limit) throws SQLException {
        String sql = """
            SELECT 
                er.rental_id, er.customer_name, er.customer_id_card, er.staff_id, 
                er.inventory_id, i.item_name, er.quantity, er.rental_date, 
                er.rent_price, er.total_amount, er.status, er.created_at, er.return_time
            FROM Equipment_Rentals er
            JOIN Inventory i ON er.inventory_id = i.inventory_id
            ORDER BY er.rental_date DESC
            LIMIT ? OFFSET ?
            """;

        List<EquipmentRental> rentals = new ArrayList<>();

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, limit);
            stmt.setInt(2, offset);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    EquipmentRental rental = mapResultSetToRental(rs);
                    rentals.add(rental);
                }
            }
        }

        return rentals;
    }

    /**
     * Tìm rentals theo customer ID card
     * Cần thiết để xem lịch sử của customer
     */
    public static List<EquipmentRental> getRentalsByCustomerIdCard(String customerIdCard) throws SQLException {
        String sql = """
            SELECT 
                er.rental_id, er.customer_name, er.customer_id_card, er.staff_id, 
                er.inventory_id, i.item_name, er.quantity, er.rental_date, 
                er.rent_price, er.total_amount, er.status, er.created_at, er.return_time
            FROM Equipment_Rentals er
            JOIN Inventory i ON er.inventory_id = i.inventory_id
            WHERE er.customer_id_card = ?
            ORDER BY er.rental_date DESC
            """;

        List<EquipmentRental> rentals = new ArrayList<>();

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, customerIdCard);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    EquipmentRental rental = mapResultSetToRental(rs);
                    rentals.add(rental);
                }
            }
        }

        return rentals;
    }

    /**
     * Đếm tổng số rentals của customer (để kiểm tra frequent offender)
     */
    public static int getRentalCountByCustomer(String customerIdCard) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Equipment_Rentals WHERE customer_id_card = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, customerIdCard);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        return 0;
    }

    /**
     * Lấy rentals có thể tạo compensation (active rentals)
     * Để hiển thị trong dropdown compensation form
     */
    public static List<EquipmentRental> getRentalsForCompensation() throws SQLException {
        String sql = """
            SELECT 
                er.rental_id, er.customer_name, er.customer_id_card, er.staff_id, 
                er.inventory_id, i.item_name, er.quantity, er.rental_date, 
                er.rent_price, er.total_amount, er.status, er.created_at, er.return_time
            FROM Equipment_Rentals er
            JOIN Inventory i ON er.inventory_id = i.inventory_id
            WHERE er.status = 'active'
            AND er.rental_id NOT IN (
                SELECT DISTINCT rental_id FROM Equipment_Compensations
            )
            ORDER BY er.rental_date DESC
            """;

        List<EquipmentRental> rentals = new ArrayList<>();

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                EquipmentRental rental = mapResultSetToRental(rs);
                rentals.add(rental);
            }
        }

        return rentals;
    }

    /**
     * Update rental status (cho compensation workflow)
     */
    public static boolean updateRentalStatus(int rentalId, String status) throws SQLException {
        String sql = "UPDATE Equipment_Rentals SET status = ? WHERE rental_id = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, rentalId);

            return stmt.executeUpdate() > 0;
        }
    }

    // ============= HELPER METHODS =============

    /**
     * Kiểm tra số lượng trong kho có đủ không
     */
    private static boolean checkInventoryStock(Connection conn, int inventoryId, int requestedQty) throws SQLException {
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
    private static boolean updateInventoryQuantity(Connection conn, int inventoryId, int changeAmount) throws SQLException {
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
    public static int getCurrentQuantity(int inventoryId) throws SQLException {
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
    public static boolean checkAvailability(int inventoryId, int requestedQty) throws SQLException {
        return getCurrentQuantity(inventoryId) >= requestedQty;
    }

    /**
     * Helper method: Map ResultSet to EquipmentRental
     */
    private static EquipmentRental mapResultSetToRental(ResultSet rs) throws SQLException {
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
        rental.setItemName(rs.getString("item_name"));
        return rental;
    }

    public static List<EquipmentRental> getRentalsByIds(List<Integer> ids) throws SQLException {
        List<EquipmentRental> rentals = new ArrayList<>();
        if (ids == null || ids.isEmpty()) return rentals;

        String placeholders = String.join(",", Collections.nCopies(ids.size(), "?"));
        String sql = "SELECT r.*, i.item_name, i.unit, i.sale_price, i.usage_id, c.category_name " +
                "FROM equipment_rentals r " +
                "JOIN inventory i ON r.inventory_id = i.inventory_id " +
                "JOIN inventory_category c ON i.category_id = c.category_id " +
                "WHERE r.rental_id IN (" + placeholders + ")";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            for (int i = 0; i < ids.size(); i++) {
                stmt.setInt(i + 1, ids.get(i));
            }

            ResultSet rs = stmt.executeQuery();
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
                rental.setDueDate(rs.getDate("due_date"));
                rental.setNotes(rs.getString("notes"));

                // Thêm thông tin bổ sung
                rental.setItemName(rs.getString("item_name"));
                rental.setUnit(rs.getString("unit"));
                rental.setSalePrice(rs.getDouble("sale_price"));
                rental.setUsageId(rs.getInt("usage_id"));
                rental.setCategory(rs.getString("category_name"));

                rentals.add(rental);
            }
        }

        return rentals;
    }

    public static List<EquipmentSale> getSalesByIds(List<Integer> ids) throws SQLException {
        List<EquipmentSale> sales = new ArrayList<>();
        if (ids == null || ids.isEmpty()) return sales;

        String placeholders = String.join(",", Collections.nCopies(ids.size(), "?"));
        String sql = "SELECT s.*, i.item_name, i.unit, i.sale_price, i.usage_id, c.category_name " +
                "FROM equipment_sales s " +
                "JOIN inventory i ON s.inventory_id = i.inventory_id " +
                "JOIN inventory_category c ON i.category_id = c.category_id " +
                "WHERE s.sale_id IN (" + placeholders + ")";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            for (int i = 0; i < ids.size(); i++) {
                stmt.setInt(i + 1, ids.get(i));
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                EquipmentSale sale = new EquipmentSale();
                sale.setSaleId(rs.getInt("sale_id"));
                sale.setCustomerName(rs.getString("customer_name"));
                sale.setStaffId(rs.getInt("staff_id"));
                sale.setInventoryId(rs.getInt("inventory_id"));
                sale.setQuantity(rs.getInt("quantity"));
                sale.setSalePrice(rs.getDouble("sale_price"));
                sale.setTotalAmount(rs.getDouble("total_amount"));
                sale.setCreatedAt(rs.getTimestamp("created_at"));

                // Thêm thông tin bổ sung (nếu bạn mở rộng model EquipmentSale)
                sale.setItemName(rs.getString("item_name"));
                sale.setUnit(rs.getString("unit"));
                sale.setCategory(rs.getString("category_name"));
                sale.setUsageId(rs.getInt("usage_id"));

                sales.add(sale);
            }
        }

        return sales;
    }

    public String getItemNameByInventoryId(int inventoryId) throws SQLException {
        String sql = "SELECT item_name FROM Inventory WHERE inventory_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, inventoryId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getString("item_name");
            }
        }
        return "Unknown Item";  // Fallback
    }
}
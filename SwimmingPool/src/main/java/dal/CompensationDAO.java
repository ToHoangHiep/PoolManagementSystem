package dal;

import model.*;
import utils.DBConnect;

import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class CompensationDAO {

    // ===================== EQUIPMENT COMPENSATION METHODS =====================

    /**
     * Tạo compensation record mới
     */
    public static boolean createCompensation(EquipmentCompensation compensation) {
        String sql = "INSERT INTO Equipment_Compensations (rental_id, compensation_type, damage_description, " +
                "import_price_total, compensation_rate, total_amount, paid_amount, " +
                "payment_status, can_repair) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, compensation.getRentalId());
            stmt.setString(2, compensation.getCompensationType());
            stmt.setString(3, compensation.getDamageDescription());
            stmt.setBigDecimal(4, compensation.getImportPriceTotal());
            stmt.setBigDecimal(5, compensation.getCompensationRate());
            stmt.setBigDecimal(6, compensation.getTotalAmount());
            stmt.setBigDecimal(7, compensation.getPaidAmount());
            stmt.setString(8, compensation.getPaymentStatus());

            if (compensation.getCanRepair() != null) {
                stmt.setBoolean(9, compensation.getCanRepair());
            } else {
                stmt.setNull(9, Types.BOOLEAN);
            }

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        compensation.setCompensationId(rs.getInt(1));
                    }
                }
                return true;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Lấy compensation theo ID
     */
    public static EquipmentCompensation getCompensationById(int compensationId) {
        String sql = "SELECT * FROM Equipment_Compensations WHERE compensation_id = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, compensationId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCompensation(rs);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Lấy tất cả compensations
     */
    public static List<EquipmentCompensation> getAllCompensations() {
        String sql = "SELECT * FROM Equipment_Compensations ORDER BY created_at DESC";
        List<EquipmentCompensation> compensations = new ArrayList<>();

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                compensations.add(mapResultSetToCompensation(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return compensations;
    }

    /**
     * Lấy compensations theo rental ID
     */
    public static List<EquipmentCompensation> getCompensationsByRentalId(int rentalId) {
        String sql = "SELECT * FROM Equipment_Compensations WHERE rental_id = ? ORDER BY created_at DESC";
        List<EquipmentCompensation> compensations = new ArrayList<>();

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, rentalId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    compensations.add(mapResultSetToCompensation(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return compensations;
    }

    /**
     * Update compensation
     */
    public static boolean updateCompensation(EquipmentCompensation compensation) {
        String sql = "UPDATE Equipment_Compensations SET damage_description = ?, " +
                "import_price_total = ?, compensation_rate = ?, total_amount = ?, paid_amount = ?, " +
                "payment_status = ?, can_repair = ?, resolved_at = ? WHERE compensation_id = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, compensation.getDamageDescription());
            stmt.setBigDecimal(2, compensation.getImportPriceTotal());
            stmt.setBigDecimal(3, compensation.getCompensationRate());
            stmt.setBigDecimal(4, compensation.getTotalAmount());
            stmt.setBigDecimal(5, compensation.getPaidAmount());
            stmt.setString(6, compensation.getPaymentStatus());

            if (compensation.getCanRepair() != null) {
                stmt.setBoolean(7, compensation.getCanRepair());
            } else {
                stmt.setNull(7, Types.BOOLEAN);
            }

            stmt.setTimestamp(8, compensation.getResolvedAt());
            stmt.setInt(9, compensation.getCompensationId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // ===================== PAYMENT METHODS (SỬA LẠI) =====================

    /**
     * Thêm payment cho compensation (sử dụng PaymentDAO)
     */
    public static boolean addCompensationPayment(Payment payment) {
        Connection conn = null;

        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false); // Bắt đầu transaction

            // 1. Thêm payment vào bảng Payments chung
            payment.setPaymentFor("compensation");
            payment.setStatus("completed"); // Giả sử payment luôn completed

            boolean paymentAdded = PaymentDAO.addPayment(payment);

            if (!paymentAdded) {
                conn.rollback();
                return false;
            }

            // 2. Update compensation payment status
            updateCompensationPaymentStatus(conn, payment.getReferenceId());

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
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException closeEx) {
                    // Log warning
                }
            }
        }

        return false;
    }

    /**
     * Helper method: Update compensation payment status sau khi có payment mới
     */
    private static void updateCompensationPaymentStatus(Connection conn, int compensationId) throws SQLException {
        // Lấy tổng tiền đã thanh toán từ bảng Payments
        BigDecimal totalPaid = PaymentDAO.getTotalPaidAmount("compensation", compensationId);

        // Lấy thông tin compensation hiện tại
        String selectSql = "SELECT total_amount FROM Equipment_Compensations WHERE compensation_id = ?";

        try (PreparedStatement selectStmt = conn.prepareStatement(selectSql)) {
            selectStmt.setInt(1, compensationId);

            try (ResultSet rs = selectStmt.executeQuery()) {
                if (rs.next()) {
                    BigDecimal totalAmount = rs.getBigDecimal("total_amount");

                    // Tính payment status
                    String status;
                    if (totalPaid.compareTo(totalAmount) >= 0) {
                        status = "paid";
                    } else if (totalPaid.compareTo(BigDecimal.ZERO) > 0) {
                        status = "partial";
                    } else {
                        status = "pending";
                    }

                    // Update compensation
                    String updateSql = "UPDATE Equipment_Compensations SET paid_amount = ?, payment_status = ? WHERE compensation_id = ?";
                    try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                        updateStmt.setBigDecimal(1, totalPaid);
                        updateStmt.setString(2, status);
                        updateStmt.setInt(3, compensationId);
                        updateStmt.executeUpdate();
                    }
                }
            }
        }
    }


    // ===================== REPAIR METHODS =====================


    // ===================== HELPER METHODS =====================

    /**
     * Helper method: Map ResultSet to EquipmentCompensation
     */
    private static EquipmentCompensation mapResultSetToCompensation(ResultSet rs) throws SQLException {
        EquipmentCompensation compensation = new EquipmentCompensation();

        compensation.setCompensationId(rs.getInt("compensation_id"));
        compensation.setRentalId(rs.getInt("rental_id"));
        compensation.setCompensationType(rs.getString("compensation_type"));
        compensation.setDamageDescription(rs.getString("damage_description"));
        compensation.setImportPriceTotal(rs.getBigDecimal("import_price_total"));
        compensation.setCompensationRate(rs.getBigDecimal("compensation_rate"));
        compensation.setTotalAmount(rs.getBigDecimal("total_amount"));
        compensation.setPaidAmount(rs.getBigDecimal("paid_amount"));
        compensation.setPaymentStatus(rs.getString("payment_status"));

        Boolean canRepair = rs.getObject("can_repair", Boolean.class);
        compensation.setCanRepair(canRepair);

        compensation.setCreatedAt(rs.getTimestamp("created_at"));
        compensation.setResolvedAt(rs.getTimestamp("resolved_at"));

        return compensation;
    }


    /**
     * Helper method: Map ResultSet to EquipmentRepair
     */

    public static boolean createCompensationAndDeductInventory(
            EquipmentCompensation compensation,
            int inventoryId,
            int quantity,
            String compensationType) {

        Connection conn = null;

        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false); // Bắt đầu transaction

            // 1. Tạo compensation record
            String compensationSql = "INSERT INTO Equipment_Compensations (rental_id, compensation_type, damage_description, " +
                    "import_price_total, compensation_rate, total_amount, paid_amount, " +
                    "payment_status, can_repair) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement stmt = conn.prepareStatement(compensationSql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setInt(1, compensation.getRentalId());
                stmt.setString(2, compensation.getCompensationType());
                stmt.setString(3, compensation.getDamageDescription());
                stmt.setBigDecimal(4, compensation.getImportPriceTotal());
                stmt.setBigDecimal(5, compensation.getCompensationRate());
                stmt.setBigDecimal(6, compensation.getTotalAmount());
                stmt.setBigDecimal(7, compensation.getPaidAmount());
                stmt.setString(8, compensation.getPaymentStatus());

                if (compensation.getCanRepair() != null) {
                    stmt.setBoolean(9, compensation.getCanRepair());
                } else {
                    stmt.setNull(9, Types.BOOLEAN);
                }

                int affectedRows = stmt.executeUpdate();
                if (affectedRows == 0) {
                    conn.rollback();
                    return false;
                }

                // Lấy compensation ID
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        compensation.setCompensationId(rs.getInt(1));
                    }
                }
            }

            // 2. Trừ thiết bị khỏi kho (chỉ với damaged và lost)
            if ("damaged".equals(compensationType) || "lost".equals(compensationType)) {
                String inventorySql = "UPDATE Inventory SET quantity = quantity - ? WHERE inventory_id = ?";

                try (PreparedStatement stmt = conn.prepareStatement(inventorySql)) {
                    stmt.setInt(1, quantity);
                    stmt.setInt(2, inventoryId);

                    int updated = stmt.executeUpdate();
                    if (updated == 0) {
                        System.err.println("Warning: Could not update inventory quantity for ID: " + inventoryId);
                    }
                }

                System.out.println("Deducted " + quantity + " units from inventory ID: " + inventoryId +
                        " (Reason: " + compensationType + ")");
            }

            // 3. Update rental status thành 'compensated'
            String rentalSql = "UPDATE Equipment_Rentals SET status = 'compensated' WHERE rental_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(rentalSql)) {
                stmt.setInt(1, compensation.getRentalId());
                stmt.executeUpdate();
            }

            conn.commit();
            System.out.println("Successfully created compensation and updated inventory");
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    e.addSuppressed(rollbackEx);
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException closeEx) {
                    // Log warning
                }
            }
        }
    }
}
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
                "damage_level, original_price, compensation_rate, total_amount, paid_amount, " +
                "payment_status, can_repair) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, compensation.getRentalId());
            stmt.setString(2, compensation.getCompensationType());
            stmt.setString(3, compensation.getDamageDescription());
            stmt.setString(4, compensation.getDamageLevel());
            stmt.setBigDecimal(5, compensation.getOriginalPrice());
            stmt.setBigDecimal(6, compensation.getCompensationRate());
            stmt.setBigDecimal(7, compensation.getTotalAmount());
            stmt.setBigDecimal(8, compensation.getPaidAmount());
            stmt.setString(9, compensation.getPaymentStatus());

            if (compensation.getCanRepair() != null) {
                stmt.setBoolean(10, compensation.getCanRepair());
            } else {
                stmt.setNull(10, Types.BOOLEAN);
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
        String sql = "UPDATE Equipment_Compensations SET damage_description = ?, damage_level = ?, " +
                "original_price = ?, compensation_rate = ?, total_amount = ?, paid_amount = ?, " +
                "payment_status = ?, can_repair = ?, resolved_at = ? WHERE compensation_id = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, compensation.getDamageDescription());
            stmt.setString(2, compensation.getDamageLevel());
            stmt.setBigDecimal(3, compensation.getOriginalPrice());
            stmt.setBigDecimal(4, compensation.getCompensationRate());
            stmt.setBigDecimal(5, compensation.getTotalAmount());
            stmt.setBigDecimal(6, compensation.getPaidAmount());
            stmt.setString(7, compensation.getPaymentStatus());

            if (compensation.getCanRepair() != null) {
                stmt.setBoolean(8, compensation.getCanRepair());
            } else {
                stmt.setNull(8, Types.BOOLEAN);
            }

            stmt.setTimestamp(9, compensation.getResolvedAt());
            stmt.setInt(10, compensation.getCompensationId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // ===================== COMPENSATION PAYMENT METHODS =====================

    /**
     * Thêm payment và tự động update compensation status
     */
    public static boolean addPayment(CompensationPayment payment) {
        Connection conn = null;

        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false); // Bắt đầu transaction

            // 1. Insert payment
            String insertPaymentSql = "INSERT INTO Compensation_Payments (compensation_id, payment_amount, notes) VALUES (?, ?, ?)";

            try (PreparedStatement stmt = conn.prepareStatement(insertPaymentSql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setInt(1, payment.getCompensationId());
                stmt.setBigDecimal(2, payment.getPaymentAmount());
                stmt.setString(3, payment.getNotes());

                int affectedRows = stmt.executeUpdate();

                if (affectedRows > 0) {
                    try (ResultSet rs = stmt.getGeneratedKeys()) {
                        if (rs.next()) {
                            payment.setPaymentId(rs.getInt(1));
                        }
                    }
                } else {
                    conn.rollback();
                    return false;
                }
            }

            // 2. Update compensation payment status
            updateCompensationPaymentStatus(conn, payment.getCompensationId(), payment.getPaymentAmount());

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
     * Lấy payments theo compensation ID
     */
    public static List<CompensationPayment> getPaymentsByCompensationId(int compensationId) {
        String sql = "SELECT * FROM Compensation_Payments WHERE compensation_id = ? ORDER BY payment_date DESC";
        List<CompensationPayment> payments = new ArrayList<>();

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, compensationId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPayment(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return payments;
    }

    // ===================== DAMAGE PHOTO METHODS =====================

    /**
     * Thêm ảnh thiệt hại
     */
    public static boolean addDamagePhoto(EquipmentDamagePhoto photo) {
        String sql = "INSERT INTO Equipment_Damage_Photos (compensation_id, photo_path, photo_description) VALUES (?, ?, ?)";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, photo.getCompensationId());
            stmt.setString(2, photo.getPhotoPath());
            stmt.setString(3, photo.getPhotoDescription());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        photo.setPhotoId(rs.getInt(1));
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
     * Lấy ảnh thiệt hại theo compensation ID
     */
    public static List<EquipmentDamagePhoto> getDamagePhotosByCompensationId(int compensationId) {
        String sql = "SELECT * FROM Equipment_Damage_Photos WHERE compensation_id = ? ORDER BY uploaded_at DESC";
        List<EquipmentDamagePhoto> photos = new ArrayList<>();

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, compensationId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    photos.add(mapResultSetToPhoto(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return photos;
    }

    /**
     * Xóa ảnh thiệt hại
     */
    public static boolean deleteDamagePhoto(int photoId) {
        String sql = "DELETE FROM Equipment_Damage_Photos WHERE photo_id = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, photoId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // ===================== REPAIR METHODS =====================

    /**
     * Tạo repair record
     */
    public static boolean createRepair(EquipmentRepair repair) {
        String sql = "INSERT INTO Equipment_Repairs (compensation_id, inventory_id, repair_description, " +
                "repair_cost, repair_vendor, estimated_completion) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, repair.getCompensationId());
            stmt.setInt(2, repair.getInventoryId());
            stmt.setString(3, repair.getRepairDescription());
            stmt.setBigDecimal(4, repair.getRepairCost());
            stmt.setString(5, repair.getRepairVendor());

            if (repair.getEstimatedCompletion() != null) {
                stmt.setDate(6, new java.sql.Date(repair.getEstimatedCompletion().getTime()));
            } else {
                stmt.setNull(6, Types.DATE);
            }

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        repair.setRepairId(rs.getInt(1));
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
     * Update repair status
     */
    public static boolean updateRepairStatus(int repairId, String status) {
        String sql = "UPDATE Equipment_Repairs SET repair_status = ?, " +
                "started_at = CASE WHEN ? = 'in_progress' AND started_at IS NULL THEN NOW() ELSE started_at END, " +
                "completed_at = CASE WHEN ? = 'completed' THEN NOW() ELSE completed_at END " +
                "WHERE repair_id = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setString(2, status);
            stmt.setString(3, status);
            stmt.setInt(4, repairId);

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Lấy repairs theo compensation ID
     */
    public static List<EquipmentRepair> getRepairsByCompensationId(int compensationId) {
        String sql = "SELECT * FROM Equipment_Repairs WHERE compensation_id = ? ORDER BY created_at DESC";
        List<EquipmentRepair> repairs = new ArrayList<>();

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, compensationId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    repairs.add(mapResultSetToRepair(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return repairs;
    }

    // ===================== HELPER METHODS =====================

    /**
     * Helper method: Update compensation payment status
     */
    private static void updateCompensationPaymentStatus(Connection conn, int compensationId, BigDecimal paymentAmount) throws SQLException {
        // Lấy thông tin compensation hiện tại
        String selectSql = "SELECT paid_amount, total_amount FROM Equipment_Compensations WHERE compensation_id = ?";

        try (PreparedStatement selectStmt = conn.prepareStatement(selectSql)) {
            selectStmt.setInt(1, compensationId);

            try (ResultSet rs = selectStmt.executeQuery()) {
                if (rs.next()) {
                    BigDecimal currentPaid = rs.getBigDecimal("paid_amount");
                    BigDecimal totalAmount = rs.getBigDecimal("total_amount");
                    BigDecimal newPaidAmount = currentPaid.add(paymentAmount);

                    // Tính payment status
                    String status;
                    if (newPaidAmount.compareTo(totalAmount) >= 0) {
                        status = "paid";
                        newPaidAmount = totalAmount; // Cap at total amount
                    } else if (newPaidAmount.compareTo(BigDecimal.ZERO) > 0) {
                        status = "partial";
                    } else {
                        status = "pending";
                    }

                    // Update compensation
                    String updateSql = "UPDATE Equipment_Compensations SET paid_amount = ?, payment_status = ? WHERE compensation_id = ?";
                    try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                        updateStmt.setBigDecimal(1, newPaidAmount);
                        updateStmt.setString(2, status);
                        updateStmt.setInt(3, compensationId);
                        updateStmt.executeUpdate();
                    }
                }
            }
        }
    }

    /**
     * Helper method: Map ResultSet to EquipmentCompensation
     */
    private static EquipmentCompensation mapResultSetToCompensation(ResultSet rs) throws SQLException {
        EquipmentCompensation compensation = new EquipmentCompensation();

        compensation.setCompensationId(rs.getInt("compensation_id"));
        compensation.setRentalId(rs.getInt("rental_id"));
        compensation.setCompensationType(rs.getString("compensation_type"));
        compensation.setDamageDescription(rs.getString("damage_description"));
        compensation.setDamageLevel(rs.getString("damage_level"));
        compensation.setOriginalPrice(rs.getBigDecimal("original_price"));
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
     * Helper method: Map ResultSet to CompensationPayment
     */
    private static CompensationPayment mapResultSetToPayment(ResultSet rs) throws SQLException {
        CompensationPayment payment = new CompensationPayment();

        payment.setPaymentId(rs.getInt("payment_id"));
        payment.setCompensationId(rs.getInt("compensation_id"));
        payment.setPaymentAmount(rs.getBigDecimal("payment_amount"));
        payment.setPaymentDate(rs.getTimestamp("payment_date"));
        payment.setNotes(rs.getString("notes"));

        return payment;
    }

    /**
     * Helper method: Map ResultSet to EquipmentDamagePhoto
     */
    private static EquipmentDamagePhoto mapResultSetToPhoto(ResultSet rs) throws SQLException {
        EquipmentDamagePhoto photo = new EquipmentDamagePhoto();

        photo.setPhotoId(rs.getInt("photo_id"));
        photo.setCompensationId(rs.getInt("compensation_id"));
        photo.setPhotoPath(rs.getString("photo_path"));
        photo.setPhotoDescription(rs.getString("photo_description"));
        photo.setUploadedAt(rs.getTimestamp("uploaded_at"));

        return photo;
    }

    /**
     * Helper method: Map ResultSet to EquipmentRepair
     */
    private static EquipmentRepair mapResultSetToRepair(ResultSet rs) throws SQLException {
        EquipmentRepair repair = new EquipmentRepair();

        repair.setRepairId(rs.getInt("repair_id"));
        repair.setCompensationId(rs.getInt("compensation_id"));
        repair.setInventoryId(rs.getInt("inventory_id"));
        repair.setRepairDescription(rs.getString("repair_description"));
        repair.setRepairCost(rs.getBigDecimal("repair_cost"));
        repair.setRepairVendor(rs.getString("repair_vendor"));
        repair.setRepairStatus(rs.getString("repair_status"));
        repair.setStartedAt(rs.getTimestamp("started_at"));
        repair.setCompletedAt(rs.getTimestamp("completed_at"));

        java.sql.Date estimatedDate = rs.getDate("estimated_completion");
        if (estimatedDate != null) {
            repair.setEstimatedCompletion(estimatedDate);
        }

        repair.setPostRepairCondition(rs.getString("post_repair_condition"));

        Boolean canReturn = rs.getObject("can_return_to_inventory", Boolean.class);
        repair.setCanReturnToInventory(canReturn);

        repair.setCreatedAt(rs.getTimestamp("created_at"));

        return repair;
    }
}
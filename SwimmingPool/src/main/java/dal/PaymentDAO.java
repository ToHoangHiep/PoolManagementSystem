package dal;

import model.Payment;
import utils.DBConnect;

import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    /**
     * Thêm payment mới
     */
    public static boolean addPayment(Payment payment) {
        String sql = "INSERT INTO Payments (user_id, customer_name, customer_id_card, " +
                "amount, payment_method, payment_for, reference_id, status, notes, staff_id) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            // Set parameters
            if (payment.getUserId() != null) {
                stmt.setInt(1, payment.getUserId());
            } else {
                stmt.setNull(1, Types.INTEGER);
            }

            stmt.setString(2, payment.getCustomerName());
            stmt.setString(3, payment.getCustomerIdCard());
            stmt.setBigDecimal(4, payment.getAmount());
            stmt.setString(5, payment.getPaymentMethod());
            stmt.setString(6, payment.getPaymentFor());
            stmt.setInt(7, payment.getReferenceId());
            stmt.setString(8, payment.getStatus());
            stmt.setString(9, payment.getNotes());

            if (payment.getStaffId() != null) {
                stmt.setInt(10, payment.getStaffId());
            } else {
                stmt.setNull(10, Types.INTEGER);
            }

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                // Lấy payment_id vừa tạo
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        payment.setPaymentId(rs.getInt(1));
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
     * Lấy payment theo ID
     */
    public static Payment getPaymentById(int paymentId) {
        String sql = "SELECT * FROM Payments WHERE payment_id = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, paymentId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPayment(rs);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Lấy danh sách payment theo reference
     */
    public static List<Payment> getPaymentsByReference(String paymentFor, int referenceId) {
        String sql = "SELECT * FROM Payments WHERE payment_for = ? AND reference_id = ? " +
                "ORDER BY payment_date DESC";
        List<Payment> payments = new ArrayList<>();

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, paymentFor);
            stmt.setInt(2, referenceId);

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

    /**
     * Update status của payment
     */
    public static boolean updatePaymentStatus(int paymentId, String status) {
        String sql = "UPDATE Payments SET status = ? WHERE payment_id = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, paymentId);

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Tính tổng tiền đã thanh toán cho một reference
     */
    public static BigDecimal getTotalPaidAmount(String paymentFor, int referenceId) {
        String sql = "SELECT SUM(amount) as total FROM Payments " +
                "WHERE payment_for = ? AND reference_id = ? AND status = 'completed'";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, paymentFor);
            stmt.setInt(2, referenceId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    BigDecimal total = rs.getBigDecimal("total");
                    return total != null ? total : BigDecimal.ZERO;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return BigDecimal.ZERO;
    }

    /**
     * Lấy danh sách payment theo customer
     */
    public static List<Payment> getPaymentsByCustomer(String customerIdCard) {
        String sql = "SELECT * FROM Payments WHERE customer_id_card = ? " +
                "ORDER BY payment_date DESC";
        List<Payment> payments = new ArrayList<>();

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, customerIdCard);

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

    /**
     * Lấy tất cả payments với filter
     */
    public static List<Payment> getAllPayments(String paymentFor, String status, Date fromDate, Date toDate) {
        StringBuilder sql = new StringBuilder("SELECT * FROM Payments WHERE 1=1");
        List<Object> params = new ArrayList<>();

        // Build dynamic query
        if (paymentFor != null && !paymentFor.isEmpty()) {
            sql.append(" AND payment_for = ?");
            params.add(paymentFor);
        }

        if (status != null && !status.isEmpty()) {
            sql.append(" AND status = ?");
            params.add(status);
        }

        if (fromDate != null) {
            sql.append(" AND DATE(payment_date) >= ?");
            params.add(fromDate);
        }

        if (toDate != null) {
            sql.append(" AND DATE(payment_date) <= ?");
            params.add(toDate);
        }

        sql.append(" ORDER BY payment_date DESC");

        List<Payment> payments = new ArrayList<>();

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

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

    /**
     * Helper method: Map ResultSet to Payment
     */
    private static Payment mapResultSetToPayment(ResultSet rs) throws SQLException {
        Payment payment = new Payment();

        payment.setPaymentId(rs.getInt("payment_id"));

        // Handle nullable Integer fields
        int userId = rs.getInt("user_id");
        if (!rs.wasNull()) {
            payment.setUserId(userId);
        }

        payment.setCustomerName(rs.getString("customer_name"));
        payment.setCustomerIdCard(rs.getString("customer_id_card"));
        payment.setAmount(rs.getBigDecimal("amount"));
        payment.setPaymentMethod(rs.getString("payment_method"));
        payment.setPaymentFor(rs.getString("payment_for"));
        payment.setReferenceId(rs.getInt("reference_id"));
        payment.setStatus(rs.getString("status"));
        payment.setPaymentDate(rs.getTimestamp("payment_date"));
        payment.setNotes(rs.getString("notes"));

        int staffId = rs.getInt("staff_id");
        if (!rs.wasNull()) {
            payment.setStaffId(staffId);
        }

        return payment;
    }

    /**
     * Delete payment (cho testing)
     */
    public static boolean deletePayment(int paymentId) {
        String sql = "DELETE FROM Payments WHERE payment_id = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, paymentId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
}
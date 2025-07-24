package dal;

import model.CustomerBlacklist;
import utils.DBConnect;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BlacklistDAO {

    /**
     * Thêm khách hàng vào blacklist
     */
    public static boolean addToBlacklist(CustomerBlacklist blacklist) {
        String sql = "INSERT INTO Customer_Blacklist (customer_id_card, customer_name, reason, " +
                "description, severity, expires_at) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, blacklist.getCustomerIdCard());
            stmt.setString(2, blacklist.getCustomerName());
            stmt.setString(3, blacklist.getReason());
            stmt.setString(4, blacklist.getDescription());
            stmt.setString(5, blacklist.getSeverity());
            stmt.setTimestamp(6, blacklist.getExpiresAt());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        blacklist.setBlacklistId(rs.getInt(1));
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
     * Kiểm tra khách hàng có trong blacklist không
     */
    public static CustomerBlacklist checkBlacklist(String customerIdCard) {
        String sql = "SELECT * FROM Customer_Blacklist WHERE customer_id_card = ? AND is_active = TRUE " +
                "AND (expires_at IS NULL OR expires_at > NOW()) ORDER BY blacklisted_at DESC LIMIT 1";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, customerIdCard);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBlacklist(rs);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Bỏ khách hàng khỏi blacklist
     */
    public static boolean removeFromBlacklist(int blacklistId) {
        String sql = "UPDATE Customer_Blacklist SET is_active = FALSE WHERE blacklist_id = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, blacklistId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Lấy tất cả blacklists đang active
     */
    public static List<CustomerBlacklist> getAllActiveBlacklists() {
        String sql = "SELECT * FROM Customer_Blacklist WHERE is_active = TRUE ORDER BY blacklisted_at DESC";
        List<CustomerBlacklist> blacklists = new ArrayList<>();

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                blacklists.add(mapResultSetToBlacklist(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return blacklists;
    }

    /**
     * Kiểm tra customer có bị ban không (convenience method)
     */
    public static boolean isCustomerBanned(String customerIdCard) {
        CustomerBlacklist blacklist = checkBlacklist(customerIdCard);
        return blacklist != null && blacklist.isBanned();
    }

    /**
     * Kiểm tra customer có bị restricted không
     */
    public static boolean isCustomerRestricted(String customerIdCard) {
        CustomerBlacklist blacklist = checkBlacklist(customerIdCard);
        return blacklist != null && (blacklist.isBanned() || blacklist.isRestricted());
    }

    /**
     * Lấy blacklist history của customer
     */
    public static List<CustomerBlacklist> getBlacklistHistory(String customerIdCard) {
        String sql = "SELECT * FROM Customer_Blacklist WHERE customer_id_card = ? ORDER BY blacklisted_at DESC";
        List<CustomerBlacklist> blacklists = new ArrayList<>();

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, customerIdCard);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    blacklists.add(mapResultSetToBlacklist(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return blacklists;
    }

    /**
     * Helper method: Map ResultSet to CustomerBlacklist
     */
    private static CustomerBlacklist mapResultSetToBlacklist(ResultSet rs) throws SQLException {
        CustomerBlacklist blacklist = new CustomerBlacklist();

        blacklist.setBlacklistId(rs.getInt("blacklist_id"));
        blacklist.setCustomerIdCard(rs.getString("customer_id_card"));
        blacklist.setCustomerName(rs.getString("customer_name"));
        blacklist.setReason(rs.getString("reason"));
        blacklist.setDescription(rs.getString("description"));
        blacklist.setSeverity(rs.getString("severity"));
        blacklist.setBlacklistedAt(rs.getTimestamp("blacklisted_at"));
        blacklist.setExpiresAt(rs.getTimestamp("expires_at"));
        blacklist.setActive(rs.getBoolean("is_active"));

        return blacklist;
    }
}
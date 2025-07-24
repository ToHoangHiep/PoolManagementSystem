package dal;

import model.StaffInitialSetup;
import utils.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class StaffInitialSetupDAO {

    protected Connection getConnection() {
        return DBConnect.getConnection();
    }


    public void insertStaffInitialSetup(int userId) throws SQLException {
        String sql = "INSERT INTO StaffInitialSetup (user_id, is_setup_complete) VALUES (?, FALSE)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }


    public void updateSetupCompleteStatus(int userId, boolean isComplete) throws SQLException {
        String sql = "UPDATE StaffInitialSetup SET is_setup_complete = ? WHERE user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, isComplete);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }


    public StaffInitialSetup getStaffInitialSetupByUserId(int userId) throws SQLException {
        String sql = "SELECT user_id, is_setup_complete, created_at FROM StaffInitialSetup WHERE user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new StaffInitialSetup(
                        rs.getInt("user_id"),
                        rs.getBoolean("is_setup_complete"),
                        rs.getTimestamp("created_at")
                );
            }
        }
        return null;
    }
}
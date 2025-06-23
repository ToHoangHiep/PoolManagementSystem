package dal;

import model.MaintenanceSchedule;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MaintenanceScheduleDAO {
    private final String jdbcURL = "jdbc:mysql://localhost:3306/swimming_pool_management";
    private final String jdbcUsername = "root";
    private final String jdbcPassword = ""; // cập nhật nếu bạn có mật khẩu

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    }

    public List<MaintenanceSchedule> getAllSchedules() {
        List<MaintenanceSchedule> list = new ArrayList<>();
        String sql = "SELECT * FROM Maintenance_Schedule ORDER BY scheduled_time ASC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                MaintenanceSchedule s = new MaintenanceSchedule();
                s.setId(rs.getInt("id"));
                s.setTitle(rs.getString("title"));
                s.setDescription(rs.getString("description"));
                s.setFrequency(rs.getString("frequency"));
                s.setAssignedStaffId(rs.getInt("assigned_staff_id"));
                s.setScheduledTime(rs.getTime("scheduled_time"));
                s.setStatus(rs.getString("status"));
                s.setCreatedBy(rs.getInt("created_by"));
                s.setCreatedAt(rs.getTimestamp("created_at"));

                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}

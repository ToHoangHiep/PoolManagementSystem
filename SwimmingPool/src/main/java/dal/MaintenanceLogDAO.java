package dal;

import utils.DBConnect;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class MaintenanceLogDAO {
    private final Connection conn = DBConnect.getConnection();

    /** Lấy danh sách các ngày đã tick của 1 staff theo schedule và tuần (trả về list các LocalDate) */
    public List<LocalDate> getCompletedDays(int userId, int scheduleId, LocalDate weekStartDate) {
        List<LocalDate> completedDays = new ArrayList<>();
        String sql = "SELECT maintenance_date FROM Maintenance_Log " +
                "WHERE staff_id = ? AND schedule_id = ? AND maintenance_date BETWEEN ? AND ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, scheduleId);
            ps.setDate(3, Date.valueOf(weekStartDate));
            ps.setDate(4, Date.valueOf(weekStartDate.plusDays(6))); // hết Chủ nhật
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    completedDays.add(rs.getDate("maintenance_date").toLocalDate());
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return completedDays;
    }

    /** Đếm số tick đã hoàn thành trong 1 tuần cụ thể */
    public int countCompletedDays(int scheduleId, int userId, LocalDate weekStartDate) {
        String sql = "SELECT COUNT(*) FROM Maintenance_Log " +
                "WHERE schedule_id = ? AND staff_id = ? AND maintenance_date BETWEEN ? AND ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            ps.setInt(2, userId);
            ps.setDate(3, Date.valueOf(weekStartDate));
            ps.setDate(4, Date.valueOf(weekStartDate.plusDays(6)));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** Cập nhật status của schedule */
    public void updateScheduleStatus(int scheduleId, String status) {
        String sql = "UPDATE Maintenance_Schedule SET status = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, scheduleId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /** Ghi log hoàn thành cho 1 ngày cụ thể */
    public void insertLog(int scheduleId, int staffId, int poolAreaId, LocalDate date, String status) {
        String sql = "INSERT INTO Maintenance_Log(schedule_id, staff_id, pool_area_id, maintenance_date, status) " +
                "VALUES(?,?,?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            ps.setInt(2, staffId);
            ps.setInt(3, poolAreaId);
            ps.setDate(4, Date.valueOf(date));
            ps.setString(5, status);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /** Kiểm tra đã tồn tại log ngày đó chưa */
    public boolean checkLogExists(int scheduleId, int staffId, LocalDate date) {
        String sql = "SELECT COUNT(*) FROM Maintenance_Log WHERE schedule_id=? AND staff_id=? AND maintenance_date=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            ps.setInt(2, staffId);
            ps.setDate(3, Date.valueOf(date));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}

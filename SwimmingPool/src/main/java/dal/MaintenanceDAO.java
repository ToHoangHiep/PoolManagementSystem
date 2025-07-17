package dal;

import model.*;
import utils.DBConnect;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MaintenanceDAO {
    private final Connection conn = DBConnect.getConnection();

    // Lấy tất cả lịch định kỳ (chưa hoàn thành hoặc có thể xem lịch sử)
    public List<MaintenanceSchedule> getAllSchedules() {
        String sql = "SELECT ms.id, ms.title, ms.description, ms.frequency, ms.scheduled_time, u.full_name AS creator " +
                "FROM Maintenance_Schedule ms " +
                "JOIN Users u ON ms.created_by = u.id ";
        List<MaintenanceSchedule> list = new ArrayList<>();
        try (PreparedStatement p = conn.prepareStatement(sql);
             ResultSet rs = p.executeQuery()) {
            while (rs.next()) {
                MaintenanceSchedule m = new MaintenanceSchedule();
                m.setId(rs.getInt("id"));
                m.setTitle(rs.getString("title"));
                m.setDescription(rs.getString("description"));
                m.setFrequency(rs.getString("frequency"));
                m.setScheduledTime(rs.getTime("scheduled_time"));
                m.setCreatedByName(rs.getString("creator"));
                list.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy log (nhiệm vụ) đã gán cho 1 staff
    public List<MaintenanceLog> getLogsByStaff(int staffId) {
        String sql = "SELECT ml.id, ml.maintenance_date, ml.status, ml.note, pa.name AS area, ms.title " +
                "FROM Maintenance_Log ml " +
                "JOIN Maintenance_Schedule ms ON ml.schedule_id=ms.id " +
                "JOIN Pool_Area pa ON ml.pool_area_id=pa.id " +
                "WHERE ml.staff_id = ?";
        List<MaintenanceLog> list = new ArrayList<>();
        try (PreparedStatement p = conn.prepareStatement(sql)) {
            p.setInt(1, staffId);
            try (ResultSet rs = p.executeQuery()) {
                while (rs.next()) {
                    MaintenanceLog log = new MaintenanceLog();
                    log.setId(rs.getInt("id"));
                    log.setMaintenanceDate(rs.getDate("maintenance_date"));
                    log.setStatus(rs.getString("status"));
                    log.setNote(rs.getString("note"));
                    log.setAreaName(rs.getString("area"));
                    log.setScheduleTitle(rs.getString("title"));
                    list.add(log);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy tất cả template để tạo schedule
    public List<MaintenanceSchedule> getAllTemplates() {
        String sql = "SELECT id, title, description, frequency FROM Maintenance_Schedule";
        List<MaintenanceSchedule> list = new ArrayList<>();
        try (PreparedStatement p = conn.prepareStatement(sql);
             ResultSet rs = p.executeQuery()) {
            while (rs.next()) {
                MaintenanceSchedule t = new MaintenanceSchedule();
                t.setId(rs.getInt("id"));
                t.setTitle(rs.getString("title"));
                t.setDescription(rs.getString("description"));
                t.setFrequency(rs.getString("frequency"));
                list.add(t);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy tất cả Pool Area
    public List<PoolArea> getAllPoolAreas() {
        String sql = "SELECT id, name FROM Pool_Area";
        List<PoolArea> list = new ArrayList<>();
        try (PreparedStatement p = conn.prepareStatement(sql);
             ResultSet rs = p.executeQuery()) {
            while (rs.next()) {
                PoolArea a = new PoolArea();
                a.setId(rs.getInt("id"));
                a.setName(rs.getString("name"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy danh sách staff
    public List<User> getAllStaff() {
        String sql = "SELECT id, full_name FROM Users WHERE role_id = 5";
        List<User> list = new ArrayList<>();
        try (PreparedStatement p = conn.prepareStatement(sql);
             ResultSet rs = p.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setFullName(rs.getString("full_name"));
                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy template by id (để tạo schedule)
    public MaintenanceSchedule getTemplateById(int id) {
        String sql = "SELECT id, title, description, frequency FROM Maintenance_Schedule WHERE id = ?";
        try (PreparedStatement p = conn.prepareStatement(sql)) {
            p.setInt(1, id);
            try (ResultSet rs = p.executeQuery()) {
                if (rs.next()) {
                    MaintenanceSchedule t = new MaintenanceSchedule();
                    t.setId(rs.getInt("id"));
                    t.setTitle(rs.getString("title"));
                    t.setDescription(rs.getString("description"));
                    t.setFrequency(rs.getString("frequency"));
                    return t;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Insert schedule mới (vào Maintenance_Log lần đầu nếu muốn)
    public void insertSchedule(MaintenanceSchedule s) {
        String sql = "INSERT INTO Maintenance_Log(schedule_id, staff_id, pool_area_id, maintenance_date, status) VALUES (?, ?, ?, CURDATE(), 'Missed')";
        try (PreparedStatement p = conn.prepareStatement(sql)) {
            p.setInt(1, s.getId());
            p.setInt(2, s.getStaffId());
            p.setInt(3, s.getPoolAreaId());
            p.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Cập nhật log thành Done
    public void updateLogStatus(int logId, String status) {
        String sql = "UPDATE Maintenance_Log SET status = ? WHERE id = ?";
        try (PreparedStatement p = conn.prepareStatement(sql)) {
            p.setString(1, status);
            p.setInt(2, logId);
            p.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Insert maintenance request
    public void insertRequest(MaintenanceRequest r) {
        String sql = "INSERT INTO Maintenance_Requests(description, status, created_by) VALUES (?, 'Open', ?)";
        try (PreparedStatement p = conn.prepareStatement(sql)) {
            p.setString(1, r.getDescription());
            p.setInt(2, r.getCreatedBy());
            p.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

package dal;

import model.MaintenanceLog;
import model.MaintenanceRequest;
import model.MaintenanceSchedule;
import model.PoolArea;
import model.User;
import utils.DBConnect;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MaintenanceDAO {
    private final Connection conn = DBConnect.getConnection();

    /** Lấy tất cả template lịch bảo trì */
    public List<MaintenanceSchedule> getAllTemplates() {
        String sql = "SELECT id, title, description, frequency, scheduled_time, created_by FROM Maintenance_Schedule";
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
                m.setCreatedBy(rs.getInt("created_by"));
                list.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Lấy log công việc của staff trong tuần hiện tại */
    public List<MaintenanceLog> getLogsForWeek(int scheduleId, int staffId) {
        String sql =
                "SELECT ml.id, ml.schedule_id, ml.pool_area_id, ml.maintenance_date, ml.status, ml.note, " +
                        "       pa.name AS area, ms.title " +
                        "FROM Maintenance_Log ml " +
                        " JOIN Maintenance_Schedule ms ON ml.schedule_id=ms.id " +
                        " JOIN Pool_Area pa ON ml.pool_area_id=pa.id " +
                        "WHERE ml.schedule_id=? AND ml.staff_id=? " +
                        "  AND ml.maintenance_date BETWEEN " +
                        "      DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY) " +
                        "  AND DATE_ADD(CURDATE(), INTERVAL (6-WEEKDAY(CURDATE())) DAY)";
        List<MaintenanceLog> list = new ArrayList<>();
        try (PreparedStatement p = conn.prepareStatement(sql)) {
            p.setInt(1, scheduleId);
            p.setInt(2, staffId);
            try (ResultSet rs = p.executeQuery()) {
                while (rs.next()) {
                    MaintenanceLog log = new MaintenanceLog();
                    log.setId(rs.getInt("id"));
                    log.setScheduleId(rs.getInt("schedule_id"));
                    log.setPoolAreaId(rs.getInt("pool_area_id"));
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

    /** Lấy log đã gán cho staff (xem chung) */
    public List<MaintenanceLog> getLogsByStaff(int staffId) {
        String sql =
                "SELECT ml.id, ml.schedule_id, ml.pool_area_id, ml.maintenance_date, ml.status, ml.note, " +
                        "       pa.name AS area, ms.title " +
                        "FROM Maintenance_Log ml " +
                        " JOIN Maintenance_Schedule ms ON ml.schedule_id=ms.id " +
                        " JOIN Pool_Area pa ON ml.pool_area_id=pa.id " +
                        "WHERE ml.staff_id = ?";
        List<MaintenanceLog> list = new ArrayList<>();
        try (PreparedStatement p = conn.prepareStatement(sql)) {
            p.setInt(1, staffId);
            try (ResultSet rs = p.executeQuery()) {
                while (rs.next()) {
                    MaintenanceLog log = new MaintenanceLog();
                    log.setId(rs.getInt("id"));
                    log.setScheduleId(rs.getInt("schedule_id"));
                    log.setPoolAreaId(rs.getInt("pool_area_id"));      // ← set poolAreaId
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
    /** Lấy tất cả PoolArea */
    public List<PoolArea> getAllPoolAreas() {
        String sql = "SELECT id, name, description FROM Pool_Area";
        List<PoolArea> list = new ArrayList<>();
        try (PreparedStatement p = conn.prepareStatement(sql);
             ResultSet rs = p.executeQuery()) {
            while (rs.next()) {
                PoolArea a = new PoolArea();
                a.setId(rs.getInt("id"));
                a.setName(rs.getString("name"));
                a.setDescription(rs.getString("description"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Lấy danh sách staff */
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

    /** Lấy schedule template theo id */
    public MaintenanceSchedule getTemplateById(int id) {
        String sql = "SELECT id, title, description, frequency, scheduled_time, created_by " +
                "FROM Maintenance_Schedule WHERE id = ?";
        try (PreparedStatement p = conn.prepareStatement(sql)) {
            p.setInt(1, id);
            try (ResultSet rs = p.executeQuery()) {
                if (rs.next()) {
                    MaintenanceSchedule t = new MaintenanceSchedule();
                    t.setId(rs.getInt("id"));
                    t.setTitle(rs.getString("title"));
                    t.setDescription(rs.getString("description"));
                    t.setFrequency(rs.getString("frequency"));
                    t.setScheduledTime(rs.getTime("scheduled_time"));
                    t.setCreatedBy(rs.getInt("created_by"));
                    return t;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /** Tạo schedule và trả về id */
    public int insertSchedule(String title, String description, String frequency, Time scheduledTime, int createdBy) {
        String sql = "INSERT INTO Maintenance_Schedule(title, description, frequency, scheduled_time, created_by) VALUES(?,?,?,?,?)";
        try (PreparedStatement p = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            p.setString(1, title);
            p.setString(2, description);
            p.setString(3, frequency);
            p.setTime(4, scheduledTime);
            p.setInt(5, createdBy);
            p.executeUpdate();
            try (ResultSet keys = p.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    /** Ghi log mới (status Missed) */
    public void insertLog(int scheduleId, int staffId, int poolAreaId) {
        String sql = "INSERT INTO Maintenance_Log(schedule_id, staff_id, pool_area_id, maintenance_date, status) " +
                "VALUES(?,?,?,CURDATE(),'Missed')";
        try (PreparedStatement p = conn.prepareStatement(sql)) {
            p.setInt(1, scheduleId);
            p.setInt(2, staffId);
            p.setInt(3, poolAreaId);
            p.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /** Ghi log cho ngày cụ thể với status */
    public void insertLogOnDate(int scheduleId, int staffId, int poolAreaId, Date date, String status) {
        String sql = "INSERT INTO Maintenance_Log(schedule_id, staff_id, pool_area_id, maintenance_date, status) " +
                "VALUES(?,?,?,?,?)";
        try (PreparedStatement p = conn.prepareStatement(sql)) {
            p.setInt(1, scheduleId);
            p.setInt(2, staffId);
            p.setInt(3, poolAreaId);
            p.setDate(4, date);
            p.setString(5, status);
            p.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /** Cập nhật log đã hoàn thành */
    public void updateLogStatus(int logId, String status) {
        String sql = "UPDATE Maintenance_Log SET status=? WHERE id=?";
        try (PreparedStatement p = conn.prepareStatement(sql)) {
            p.setString(1, status);
            p.setInt(2, logId);
            p.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /** Tạo maintenance request */
    public void insertRequest(MaintenanceRequest request) {
        // Sửa lại câu SQL để thêm pool_area_id
        String sql = "INSERT INTO Maintenance_Requests (description, status, created_by, created_at, pool_area_id) VALUES (?, 'Open', ?, NOW(), ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, request.getDescription());
            ps.setInt(2, request.getCreatedBy());
            ps.setInt(3, request.getPoolAreaId()); // <-- Thêm tham số này
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}

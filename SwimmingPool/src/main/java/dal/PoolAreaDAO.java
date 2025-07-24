package dal;

import model.MaintenanceLog;
import model.MaintenanceRequest;
import model.PoolArea;
import utils.DBConnect;

import java.sql.*;
import java.util.*;

public class PoolAreaDAO {

    protected Connection getConnection() {
        return DBConnect.getConnection();
    }

    public void insert(PoolArea area) throws SQLException {
        String sql = "INSERT INTO Pool_Area (name, description, type, water_depth, length, width, max_capacity) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, area.getName());
            ps.setString(2, area.getDescription());
            ps.setString(3, area.getType());
            ps.setDouble(4, area.getWaterDepth());
            ps.setDouble(5, area.getLength());
            ps.setDouble(6, area.getWidth());
            ps.setInt(7, area.getMaxCapacity());
            ps.executeUpdate();
        }
    }
    public List<PoolArea> selectAll() throws SQLException {
        List<PoolArea> areas = new ArrayList<>();
        String sql = "SELECT * FROM Pool_Area";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PoolArea area = new PoolArea(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getString("type"),
                        rs.getDouble("water_depth"),
                        rs.getDouble("length"),
                        rs.getDouble("width"),
                        rs.getInt("max_capacity")
                );
                areas.add(area);
            }
        }
        return areas;
    }

    public PoolArea selectById(int id) throws SQLException {
        PoolArea area = null;
        String sql = "SELECT * FROM Pool_Area WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                area = new PoolArea(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getString("type"),
                        rs.getDouble("water_depth"),
                        rs.getDouble("length"),
                        rs.getDouble("width"),
                        rs.getInt("max_capacity")
                );
            }
        }
        return area;
    }

    public void update(PoolArea area) throws SQLException {
        String sql = "UPDATE Pool_Area SET name=?, description=?, type=?, water_depth=?, length=?, width=?, max_capacity=? WHERE id=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, area.getName());
            ps.setString(2, area.getDescription());
            ps.setString(3, area.getType());
            ps.setDouble(4, area.getWaterDepth());
            ps.setDouble(5, area.getLength());
            ps.setDouble(6, area.getWidth());
            ps.setInt(7, area.getMaxCapacity());
            ps.setInt(8, area.getId());
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM Pool_Area WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public boolean isInUse(int id) throws SQLException {
        String sqlLog = "SELECT COUNT(*) FROM Maintenance_Log WHERE pool_area_id = ?";
        String sqlRequest = "SELECT COUNT(*) FROM Maintenance_Requests WHERE pool_area_id = ?";

        try (Connection conn = getConnection()) {
            try (PreparedStatement psLog = conn.prepareStatement(sqlLog)) {
                psLog.setInt(1, id);
                try (ResultSet rs = psLog.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        return true;
                    }
                }
            }
            try (PreparedStatement psRequest = conn.prepareStatement(sqlRequest)) {
                psRequest.setInt(1, id);
                try (ResultSet rs = psRequest.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    public List<PoolArea> searchPoolAreas(String keyword) throws SQLException {
        List<PoolArea> areas = new ArrayList<>();
        // Sửa câu truy vấn SQL: chỉ tìm kiếm theo cột 'name'
        String sql = "SELECT * FROM Pool_Area WHERE name LIKE ?";
        String searchPattern = "%" + keyword + "%";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, searchPattern); // Chỉ cần set 1 tham số
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PoolArea area = new PoolArea(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getString("type"),
                        rs.getDouble("water_depth"),
                        rs.getDouble("length"),
                        rs.getDouble("width"),
                        rs.getInt("max_capacity")
                );
                areas.add(area);
            }
        }
        return areas;
    }


    public List<MaintenanceLog> getMaintenanceLogsForPool(int poolAreaId) throws SQLException {
        List<MaintenanceLog> logs = new ArrayList<>();
        String sql = "SELECT ml.id, ml.schedule_id, ml.staff_id, ml.pool_area_id, " +
                "ml.maintenance_date, ml.note, ml.status, ml.log_time, ml.updated_at, " +
                "u.full_name AS staff_name, " +
                "ms.title AS schedule_title, ms.frequency, " +
                "pa.name AS area_name " +
                "FROM Maintenance_Log ml " +
                "JOIN Users u ON ml.staff_id = u.id " +
                "JOIN Maintenance_Schedule ms ON ml.schedule_id = ms.id " +
                "JOIN Pool_Area pa ON ml.pool_area_id = pa.id " +
                "WHERE ml.pool_area_id = ? ORDER BY ml.maintenance_date DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, poolAreaId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                MaintenanceLog log = new MaintenanceLog();
                log.setId(rs.getInt("id"));
                log.setScheduleId(rs.getInt("schedule_id"));
                log.setStaffId(rs.getInt("staff_id"));
                log.setPoolAreaId(rs.getInt("pool_area_id"));
                log.setMaintenanceDate(rs.getDate("maintenance_date"));
                log.setStatus(rs.getString("status"));
                log.setNote(rs.getString("note"));
                // if you need log_time, ensure it's in your MaintenanceLog model and uncomment this line
                // log.setLogTime(rs.getTimestamp("log_time"));
                log.setUpdatedAt(rs.getTimestamp("updated_at"));

                log.setStaffName(rs.getString("staff_name"));
                log.setScheduleTitle(rs.getString("schedule_title"));
                log.setFrequency(rs.getString("frequency"));
                log.setAreaName(rs.getString("area_name"));

                logs.add(log);
            }
        }
        return logs;
    }

    public List<MaintenanceRequest> getMaintenanceRequestsForPool(int poolAreaId) throws SQLException {
        List<MaintenanceRequest> requests = new ArrayList<>();
        String sql = "SELECT mr.id, mr.description, mr.status, mr.created_by, mr.staff_id, " +
                "mr.pool_area_id, mr.created_at, mr.updated_at, " +
                "u.full_name AS created_by_name, " +
                "pa.name AS pool_area_name " +
                "FROM Maintenance_Requests mr " +
                "JOIN Users u ON mr.created_by = u.id " +
                "JOIN Pool_Area pa ON mr.pool_area_id = pa.id " +
                "WHERE mr.pool_area_id = ? ORDER BY mr.created_at DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, poolAreaId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                MaintenanceRequest request = new MaintenanceRequest();
                request.setId(rs.getInt("id"));
                request.setDescription(rs.getString("description"));
                request.setStatus(rs.getString("status"));
                request.setCreatedBy(rs.getInt("created_by"));

                int staffId = rs.getInt("staff_id");
                if (rs.wasNull()) {
                    request.setStaffId(0);
                } else {
                    request.setStaffId(staffId);
                }

                request.setPoolAreaId(rs.getInt("pool_area_id"));
                request.setCreatedAt(rs.getTimestamp("created_at"));
                request.setUpdatedAt(rs.getTimestamp("updated_at"));

                request.setCreatedByName(rs.getString("created_by_name"));
                request.setPoolAreaName(rs.getString("pool_area_name"));

                requests.add(request);
            }
        }
        return requests;
    }

    /**
     * KIỂM TRA TRẠNG THÁI "ĐANG BẢO TRÌ/CÓ VẤN ĐỀ" CỦA KHU VỰC BỂ BƠI.
     * Khu vực được coi là có vấn đề nếu:
     * 1. Có yêu cầu bảo trì đang mở ('Open'). HOẶC
     * 2. Có công việc bảo trì được giao đang chờ xử lý ('Pending') HOẶC
     * 3. Có công việc bảo trì định kỳ bị bỏ lỡ gần đây ('Missed' trong 7 ngày gần nhất).
     *
     * @param poolAreaId ID của khu vực bể bơi
     * @return true nếu khu vực đang bảo trì hoặc có vấn đề, false nếu hoạt động bình thường
     * @throws SQLException
     */
    public boolean isUnderMaintenanceOrProblem(int poolAreaId) throws SQLException {
        String sql = "SELECT " +
                "  (SELECT COUNT(*) FROM Maintenance_Requests WHERE pool_area_id = ? AND status = 'Open') AS open_requests_count, " +
                "  (SELECT COUNT(*) FROM Maintenance_Log WHERE pool_area_id = ? AND status = 'Pending') AS pending_logs_count, " +
                "  (SELECT COUNT(*) FROM Maintenance_Log WHERE pool_area_id = ? AND status = 'Missed' AND maintenance_date >= CURDATE() - INTERVAL 7 DAY) AS missed_logs_count";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, poolAreaId);
            ps.setInt(2, poolAreaId);
            ps.setInt(3, poolAreaId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int openRequests = rs.getInt("open_requests_count");
                    int pendingLogs = rs.getInt("pending_logs_count");
                    int missedLogs = rs.getInt("missed_logs_count");

                    // Nếu có bất kỳ yêu cầu mở, log chờ xử lý, hoặc log bị bỏ lỡ gần đây
                    if (openRequests > 0 || pendingLogs > 0 || missedLogs > 0) {
                        return true;
                    }
                }
            }
        }
        return false;
    }
}
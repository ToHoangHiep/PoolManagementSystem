package dal;

import model.MaintenanceLog;
import model.MaintenanceRequest;
import model.MaintenanceSchedule;
import model.PoolArea;
import model.User;
import utils.DBConnect; // Assuming DBConnect handles connection pooling

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger; // Import Logger

public class MaintenanceDAO {

    // Logger for detailed error messages, good practice for production
    private static final Logger LOGGER = Logger.getLogger(MaintenanceDAO.class.getName());

    // Method to get a connection from DBConnect (assuming DBConnect is robust)
    private Connection getConnection() throws SQLException {
        // DBConnect.getConnection() should provide a new connection from the pool each time it's called
        return DBConnect.getConnection();
    }

    /** Lấy tất cả template lịch bảo trì */
    public List<MaintenanceSchedule> getAllTemplates() {
        List<MaintenanceSchedule> list = new ArrayList<>();
        // Lấy thêm created_at và tên người tạo
        String sql = "SELECT ms.id, ms.title, ms.description, ms.frequency, ms.scheduled_time, ms.created_at, ms.created_by, u.full_name AS creator_name " +
                "FROM Maintenance_Schedule ms JOIN Users u ON ms.created_by = u.id";
        try (Connection conn = getConnection(); // Mở kết nối mới cho mỗi lần gọi
             PreparedStatement p = conn.prepareStatement(sql);
             ResultSet rs = p.executeQuery()) {
            while (rs.next()) {
                MaintenanceSchedule m = new MaintenanceSchedule();
                m.setId(rs.getInt("id"));
                m.setTitle(rs.getString("title"));
                m.setDescription(rs.getString("description"));
                m.setFrequency(rs.getString("frequency"));
                m.setScheduledTime(rs.getTime("scheduled_time"));
                m.setCreatedAt(rs.getTimestamp("created_at")); // Đã sửa: dùng getTimestamp
                m.setCreatedBy(rs.getInt("created_by"));
                m.setCreatedByName(rs.getString("creator_name")); // Đã sửa
                list.add(m);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all maintenance templates", e);
        }
        return list;
    }

    /** Lấy log công việc của staff trong tuần hiện tại */
    public List<MaintenanceLog> getLogsForWeek(int scheduleId, int staffId) {
        String sql =
                "SELECT ml.id, ml.schedule_id, ml.pool_area_id, ml.maintenance_date, ml.status, ml.note, " +
                        " pa.name AS area, ms.title " +
                        "FROM Maintenance_Log ml " +
                        " JOIN Maintenance_Schedule ms ON ml.schedule_id=ms.id " +
                        " JOIN Pool_Area pa ON ml.pool_area_id=pa.id " + // Đã sửa: Pool_Area
                        "WHERE ml.schedule_id=? AND ml.staff_id=? " +
                        " AND ml.maintenance_date BETWEEN " +
                        "    DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY) " +
                        "    AND DATE_ADD(CURDATE(), INTERVAL (6-WEEKDAY(CURDATE())) DAY)";
        List<MaintenanceLog> list = new ArrayList<>();
        try (Connection conn = getConnection(); // Mở kết nối mới
             PreparedStatement p = conn.prepareStatement(sql)) {
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
            LOGGER.log(Level.SEVERE, "Error getting logs for week for scheduleId: " + scheduleId + ", staffId: " + staffId, e);
        }
        return list;
    }

    /** Lấy log đã gán cho staff */
    /** Lấy log đã gán cho staff */
    public List<MaintenanceLog> getLogsByStaff(int staffId) {
        String sql =
                "SELECT ml.id, ml.schedule_id, ml.pool_area_id, ml.maintenance_date, ml.status, ml.note, " +
                        " pa.name AS area, ms.title, ms.frequency " + // <-- THÊM ms.frequency vào SELECT
                        "FROM Maintenance_Log ml " +
                        " JOIN Maintenance_Schedule ms ON ml.schedule_id=ms.id " +
                        " JOIN Pool_Area pa ON ml.pool_area_id=pa.id " +
                        "WHERE ml.staff_id = ? ORDER BY ml.maintenance_date ASC, ml.status DESC";
        // Gọi lại phương thức executeLogQuery, nhưng chúng ta cần chỉnh sửa nó để lấy frequency.
        // Tốt hơn là tạo một phương thức riêng biệt hoặc điều chỉnh executeLogQuery để linh hoạt hơn.
        // Tạm thời, tôi sẽ chỉnh sửa trực tiếp logic trong phương thức này.
        List<MaintenanceLog> list = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement p = conn.prepareStatement(sql)) {
            p.setInt(1, staffId);
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
                    log.setFrequency(rs.getString("frequency")); // <-- THÊM dòng này để set frequency
                    list.add(log);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting logs by staff ID: " + staffId, e);
        }
        return list;
    }




    /** Lấy tất cả PoolArea */
    public List<PoolArea> getAllPoolAreas() {
        List<PoolArea> list = new ArrayList<>();
        String sql = "SELECT id, name, description FROM Pool_Area"; // Đã sửa: Pool_Area
        try (Connection conn = getConnection(); // Mở kết nối mới
             PreparedStatement p = conn.prepareStatement(sql);
             ResultSet rs = p.executeQuery()) {
            while (rs.next()) {
                PoolArea a = new PoolArea();
                a.setId(rs.getInt("id"));
                a.setName(rs.getString("name"));
                a.setDescription(rs.getString("description"));
                list.add(a);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all pool areas", e);
        }
        return list;
    }

    /** Lấy danh sách staff */
    public List<User> getAllStaff() {
        List<User> list = new ArrayList<>();
        // Quay về query gốc của bạn, đảm bảo lấy đúng role_id cho Staff
        String sql = "SELECT id, full_name, email, phone_number FROM Users WHERE role_id = 5"; // Sử dụng role_id của bạn
        try (Connection conn = getConnection(); // Mở kết nối mới
             PreparedStatement p = conn.prepareStatement(sql);
             ResultSet rs = p.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email")); // Đảm bảo cột email tồn tại trong DB
                u.setPhoneNumber(rs.getString("phone_number")); // Đảm bảo cột phone_number tồn tại trong DB
                // Nếu User model của bạn không có Role, bạn có thể bỏ dòng này:
                // u.setRole(new model.Role(0, rs.getString("role_name")));
                list.add(u);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all staff users", e);
        }
        return list;
    }

    /** Lấy schedule template theo id */
    public MaintenanceSchedule getTemplateById(int id) {
        MaintenanceSchedule t = null;
        // Lấy thêm created_at
        String sql = "SELECT id, title, description, frequency, scheduled_time, created_at, created_by " +
                "FROM Maintenance_Schedule WHERE id = ?";
        try (Connection conn = getConnection(); // Mở kết nối mới
             PreparedStatement p = conn.prepareStatement(sql)) {
            p.setInt(1, id);
            try (ResultSet rs = p.executeQuery()) {
                if (rs.next()) {
                    t = new MaintenanceSchedule();
                    t.setId(rs.getInt("id"));
                    t.setTitle(rs.getString("title"));
                    t.setDescription(rs.getString("description"));
                    t.setFrequency(rs.getString("frequency"));
                    t.setScheduledTime(rs.getTime("scheduled_time"));
                    t.setCreatedAt(rs.getTimestamp("created_at")); // Đã sửa: dùng getTimestamp
                    t.setCreatedBy(rs.getInt("created_by"));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting maintenance template by ID: " + id, e);
        }
        return t;
    }

    /** Tạo schedule */
    public int insertSchedule(String title, String description, String frequency, Time scheduledTime, int createdBy) {
        int id = -1;
        String sql = "INSERT INTO Maintenance_Schedule(title, description, frequency, scheduled_time, created_by) VALUES(?,?,?,?,?)";
        try (Connection conn = getConnection(); // Mở kết nối mới
             PreparedStatement p = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            p.setString(1, title);
            p.setString(2, description);
            p.setString(3, frequency);
            p.setTime(4, scheduledTime);
            p.setInt(5, createdBy);
            p.executeUpdate();
            try (ResultSet keys = p.getGeneratedKeys()) {
                if (keys.next()) {
                    id = keys.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting new maintenance schedule", e);
        }
        return id;
    }

    /** Ghi log Missed mặc định */
    public void insertLog(int scheduleId, int staffId, int poolAreaId) {
        insertLogOnDate(scheduleId, staffId, poolAreaId, null, "Missed");
    }

    /** Ghi log với ngày cụ thể và status */
    public void insertLogOnDate(int scheduleId, int staffId, int poolAreaId, Date date, String status) {
        String sql = "INSERT INTO Maintenance_Log(schedule_id, staff_id, pool_area_id, maintenance_date, status, note) VALUES(?,?,?,?,?,?)";
        try (Connection conn = getConnection(); // Mở kết nối mới
             PreparedStatement p = conn.prepareStatement(sql)) {
            p.setInt(1, scheduleId);
            p.setInt(2, staffId);
            p.setInt(3, poolAreaId);
            if (date != null) {
                p.setDate(4, date);
            } else {
                p.setDate(4, Date.valueOf(LocalDate.now())); // Sử dụng LocalDate.now()
            }
            p.setString(5, status);
            p.setString(6, ""); // Default empty note
            p.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting maintenance log on date for scheduleId: " + scheduleId, e);
        }
    }

    /** Cập nhật log đã hoàn thành */
    public void updateLogStatus(int logId, String status) {
        String sql = "UPDATE Maintenance_Log SET status=?, note=?, updated_at=NOW() WHERE id=?"; // Đã thêm updated_at
        try (Connection conn = getConnection(); // Mở kết nối mới
             PreparedStatement p = conn.prepareStatement(sql)) {
            p.setString(1, status);
            p.setString(2, "Hoàn thành"); // Example note for 'Done' status
            p.setInt(3, logId);
            p.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating maintenance log status for logId: " + logId, e);
        }
    }

    /** Tạo request mới */
    public void insertRequest(MaintenanceRequest request) {
        String sql = "INSERT INTO Maintenance_Requests(description, status, created_by, created_at, pool_area_id) VALUES(?, ?, ?, NOW(), ?)";
        try (Connection conn = getConnection(); // Mở kết nối mới
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, request.getDescription());
            ps.setString(2, "Open"); // Explicitly set status to 'Open'
            ps.setInt(3, request.getCreatedBy());
            ps.setInt(4, request.getPoolAreaId());
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting new maintenance request", e);
        }
    }

    /** Lấy tất cả request mở */
    public List<MaintenanceRequest> getAllRequests() {
        // SQL này lấy tất cả các request có status 'Open'
        String sql = "SELECT mr.*, u.full_name AS createdByName, pa.name AS poolAreaName FROM Maintenance_Requests mr " +
                "JOIN Users u ON mr.created_by=u.id JOIN Pool_Area pa ON mr.pool_area_id=pa.id WHERE mr.status='Open' ORDER BY mr.created_at DESC"; // Đã sửa: Pool_Area
        List<MaintenanceRequest> list = new ArrayList<>();
        try (Connection conn = getConnection(); // Mở kết nối mới
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                MaintenanceRequest r = mapRequest(rs);
                list.add(r);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all open maintenance requests", e);
        }
        return list;
    }

    private MaintenanceRequest mapRequest(ResultSet rs) throws SQLException {
        MaintenanceRequest r = new MaintenanceRequest();
        r.setId(rs.getInt("id"));
        r.setDescription(rs.getString("description"));
        r.setStatus(rs.getString("status"));
        r.setCreatedBy(rs.getInt("created_by"));
        try { // Safe check for staff_id column
            if (rs.getObject("staff_id") != null) {
                r.setStaffId(rs.getInt("staff_id"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.FINER, "Column staff_id not found or was null for request ID: " + rs.getInt("id"));
        }
        r.setPoolAreaId(rs.getInt("pool_area_id"));
        r.setCreatedAt(rs.getTimestamp("created_at"));
        r.setUpdatedAt(rs.getTimestamp("updated_at"));
        r.setCreatedByName(rs.getString("createdByName"));
        r.setPoolAreaName(rs.getString("poolAreaName"));
        return r;
    }

    /**
     * THÊM MỚI: Tạo một MaintenanceSchedule tạm thời (Unscheduled) cho các yêu cầu bảo trì được chấp nhận.
     * Trả về ID của schedule vừa tạo.
     */
    public int createAdHocMaintenanceSchedule(String title, String description, int createdBy) throws SQLException {
        // frequency là 'Unscheduled' để phân biệt với lịch định kỳ
        String sql = "INSERT INTO Maintenance_Schedule(title, description, frequency, scheduled_time, created_by) VALUES(?, ?, 'Unscheduled', CURTIME(), ?)"; // Đã sửa 'AdHoc' -> 'Unscheduled'
        int newScheduleId = -1;
        try (Connection conn = getConnection(); // Mở kết nối mới
             PreparedStatement p = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            p.setString(1, title);
            p.setString(2, description);
            p.setInt(3, createdBy);
            p.executeUpdate();
            try (ResultSet keys = p.getGeneratedKeys()) {
                if (keys.next()) {
                    newScheduleId = keys.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Failed to create unscheduled maintenance schedule", e);
            throw e; // Re-throw to allow transaction management in acceptRequest
        }
        return newScheduleId;
    }

    /**
     * Admin chấp nhận yêu cầu và gán cho staff.
     * Logic mới: CHUYỂN YÊU CẦU THÀNH MAINTENANCE_LOG.
     * THAY ĐỔI HOÀN TOÀN LOGIC CỦA acceptRequest
     */
    public void acceptRequest(int requestId, int staffId) throws SQLException {
        Connection conn = null; // Declare conn outside try for finally block
        try {
            conn = getConnection(); // Mở kết nối mới
            conn.setAutoCommit(false); // Start transaction

            // 1. Lấy thông tin chi tiết của MaintenanceRequest
            String getRequestSql = "SELECT description, pool_area_id, created_by FROM Maintenance_Requests WHERE id = ?";
            String requestDescription;
            int poolAreaId;
            int createdByUserId; // Người gửi request

            try (PreparedStatement psGetReq = conn.prepareStatement(getRequestSql)) {
                psGetReq.setInt(1, requestId);
                try (ResultSet rs = psGetReq.executeQuery()) {
                    if (rs.next()) {
                        requestDescription = rs.getString("description");
                        poolAreaId = rs.getInt("pool_area_id");
                        createdByUserId = rs.getInt("created_by");
                    } else {
                        LOGGER.log(Level.WARNING, "Request with ID {0} not found. Rolling back transaction.", requestId);
                        conn.rollback();
                        return; // Request does not exist
                    }
                }
            }

            // 2. Tạo một MaintenanceSchedule tạm thời (Unscheduled) cho công việc này
            String scheduleTitle = "Yêu cầu: " + requestDescription;
            int newScheduleId = createAdHocMaintenanceSchedule(scheduleTitle, requestDescription, staffId); // createdBy là staffId được giao

            if (newScheduleId == -1) {
                LOGGER.log(Level.SEVERE, "Failed to create unscheduled maintenance schedule for request ID {0}. Rolling back transaction.", requestId);
                conn.rollback();
                return;
            }

            // 3. Tạo một MaintenanceLog mới dựa trên schedule tạm thời
            LocalDate today = LocalDate.now();
            String logStatus = "Pending"; // Default to Pending when assigned

            String insertLogSql = "INSERT INTO Maintenance_Log(schedule_id, staff_id, pool_area_id, maintenance_date, status, note) VALUES(?,?,?,?,?,?)";
            try (PreparedStatement psLog = conn.prepareStatement(insertLogSql)) {
                psLog.setInt(1, newScheduleId);
                psLog.setInt(2, staffId); // Assigned staff
                psLog.setInt(3, poolAreaId);
                psLog.setDate(4, Date.valueOf(today));
                psLog.setString(5, logStatus);
                psLog.setString(6, "Được phân công từ yêu cầu #" + requestId);
                psLog.executeUpdate();
            }

            // 4. Cập nhật trạng thái của MaintenanceRequest thành 'Transferred'
            String updateRequestSql = "UPDATE Maintenance_Requests SET status='Transferred', staff_id=?, updated_at=NOW() WHERE id=?";
            try (PreparedStatement psUpdateReq = conn.prepareStatement(updateRequestSql)) {
                psUpdateReq.setInt(1, staffId);
                psUpdateReq.setInt(2, requestId);
                psUpdateReq.executeUpdate();
            }

            // 5. Gửi thông báo cho người dùng đã tạo request rằng yêu cầu đã được xử lý và chuyển thành công việc
            createNotification(createdByUserId,
                    "Yêu cầu bảo trì #" + requestId + " của bạn đã được CHẤP NHẬN và chuyển thành công việc.",
                    "MaintenanceRequestStatus", requestId);

            // Gửi thông báo cho staff được giao việc
            createNotification(staffId,
                    "Bạn đã được giao một công việc mới: " + scheduleTitle + " từ yêu cầu #" + requestId + ".",
                    "MaintenanceAssignment", newScheduleId);

            conn.commit(); // Commit transaction
            LOGGER.log(Level.INFO, "Request ID {0} accepted and transferred successfully to staff ID {1}", new Object[]{requestId, staffId});

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback on error
                    LOGGER.log(Level.WARNING, "Transaction rolled back for acceptRequest due to error.", e);
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error during rollback for acceptRequest", ex);
                }
            }
            LOGGER.log(Level.SEVERE, "Failed to accept request ID: " + requestId, e);
            throw e; // Re-throw for servlet to catch
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // Reset auto-commit
                    conn.close(); // Close the connection
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error closing connection in acceptRequest finally block", e);
                }
            }
        }
    }

    /**
     * Admin từ chối yêu cầu.
     */
    public void rejectRequest(int requestId) throws SQLException {
        Connection conn = null; // Declare conn outside try for finally block
        try {
            conn = getConnection(); // Mở kết nối mới
            conn.setAutoCommit(false); // Start transaction

            // Get creator's ID for notification
            String getCreatorSql = "SELECT created_by FROM Maintenance_Requests WHERE id = ?";
            int createdByUserId = -1;
            try (PreparedStatement psCreator = conn.prepareStatement(getCreatorSql)) {
                psCreator.setInt(1, requestId);
                try (ResultSet rs = psCreator.executeQuery()) {
                    if (rs.next()) {
                        createdByUserId = rs.getInt("created_by");
                    } else {
                        LOGGER.log(Level.WARNING, "Request with ID {0} not found for rejection. Rolling back.", requestId);
                        conn.rollback();
                        return;
                    }
                }
            }

            String sql = "UPDATE Maintenance_Requests SET status='Rejected', updated_at=NOW() WHERE id=?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, requestId);
                ps.executeUpdate();
            }

            // Create notification for the staff who sent the request
            createNotification(createdByUserId,
                    "Yêu cầu bảo trì #" + requestId + " của bạn đã bị TỪ CHỐI.",
                    "MaintenanceRequestStatus", requestId);

            conn.commit(); // Commit transaction
            LOGGER.log(Level.INFO, "Request ID {0} rejected successfully.", requestId);

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback on error
                    LOGGER.log(Level.WARNING, "Transaction rolled back for rejectRequest due to error.", e);
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error during rollback for rejectRequest", ex);
                }
            }
            LOGGER.log(Level.SEVERE, "Failed to reject request ID: " + requestId, e);
            throw e; // Re-throw for servlet to catch
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // Reset auto-commit
                    conn.close(); // Close the connection
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error closing connection in rejectRequest finally block", e);
                }
            }
        }
    }


    private List<MaintenanceRequest> executeRequestQuery(String sql, int id) {
        List<MaintenanceRequest> list = new ArrayList<>();
        try (Connection conn = getConnection(); // Mở kết nối mới
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRequest(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error executing request query with ID: " + id + ", SQL: " + sql, e);
        }
        return list;
    }


    /**
     * Lấy tên nhân viên theo ID.
     * Dùng để đưa vào nội dung thông báo.
     */
    public String getStaffNameById(int staffId) {
        String staffName = "Không xác định";
        String sql = "SELECT full_name FROM Users WHERE id = ?";
        try (Connection conn = getConnection(); // Mở kết nối mới
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, staffId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    staffName = rs.getString("full_name");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting staff name by ID: " + staffId, e);
        }
        return staffName;
    }

    /**
     * Tạo một thông báo trong database.
     */
    public void createNotification(int userId, String message, String notificationType, int relatedId) {
        String sql = "INSERT INTO Notifications(user_id, message, notification_type, related_id, is_read, created_at) VALUES(?, ?, ?, ?, FALSE, NOW())";
        try (Connection conn = getConnection(); // Mở kết nối mới
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, message);
            ps.setString(3, notificationType);
            ps.setInt(4, relatedId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating notification for userId: " + userId, e);
        }
    }

    /**
     * Lấy tất cả thông báo chưa đọc của một người dùng.
     */
    public List<String> getUnreadNotifications(int userId) {
        List<String> notifications = new ArrayList<>();
        String sql = "SELECT message FROM Notifications WHERE user_id = ? AND is_read = FALSE ORDER BY created_at DESC";
        try (Connection conn = getConnection(); // Mở kết nối mới
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    notifications.add(rs.getString("message"));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting unread notifications for userId: " + userId, e);
        }
        return notifications;
    }

    /**
     * Đánh dấu tất cả thông báo chưa đọc của một người dùng là đã đọc.
     */
    public void markNotificationsAsRead(int userId) {
        String sql = "UPDATE Notifications SET is_read = TRUE WHERE user_id = ? AND is_read = FALSE";
        try (Connection conn = getConnection(); // Mở kết nối mới
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error marking notifications as read for userId: " + userId, e);
        }
    }


    public List<MaintenanceRequest> getMySentRequests(int createdByStaffId) {
        List<MaintenanceRequest> list = new ArrayList<>();
        // Truy vấn này sẽ lấy tất cả request do staff tạo,
        // bao gồm cả Open (chưa xử lý), Transferred (đã chấp nhận), Rejected (đã từ chối).
        // Chúng ta sẽ xử lý status "Processing" ở tầng hiển thị hoặc trong Business Logic (Servlet).
        String sql = "SELECT mr.*, u.full_name AS createdByName, pa.name AS poolAreaName FROM Maintenance_Requests mr " +
                "JOIN Users u ON mr.created_by=u.id JOIN Pool_Area pa ON mr.pool_area_id=pa.id " +
                "WHERE mr.created_by=? ORDER BY mr.created_at DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, createdByStaffId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MaintenanceRequest r = mapRequest(rs);
                    // Đây là nơi chúng ta điều chỉnh hiển thị trạng thái cho Staff:
                    // Nếu status trong DB là 'Open', hiển thị là 'Processing'
                    if ("Open".equals(r.getStatus())) {
                        r.setStatus("Processing");
                    }
                    list.add(r);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting sent requests for staff ID: " + createdByStaffId, e);
        }
        return list;
    }
    public List<MaintenanceLog> getAllMaintenanceLogs() {
        List<MaintenanceLog> list = new ArrayList<>();
        String sql = "SELECT ml.id, ml.schedule_id, ml.pool_area_id, ml.maintenance_date, ml.status, ml.note, " +
                "ml.staff_id, ml.updated_at, " + // Thêm ml.updated_at
                "u.full_name AS staff_name, " + // Lấy tên nhân viên từ bảng Users
                "pa.name AS area_name, " + // Lấy tên khu vực từ bảng Pool_Area
                "ms.title AS schedule_title, ms.frequency " + // Lấy tiêu đề và tần suất từ Maintenance_Schedule
                "FROM Maintenance_Log ml " +
                "JOIN Maintenance_Schedule ms ON ml.schedule_id = ms.id " +
                "JOIN Pool_Area pa ON ml.pool_area_id = pa.id " +
                "JOIN Users u ON ml.staff_id = u.id " + // JOIN với bảng Users
                "ORDER BY ml.maintenance_date DESC, ml.updated_at DESC"; // Sắp xếp để dễ nhìn

        try (Connection conn = getConnection();
             PreparedStatement p = conn.prepareStatement(sql);
             ResultSet rs = p.executeQuery()) {
            while (rs.next()) {
                MaintenanceLog log = new MaintenanceLog();
                log.setId(rs.getInt("id"));
                log.setScheduleId(rs.getInt("schedule_id"));
                log.setPoolAreaId(rs.getInt("pool_area_id"));

                // Sử dụng rs.getDate() cho maintenance_date nếu đó là kiểu DATE trong DB
                // và gán cho java.util.Date
                log.setMaintenanceDate(new java.util.Date(rs.getDate("maintenance_date").getTime()));

                log.setStatus(rs.getString("status"));
                log.setNote(rs.getString("note"));
                log.setStaffId(rs.getInt("staff_id"));

                // Set các giá trị từ JOIN
                log.setStaffName(rs.getString("staff_name")); // Set tên nhân viên
                log.setAreaName(rs.getString("area_name")); // Set tên khu vực
                log.setScheduleTitle(rs.getString("schedule_title")); // Set tiêu đề lịch trình
                log.setFrequency(rs.getString("frequency")); // Set tần suất

                // Set updated_at
                log.setUpdatedAt(rs.getTimestamp("updated_at")); // Lấy timestamp

                list.add(log);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all maintenance logs for admin/manager", e);
        }
        return list;
    }

}
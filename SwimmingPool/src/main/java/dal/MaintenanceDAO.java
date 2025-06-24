package dal;

import model.MaintenanceSchedule;
import utils.DBConnect;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MaintenanceDAO {

    // Lấy tất cả lịch bảo trì với phân trang
    public List<MaintenanceSchedule> getSchedulesWithPagination(int pageNo, int pageSize) {
        List<MaintenanceSchedule> list = new ArrayList<>();

        // Tính toán OFFSET để lấy bản ghi bắt đầu
        int offset = (pageNo - 1) * pageSize;

        String sql = """
                    SELECT ms.*, 
                           staff.full_name AS staff_name, 
                           creator.full_name AS creator_name
                    FROM Maintenance_Schedule ms
                    LEFT JOIN Users staff ON ms.assigned_staff_id = staff.id
                    LEFT JOIN Users creator ON ms.created_by = creator.id
                    ORDER BY ms.scheduled_time
                    LIMIT ? OFFSET ?
                """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Thiết lập các tham số trong câu truy vấn
            ps.setInt(1, pageSize); // Số bản ghi mỗi trang
            ps.setInt(2, offset);   // Vị trí bắt đầu của trang (OFFSET)

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MaintenanceSchedule m = new MaintenanceSchedule();
                    m.setId(rs.getInt("id"));
                    m.setTitle(rs.getString("title"));
                    m.setDescription(rs.getString("description"));
                    m.setFrequency(rs.getString("frequency"));
                    m.setAssignedStaffId(rs.getInt("assigned_staff_id"));
                    m.setScheduledTime(rs.getTime("scheduled_time"));
                    m.setStatus(rs.getString("status"));
                    m.setCreatedBy(rs.getInt("created_by"));
                    m.setCreatedAt(rs.getTimestamp("created_at"));
                    m.setAssignedStaffName(rs.getString("staff_name"));
                    m.setCreatedByName(rs.getString("creator_name"));

                    list.add(m);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int getTotalSchedules(String status, String title) {
        int totalRecords = 0;

        String sql = "SELECT COUNT(*) FROM Maintenance_Schedule ms " +
                "LEFT JOIN Users staff ON ms.assigned_staff_id = staff.id " +
                "LEFT JOIN Users creator ON ms.created_by = creator.id " +
                "WHERE ms.status LIKE ? AND ms.title LIKE ? ";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status != null ? "%" + status + "%" : "%");
            ps.setString(2, title != null ? "%" + title + "%" : "%");

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    totalRecords = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return totalRecords;
    }




    // Phương thức insert lịch bảo trì
    public void insertSchedule(MaintenanceSchedule schedule) {
        String sql = """
                INSERT INTO Maintenance_Schedule (title, description, frequency, assigned_staff_id, scheduled_time, status, created_by, created_at)
                VALUES (?, ?, ?, ?, ?, ?, ?, NOW())
                """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, schedule.getTitle());
            ps.setString(2, schedule.getDescription());
            ps.setString(3, schedule.getFrequency());
            ps.setInt(4, schedule.getAssignedStaffId());
            ps.setTime(5, schedule.getScheduledTime());
            ps.setString(6, schedule.getStatus());
            ps.setInt(7, schedule.getCreatedBy());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        // Tạo đối tượng MaintenanceSchedule và gán giá trị cho các trường
        MaintenanceSchedule schedule = new MaintenanceSchedule();
        schedule.setTitle("Bảo trì bể bơi");
        schedule.setDescription("Bảo trì hàng tháng cho bể bơi chính");
        schedule.setFrequency("Monthly");
        schedule.setAssignedStaffId(2);  // Ví dụ nhân viên có id = 2
        schedule.setScheduledTime(Time.valueOf("10:00:00"));  // Thời gian bảo trì là 10:00 AM
        schedule.setStatus("Scheduled");
        schedule.setCreatedBy(1);  // Ví dụ người tạo có id = 1 (Admin)

        // Tạo đối tượng MaintenanceDAO và gọi phương thức insertSchedule
        MaintenanceDAO maintenanceDAO = new MaintenanceDAO();
        maintenanceDAO.insertSchedule(schedule);

        System.out.println("Đã thêm lịch bảo trì mới vào cơ sở dữ liệu.");
    }

    // Phương thức xóa lịch bảo trì
    public void deleteSchedule(int scheduleId) {
        String sql = "DELETE FROM Maintenance_Schedule WHERE id = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Thiết lập tham số
            ps.setInt(1, scheduleId);

            // Thực thi câu lệnh xóa
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateSchedule(MaintenanceSchedule schedule) {
        String sql = """
                UPDATE Maintenance_Schedule
                SET title = ?, description = ?, frequency = ?, assigned_staff_id = ?, scheduled_time = ?, status = ?
                WHERE id = ?
                """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, schedule.getTitle());
            ps.setString(2, schedule.getDescription());
            ps.setString(3, schedule.getFrequency());
            ps.setInt(4, schedule.getAssignedStaffId());
            ps.setTime(5, schedule.getScheduledTime());
            ps.setString(6, schedule.getStatus());
            ps.setInt(7, schedule.getId());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public MaintenanceSchedule getScheduleById(int id) {
        MaintenanceSchedule schedule = null;
        String sql = "SELECT * FROM Maintenance_Schedule WHERE id = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    schedule = new MaintenanceSchedule();
                    schedule.setId(rs.getInt("id"));
                    schedule.setTitle(rs.getString("title"));
                    schedule.setDescription(rs.getString("description"));
                    schedule.setFrequency(rs.getString("frequency"));
                    schedule.setAssignedStaffId(rs.getInt("assigned_staff_id"));
                    schedule.setScheduledTime(rs.getTime("scheduled_time"));
                    schedule.setStatus(rs.getString("status"));
                    schedule.setCreatedBy(rs.getInt("created_by"));
                    schedule.setCreatedAt(rs.getTimestamp("created_at"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return schedule;
    }

    public List<MaintenanceSchedule> getSchedulesWithSearch(String status, String title, Integer staffId, int pageNo, int pageSize) {
        List<MaintenanceSchedule> list = new ArrayList<>();
        int offset = (pageNo - 1) * pageSize;

        String sql = "SELECT ms.*, staff.full_name AS staff_name, creator.full_name AS creator_name " +
                "FROM Maintenance_Schedule ms " +
                "LEFT JOIN Users staff ON ms.assigned_staff_id = staff.id " +
                "LEFT JOIN Users creator ON ms.created_by = creator.id " +
                "WHERE ms.status LIKE ? " +
                "AND ms.title LIKE ? ";

        if (staffId != null) {
            sql += "AND ms.assigned_staff_id = ? ";
        }

        sql += "ORDER BY ms.scheduled_time LIMIT ? OFFSET ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status != null ? "%" + status + "%" : "%");
            ps.setString(2, title != null ? "%" + title + "%" : "%");

            if (staffId != null) {
                ps.setInt(3, staffId);
                ps.setInt(4, pageSize);
                ps.setInt(5, offset);
            } else {
                ps.setInt(3, pageSize);
                ps.setInt(4, offset);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MaintenanceSchedule m = new MaintenanceSchedule();
                    m.setId(rs.getInt("id"));
                    m.setTitle(rs.getString("title"));
                    m.setDescription(rs.getString("description"));
                    m.setFrequency(rs.getString("frequency"));
                    m.setAssignedStaffId(rs.getInt("assigned_staff_id"));
                    m.setScheduledTime(rs.getTime("scheduled_time"));
                    m.setStatus(rs.getString("status"));
                    m.setCreatedBy(rs.getInt("created_by"));
                    m.setCreatedAt(rs.getTimestamp("created_at"));
                    m.setAssignedStaffName(rs.getString("staff_name"));
                    m.setCreatedByName(rs.getString("creator_name"));

                    list.add(m);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }


    // Lấy danh sách lịch bảo trì theo trạng thái và tiêu đề với phân trang
    public List<MaintenanceSchedule> getSchedulesWithSearch(String status, String title, int pageNo, int pageSize) {
        List<MaintenanceSchedule> list = new ArrayList<>();
        int offset = (pageNo - 1) * pageSize;

        // Tạo câu truy vấn để lọc theo trạng thái và tiêu đề
        String sql = """
                SELECT ms.*, 
                       staff.full_name AS staff_name, 
                       creator.full_name AS creator_name
                FROM Maintenance_Schedule ms
                LEFT JOIN Users staff ON ms.assigned_staff_id = staff.id
                LEFT JOIN Users creator ON ms.created_by = creator.id
                WHERE ms.status LIKE ? AND ms.title LIKE ?
                ORDER BY ms.scheduled_time
                LIMIT ? OFFSET ?
            """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Thiết lập các tham số cho câu truy vấn
            ps.setString(1, status != null ? "%" + status + "%" : "%");  // Tìm kiếm theo trạng thái
            ps.setString(2, title != null ? "%" + title + "%" : "%");    // Tìm kiếm theo tiêu đề
            ps.setInt(3, pageSize); // Số bản ghi mỗi trang
            ps.setInt(4, offset);   // Vị trí bắt đầu của trang (OFFSET)

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MaintenanceSchedule m = new MaintenanceSchedule();
                    m.setId(rs.getInt("id"));
                    m.setTitle(rs.getString("title"));
                    m.setDescription(rs.getString("description"));
                    m.setFrequency(rs.getString("frequency"));
                    m.setAssignedStaffId(rs.getInt("assigned_staff_id"));
                    m.setScheduledTime(rs.getTime("scheduled_time"));
                    m.setStatus(rs.getString("status"));
                    m.setCreatedBy(rs.getInt("created_by"));
                    m.setCreatedAt(rs.getTimestamp("created_at"));
                    m.setAssignedStaffName(rs.getString("staff_name"));
                    m.setCreatedByName(rs.getString("creator_name"));

                    list.add(m);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<MaintenanceSchedule> getSchedulesForStaff(int staffId) {
        List<MaintenanceSchedule> list = new ArrayList<>();

        String sql = "SELECT ms.*, " +
                "staff.full_name AS staff_name, " +
                "creator.full_name AS creator_name " +
                "FROM Maintenance_Schedule ms " +
                "LEFT JOIN Users staff ON ms.assigned_staff_id = staff.id " +
                "LEFT JOIN Users creator ON ms.created_by = creator.id " +
                "WHERE ms.assigned_staff_id = ? " +
                "ORDER BY ms.scheduled_time";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, staffId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MaintenanceSchedule m = new MaintenanceSchedule();
                    m.setId(rs.getInt("id"));
                    m.setTitle(rs.getString("title"));
                    m.setDescription(rs.getString("description"));
                    m.setFrequency(rs.getString("frequency"));
                    m.setAssignedStaffId(rs.getInt("assigned_staff_id"));
                    m.setScheduledTime(rs.getTime("scheduled_time"));
                    m.setStatus(rs.getString("status"));
                    m.setCreatedBy(rs.getInt("created_by"));
                    m.setCreatedAt(rs.getTimestamp("created_at"));
                    m.setAssignedStaffName(rs.getString("staff_name"));
                    m.setCreatedByName(rs.getString("creator_name"));

                    list.add(m);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }


    public boolean updateScheduleStatus(int scheduleId, String newStatus) {
        String sql = "UPDATE Maintenance_Schedule SET status = ? WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, scheduleId);
            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }


    public List<MaintenanceSchedule> getSchedulesForStaff(int staffId, int pageNo, int pageSize) {
        List<MaintenanceSchedule> list = new ArrayList<>();
        int offset = (pageNo - 1) * pageSize;

        String sql = """
            SELECT ms.*, 
                   staff.full_name AS staff_name, 
                   creator.full_name AS creator_name
            FROM Maintenance_Schedule ms
            LEFT JOIN Users staff ON ms.assigned_staff_id = staff.id
            LEFT JOIN Users creator ON ms.created_by = creator.id
            WHERE ms.assigned_staff_id = ?  -- Lọc theo staffId
            ORDER BY ms.scheduled_time
            LIMIT ? OFFSET ?
        """;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, staffId);  // Lọc theo staffId
            ps.setInt(2, pageSize); // Số bản ghi mỗi trang
            ps.setInt(3, offset);   // Vị trí bắt đầu của trang (OFFSET)

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MaintenanceSchedule m = new MaintenanceSchedule();
                    m.setId(rs.getInt("id"));
                    m.setTitle(rs.getString("title"));
                    m.setDescription(rs.getString("description"));
                    m.setFrequency(rs.getString("frequency"));
                    m.setAssignedStaffId(rs.getInt("assigned_staff_id"));
                    m.setScheduledTime(rs.getTime("scheduled_time"));
                    m.setStatus(rs.getString("status"));
                    m.setCreatedBy(rs.getInt("created_by"));
                    m.setCreatedAt(rs.getTimestamp("created_at"));
                    m.setAssignedStaffName(rs.getString("staff_name"));
                    m.setCreatedByName(rs.getString("creator_name"));

                    list.add(m);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }






}

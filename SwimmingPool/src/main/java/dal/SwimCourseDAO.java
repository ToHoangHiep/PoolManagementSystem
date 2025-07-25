package dal;

import model.SwimCourse;
import utils.DBConnect;

import java.sql.*;
import java.util.*;

public class SwimCourseDAO {
    private Connection conn;

    public SwimCourseDAO(Connection conn) {
        this.conn = conn;
    }

    // Lấy tất cả khóa học
    public List<SwimCourse> getAllCourses() throws SQLException {
        List<SwimCourse> list = new ArrayList<>();
        String sql = "SELECT * FROM Courses";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                SwimCourse course = new SwimCourse();
                course.setId(rs.getInt("id"));
                course.setName(rs.getString("name"));
                course.setDescription(rs.getString("description"));
                course.setPrice(rs.getDouble("price"));
                course.setDuration(rs.getInt("duration"));
                course.setEstimatedSessionTime(rs.getString("estimated_session_time"));
                course.setStudentDescription(rs.getString("student_description"));
                course.setScheduleDescription(rs.getString("schedule_description"));
                course.setStatus(rs.getString("status"));
                list.add(course);
            }
        }
        return list;
    }

    // Thêm khóa học mới
    public void addCourse(SwimCourse course) throws SQLException {
        String sql = "INSERT INTO Courses (name, description, price, duration, estimated_session_time, student_description, schedule_description, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, course.getName());
            ps.setString(2, course.getDescription());
            ps.setDouble(3, course.getPrice());
            ps.setInt(4, course.getDuration());
            ps.setString(5, course.getEstimatedSessionTime());
            ps.setString(6, course.getStudentDescription());
            ps.setString(7, course.getScheduleDescription());
            ps.setString(8, course.getStatus());
            ps.executeUpdate();
        }
    }

    // Lấy thông tin khóa học theo ID
    public SwimCourse getCourseById(int id) throws SQLException {
        String sql = "SELECT * FROM Courses WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                SwimCourse course = new SwimCourse();
                course.setId(rs.getInt("id"));
                course.setName(rs.getString("name"));
                course.setDescription(rs.getString("description"));
                course.setPrice(rs.getDouble("price"));
                course.setDuration(rs.getInt("duration"));
                course.setEstimatedSessionTime(rs.getString("estimated_session_time"));
                course.setStudentDescription(rs.getString("student_description"));
                course.setScheduleDescription(rs.getString("schedule_description"));
                course.setStatus(rs.getString("status"));
                return course;
            }
        }
        return null;
    }

    // Cập nhật khóa học
    public void updateCourse(SwimCourse course) throws SQLException {
        String sql = "UPDATE Courses SET name=?, description=?, price=?, duration=?, estimated_session_time=?, student_description=?, schedule_description=?, status=? WHERE id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, course.getName());
            ps.setString(2, course.getDescription());
            ps.setDouble(3, course.getPrice());
            ps.setInt(4, course.getDuration());
            ps.setString(5, course.getEstimatedSessionTime());
            ps.setString(6, course.getStudentDescription());
            ps.setString(7, course.getScheduleDescription());
            ps.setString(8, course.getStatus());
            ps.setInt(9, course.getId());
            ps.executeUpdate();
        }
    }

    // Xóa khóa học và các feedback liên quan
    public void deleteCourse(int courseId) throws SQLException {
        String[] queries = {
                // Chỉ xóa Feedbacks liên quan đến khóa học
                "DELETE FROM Feedbacks WHERE course_id = ?",
                // Xóa chính khóa học
                "DELETE FROM Courses WHERE id = ?"
        };

        try (Connection conn = DBConnect.getConnection()) {
            conn.setAutoCommit(false);

            try {
                for (String sql : queries) {
                    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                        stmt.setInt(1, courseId);
                        stmt.executeUpdate();
                    }
                }
                conn.commit();
            } catch (SQLException ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }
}

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

    public void deleteCourse(int courseId) throws SQLException {
        String[] queries = {
                // 1. Xóa FeedbackReplies trước (liên kết qua Feedbacks)
                "DELETE FROM FeedbackReplies WHERE feedback_id IN (SELECT id FROM Feedbacks WHERE course_id = ?)",

                // 2. Xóa Feedbacks liên quan đến Course
                "DELETE FROM Feedbacks WHERE course_id = ?",

                // 3. Xóa Blog_Comments trước (liên kết qua Blogs)
                "DELETE FROM Blog_Comments WHERE blog_id IN (SELECT id FROM Blogs WHERE course_id = ?)",

                // 4. Xóa Blogs liên quan đến Course
                "DELETE FROM Blogs WHERE course_id = ?",

                // 5. Xóa Class_Registrations liên quan đến Class trong khóa học
                "DELETE FROM Class_Registrations WHERE class_id IN (SELECT id FROM Classes WHERE course_id = ?)",

                // 6. Xóa Schedules liên quan đến Class trong khóa học
                "DELETE FROM Schedules WHERE class_id IN (SELECT id FROM Classes WHERE course_id = ?)",

                // 7. Xóa Classes thuộc Course
                "DELETE FROM Classes WHERE course_id = ?",

                // 8. Cuối cùng, xóa Course
                "DELETE FROM Courses WHERE id = ?"
        };

        try (Connection conn = DBConnect.getConnection()) {
            conn.setAutoCommit(false); // dùng transaction

            try {
                for (String sql : queries) {
                    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                        stmt.setInt(1, courseId);
                        stmt.executeUpdate();
                    }
                }

                conn.commit(); // tất cả thành công
            } catch (SQLException ex) {
                conn.rollback(); // lỗi thì rollback lại toàn bộ
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

}

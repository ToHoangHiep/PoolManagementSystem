package dal;

import model.Course;
import utils.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;


public class CourseDAO {
	public static List<Course> getAllCourses() throws SQLException {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT * FROM Courses";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)){

            ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Course course = new Course();
				course.setId(rs.getInt("id"));
				course.setName(rs.getString("name"));
				course.setDescription(rs.getString("description"));
                course.setPrice(rs.getDouble("price"));
                course.setDuration(rs.getInt("duration"));
                course.setEstimated_session_time(rs.getString("estimated_session_time"));
                course.setSchedule_description(rs.getString("schedule_description"));
                course.setStatus(rs.getString("status"));
                course.setCreated_at(rs.getDate("created_at"));
				courses.add(course);
			}
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }

        return courses;
    }

    public static Course getCourseById(int courseId) {
        String sql = "SELECT * FROM Courses WHERE id = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Course course = new Course();
                course.setId(rs.getInt("id"));
                course.setName(rs.getString("name"));
                course.setDescription(rs.getString("description"));
                course.setPrice(rs.getDouble("price"));
                course.setDuration(rs.getInt("duration"));
                course.setEstimated_session_time(rs.getString("estimated_session_time"));
                course.setSchedule_description(rs.getString("schedule_description"));
                course.setStatus(rs.getString("status"));
                course.setCreated_at(rs.getDate("created_at"));
                return course;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;

    }

    public static boolean createCourse(Course course) {
        String sql = "INSERT INTO Courses (name, description, price, duration, estimated_session_time, schedule_description, status) VALUES (?,?,?,?,?,?,?) ";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, course.getName());
            ps.setString(2, course.getDescription());
            ps.setDouble(3, course.getPrice());
            ps.setInt(4, course.getDuration());
            ps.setString(5, course.getEstimated_session_time());
            ps.setString(6, course.getSchedule_description());
            ps.setString(7, course.getStatus());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static boolean updateCourse(Course course) {
        String sql = "UPDATE Courses SET name = ?, description = ?, price = ?, duration = ?, estimated_session_time = ?, schedule_description = ?, status = ? WHERE id = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, course.getName());
            ps.setString(2, course.getDescription());
            ps.setDouble(3, course.getPrice());
            ps.setInt(4, course.getDuration());
            ps.setString(5, course.getEstimated_session_time());
            ps.setString(6, course.getSchedule_description());
            ps.setString(7, course.getStatus());
            ps.setInt(8, course.getId());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean deleteCourse(int courseId) {
        String sql = "DELETE FROM Courses WHERE id = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, courseId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Trong file: dal/CourseDAO.java

    public boolean updateCourseStatus(int courseId, String status) {
        String sql = "UPDATE Courses SET status = ? WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, courseId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static Map<Integer, Integer> getProcessedCourseRegistrationCounts() throws SQLException {
        Map<Integer, Integer> counts = new HashMap<>();
        // This query counts how many times each course_id appears in the course_form table
        // but only for rows where the form has been processed.
        String sql = "SELECT course_id, COUNT(*) as registration_count FROM course_form WHERE has_processed = true GROUP BY course_id";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                counts.put(rs.getInt("course_id"), rs.getInt("registration_count"));
            }
        }
        return counts;
    }
}
package dal;

import model.SwimCourse;
import java.sql.*;
import java.util.*;

public class SwimCourseDAO {
    private Connection conn;

    public SwimCourseDAO(Connection conn) {
        this.conn = conn;
    }

    public List<SwimCourse> getAllCoursesWithCoach() throws SQLException {
        List<SwimCourse> list = new ArrayList<>();
        String sql = "SELECT c.*, co.full_name FROM Courses c LEFT JOIN Coaches co ON c.coach_id = co.id";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                SwimCourse course = new SwimCourse();
                course.setId(rs.getInt("id"));
                course.setName(rs.getString("name"));
                course.setDescription(rs.getString("description"));
                course.setPrice(rs.getDouble("price"));
                course.setDuration(rs.getInt("duration"));
                course.setStatus(rs.getString("status"));
                course.setCoachId(rs.getInt("coach_id"));
                course.setCoachName(rs.getString("full_name"));
                list.add(course);
            }
        }
        return list;
    }

    public void addCourse(SwimCourse course) throws SQLException {
        String sql = "INSERT INTO Courses(name, description, price, duration, coach_id, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, course.getName());
            ps.setString(2, course.getDescription());
            ps.setDouble(3, course.getPrice());
            ps.setInt(4, course.getDuration());
            ps.setInt(5, course.getCoachId());
            ps.setString(6, course.getStatus());
            ps.executeUpdate();
        }
    }
    // dal/SwimCourseDAO.java
    public SwimCourse getCourseById(int id) throws SQLException {
        String sql = "SELECT c.*, co.full_name AS coach_name FROM Courses c LEFT JOIN Coaches co ON c.coach_id = co.id WHERE c.id = ?";
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
                course.setCoachId(rs.getInt("coach_id"));
                course.setStatus(rs.getString("status"));
                course.setCoachName(rs.getString("coach_name"));
                return course;
            }
        }
        return null;
    }

    public void updateCourse(SwimCourse course) throws SQLException {
        String sql = "UPDATE Courses SET name=?, description=?, price=?, duration=?, coach_id=? WHERE id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, course.getName());
            ps.setString(2, course.getDescription());
            ps.setDouble(3, course.getPrice());
            ps.setInt(4, course.getDuration());
            ps.setInt(5, course.getCoachId());
            ps.setInt(6, course.getId());
            ps.executeUpdate();
        }
    }
    public void deleteCourse(int id) throws SQLException {
        String sql = "DELETE FROM Courses WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

}

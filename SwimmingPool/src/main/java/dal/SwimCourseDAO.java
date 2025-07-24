package dal;

import model.SwimCourse;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SwimCourseDAO {
    private final Connection conn;

    public SwimCourseDAO(Connection conn) {
        this.conn = conn;
    }

    public List<SwimCourse> getCourses(String status, String keyword) throws SQLException {
        List<SwimCourse> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT c.*, u.full_name AS coach_name FROM Courses c " +
                        "LEFT JOIN Users u ON c.coach_id = u.id WHERE 1=1"
        );

        if (status != null && !status.isEmpty()) {
            sql.append(" AND c.status = ?");
        }
        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND c.name LIKE ?");
        }

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int index = 1;
            if (status != null && !status.isEmpty()) {
                ps.setString(index++, status);
            }
            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SwimCourse sc = new SwimCourse();
                sc.setId(rs.getInt("id"));
                sc.setName(rs.getString("name"));
                sc.setDescription(rs.getString("description"));
                sc.setPrice(rs.getDouble("price"));
                sc.setDuration(rs.getInt("duration"));
                sc.setStatus(rs.getString("status"));
                sc.setCoach(rs.getString("coach_name"));
                list.add(sc);
            }
        }

        return list;
    }

    public List<SwimCourse> getCoursesByCoach(int coachId, String status, String keyword) throws SQLException {
        List<SwimCourse> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Courses WHERE coach_id = ?");

        if (status != null && !status.isEmpty()) {
            sql.append(" AND status = ?");
        }
        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND name LIKE ?");
        }

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int index = 1;
            ps.setInt(index++, coachId);
            if (status != null && !status.isEmpty()) {
                ps.setString(index++, status);
            }
            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SwimCourse sc = new SwimCourse();
                sc.setId(rs.getInt("id"));
                sc.setName(rs.getString("name"));
                sc.setDescription(rs.getString("description"));
                sc.setPrice(rs.getDouble("price"));
                sc.setDuration(rs.getInt("duration"));
                sc.setStatus(rs.getString("status"));
                list.add(sc);
            }
        }
        return list;
    }


    public SwimCourse getById(int id) throws SQLException {
        String sql = "SELECT * FROM Courses WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                SwimCourse sc = new SwimCourse();
                sc.setId(id);
                sc.setName(rs.getString("name"));
                sc.setDescription(rs.getString("description"));
                sc.setPrice(rs.getDouble("price"));
                sc.setDuration(rs.getInt("duration"));
                sc.setStatus(rs.getString("status"));
                return sc;
            }
        }
        return null;
    }

    public void addCourse(SwimCourse sc) throws SQLException {
        String sql = "INSERT INTO Courses(name, description, price, duration, status, coach_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, sc.getName());
            ps.setString(2, sc.getDescription());
            ps.setDouble(3, sc.getPrice());
            ps.setInt(4, sc.getDuration());
            ps.setString(5, "Inactive"); // default status
            ps.setInt(6, sc.getCoachId());
            ps.executeUpdate();
        }
    }

    public void updateCourse(SwimCourse sc) throws SQLException {
        String sql = "UPDATE Courses SET name = ?, description = ?, price = ?, duration = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, sc.getName());
            ps.setString(2, sc.getDescription());
            ps.setDouble(3, sc.getPrice());
            ps.setInt(4, sc.getDuration());
            ps.setInt(5, sc.getId());
            ps.executeUpdate();
        }
    }

    public void deleteCourse(int id) throws SQLException {
        String deleteCourse = "DELETE FROM Courses WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(deleteCourse)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public void toggleStatus(int id) throws SQLException {
        String sql = "UPDATE Courses SET status = CASE " +
                "WHEN status = 'Active' THEN 'Inactive' " +
                "ELSE 'Active' END WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    // SwimCourseDAO.java
    public boolean hasRegistrations(int courseId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM course_registrations WHERE course_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public List<SwimCourse> getAllCoursesByCoachRequest(String status, String keyword) throws SQLException {
        List<SwimCourse> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT c.id, c.name, c.description, c.price, c.duration, c.status, u.full_name AS coach_name " +
                        "FROM Courses c LEFT JOIN Users u ON c.coach_id = u.id WHERE 1=1 "
        );

        if (status != null && !status.isEmpty()) {
            sql.append(" AND c.status = ? ");
        }

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND c.name LIKE ? ");
        }

        sql.append(" ORDER BY c.id DESC");

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int index = 1;
            if (status != null && !status.isEmpty()) {
                ps.setString(index++, status);
            }
            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(index, "%" + keyword + "%");
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SwimCourse c = new SwimCourse();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setDescription(rs.getString("description"));
                c.setPrice(rs.getDouble("price"));
                c.setDuration(rs.getInt("duration"));
                c.setStatus(rs.getString("status"));
                c.setCoach(rs.getString("coach_name")); // nếu bạn có thuộc tính này trong model
                list.add(c);
            }
        }

        return list;
    }
}
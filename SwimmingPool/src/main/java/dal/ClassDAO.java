package dal;

import model.Class;
import java.sql.*;
import java.util.*;

public class ClassDAO {
    private Connection conn;

    public ClassDAO(Connection conn) {
        this.conn = conn;
    }

    public List<Class> getAll() throws SQLException {
        List<Class> list = new ArrayList<>();
        String sql = "SELECT * FROM classes";
        PreparedStatement st = conn.prepareStatement(sql);
        ResultSet rs = st.executeQuery();
        while (rs.next()) {
            Class c = new Class();
            c.setId(rs.getInt("id"));
            c.setName(rs.getString("name"));
            c.setCourseId(rs.getInt("course_id"));
            c.setCoachId(rs.getInt("coach_id"));
            c.setStatus(rs.getString("status"));
            c.setNote(rs.getString("note"));
            list.add(c);
        }
        return list;
    }

    public Class getById(int id) throws SQLException {
        String sql = "SELECT * FROM classes WHERE id = ?";
        PreparedStatement st = conn.prepareStatement(sql);
        st.setInt(1, id);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            Class c = new Class();
            c.setId(id);
            c.setName(rs.getString("name"));
            c.setCourseId(rs.getInt("course_id"));
            c.setCoachId(rs.getInt("coach_id"));
            c.setStatus(rs.getString("status"));
            c.setNote(rs.getString("note"));
            return c;
        }
        return null;
    }

    public void insert(Class c) throws SQLException {
        String sql = "INSERT INTO classes (name, course_id, coach_id, status, note) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement st = conn.prepareStatement(sql);
        st.setString(1, c.getName());
        st.setInt(2, c.getCourseId());
        st.setInt(3, c.getCoachId());
        st.setString(4, c.getStatus());
        st.setString(5, c.getNote());
        st.executeUpdate();
    }

    public void update(Class c) throws SQLException {
        String sql = "UPDATE classes SET name=?, course_id=?, coach_id=?, status=?, note=? WHERE id=?";
        PreparedStatement st = conn.prepareStatement(sql);
        st.setString(1, c.getName());
        st.setInt(2, c.getCourseId());
        st.setInt(3, c.getCoachId());
        st.setString(4, c.getStatus());
        st.setString(5, c.getNote());
        st.setInt(6, c.getId());
        st.executeUpdate();
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM classes WHERE id = ?";
        PreparedStatement st = conn.prepareStatement(sql);
        st.setInt(1, id);
        st.executeUpdate();
    }
}
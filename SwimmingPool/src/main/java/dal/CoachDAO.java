package dal;

import model.Coach;
import java.sql.*;
import java.util.*;

public class CoachDAO {
    private Connection conn;
    public CoachDAO(Connection conn) {
        this.conn = conn;
    }

    public List<Coach> getAll() throws SQLException {
        List<Coach> list = new ArrayList<>();
        String sql = "SELECT * FROM Coaches";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Coach c = new Coach();
                c.setId(rs.getInt("id"));
                c.setFullName(rs.getString("full_name"));
                c.setEmail(rs.getString("email"));
                c.setPhone(rs.getString("phone_number"));
                c.setGender(rs.getString("gender"));
                c.setBio(rs.getString("bio"));
                c.setProfilePicture(rs.getString("profile_picture"));
                list.add(c);
            }
        }
        return list;
    }

    public Coach getById(int id) throws SQLException {
        String sql = "SELECT * FROM Coaches WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Coach c = new Coach();
                    c.setId(rs.getInt("id"));
                    c.setFullName(rs.getString("full_name"));
                    c.setEmail(rs.getString("email"));
                    c.setPhone(rs.getString("phone_number"));
                    c.setGender(rs.getString("gender"));
                    c.setBio(rs.getString("bio"));
                    c.setProfilePicture(rs.getString("profile_picture"));
                    return c;
                }
            }
        }
        return null;
    }

    public void insert(Coach c) throws SQLException {
        String sql = "INSERT INTO Coaches (full_name, email, phone_number, gender, bio, profile_picture) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getFullName());
            ps.setString(2, c.getEmail());
            ps.setString(3, c.getPhone());
            ps.setString(4, c.getGender());
            ps.setString(5, c.getBio());
            ps.setString(6, c.getProfilePicture());
            ps.executeUpdate();
        }
    }

    public void update(Coach c) throws SQLException {
        String sql = "UPDATE Coaches SET full_name = ?, email = ?, phone_number = ?, gender = ?, bio = ?, profile_picture = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getFullName());
            ps.setString(2, c.getEmail());
            ps.setString(3, c.getPhone());
            ps.setString(4, c.getGender());
            ps.setString(5, c.getBio());
            ps.setString(6, c.getProfilePicture());
            ps.setInt(7, c.getId());
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM Coaches WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
    public boolean isCoachUsed(int coachId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Classes WHERE coach_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, coachId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }
}

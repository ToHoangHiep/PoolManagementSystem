package dal;

import model.Coach;
import utils.DBConnect;

import java.sql.*;
import java.util.*;

public class CoachDAO {
    // Lấy danh sách tất cả huấn luyện viên
    public static List<Coach> getAllCoaches() throws SQLException {
        List<Coach> list = new ArrayList<>();
        String sql = "SELECT * FROM Coaches";
        try (Connection conn = DBConnect.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Coach coach = new Coach();
                coach.setId(rs.getInt("id"));
                coach.setFullName(rs.getString("full_name"));
                coach.setEmail(rs.getString("email"));
                coach.setPhone(rs.getString("phone_number"));
                coach.setGender(rs.getString("gender"));
                coach.setBio(rs.getString("bio"));
                coach.setProfilePicture(rs.getString("profile_picture"));
                coach.setActive(rs.getBoolean("active"));
                list.add(coach);
            }
        }
        return list;
    }

    // Lấy huấn luyện viên theo ID
    public static Coach getCoachById(int id) throws SQLException {
        String sql = "SELECT * FROM Coaches WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Coach coach = new Coach();
                    coach.setId(rs.getInt("id"));
                    coach.setFullName(rs.getString("full_name"));
                    coach.setEmail(rs.getString("email"));
                    coach.setPhone(rs.getString("phone_number"));
                    coach.setGender(rs.getString("gender"));
                    coach.setBio(rs.getString("bio"));
                    coach.setProfilePicture(rs.getString("profile_picture"));
                    coach.setActive(rs.getBoolean("active"));
                    return coach;
                }
            }
        }
        return null;
    }

    // Thêm huấn luyện viên mới
    public static void insertCoach(Coach coach) throws SQLException {
        String sql = "INSERT INTO Coaches (full_name, email, phone_number, gender, bio, profile_picture, active) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, coach.getFullName());
            ps.setString(2, coach.getEmail());
            ps.setString(3, coach.getPhone());
            ps.setString(4, coach.getGender());
            ps.setString(5, coach.getBio());
            ps.setString(6, coach.getProfilePicture());
            ps.setBoolean(7, coach.isActive());
            ps.executeUpdate();
        }
    }

    // Cập nhật huấn luyện viên
    public static void updateCoach(Coach coach) throws SQLException {
        String sql = "UPDATE Coaches SET full_name=?, email=?, phone_number=?, gender=?, bio=?, profile_picture=?, active=? WHERE id=?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, coach.getFullName());
            ps.setString(2, coach.getEmail());
            ps.setString(3, coach.getPhone());
            ps.setString(4, coach.getGender());
            ps.setString(5, coach.getBio());
            ps.setString(6, coach.getProfilePicture());
            ps.setBoolean(7, coach.isActive());
            ps.setInt(8, coach.getId());
            ps.executeUpdate();
        }
    }

    // Xóa huấn luyện viên
    public static void deleteCoach(int id) throws SQLException {
        String sql = "DELETE FROM Coaches WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
}

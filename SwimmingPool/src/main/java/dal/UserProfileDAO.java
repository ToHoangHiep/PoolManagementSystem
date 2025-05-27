package dal;

import model.UserProfile;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserProfileDAO {

    private Connection conn;

    public UserProfileDAO(Connection conn) {
        this.conn = conn;
    }

    public UserProfile getUserById(int userId) {
        String sql = "SELECT id, full_name, phone_number, gender, address, dob, email, profile_picture FROM users WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new UserProfile(
                        rs.getInt("id"),
                        rs.getString("full_name"),
                        rs.getString("phone_number"),
                        rs.getString("gender"),
                        rs.getString("address"),
                        rs.getDate("dob"),
                        rs.getString("email"),
                        rs.getString("profile_picture")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    public void updateUser(UserProfile user) throws SQLException {
        String sql = "UPDATE users SET full_name = ?, phone_number = ?, gender = ?, address = ?, dob = ?, email = ?, profile_picture = ? WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getPhoneNumber());
            stmt.setString(3, user.getGender());
            stmt.setString(4, user.getAddress());
            stmt.setDate(5, user.getDob());
            stmt.setString(6, user.getEmail());
            stmt.setString(7, user.getProfile_picture());
            stmt.setInt(8, user.getUserId());

            stmt.executeUpdate();
        }
    }

}

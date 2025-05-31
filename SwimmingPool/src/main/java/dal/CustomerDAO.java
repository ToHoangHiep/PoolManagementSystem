package dal;

import model.Customer;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CustomerDAO {

    private Connection conn;

    public CustomerDAO(Connection conn) {
        this.conn = conn;
    }

    public Customer getCustomerById(int userId) {
        String sql = "SELECT id, full_name, phone_number, dob, gender, address, email, profile_picture FROM users WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Customer(
                        rs.getInt("id"),
                        rs.getString("full_name"),
                        rs.getString("phone_number"),
                        rs.getDate("dob"),
                        rs.getString("gender"),
                        rs.getString("address"),
                        rs.getString("profile_picture"),
                        rs.getString("email")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateUser(Customer user) throws SQLException {
        String sql = "UPDATE users SET full_name = ?, phone_number = ?, dob = ?, gender = ?, address = ?, email = ?, profile_picture = ? WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getPhoneNumber());
            stmt.setDate(3, user.getDob());
            stmt.setString(4, user.getGender());
            stmt.setString(5, user.getAddress());
            stmt.setString(6, user.getEmail());
            stmt.setString(7, user.getProfilePicture());
            stmt.setInt(8, user.getUserId());
            int rows = stmt.executeUpdate();
            return rows > 0;
        }
    }
}

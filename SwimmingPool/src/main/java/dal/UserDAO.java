package dal;

import model.Role;
import model.User;
import utils.DBConnect;

import java.sql.*;

public class UserDAO {
    public static User login(String email, String password) {
        String sql = "SELECT u.*, r.name AS role_name FROM users u " +
                "JOIN roles r ON u.role_id = r.id " +
                "WHERE u.email = ? AND u.password_hash = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Role role = new Role(rs.getInt("role_id"), rs.getString("role_name"));
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setRole(role);
                return user;
            } else {
                return null; // ❗ Bắt buộc return null nếu không có tài khoản
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static boolean checkEmailExists(String email) {
        String sql = "SELECT id FROM users WHERE email = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next(); // nếu tồn tại -> true
        } catch (Exception e) {
            e.printStackTrace();
            return true; // để tránh lỗi đăng ký trùng
        }
    }

    public static boolean register(String fullName, String email, String phone, String password) {
        String sql = "INSERT INTO users (full_name, email, phone_number, password_hash, role_id) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, password); // có thể mã hóa nếu muốn
            ps.setInt(5, 4); // mặc định role_id = 4 (customer)
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


}

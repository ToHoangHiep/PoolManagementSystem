package dal;

import model.Role;
import model.User;
import utils.DBConnect;

import java.sql.*;
import java.time.LocalDate;

public class UserDAO {

    // LOGIN
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
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhoneNumber(rs.getString("phone_number"));
                user.setAddress(rs.getString("address"));
                user.setDob(rs.getDate("dob"));
                user.setGender(rs.getString("gender"));
                user.setPasswordHash(rs.getString("password_hash"));
                user.setUserStatus(rs.getString("user_status"));
                user.setRole(new Role(rs.getInt("role_id"), rs.getString("role_name")));
                return user;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    // CHECK EMAIL EXISTENCE
    public static boolean checkEmailExists(String email) {
        String sql = "SELECT id FROM users WHERE email = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
            return true; // Giả định tồn tại nếu lỗi
        }
    }

    // REGISTER
    public static boolean register(String fullName, String email, String phone, String password,
                                   String address, String dob, String gender) {
        String sql = "INSERT INTO users (full_name, email, phone_number, password_hash, " +
                "address, dob, gender, role_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            System.out.println(">>> REGISTER INPUT");
            System.out.println("Email: " + email);
            System.out.println("DOB: " + dob);
            System.out.println("Gender: " + gender);

            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, password);
            ps.setString(5, address);
            ps.setDate(6, Date.valueOf(dob));
            ps.setString(7, gender);
            ps.setInt(8, 4); // role_id = 4 (Customer)

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }



    // RESET PASSWORD
    public static boolean updatePassword(String email, String newPassword) {
        String sql = "UPDATE users SET password_hash = ? WHERE email = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newPassword);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // FIND USER BY EMAIL
    public static User findUserFromEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhoneNumber(rs.getString("phone_number"));
                user.setAddress(rs.getString("address"));
                user.setDob(rs.getDate("dob"));
                user.setGender(rs.getString("gender"));
                user.setUserStatus(rs.getString("user_status"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                user.setUpdatedAt(rs.getTimestamp("updated_at"));
                return user;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
    public static void updateStatus(String email, String status) {
        String sql = "UPDATE users SET user_status = ? WHERE email = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, email);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


}

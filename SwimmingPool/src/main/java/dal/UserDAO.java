package dal;

import model.Role;
import model.User;
import utils.DBConnect;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

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

    // LẤY DANH SÁCH USER KÈM ROLE (CHO ADMIN QUẢN LÝ)
    public static List<User> getAllUsersWithRoles() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.*, r.name AS role_name FROM users u JOIN roles r ON u.role_id = r.id";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhoneNumber(rs.getString("phone_number"));
                user.setUserStatus(rs.getString("user_status"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                user.setUpdatedAt(rs.getTimestamp("updated_at"));

                Role role = new Role(rs.getInt("role_id"), rs.getString("role_name"));
                user.setRole(role);

                list.add(user);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // CẬP NHẬT ROLE CHO USER
    public static boolean updateUserRole(int userId, int roleId) {
        String sql = "UPDATE users SET role_id = ? WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roleId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static List<User> getAllUsers(String name, String status, String roleId) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.*, r.name as role_name FROM users u " +
                "JOIN roles r ON u.role_id = r.id WHERE 1=1 ";

        if (name != null && !name.trim().isEmpty()) {
            sql += " AND u.full_name LIKE ?";
        }
        if (status != null && !status.trim().isEmpty()) {
            sql += " AND u.user_status = ?";
        }
        if (roleId != null && !roleId.trim().isEmpty()) {
            sql += " AND u.role_id = ?";
        }

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int idx = 1;
            if (name != null && !name.trim().isEmpty()) {
                ps.setString(idx++, "%" + name + "%");
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(idx++, status);
            }
            if (roleId != null && !roleId.trim().isEmpty()) {
                ps.setInt(idx++, Integer.parseInt(roleId));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
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
                user.setCreatedAt(rs.getTimestamp("created_at"));
                user.setUpdatedAt(rs.getTimestamp("updated_at"));
                user.setRole(new Role(rs.getInt("role_id"), rs.getString("role_name")));
                list.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }


    public static User getUserById(int id) {
        String sql = "SELECT u.*, r.name AS role_name FROM users u JOIN roles r ON u.role_id = r.id WHERE u.id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
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
                user.setRole(new Role(rs.getInt("role_id"), rs.getString("role_name")));
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static boolean deleteUser(int id) {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean updateUser(int userId, int roleId, String status) {
        String sql = "UPDATE users SET role_id = ?, user_status = ? WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roleId);
            ps.setString(2, status);
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public static void updateStatusById(int userId, String status) {
        String sql = "UPDATE users SET user_status = ? WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }




}

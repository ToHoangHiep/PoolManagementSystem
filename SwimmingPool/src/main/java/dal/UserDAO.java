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
            ps.setString(2, password); // So sánh trực tiếp mật khẩu plain text hoặc đã băm theo cách cũ của bạn

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
            ps.setString(4, password); // Lưu mật khẩu plain text hoặc theo cách cũ của bạn
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

            ps.setString(1, newPassword); // Cập nhật mật khẩu plain text hoặc theo cách cũ của bạn
            ps.setString(2, email);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // FIND USER BY EMAIL
    public static User findUserFromEmail(String email) {
        String sql = "SELECT u.*, r.name AS role_name FROM users u JOIN roles r ON u.role_id = r.id WHERE u.email = ?";
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
                user.setRole(new Role(rs.getInt("role_id"), rs.getString("role_name"))); // Lấy Role
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

    // getAllUsers
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
                user.setPasswordHash(rs.getString("password_hash"));
                user.setRole(new Role(rs.getInt("role_id"), rs.getString("role_name")));
                user.setCreatedAt(rs.getTimestamp("created_at")); // Lấy created_at
                user.setUpdatedAt(rs.getTimestamp("updated_at")); // Lấy updated_at
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


    public static List<User> getAllStaff() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.*, r.name AS role_name " +
                "FROM users u JOIN roles r ON u.role_id = r.id " +
                "WHERE u.role_id = 5"; // 5 là Staff

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
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
                user.setRole(new Role(rs.getInt("role_id"), rs.getString("role_name")));
                list.add(user);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    public static String getFullNameById(int userId) {
        String sql = "SELECT full_name FROM users WHERE id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("full_name");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


     // Lấy Role theo ID.

    public static Role getRoleById(int roleId) throws SQLException {
        String sql = "SELECT id, name FROM Roles WHERE id = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Role(rs.getInt("id"), rs.getString("name"));
            }
        } catch (SQLException e) {
            // In lỗi ra console để debug
            System.err.println("ERROR (UserDAO.getRoleById): " + e.getMessage());
            throw e; // Ném lại lỗi để Servlet xử lý
        }
        return null;
    }

    //Thêm User tối thiểu (chỉ email, mật khẩu, role_id, status).

    public static int insertUserMinimal(String email, String password, int roleId, String userStatus) throws SQLException {
        String sql = "INSERT INTO Users (email, password_hash, role_id, user_status) VALUES (?, ?, ?, ?)";
        int userId = -1;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, email);
            ps.setString(2, password); // Lưu mật khẩu plain text
            ps.setInt(3, roleId);
            ps.setString(4, userStatus);

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        userId = rs.getInt(1); // Lấy ID của user vừa được thêm
                        System.out.println("DEBUG (UserDAO.insertUserMinimal): User inserted with ID: " + userId);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("ERROR (UserDAO.insertUserMinimal): " + e.getMessage());
            throw e; // Ném lại lỗi để Servlet xử lý
        }
        return userId;
    }

    // Cập nhật thông tin cá nhân của User.

    public static boolean updateUserProfile(User user) throws SQLException {
        String sql = "UPDATE Users SET full_name=?, phone_number=?, address=?, dob=?, gender=?, updated_at=CURRENT_TIMESTAMP WHERE id=?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhoneNumber());
            ps.setString(3, user.getAddress());
            ps.setDate(4, new java.sql.Date(user.getDob().getTime())); // Chuyển đổi java.util.Date sang java.sql.Date
            ps.setString(5, user.getGender());
            ps.setInt(6, user.getId());
            int affectedRows = ps.executeUpdate();
            System.out.println("DEBUG (UserDAO.updateUserProfile): User ID " + user.getId() + " updated. Affected rows: " + affectedRows);
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("ERROR (UserDAO.updateUserProfile): " + e.getMessage());
            throw e; // Ném lại lỗi để Servlet xử lý
        }
    }
}

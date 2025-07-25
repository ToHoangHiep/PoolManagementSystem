package dal;

import model.Customer;
import model.Role; // Import lớp Role
import utils.DBConnect;

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
        // Cập nhật câu lệnh SQL để JOIN với bảng 'roles' và lấy thông tin vai trò
        String sql = "SELECT u.id, u.full_name, u.phone_number, u.dob, u.gender, u.address, u.email, u.profile_picture, " +
                "r.id AS role_id, r.name AS role_name " + // Lấy id và name của role
                "FROM users u " + // Tên bảng người dùng của bạn
                "JOIN roles r ON u.role_id = r.id " + // Giả sử cột khóa ngoại trong bảng 'users' là 'role_id'
                "WHERE u.id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Customer customer = new Customer(
                        rs.getInt("id"),
                        rs.getString("full_name"),
                        rs.getString("phone_number"),
                        rs.getDate("dob"),
                        rs.getString("gender"),
                        rs.getString("address"),
                        rs.getString("profile_picture"),
                        rs.getString("email")
                );
                // Tạo đối tượng Role và gán cho Customer
                Role role = new Role(rs.getInt("role_id"), rs.getString("role_name"));
                customer.setRole(role); // <-- ĐÃ THÊM: Gán đối tượng Role đã được tạo
                return customer;
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
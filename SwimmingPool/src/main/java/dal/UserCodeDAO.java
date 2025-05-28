package dal;

import model.User;
import utils.DBConnect;

import java.security.SecureRandom;
import java.sql.*;

public class UserCodeDAO {
    public static String getCode(User user) {
        String sql = "SELECT user_code FROM usercode WHERE user_id = ?";
        String code = null;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, user.getId());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                code = rs.getString("user_code");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return code; // Trả về mã nếu tìm thấy, hoặc null nếu không có
    }


    public static boolean createCode(User user) {
        String sql = "INSERT INTO usercode (user_id, user_code, created_at) VALUES (?, ?, ?) " +
                "ON DUPLICATE KEY UPDATE user_code = ?, created_at = ?";
        String code = generateCode();
        System.out.println("Code: " + code);

        Timestamp now = new Timestamp(System.currentTimeMillis());

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, user.getId());
            ps.setString(2, code);
            ps.setTimestamp(3, now);

            // Parameters for the UPDATE part
            ps.setString(4, code);
            ps.setTimestamp(5, now);
            int result = ps.executeUpdate();

            return result > 0; // Trả về true nếu tạo mã thành công
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false; // Trả về true nếu tạo mã thành công
    }

    private static String generateCode() {
        SecureRandom random = new SecureRandom();
        String chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
        StringBuilder code = new StringBuilder(8);

        // Generate 8 random characters
        for (int i = 0; i < 8; i++) {
            int randomIndex = random.nextInt(chars.length());
            char randomChar = chars.charAt(randomIndex);
            code.append(randomChar);
        }

        return code.toString();
    }

    public static boolean checkCode(User user, String code) {
        String sql = "SELECT * FROM usercode WHERE user_id = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, user.getId());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String storedCode = rs.getString("user_code");

                if (storedCode == null || storedCode.isEmpty()) {
                    return false; // Không có mã nào được lưu trữ
                }

                if (storedCode.length() != code.length()) {
                    return false; // Độ dài mã không khớp
                }

                // Check if code has expired (15 minutes)
                Timestamp createdTime = rs.getTimestamp("created_at");
                if (createdTime == null || System.currentTimeMillis() - createdTime.getTime() > 15 * 60 * 1000) {
                    return false; // Code has expired
                }

                // Kiểm tra mã có hợp lệ không
                return storedCode.equals(code);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }

        return false;
    }

    public static boolean deleteCode(User user) {
        String sql = "DELETE FROM usercode WHERE user_id = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, user.getId());
            int rowsAffected = ps.executeUpdate();

            return rowsAffected > 0; // Trả về true nếu xóa thành công
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
}

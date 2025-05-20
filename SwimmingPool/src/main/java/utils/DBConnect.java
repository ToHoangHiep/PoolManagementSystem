package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnect {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/swimming_pool_management?useSSL=false&serverTimezone=UTC";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "1234";

    /**
     * Kết nối đến MySQL và trả về đối tượng Connection
     */
    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Nạp driver MySQL
            return DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
        } catch (ClassNotFoundException e) {
            System.out.println("Không tìm thấy MySQL JDBC Driver.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("Lỗi khi kết nối MySQL.");
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Hàm main để tự kiểm tra kết nối
     */
    public static void main(String[] args) {
        Connection conn = getConnection();
        if (conn != null) {
            System.out.println("Kết nối thành công đến MySQL!");
        } else {
            System.out.println("Kết nối thất bại!");
        }
    }
}

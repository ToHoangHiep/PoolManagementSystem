package controller;

import dal.UserDAO;
import dal.StaffInitialSetupDAO; // Import StaffInitialSetupDAO
import model.User;
import model.StaffInitialSetup; // Import StaffInitialSetup

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet; // Cần annotation này nếu chưa có
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException; // Import SQLException

@WebServlet("/login") // Đảm bảo annotation này tồn tại và đúng
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO; // Khai báo instance của UserDAO
    private StaffInitialSetupDAO staffSetupDAO; // Khai báo instance của StaffInitialSetupDAO

    @Override
    public void init() throws ServletException {
        super.init(); // Gọi init của lớp cha
        userDAO = new UserDAO(); // Khởi tạo UserDAO
        staffSetupDAO = new StaffInitialSetupDAO(); // Khởi tạo StaffInitialSetupDAO
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String errorMessage = null; // Biến để lưu thông báo lỗi

        System.out.println("DEBUG (LoginServlet): Attempting login for email = " + email);

        // Kiểm tra input rỗng
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            errorMessage = "Vui lòng nhập đầy đủ Email và Mật khẩu.";
            System.out.println("DEBUG (LoginServlet): Missing email or password.");
        } else {
            try {
                // Gọi DAO để kiểm tra đăng nhập
                User user = UserDAO.login(email, password); // UserDAO.login đã được sửa để băm mật khẩu

                if (user != null) {
                    // Kiểm tra trạng thái tài khoản
                    String status = user.getUserStatus();
                    if (!"Active".equalsIgnoreCase(status)) {
                        errorMessage = "Tài khoản chưa được kích hoạt hoặc đã bị khóa. Vui lòng kiểm tra email để xác minh.";
                        System.out.println("DEBUG (LoginServlet): User " + email + " is not Active. Status: " + status);
                    } else {
                        // Lưu user vào session
                        HttpSession session = request.getSession();
                        session.setAttribute("user", user);
                        System.out.println("DEBUG (LoginServlet): Login successful for user: " + user.getEmail() + ", Role: " + user.getRole().getName());

                        // Phân luồng theo vai trò
                        int roleId = user.getRole().getId();

                        if (roleId == 5) { // Nếu là Staff
                            // Kiểm tra trạng thái hoàn thiện hồ sơ của Staff
                            StaffInitialSetup setup = staffSetupDAO.getStaffInitialSetupByUserId(user.getId());
                            if (setup != null && !setup.isSetupComplete()) {
                                System.out.println("DEBUG (LoginServlet): Staff " + user.getEmail() + " needs to complete profile setup. Redirecting to staff-profile-setup.jsp.");
                                response.sendRedirect("staff-profile-setup.jsp");
                                return; // Dừng xử lý
                            }
                        }

                        // Chuyển hướng dựa trên vai trò
                        if (roleId == 1 || roleId == 2) { // Admin hoặc Manager
                            response.sendRedirect("admin_dashboard.jsp"); // Giả định admin_dashboard.jsp là trang chung cho Admin/Manager
                        } else if (roleId == 4) { // Customer
                            response.sendRedirect("home.jsp"); // Giả định home.jsp là trang chủ khách hàng
                        } else if (roleId == 5) { // Staff (đã xử lý trường hợp setup ở trên)
                            response.sendRedirect("staff_dashboard.jsp");
                        } else {
                            errorMessage = "Vai trò không xác định. Vui lòng liên hệ quản trị viên.";
                            System.err.println("ERROR (LoginServlet): Unknown role ID for user " + user.getEmail() + ": " + roleId);
                        }
                    }
                } else {
                    errorMessage = "Sai tài khoản hoặc mật khẩu.";
                    System.out.println("DEBUG (LoginServlet): Login failed for email: " + email + " - Invalid credentials.");
                }
            } catch (SQLException e) {
                errorMessage = "Lỗi cơ sở dữ liệu trong quá trình đăng nhập: " + e.getMessage();
                System.err.println("ERROR (LoginServlet): SQLException during login: " + e.getMessage());
                e.printStackTrace();
            } catch (Exception e) {
                errorMessage = "Đã xảy ra lỗi không mong muốn trong quá trình đăng nhập: " + e.getMessage();
                System.err.println("ERROR (LoginServlet): Unexpected error during login: " + e.getMessage());
                e.printStackTrace();
            }
        }

        // Nếu có lỗi, đặt errorMessage vào request và forward về trang login
        if (errorMessage != null) {
            request.setAttribute("error", errorMessage);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    // GET: chuyển về login.jsp
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}
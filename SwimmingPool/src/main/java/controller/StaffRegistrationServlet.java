package controller;

import dal.UserDAO;
import dal.StaffInitialSetupDAO;
import model.User;
import model.Role;
import utils.EmailUtils; // Import EmailUtils
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/staff-registration")
public class StaffRegistrationServlet extends HttpServlet {

    private UserDAO userDAO;
    private StaffInitialSetupDAO staffSetupDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
        staffSetupDAO = new StaffInitialSetupDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        // Kiểm tra quyền: Chỉ Admin (role_id = 1) hoặc Manager (role_id = 2) mới được truy cập
        if (currentUser == null || currentUser.getRole() == null ||
                (currentUser.getRole().getId() != 1 && currentUser.getRole().getId() != 2)) {
            System.out.println("DEBUG (StaffRegistrationServlet): Access denied for user ID " + (currentUser != null ? currentUser.getId() : "null") + ". Redirecting to error.jsp.");
            response.sendRedirect("error.jsp"); // Hoặc trang báo lỗi quyền
            return;
        }

        request.getRequestDispatcher("register-staff.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        // Kiểm tra quyền lại lần nữa cho POST request
        if (currentUser == null || currentUser.getRole() == null ||
                (currentUser.getRole().getId() != 1 && currentUser.getRole().getId() != 2)) {
            System.out.println("DEBUG (StaffRegistrationServlet): POST Access denied for user ID " + (currentUser != null ? currentUser.getId() : "null") + ". Redirecting to error.jsp.");
            response.sendRedirect("error.jsp");
            return;
        }

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        String errorMessage = null;

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty() || confirmPassword == null || confirmPassword.trim().isEmpty()) {
            errorMessage = "Vui lòng điền đầy đủ email và mật khẩu.";
        } else if (!password.equals(confirmPassword)) {
            errorMessage = "Mật khẩu và xác nhận mật khẩu không khớp.";
        } else {
            try {
                // Transaction 1: Kiểm tra email đã tồn tại chưa
                if (UserDAO.checkEmailExists(email)) {
                    errorMessage = "Email này đã được sử dụng. Vui lòng chọn email khác.";
                } else {
                    // Role ID 5 là Staff (theo database schema bạn cung cấp)
                    Role staffRole = userDAO.getRoleById(5);
                    if (staffRole == null) {
                        errorMessage = "Không tìm thấy vai trò 'Staff' trong hệ thống. Vui lòng kiểm tra database.";
                        System.err.println("ERROR (StaffRegistrationServlet): Role 'Staff' (ID 5) not found in database.");
                    } else {
                        // Transaction 2: Chèn user mới với thông tin tối thiểu
                        int newUserId = UserDAO.insertUserMinimal(email, password, staffRole.getId(), "Active");

                        if (newUserId != -1) {
                            // Transaction 3: Thêm bản ghi vào StaffInitialSetup
                            staffSetupDAO.insertStaffInitialSetup(newUserId);

                            // ---- BẮT ĐẦU PHẦN TÍCH HỢP GỬI EMAIL ----
                            String subject = "Thông tin tài khoản Nhân viên của bạn";
                            // Lấy URL cơ sở của ứng dụng
                            String baseUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
                            String loginUrl = baseUrl + "/login";

                            String emailBody = "Chào bạn,\n\n"
                                    + "Một tài khoản nhân viên đã được tạo cho bạn trong hệ thống quản lý bể bơi của chúng tôi.\n"
                                    + "Dưới đây là thông tin đăng nhập của bạn:\n\n"
                                    + "Email: " + email + "\n"
                                    + "Mật khẩu: " + password + "\n\n"
                                    + "Vì lý do bảo mật, bạn **phải đổi mật khẩu** khi đăng nhập lần đầu tiên.\n"
                                    + "Vui lòng truy cập hệ thống tại: " + loginUrl + "\n\n"
                                    + "Trân trọng,\n"
                                    + "Hệ thống quản lý bể bơi.";

                            try {
                                EmailUtils.sendEmail(email, subject, emailBody);
                                System.out.println("DEBUG (StaffRegistrationServlet): Email sent successfully to " + email);
                            } catch (Exception emailEx) {
                                System.err.println("ERROR (StaffRegistrationServlet): Failed to send email to " + email + " - " + emailEx.getMessage());

                            }


                            System.out.println("DEBUG (StaffRegistrationServlet): New staff account created successfully for email: " + email + ", User ID: " + newUserId);
                            session.setAttribute("successMessage", "Đăng ký tài khoản nhân viên thành công cho email: " + email + ". Thông tin đã được gửi đến email này.");
                            response.sendRedirect("staff-registration");
                            return;
                        } else {
                            errorMessage = "Không thể tạo tài khoản nhân viên. Vui lòng thử lại.";
                            System.err.println("ERROR (StaffRegistrationServlet): Failed to insert minimal user for email: " + email);
                        }
                    }
                }
            } catch (SQLException e) {
                errorMessage = "Lỗi cơ sở dữ liệu: " + e.getMessage();
                System.err.println("ERROR (StaffRegistrationServlet): SQLException during staff registration: " + e.getMessage());
                e.printStackTrace();
            } catch (Exception e) {
                errorMessage = "Đã xảy ra lỗi không mong muốn: " + e.getMessage();
                System.err.println("ERROR (StaffRegistrationServlet): Unexpected error during staff registration: " + e.getMessage());
                e.printStackTrace();
            }
        }

        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("email", email);
        request.getRequestDispatcher("register-staff.jsp").forward(request, response);
    }
}
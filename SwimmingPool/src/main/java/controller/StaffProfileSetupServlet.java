package controller;

import dal.UserDAO;
import dal.StaffInitialSetupDAO;
import model.User;
import model.StaffInitialSetup;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date; // Sử dụng java.sql.Date cho dob
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar; // Import Calendar

@WebServlet("/staff-profile-setup")
public class StaffProfileSetupServlet extends HttpServlet {

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

        // Kiểm tra xem người dùng có phải là Staff và cần hoàn thiện hồ sơ không
        if (currentUser == null || currentUser.getRole() == null || currentUser.getRole().getId() != 5) {
            System.out.println("DEBUG (StaffProfileSetupServlet): Access denied. Not a Staff or no user in session. Redirecting to login.");
            response.sendRedirect("login.jsp"); // Chuyển hướng về trang đăng nhập
            return;
        }

        try {
            StaffInitialSetup setup = staffSetupDAO.getStaffInitialSetupByUserId(currentUser.getId());
            if (setup != null && setup.isSetupComplete()) {
                System.out.println("DEBUG (StaffProfileSetupServlet): Staff " + currentUser.getEmail() + " has already completed setup. Redirecting to dashboard.");
                response.sendRedirect("staff_dashboard.jsp"); // Đã hoàn thành, chuyển về dashboard
                return;
            }
        } catch (SQLException e) {
            System.err.println("ERROR (StaffProfileSetupServlet): SQLException checking setup status: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi cơ sở dữ liệu khi kiểm tra trạng thái hồ sơ.");
            request.getRequestDispatcher("error.jsp").forward(request, response); // Chuyển đến trang lỗi
            return;
        }

        request.setAttribute("user", currentUser); // Đặt lại user vào request để JSP có thể hiển thị email
        request.getRequestDispatcher("staff-profile-setup.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || currentUser.getRole() == null || currentUser.getRole().getId() != 5) {
            System.out.println("DEBUG (StaffProfileSetupServlet): POST Access denied. Not a Staff or no user in session. Redirecting to login.");
            response.sendRedirect("login.jsp");
            return;
        }

        String fullName = request.getParameter("fullName");
        String phoneNumber = request.getParameter("phoneNumber");
        String address = request.getParameter("address");
        String dobStr = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String newPassword = request.getParameter("newPassword");
        String confirmNewPassword = request.getParameter("confirmNewPassword");

        String errorMessage = null;
        Date dob = null;

        // Validation for personal info
        if (fullName == null || fullName.trim().isEmpty() ||
                phoneNumber == null || phoneNumber.trim().isEmpty() ||
                address == null || address.trim().isEmpty() ||
                dobStr == null || dobStr.trim().isEmpty() ||
                gender == null || gender.trim().isEmpty()) {
            errorMessage = "Vui lòng điền đầy đủ tất cả các thông tin cá nhân.";
        } else {
            // Validate phone number (10 or 11 digits)
            if (!phoneNumber.matches("^\\d{10,11}$")) {
                errorMessage = "Số điện thoại phải có 10 hoặc 11 chữ số.";
            }

            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                sdf.setLenient(false); // Đảm bảo phân tích cú pháp nghiêm ngặt
                dob = new Date(sdf.parse(dobStr).getTime()); // Chuyển String sang java.sql.Date

                // Lấy ngày hiện tại (chỉ phần ngày, tháng, năm)
                Calendar today = Calendar.getInstance();
                today.set(Calendar.HOUR_OF_DAY, 0);
                today.set(Calendar.MINUTE, 0);
                today.set(Calendar.SECOND, 0);
                today.set(Calendar.MILLISECOND, 0);

                // Lấy ngày sinh (chỉ phần ngày, tháng, năm)
                Calendar dobCalendar = Calendar.getInstance();
                dobCalendar.setTime(dob);
                dobCalendar.set(Calendar.HOUR_OF_DAY, 0);
                dobCalendar.set(Calendar.MINUTE, 0);
                dobCalendar.set(Calendar.SECOND, 0);
                dobCalendar.set(Calendar.MILLISECOND, 0);

                // Kiểm tra ngày sinh không được là ngày hiện tại hoặc trong tương lai
                if (!dobCalendar.before(today)) { // Nếu không phải trước ngày hôm nay (tức là hôm nay hoặc tương lai)
                    errorMessage = "Ngày sinh không được là ngày hiện tại hoặc ngày trong tương lai.";
                    System.err.println("ERROR (StaffProfileSetupServlet): DOB is today or in the future: " + dobStr);
                }

            } catch (ParseException e) {
                errorMessage = "Ngày sinh không hợp lệ. Vui lòng nhập theo định dạng YYYY-MM-DD.";
                System.err.println("ERROR (StaffProfileSetupServlet): Date parsing error for DOB: " + dobStr + " - " + e.getMessage());
            }
        }

        // Validation for new password
        if (errorMessage == null) { // Chỉ kiểm tra mật khẩu nếu không có lỗi thông tin cá nhân
            if (newPassword == null || newPassword.trim().isEmpty() ||
                    confirmNewPassword == null || confirmNewPassword.trim().isEmpty()) {
                errorMessage = "Vui lòng nhập mật khẩu mới và xác nhận mật khẩu.";
            } else if (!newPassword.equals(confirmNewPassword)) {
                errorMessage = "Mật khẩu mới và xác nhận mật khẩu không khớp.";
            } else if (newPassword.length() < 6) {
                errorMessage = "Mật khẩu mới phải có ít nhất 6 ký tự.";
            }
        }

        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
            // Gán lại các giá trị đã nhập để người dùng không phải nhập lại
            currentUser.setFullName(fullName);
            currentUser.setPhoneNumber(phoneNumber);
            currentUser.setAddress(address);
            currentUser.setGender(gender);
            currentUser.setDob(dob); // dob có thể là null nếu có lỗi parse hoặc lỗi validation ngày
            // Không set password vào user object để tránh hiển thị trong form
            request.setAttribute("user", currentUser);
            request.getRequestDispatcher("staff-profile-setup.jsp").forward(request, response);
            return;
        }

        try {
            // Cập nhật thông tin User
            currentUser.setFullName(fullName);
            currentUser.setPhoneNumber(phoneNumber);
            currentUser.setAddress(address);
            currentUser.setDob(dob);
            currentUser.setGender(gender);

            // Transaction 1: Cập nhật hồ sơ người dùng
            boolean profileUpdated = UserDAO.updateUserProfile(currentUser);

            // Transaction 2: Cập nhật mật khẩu mới
            boolean passwordUpdated = UserDAO.updatePassword(currentUser.getEmail(), newPassword);

            if (profileUpdated && passwordUpdated) {
                // Transaction 3: Cập nhật trạng thái hoàn thành setup
                staffSetupDAO.updateSetupCompleteStatus(currentUser.getId(), true);

                // Cập nhật lại đối tượng user trong session sau khi update
                User updatedUser = UserDAO.getUserById(currentUser.getId());
                session.setAttribute("user", updatedUser);

                System.out.println("DEBUG (StaffProfileSetupServlet): Staff profile and password updated successfully for user ID: " + currentUser.getId());
                session.setAttribute("successMessage", "Hồ sơ và mật khẩu của bạn đã được cập nhật thành công!");
                response.sendRedirect("staff_dashboard.jsp"); // Chuyển hướng về dashboard
            } else {
                errorMessage = "Không thể cập nhật hồ sơ hoặc mật khẩu. Vui lòng thử lại.";
                if (!profileUpdated) System.err.println("ERROR: Profile update failed for user ID: " + currentUser.getId());
                if (!passwordUpdated) System.err.println("ERROR: Password update failed for user ID: " + currentUser.getId());

                request.setAttribute("errorMessage", errorMessage);
                request.setAttribute("user", currentUser);
                request.getRequestDispatcher("staff-profile-setup.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            errorMessage = "Lỗi cơ sở dữ liệu khi cập nhật hồ sơ: " + e.getMessage();
            System.err.println("ERROR (StaffProfileSetupServlet): SQLException during profile update: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", errorMessage);
            request.setAttribute("user", currentUser);
            request.getRequestDispatcher("staff-profile-setup.jsp").forward(request, response);
        } catch (Exception e) {
            errorMessage = "Đã xảy ra lỗi không mong muốn: " + e.getMessage();
            System.err.println("ERROR (StaffProfileSetupServlet): Unexpected error during profile update: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", errorMessage);
            request.setAttribute("user", currentUser);
            request.getRequestDispatcher("staff-profile-setup.jsp").forward(request, response);
        }
    }
}

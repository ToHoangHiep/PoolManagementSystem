package controller;

import dal.UserDAO;
import utils.EmailUtils;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String address = request.getParameter("address");
        String dob = request.getParameter("dob");
        String gender = request.getParameter("gender");

        // Validate password match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Check if email already exists
        if (UserDAO.checkEmailExists(email)) {
            request.setAttribute("error", "Email đã tồn tại trong hệ thống.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Register user với user_status = 'Deactive' (bạn cần chắc chắn UserDAO.register đã làm điều này)
        boolean success = UserDAO.register(fullName, email, phone, password, address, dob, gender);

        if (success) {
            // Sinh mã xác minh 6 số ngẫu nhiên
            String code = String.valueOf((int)(Math.random() * 900000) + 100000);

            // Gửi email mã xác minh
            EmailUtils.send(email, "Xác minh đăng ký", "Mã xác minh của bạn là: " + code);

            // Lưu mã xác minh và email vào session
            HttpSession session = request.getSession();
            session.setAttribute("verificationCode", code);
            session.setAttribute("pendingEmail", email);

            // Chuyển hướng sang trang verify.jsp để nhập mã xác minh
            response.sendRedirect("verify.jsp");
        } else {
            request.setAttribute("error", "Đăng ký thất bại. Vui lòng thử lại.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}

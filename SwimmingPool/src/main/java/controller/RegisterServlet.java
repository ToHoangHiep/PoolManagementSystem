package controller;

import dal.UserDAO;
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

        // Kiểm tra dữ liệu đầu vào
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (UserDAO.checkEmailExists(email)) {
            request.setAttribute("error", "Email đã được sử dụng.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Tạo người dùng mới
        boolean success = UserDAO.register(fullName, email, phone, password);

        if (success) {
            response.sendRedirect("login.jsp");
        } else {
            request.setAttribute("error", "Đăng ký thất bại. Vui lòng thử lại.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}

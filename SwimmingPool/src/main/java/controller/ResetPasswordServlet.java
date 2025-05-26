package controller;

import dal.UserCodeDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

import java.io.IOException;

public class ResetPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        User user = UserDAO.findUserFromEmail(email);

        if (user == null) {
            request.setAttribute("error", "Email không tồn tại.");
            request.getRequestDispatcher("reset_password.jsp").forward(request, response);
            return;
        }

        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("reset_password.jsp").forward(request, response);
            return;
        }
        // Thêm điều kiện kiểm tra độ mạnh mật khẩu nếu cần

        if (newPassword.length() < 8) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 8 ký tự.");
            request.getRequestDispatcher("reset_password.jsp").forward(request, response);
            return;
        }

        // Kiểm tra xem có ít nhât một ký tự chữ hoa, một ký tự chữ thường, một ký tự số và một ký tự đặc biệt
        String passwordPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z0-9@$!%*?&]{8,}$";
        if (!newPassword.matches(passwordPattern)) {
            request.setAttribute("error", "Mật khẩu phải chứa ít nhất một chữ hoa, một chữ thường, một số và một ký tự đặc biệt.");
            request.getRequestDispatcher("reset_password.jsp").forward(request, response);
            return;
        }

        String oldPassword = user.getPasswordHash();
        if (newPassword.equals(oldPassword)) {
            request.setAttribute("error", "Mật khẩu không thể là mật khẩu cũ!");
            request.getRequestDispatcher("reset_password.jsp").forward(request, response);
            return;
        }

        // Cập nhật mật khẩu mới
        UserDAO.updatePassword(email, newPassword);
        UserCodeDAO.deleteCode(user);

        response.sendRedirect("login.jsp");
    }
}

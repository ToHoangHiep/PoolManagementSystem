package controller;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import utils.Utils;

import java.io.IOException;

public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Kiểm tra dữ liệu đầu vào
        if (Utils.CheckIfEmpty(currentPassword) || Utils.CheckIfEmpty(newPassword) || Utils.CheckIfEmpty(confirmPassword)) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin.");
            request.getRequestDispatcher("change_password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("change_password.jsp").forward(request, response);
            return;
        }

        // Giả sử bạn đã có một phương thức để lấy người dùng hiện tại từ session
        HttpSession session = request.getSession();
        Object userObj = session.getAttribute("user");
        if (userObj == null) {
            request.setAttribute("error", "Bạn cần đăng nhập để thay đổi mật khẩu.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Giả sử userObj là một đối tượng User với phương thức getPassword() để lấy mật khẩu hiện tại
        // Kiểm tra mật khẩu hiện tại
        User user = (User) userObj;
        if (!(user.getPasswordHash().equals(currentPassword))) {
            request.setAttribute("error", "Mật khẩu hiện tại không đúng.");
            request.getRequestDispatcher("change_password.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 8) {
            request.setAttribute("error", "Mật khẩu mới phải có ít nhất 8 ký tự.");
            request.getRequestDispatcher("change_password.jsp").forward(request, response);
            return;
        }

        // Kiểm tra xem mật khẩu mới có chứa ít nhất một ký tự chữ hoa, một ký tự chữ thường, một số và một ký tự đặc biệt
        String passwordPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z0-9@$!%*?&]{8,}$";
        if (!newPassword.matches(passwordPattern)) {
            request.setAttribute("error", "Mật khẩu mới phải chứa ít nhất một chữ hoa, một chữ thường, một số và một ký tự đặc biệt.");
            request.getRequestDispatcher("change_password.jsp").forward(request, response);
            return;
        }

        // Kiểm tra xem mật khẩu mới có phải là mật khẩu cũ không
        if (newPassword.equals(currentPassword)) {
            request.setAttribute("error", "Mật khẩu mới không thể là mật khẩu cũ!");
            request.getRequestDispatcher("change_password.jsp").forward(request, response);
            return;
        }

        // Cập nhật mật khẩu mới
        // Giả sử bạn có một phương thức để cập nhật mật khẩu trong UserDAO
        boolean success = UserDAO.updatePassword(user.getEmail(), newPassword);
        if (success) {
            request.setAttribute("message", "Mật khẩu đã được thay đổi thành công.");
            request.getRequestDispatcher("change_password.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Đã xảy ra lỗi khi thay đổi mật khẩu. Vui lòng thử lại.");
            request.getRequestDispatcher("change_password.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng đến trang thay đổi mật khẩu
        request.getRequestDispatcher("change_password.jsp").forward(request, response);
    }
}




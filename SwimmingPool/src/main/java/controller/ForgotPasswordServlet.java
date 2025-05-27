package controller;

import dal.UserCodeDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import utils.EmailUtils;
import utils.Utils;

import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

public class ForgotPasswordServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        System.out.println(">>> action = " + action);

        if ("sendCode".equals(action)) {
            String email = request.getParameter("email");
            // Gửi mã xác nhận đến email

            if (Utils.CheckIfEmpty(email)) {
                request.setAttribute("error_p1", "Vui lòng nhập email.");
                request.getRequestDispatcher("forgot_password.jsp").forward(request, response);
                return;
            }

            // Validate email format
            String emailRegex = "^[\\w.%+-]+@[\\w.-]+\\.[a-zA-Z]{2,}$";
            if (!email.matches(emailRegex)) {
                request.setAttribute("error_p1", "Email không hợp lệ. Vui lòng nhập email hợp lệ.");
                request.getRequestDispatcher("forgot_password.jsp").forward(request, response);
                return;
            }

            // Kiểm tra email có tồn tại không
            if (!UserDAO.checkEmailExists(email)) {
                request.setAttribute("error_p1", "Email không tồn tại.");
                request.getRequestDispatcher("forgot_password.jsp").forward(request, response);
                return;
            }

            User user = UserDAO.findUserFromEmail(email);
            System.out.println(">>> email = " + email);
            System.out.println(">>> user = " + user);

            if (user == null) {
                request.setAttribute("error_p1", "Không tìm thấy người dùng với email này.");
                request.getRequestDispatcher("forgot_password.jsp").forward(request, response);
                return;
            }

            boolean codeCreated = UserCodeDAO.createCode(user);
            if (codeCreated) {
                String code = UserCodeDAO.getCode(user);
                // Sau khi tạo mã, bạn có thể gửi email chứa mã xác nhận
//                Utils.SendEmail("Pool Management System Reset Password <pms@testmailgun.org>",
//                        email,
//                        "Xác nhận đặt lại mật khẩu",
//                        "Mã xác nhận của bạn là: " + code +
//                                "\nVui lòng không chia sẻ mã này với bất kỳ ai." +
//                                "\nNếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này." +
//                                "\nMã này sẽ hết hạn sau 15 phút." +
//                                "\n\nTrân trọng,\nPMS Team");
                EmailUtils.send(email, "Xác minh đặt lại mật khẩu", "Mã xác minh của bạn là: " + code);


                // Chuyển hướng đến trang xác nhận mã
                response.sendRedirect("forgot_password.jsp?step=verify&email=" +
                        URLEncoder.encode(email, StandardCharsets.UTF_8));
            } else {
                request.setAttribute("error_p1", "Không thể tạo mã xác nhận. Vui lòng thử lại.");
                request.getRequestDispatcher("forgot_password.jsp").forward(request, response);
            }

        } else if ("checkCode".equals(action)) {
            String code = request.getParameter("code");
            String email = request.getParameter("email");
            System.out.println(">>> code = " + code);
            System.out.println(">>> email = " + email);
            // Kiểm tra mã xác nhận

            String decodedEmail = URLDecoder.decode(email, StandardCharsets.UTF_8);

            User user = UserDAO.findUserFromEmail(decodedEmail);
            if (user == null) {
                request.setAttribute("error_p2", "Không tìm thấy người dùng với email này.");
                request.getRequestDispatcher("forgot_password.jsp").forward(request, response);
                return;
            }

            boolean isValid = UserCodeDAO.checkCode(user, code);
            if (isValid) { // Giả sử mã hợp lệ
                response.sendRedirect("reset_password.jsp?email=" + URLEncoder.encode(email, StandardCharsets.UTF_8));
            } else {
                request.setAttribute("error_p2", "Mã xác nhận không hợp lệ.");
                request.getRequestDispatcher("forgot_password.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng về trang forgot_password.jsp nếu có GET
        response.sendRedirect("forgot_password.jsp");
    }
}

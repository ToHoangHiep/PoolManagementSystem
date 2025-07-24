package controller;

import dal.UserDAO;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        System.out.println(">>> Đăng nhập với email = " + email + ", password = " + password);

        // Kiểm tra input rỗng
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ Email và Mật khẩu.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Gọi DAO để kiểm tra đăng nhập
        User user = UserDAO.login(email, password);

        if (user != null) {
            // Kiểm tra trạng thái tài khoản
            String status = user.getUserStatus();
            if (!"Active".equalsIgnoreCase(status)) {
                request.setAttribute("error", "Tài khoản chưa được kích hoạt hoặc đã bị khóa. Vui lòng kiểm tra email để xác minh.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            // Lưu user vào session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            System.out.println(">>> Đăng nhập thành công! Vai trò: " + user.getRole().getName());

            // Phân luồng theo vai trò
            int roleId = user.getRole().getId();

            if (roleId == 4) { // Customer
                response.sendRedirect("home.jsp");
            } else if (roleId == 5) { // Staff
                response.sendRedirect("staff_dashboard.jsp");
            } else if (roleId == 2) { // Manager
                response.sendRedirect("admin_dashboard.jsp");
            } else if (roleId == 1) { // Admin
                response.sendRedirect("admin_dashboard.jsp");
            } else {
                response.sendRedirect("error.jsp");
            }


        } else {
            System.out.println(">>> Đăng nhập thất bại!");
            request.setAttribute("error", "Sai tài khoản hoặc mật khẩu.");
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

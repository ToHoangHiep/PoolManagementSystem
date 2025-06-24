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

        // Log đầu vào
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

            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            System.out.println(">>> Đăng nhập thành công! Vai trò: " + user.getRole().getName());
            
            // Check for return URL
            String returnUrl = (String) session.getAttribute("returnUrl");
            if (returnUrl != null) {
                session.removeAttribute("returnUrl");
                response.sendRedirect(returnUrl);
            } else {
                response.sendRedirect("home.jsp");
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
        response.sendRedirect("login.jsp");
    }
}

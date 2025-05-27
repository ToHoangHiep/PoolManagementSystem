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

        // Kiểm tra input
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Please enter full Email and Password!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Kiểm tra thông tin đăng nhập
        User user = UserDAO.login(email, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user); // Lưu user vào session

            // Chuyển sang UserProfileServlet để load dữ liệu
            response.sendRedirect("userProfile");
        } else {
            request.setAttribute("error", "Wrong account or password!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    // Xử lý khi truy cập GET → quay về trang đăng nhập
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }
}

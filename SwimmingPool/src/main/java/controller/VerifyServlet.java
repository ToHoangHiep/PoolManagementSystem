package controller;

import dal.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class VerifyServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String inputCode = request.getParameter("code");
        HttpSession session = request.getSession(false);

        if (session == null) {
            request.setAttribute("error", "Phiên làm việc hết hạn, vui lòng đăng ký lại.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        String expectedCode = (String) session.getAttribute("verificationCode");
        String email = (String) session.getAttribute("pendingEmail");

        if (expectedCode == null || email == null) {
            request.setAttribute("error", "Không có mã xác minh hợp lệ, vui lòng đăng ký lại.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (inputCode != null && inputCode.equals(expectedCode)) {
            // Cập nhật trạng thái user thành Active
            UserDAO.updateStatus(email, "Active");

            // Xóa session liên quan
            session.removeAttribute("verificationCode");
            session.removeAttribute("pendingEmail");

            // Chuyển về trang đăng nhập
            response.sendRedirect("login.jsp");
        } else {
            request.setAttribute("error", "Mã xác minh không đúng!");
            request.getRequestDispatcher("verify.jsp").forward(request, response);
        }
    }
}

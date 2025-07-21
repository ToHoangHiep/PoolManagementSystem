package controller;

import dal.RoleDAO;
import dal.UserDAO;
import model.Role;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin-user")
public class AdminUserServlet extends HttpServlet {
    // Ghi đè phương thức doGet để xử lý khi trình duyệt gửi yêu cầu GET
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy tham số "name" từ URL query string để lọc theo tên người dùng
        String nameFilter = request.getParameter("name");

        // Lấy tham số "status" từ URL để lọc theo trạng thái người dùng (VD: active/inactive)
        String statusFilter = request.getParameter("status");

        // Lấy tham số "role" từ URL để lọc theo vai trò người dùng
        String roleFilter = request.getParameter("role");

        // Gọi UserDAO để lấy danh sách người dùng theo các điều kiện lọc (nếu có)
        List<User> userList = UserDAO.getAllUsers(nameFilter, statusFilter, roleFilter);

        // Gọi RoleDAO để lấy tất cả vai trò (dùng để hiển thị ở dropdown lọc)
        List<Role> roleList = RoleDAO.getAllRoles();

        // Đưa danh sách người dùng vào thuộc tính request để gửi sang JSP
        request.setAttribute("users", userList);

        // Đưa danh sách vai trò vào request để gửi sang JSP
        request.setAttribute("roles", roleList);

        // Chuyển tiếp request sang trang JSP hiển thị danh sách user: admin_users.jsp
        request.getRequestDispatcher("admin_users.jsp").forward(request, response);
    }
}


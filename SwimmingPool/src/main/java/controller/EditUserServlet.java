package controller;

import dal.RoleDAO;
import dal.UserDAO;
import model.Role;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/edit-user")
public class EditUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(req.getParameter("id"));
            // Lấy ID người dùng từ request

            User user = UserDAO.getUserById(userId);
            // Lấy thông tin user theo ID

            List<Role> roles = RoleDAO.getAllRoles();
            // Lấy danh sách vai trò để hiển thị trong dropdown

            if (user == null) {
                // Nếu không tìm thấy user → quay lại danh sách
                resp.sendRedirect("admin-user");
                return;
            }

            req.setAttribute("user", user);
            req.setAttribute("roles", roles);
            // Truyền user và roles sang JSP để hiển thị trong form

            req.getRequestDispatcher("edit_user.jsp").forward(req, resp);
            // Chuyển tiếp sang trang edit_user.jsp
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("admin-user");
            // Nếu có lỗi → chuyển về danh sách user
        }
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(req.getParameter("id"));
            int roleId = Integer.parseInt(req.getParameter("roleId"));
            String status = req.getParameter("status");
            // Lấy dữ liệu từ form: ID, Role ID, Status

            boolean success = UserDAO.updateUser(userId, roleId, status);
            // Gọi DAO để cập nhật user trong CSDL

            if (success) {
                // Nếu cập nhật thành công → quay lại danh sách
                resp.sendRedirect("admin-user");
            } else {
                // Nếu cập nhật thất bại → giữ lại user và roles để hiển thị lại form
                User user = UserDAO.getUserById(userId);
                List<Role> roles = RoleDAO.getAllRoles();
                req.setAttribute("user", user);
                req.setAttribute("roles", roles);
                req.setAttribute("error", "Failed to update user.");
                req.getRequestDispatcher("edit_user.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Xử lý nếu có lỗi trong quá trình cập nhật

            int userId = Integer.parseInt(req.getParameter("id"));
            User user = UserDAO.getUserById(userId);
            List<Role> roles = RoleDAO.getAllRoles();

            req.setAttribute("user", user);
            req.setAttribute("roles", roles);
            req.setAttribute("error", "Exception occurred when updating user.");
            // Gửi lại thông tin và báo lỗi cho giao diện

            req.getRequestDispatcher("edit_user.jsp").forward(req, resp);
        }
    }
}






package controller;

import dal.RoleDAO;
import dal.UserDAO;
import model.Role;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.util.List;

@WebServlet("/user-role")
public class UserRoleServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException {
        try {
            List<User> users = UserDAO.getAllUsersWithRoles();
            List<Role> roles = RoleDAO.getAllRoles();

            req.setAttribute("users", users);
            req.setAttribute("roles", roles);
            req.getRequestDispatcher("user_role.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException {
        try {
            int userId = Integer.parseInt(req.getParameter("userId"));
            int roleId = Integer.parseInt(req.getParameter("roleId"));
            UserDAO.updateUserRole(userId, roleId);
            resp.sendRedirect("user-role");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

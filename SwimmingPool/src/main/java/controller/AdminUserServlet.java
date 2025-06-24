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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nameFilter = request.getParameter("name");
        String statusFilter = request.getParameter("status");
        String roleFilter = request.getParameter("role");

        List<User> userList = UserDAO.getAllUsers(nameFilter, statusFilter, roleFilter);
        List<Role> roleList = RoleDAO.getAllRoles();

        request.setAttribute("users", userList);
        request.setAttribute("roles", roleList);
        request.getRequestDispatcher("admin_users.jsp").forward(request, response);
    }
}

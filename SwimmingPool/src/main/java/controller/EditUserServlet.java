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
            User user = UserDAO.getUserById(userId);
            List<Role> roles = RoleDAO.getAllRoles();

            if (user == null) {
                resp.sendRedirect("admin-user");
                return;
            }

            req.setAttribute("user", user);
            req.setAttribute("roles", roles);
            req.getRequestDispatcher("edit_user.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("admin-user");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(req.getParameter("id"));
            int roleId = Integer.parseInt(req.getParameter("roleId"));
            String status = req.getParameter("status");

            boolean success = UserDAO.updateUser(userId, roleId, status);

            if (success) {
                resp.sendRedirect("admin-user");
            } else {
                User user = UserDAO.getUserById(userId);
                List<Role> roles = RoleDAO.getAllRoles();
                req.setAttribute("user", user);
                req.setAttribute("roles", roles);
                req.setAttribute("error", "Failed to update user.");
                req.getRequestDispatcher("edit_user.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            int userId = Integer.parseInt(req.getParameter("id"));
            User user = UserDAO.getUserById(userId);
            List<Role> roles = RoleDAO.getAllRoles();
            req.setAttribute("user", user);
            req.setAttribute("roles", roles);
            req.setAttribute("error", "Exception occurred when updating user.");
            req.getRequestDispatcher("edit_user.jsp").forward(req, resp);
        }
    }



}

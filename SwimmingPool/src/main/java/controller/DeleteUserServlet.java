package controller;

import dal.UserDAO;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/delete-user")
public class DeleteUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            UserDAO.updateStatusById(userId, "Deactive");

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("admin-user");
    }
}

package controller;

import dal.MaintenanceScheduleDAO;
import model.MaintenanceSchedule;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/maintenance")
public class MaintenanceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy user từ session
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // Kiểm tra login + quyền
        if (user == null || user.getRole() == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String role = user.getRole().getName();
        if (!role.equalsIgnoreCase("Admin") &&
                !role.equalsIgnoreCase("Manager") &&
                !role.equalsIgnoreCase("Staff")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        // Load dữ liệu bảo trì
        MaintenanceScheduleDAO dao = new MaintenanceScheduleDAO();
        List<MaintenanceSchedule> scheduleList = dao.getAllSchedules();

        // Gửi dữ liệu sang JSP
        request.setAttribute("maintenanceList", scheduleList);
        request.getRequestDispatcher("maintenance.jsp").forward(request, response);
    }
}

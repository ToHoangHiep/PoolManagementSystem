package controller;

import dal.MaintenanceDAO;
import model.MaintenanceSchedule;
import model.User;
import dal.UserDAO;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/maintenance")
public class MaintenanceServlet extends HttpServlet {

    private MaintenanceDAO maintenanceDAO;
    private UserDAO userDAO;

    @Override
    public void init() {
        maintenanceDAO = new MaintenanceDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra xem người dùng đã đăng nhập chưa
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            // Nếu chưa đăng nhập, chuyển hướng về trang login
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "new":
                showAddForm(request, response);  // Hiển thị form thêm lịch bảo trì
                break;
            case "edit":
                showEditForm(request, response);  // Hiển thị form chỉnh sửa lịch bảo trì
                break;
            case "delete":
                deleteSchedule(request, response);  // Xử lý xoá lịch bảo trì
                break;
            case "update":
                updateSchedule(request, response);  // Xử lý cập nhật lịch bảo trì
                break;
            default:
                listSchedules(request, response);  // Hiển thị danh sách lịch bảo trì
        }
    }



    private void listSchedules(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int pageNo = 1;
        int pageSize = 10;
        String status = request.getParameter("searchStatus");
        String title = request.getParameter("searchTitle");

        try {
            pageNo = Integer.parseInt(request.getParameter("pageNo"));
        } catch (NumberFormatException e) {
            pageNo = 1;
        }

        try {
            pageSize = Integer.parseInt(request.getParameter("pageSize"));
        } catch (NumberFormatException e) {
            pageSize = 10;
        }

        // Lấy danh sách lịch bảo trì theo trạng thái và tiêu đề nếu có
        List<MaintenanceSchedule> schedules = maintenanceDAO.getSchedulesWithSearch(status, title, pageNo, pageSize);
        request.setAttribute("schedules", schedules);

        // Truyền trạng thái và tiêu đề tìm kiếm về JSP
        request.setAttribute("searchStatus", status);
        request.setAttribute("searchTitle", title);

        // Lấy tổng số bản ghi và tính tổng số trang
        int totalRecords = maintenanceDAO.getTotalSchedules(status, title);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", pageNo);

        RequestDispatcher dispatcher = request.getRequestDispatcher("maintenance.jsp");
        dispatcher.forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> staffList = userDAO.getAllStaff();  // Lấy danh sách nhân viên
        request.setAttribute("staffList", staffList);  // Truyền danh sách nhân viên vào request
        RequestDispatcher dispatcher = request.getRequestDispatcher("maintenance-form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        MaintenanceSchedule schedule = maintenanceDAO.getScheduleById(id);  // Lấy lịch bảo trì theo ID
        List<User> staffList = userDAO.getAllStaff();  // Lấy danh sách nhân viên
        request.setAttribute("schedule", schedule);
        request.setAttribute("staffList", staffList);  // Truyền danh sách nhân viên vào request
        request.getRequestDispatcher("maintenance-edit.jsp").forward(request, response);  // Chuyển đến trang sửa
    }

    // Xử lý thêm lịch bảo trì
    private void insertSchedule(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        try {
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String frequency = request.getParameter("frequency");
            int staffId = Integer.parseInt(request.getParameter("assignedStaffId"));
            java.sql.Time scheduledTime = java.sql.Time.valueOf(request.getParameter("scheduledTime"));
            String status = request.getParameter("status");

            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            MaintenanceSchedule schedule = new MaintenanceSchedule();
            schedule.setTitle(title);
            schedule.setDescription(description);
            schedule.setFrequency(frequency);
            schedule.setAssignedStaffId(staffId);
            schedule.setScheduledTime(scheduledTime);
            schedule.setStatus(status);
            schedule.setCreatedBy(user.getId());

            maintenanceDAO.insertSchedule(schedule);  // Gọi DAO để thêm lịch bảo trì
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi thêm lịch bảo trì.");
            request.getRequestDispatcher("maintenance-form.jsp").forward(request, response);
            return;
        }

        response.sendRedirect("maintenance");  // Sau khi thêm thành công, chuyển về trang danh sách
    }

    // Xử lý cập nhật lịch bảo trì
    private void updateSchedule(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String frequency = request.getParameter("frequency");
            int staffId = Integer.parseInt(request.getParameter("assignedStaffId"));
            java.sql.Time scheduledTime = java.sql.Time.valueOf(request.getParameter("scheduledTime"));
            String status = request.getParameter("status");

            MaintenanceSchedule schedule = new MaintenanceSchedule();
            schedule.setId(id);
            schedule.setTitle(title);
            schedule.setDescription(description);
            schedule.setFrequency(frequency);
            schedule.setAssignedStaffId(staffId);
            schedule.setScheduledTime(scheduledTime);
            schedule.setStatus(status);

            maintenanceDAO.updateSchedule(schedule);  // Gọi DAO để cập nhật lịch bảo trì
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("maintenance");  // Sau khi cập nhật thành công, chuyển về trang danh sách
    }

    // Xử lý xoá lịch bảo trì
    private void deleteSchedule(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            maintenanceDAO.deleteSchedule(id);  // Gọi DAO để xoá lịch bảo trì
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("maintenance");  // Sau khi xoá thành công, chuyển về trang danh sách
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "insert":
                insertSchedule(request, response);
                break;
            case "update":
                updateSchedule(request, response);
                break;
            default:
                listSchedules(request, response);
        }
    }
}

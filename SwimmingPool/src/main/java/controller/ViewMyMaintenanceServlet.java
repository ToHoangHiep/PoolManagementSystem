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

@WebServlet("/viewMyMaintenance")
public class ViewMyMaintenanceServlet extends HttpServlet {

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

        User currentUser = (User) session.getAttribute("user");

        // Lấy staffId của người dùng đang đăng nhập
        int staffId = currentUser.getId();

        // Kiểm tra nếu đang xem chi tiết của một lịch bảo trì cụ thể
        String scheduleId = request.getParameter("id");

        if (scheduleId != null) {
            // Lấy thông tin lịch bảo trì dựa trên ID
            int id = Integer.parseInt(scheduleId);
            MaintenanceSchedule schedule = maintenanceDAO.getScheduleById(id);

            if (schedule != null && schedule.getAssignedStaffId() == staffId) {
                // Truyền thông tin lịch bảo trì vào request
                request.setAttribute("schedule", schedule);

                // Chuyển tới trang xem chi tiết lịch bảo trì
                RequestDispatcher dispatcher = request.getRequestDispatcher("viewMaintenanceDetail.jsp");
                dispatcher.forward(request, response);
            } else {
                // Nếu không tìm thấy lịch bảo trì hoặc không phải của nhân viên hiện tại, quay lại danh sách và thông báo lỗi
                request.setAttribute("errorMessage", "Lịch bảo trì không tồn tại hoặc không phải của bạn.");
                listSchedules(request, response, staffId);  // Lấy lại danh sách lịch bảo trì của nhân viên hiện tại
            }
        } else {
            // Nếu không có ID, hiển thị danh sách lịch bảo trì
            listSchedules(request, response, staffId);  // Lấy lại danh sách lịch bảo trì của nhân viên hiện tại
        }
    }

    // Hàm xử lý danh sách lịch bảo trì
    private void listSchedules(HttpServletRequest request, HttpServletResponse response, int staffId)
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

        // Lấy danh sách lịch bảo trì của nhân viên đã đăng nhập (staffId)
        List<MaintenanceSchedule> schedules = maintenanceDAO.getSchedulesForStaff(staffId, pageNo, pageSize);
        request.setAttribute("schedules", schedules);

        // Truyền thông tin trạng thái và tiêu đề tìm kiếm về JSP
        request.setAttribute("searchStatus", status);
        request.setAttribute("searchTitle", title);

        // Lấy tổng số bản ghi và tính tổng số trang
        int totalRecords = maintenanceDAO.getTotalSchedules(status, title);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", pageNo);

        // Chuyển tới trang hiển thị danh sách lịch bảo trì
        RequestDispatcher dispatcher = request.getRequestDispatcher("viewMyMaintenance.jsp");
        dispatcher.forward(request, response);
    }

    // Xử lý cập nhật status của lịch bảo trì
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiểm tra nếu người dùng đã đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            // Nếu chưa đăng nhập, chuyển hướng về trang login
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy thông tin người dùng đang đăng nhập
        User currentUser = (User) session.getAttribute("user");

        // Lấy thông tin cập nhật từ form (status mới và id lịch bảo trì)
        String scheduleId = request.getParameter("id");
        String newStatus = request.getParameter("status");

        if (scheduleId != null && newStatus != null) {
            int id = Integer.parseInt(scheduleId);

            // Lấy thông tin lịch bảo trì hiện tại
            MaintenanceSchedule schedule = maintenanceDAO.getScheduleById(id);

            if (schedule != null && schedule.getAssignedStaffId() == currentUser.getId()) {
                // Cập nhật trạng thái cho lịch bảo trì
                schedule.setStatus(newStatus);

                // Lưu thông tin vào cơ sở dữ liệu
                maintenanceDAO.updateSchedule(schedule);

                // Sau khi cập nhật, trả về trang danh sách
                listSchedules(request, response, currentUser.getId());
            } else {
                // Nếu không tìm thấy lịch bảo trì, thông báo lỗi
                request.setAttribute("errorMessage", "Lịch bảo trì không tồn tại hoặc không phải của bạn.");
                listSchedules(request, response, currentUser.getId());
            }
        } else {
            // Nếu thiếu thông tin, quay lại danh sách lịch bảo trì
            listSchedules(request, response, currentUser.getId());
        }
    }
}

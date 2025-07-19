package controller;

import dal.MaintenanceDAO;
import dal.MaintenanceLogDAO; // Bạn vẫn có thể cần MaintenanceLogDAO cho các tác vụ tạo log định kỳ riêng biệt
import model.MaintenanceLog;
import model.MaintenanceRequest;
import model.MaintenanceSchedule;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Time;
import java.time.LocalDate;
import java.time.DayOfWeek;
import java.util.*;

@WebServlet("/MaintenanceServlet")
public class MaintenanceServlet extends HttpServlet {
    private MaintenanceDAO dao;
    // Khởi tạo MaintenanceLogDAO nếu bạn vẫn cần nó cho các tác vụ tạo log định kỳ
    // private MaintenanceLogDAO maintenanceLogDAO;

    @Override
    public void init() throws ServletException {
        dao = new MaintenanceDAO();
        // maintenanceLogDAO = new MaintenanceLogDAO(); // Nếu bạn có các phương thức riêng biệt trong đó
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }
        String role = user.getRole().getName();
        String action = req.getParameter("action");
        if (action == null) {
            action = role.equalsIgnoreCase("Staff") ? "staffView" : "list";
        }

        switch (action) {
            case "list":
                if (role.equalsIgnoreCase("Admin") || role.equalsIgnoreCase("Manager")) {
                    List<MaintenanceSchedule> templates = dao.getAllTemplates();
                    // Lấy các request CÓ TRẠNG THÁI 'Open' để Admin/Manager xử lý
                    List<MaintenanceRequest> requests = dao.getAllRequests();
                    List<User> staffs = dao.getAllStaff();

                    req.setAttribute("schedules", templates);
                    req.setAttribute("requests", requests);
                    req.setAttribute("staffs", staffs);

                    req.getRequestDispatcher("maintenance.jsp").forward(req, resp);
                } else {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                }
                break;

            case "showForm":
                if (role.equalsIgnoreCase("Admin") || role.equalsIgnoreCase("Manager")) {
                    req.setAttribute("templates", dao.getAllTemplates());
                    req.setAttribute("areas", dao.getAllPoolAreas());
                    req.setAttribute("staffs", dao.getAllStaff());
                    req.getRequestDispatcher("maintenance-form.jsp").forward(req, resp);
                } else {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                }
                break;

            case "showRequestForm":
                if (role.equalsIgnoreCase("Staff")) {
                    req.setAttribute("areas", dao.getAllPoolAreas());
                    req.getRequestDispatcher("request-form.jsp").forward(req, resp);
                } else {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                }
                break;

            case "staffView":
                if (!role.equalsIgnoreCase("Staff")) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                // Nếu bạn có các logic tạo log 'Missed' riêng, hãy cân nhắc đặt chúng ở đây hoặc trong một Scheduled Executor Service.
                // Đối với các yêu cầu bảo trì được chấp nhận, chúng ta không cần tạo log 'Missed' riêng biệt
                // vì chúng được tạo thành log ngay khi chấp nhận.

                // Lấy danh sách các thông báo CHƯA ĐỌC cho staff hiện tại
                List<String> unreadNotifications = dao.getUnreadNotifications(user.getId());
                req.setAttribute("unreadNotifications", unreadNotifications);
                if (!unreadNotifications.isEmpty()) {
                    dao.markNotificationsAsRead(user.getId()); // Đánh dấu đã đọc sau khi lấy
                }

                // Lấy danh sách MaintenanceLog (BAO GỒM CẢ CÁC LOG TẠO TỪ YÊU CẦU ĐÃ CHẤP NHẬN)
                // Phương thức getLogsByStaff trong DAO đã được sửa đổi để lấy tất cả log gán cho staff,
                // bao gồm cả log định kỳ và log từ request ad-hoc.
                List<MaintenanceLog> logs = dao.getLogsByStaff(user.getId());
                req.setAttribute("logs", logs);

                // Lấy danh sách request staff ĐÃ GỬI VÀ ĐƯỢC CHẤP NHẬN (chúng đã được chuyển thành log)
                List<MaintenanceRequest> myAcceptedRequests = dao.getMyAcceptedRequests(user.getId());
                req.setAttribute("myAccepted", myAcceptedRequests);

                // Lấy danh sách request staff ĐÃ GỬI VÀ BỊ TỪ CHỐI
                List<MaintenanceRequest> myRejectedRequests = dao.getRejectedRequestsByStaff(user.getId());
                req.setAttribute("myRejected", myRejectedRequests);

                // KHÔNG CẦN DÙNG NỮA: Yêu cầu được phân công cho tôi (assignedRequests)
                // Bởi vì các yêu cầu được chấp nhận và phân công giờ đây đã trở thành MaintenanceLog
                // và được hiển thị trong phần "Công việc định kỳ" (biến 'logs').
                // List<MaintenanceRequest> assignedRequests = dao.getAssignedRequestsForStaff(user.getId());
                // req.setAttribute("assigned", assignedRequests);

                req.getRequestDispatcher("maintenance-staff.jsp").forward(req, resp);
                break;

            case "staffDetail":
                if (!role.equalsIgnoreCase("Staff")) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                int scheduleId = Integer.parseInt(req.getParameter("scheduleId"));
                LocalDate todayDate = LocalDate.now();
                LocalDate startOfWeek = todayDate.with(DayOfWeek.MONDAY);
                LocalDate endOfWeek   = todayDate.with(DayOfWeek.SUNDAY);

                MaintenanceSchedule sch = dao.getTemplateById(scheduleId);
                req.setAttribute("schedule", sch);

                List<MaintenanceLog> weekLogs = dao.getLogsForWeek(scheduleId, user.getId());
                req.setAttribute("weekLogs", weekLogs);

                Map<String, Boolean> dailyStatus = new LinkedHashMap<>();
                for (int i = 0; i < 7; i++) {
                    LocalDate d = startOfWeek.plusDays(i);
                    boolean done = weekLogs.stream().anyMatch(log -> {
                        LocalDate logDate = ((java.sql.Date) log.getMaintenanceDate()).toLocalDate();
                        return logDate.equals(d) && "Done".equals(log.getStatus());
                    });
                    dailyStatus.put(d.getDayOfWeek().toString(), done);
                }
                req.setAttribute("dailyStatus", dailyStatus);

                String weekStatus = todayDate.isBefore(endOfWeek)
                        ? "Doing"
                        : (dailyStatus.values().stream().allMatch(v->v) ? "Done" : "Missed");
                req.setAttribute("weekStatus", weekStatus);

                // Cần đảm bảo `sch.getPoolAreaId()` không bị null nếu `sch` là schedule ad-hoc.
                // MaintenanceLog đã có poolAreaId, có thể lấy từ đó nếu cần.
                int areaId = weekLogs.isEmpty() ? sch.getPoolAreaId() : weekLogs.get(0).getPoolAreaId();
                req.setAttribute("areaId", areaId);

                req.getRequestDispatcher("maintenance-week.jsp").forward(req, resp);
                break;
            case "listRequests": // Hành động này có thể bị loại bỏ vì `maintenance.jsp` đã hiển thị requests
                if (role.equalsIgnoreCase("Admin") || role.equalsIgnoreCase("Manager")) {
                    List<MaintenanceRequest> requests = dao.getAllRequests();
                    req.setAttribute("requests", requests);
                    req.getRequestDispatcher("maintenance-requests.jsp").forward(req, resp);
                } else {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                }
                break;

            default:
                resp.sendRedirect("MaintenanceServlet");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        String role = user.getRole().getName();
        String action = req.getParameter("action");

        try {
            switch (action) {
                case "create":
                    if (!role.equalsIgnoreCase("Admin") && !role.equalsIgnoreCase("Manager")) {
                        resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                        return;
                    }
                    String tplIdStr = req.getParameter("templateId");
                    String title, desc, freq;
                    Time schedTime;
                    if (tplIdStr != null && !tplIdStr.isEmpty()) {
                        int tplId = Integer.parseInt(tplIdStr);
                        MaintenanceSchedule tpl = dao.getTemplateById(tplId);
                        title = tpl.getTitle();
                        desc  = tpl.getDescription();
                        freq  = tpl.getFrequency();
                        schedTime = tpl.getScheduledTime();
                    } else {
                        title = req.getParameter("title");
                        desc  = req.getParameter("description");
                        freq  = req.getParameter("frequency");
                        String t = req.getParameter("scheduledTime");
                        schedTime = (t != null && !t.isEmpty())
                                ? Time.valueOf(t)
                                : new Time(System.currentTimeMillis());
                    }
                    int newArea = Integer.parseInt(req.getParameter("areaId"));
                    int staff  = Integer.parseInt(req.getParameter("staffId"));
                    int newId = dao.insertSchedule(title, desc, freq, schedTime, user.getId());
                    if (newId > 0) dao.insertLog(newId, staff, newArea);
                    break;

                case "complete":
                    // Đây là hành động staff hoàn thành một MaintenanceLog
                    dao.updateLogStatus(
                            Integer.parseInt(req.getParameter("logId")), "Done"
                    );
                    break;

                case "submitWeekStatus":
                    String[] days = req.getParameterValues("dates");
                    LocalDate td = LocalDate.now();
                    if (days == null || !Arrays.asList(days).contains(td.toString())) {
                        req.setAttribute("error", "Bạn phải tick ngày hôm nay trước khi submit.");
                        doGet(req, resp);
                        return;
                    }
                    int schedId = Integer.parseInt(req.getParameter("scheduleId"));
                    int weekArea = Integer.parseInt(req.getParameter("areaId"));
                    // Sử dụng dao.insertLogOnDate thay vì MaintenanceLogDAO nếu bạn đã di chuyển nó sang MaintenanceDAO
                    // Hoặc đảm bảo MaintenanceLogDAO được khởi tạo và sử dụng đúng cách
                    MaintenanceLogDAO weekDao = new MaintenanceLogDAO(); // Giữ lại nếu bạn có lý do riêng để dùng 2 DAO
                    for (String d : days) {
                        LocalDate ld = LocalDate.parse(d);
                        if (!weekDao.checkLogExists(schedId, user.getId(), ld)) { // Giả định checkLogExists nằm trong MaintenanceLogDAO
                            weekDao.insertLog(schedId, user.getId(), weekArea, ld, "Done");
                        }
                    }
                    break;

                case "request":
                    if (!role.equalsIgnoreCase("Staff")) {
                        resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                        return;
                    }
                    int areaReq = Integer.parseInt(req.getParameter("areaId"));
                    String rdesc = req.getParameter("description");
                    dao.insertRequest(new MaintenanceRequest(user.getId(), rdesc, areaReq));
                    break;

                case "acceptRequest":
                    if (!role.equalsIgnoreCase("Admin") && !role.equalsIgnoreCase("Manager")) {
                        resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                        return;
                    }
                    int requestId = Integer.parseInt(req.getParameter("id"));
                    String staffIdParam = req.getParameter("staffId");
                    if (staffIdParam == null || staffIdParam.isEmpty()) {
                        req.setAttribute("error", "Bạn phải chọn nhân viên trước khi chấp nhận.");
                        doGet(req, resp);
                        return;
                    }
                    int staffId = Integer.parseInt(staffIdParam);
                    // GỌI PHƯƠNG THỨC MỚI CỦA DAO: acceptRequest sẽ tạo log và cập nhật request.
                    dao.acceptRequest(requestId, staffId); // Tên phương thức vẫn là acceptRequest nhưng logic đã thay đổi trong DAO
                    resp.sendRedirect("MaintenanceServlet?action=list");
                    return;

                case "rejectRequest":
                    if (!role.equalsIgnoreCase("Admin") && !role.equalsIgnoreCase("Manager")) {
                        resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                        return;
                    }
                    int rejectId = Integer.parseInt(req.getParameter("id"));
                    dao.rejectRequest(rejectId);
                    resp.sendRedirect("MaintenanceServlet?action=list");
                    return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            doGet(req, resp);
            return;
        }

        // Sau khi xử lý POST, redirect về trang view phù hợp với vai trò
        if (role.equalsIgnoreCase("Staff")) {
            resp.sendRedirect("MaintenanceServlet?action=staffView");
        } else {
            resp.sendRedirect("MaintenanceServlet?action=list");
        }
    }
}
package controller;
import dal.MaintenanceDAO;
import model.MaintenanceLog;
import model.MaintenanceRequest;
import model.MaintenanceSchedule;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Time;
import java.util.*;


@WebServlet("/MaintenanceServlet")

public class MaintenanceServlet extends HttpServlet {

    private MaintenanceDAO dao;

    @Override

    public void init() throws ServletException {

        dao = new MaintenanceDAO();

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
                    List<MaintenanceRequest> requests = dao.getAllRequests();
                    List<User> staffs = dao.getAllStaff();
                    // Lấy tất cả các MaintenanceLog
                    List<MaintenanceLog> allLogs = dao.getAllMaintenanceLogs(); // <-- Dòng này gọi phương thức đã cập nhật trong DAO

                    req.setAttribute("schedules", templates);
                    req.setAttribute("requests", requests);
                    req.setAttribute("staffs", staffs);
                    req.setAttribute("allMaintenanceLogs", allLogs); // <-- Truyền danh sách logs sang JSP

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

            // Lấy danh sách các thông báo CHƯA ĐỌC cho staff hiện tại
            List<String> unreadNotifications = dao.getUnreadNotifications(user.getId());
            req.setAttribute("unreadNotifications", unreadNotifications);
            if (!unreadNotifications.isEmpty()) {
                dao.markNotificationsAsRead(user.getId()); // Đánh dấu đã đọc sau khi lấy
            }

            // Lấy danh sách MaintenanceLog (BAO GỒM CẢ CÁC LOG TẠO TỪ YÊU CẦU ĐÃ CHẤP NHẬN)
            List<MaintenanceLog> logs = dao.getLogsByStaff(user.getId());
            req.setAttribute("logs", logs);

            // Lấy TẤT CẢ request mà staff hiện tại đã gửi
            List<MaintenanceRequest> mySentRequests = dao.getMySentRequests(user.getId());

            // Khởi tạo các danh sách để phân loại các yêu cầu đã gửi
            List<MaintenanceRequest> myProcessingRequests = new ArrayList<>();
            List<MaintenanceRequest> myAcceptedRequests = new ArrayList<>();
            List<MaintenanceRequest> myRejectedRequests = new ArrayList<>();

            // Phân loại các yêu cầu đã gửi dựa trên trạng thái của chúng
            for (MaintenanceRequest requestItem : mySentRequests) {
                // Trạng thái 'Processing' được map từ 'Open' trong DAO
                if ("Processing".equals(requestItem.getStatus())) {
                    myProcessingRequests.add(requestItem);
                }
                // Trạng thái 'Transferred' trong DB tương ứng với 'Accepted' hiển thị cho người dùng
                else if ("Transferred".equals(requestItem.getStatus())) {
                    // Có thể set lại status cho mục đích hiển thị trong JSP nếu muốn
                    requestItem.setStatus("Accepted"); // Ví dụ: hiển thị "Đã chấp nhận"
                    myAcceptedRequests.add(requestItem);
                }
                // Trạng thái 'Rejected' trong DB
                else if ("Rejected".equals(requestItem.getStatus())) {
                    myRejectedRequests.add(requestItem);
                }
                // Các trạng thái khác (nếu có), bạn có thể thêm logic ở đây
            }

            // Đặt các danh sách đã phân loại vào request attribute để truyền sang JSP
            req.setAttribute("myProcessingRequests", myProcessingRequests);
            req.setAttribute("myAccepted", myAcceptedRequests);
            req.setAttribute("myRejected", myRejectedRequests);

            // KHÔNG CẦN DÙNG NỮA: Yêu cầu được phân công cho tôi (assignedRequests)
            // Vì các yêu cầu được chấp nhận và phân công giờ đây đã trở thành MaintenanceLog
            // và được hiển thị trong phần "Công việc định kỳ" (biến 'logs').
            // List<MaintenanceRequest> assignedRequests = dao.getAssignedRequestsForStaff(user.getId());
            // req.setAttribute("assigned", assignedRequests);

            req.getRequestDispatcher("maintenance-staff.jsp").forward(req, resp);
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

                        // FIX START: Ensure scheduledTime is in "hh:mm:ss" format
                        if (t != null && !t.isEmpty()) {
                            // Check if seconds are missing (e.g., "10:30")
                            if (t.matches("^\\d{2}:\\d{2}$")) { // Regex to check for HH:MM format
                                t += ":00"; // Append ":00" for seconds
                            }
                            schedTime = Time.valueOf(t);
                        } else {
                            schedTime = new Time(System.currentTimeMillis()); // Default to current time if empty
                        }
                        // FIX END

                    }
                    int newArea = Integer.parseInt(req.getParameter("areaId"));
                    int staff  = Integer.parseInt(req.getParameter("staffId"));
                    int newId = dao.insertSchedule(title, desc, freq, schedTime, user.getId());
                    if (newId > 0) dao.insertLog(newId, staff, newArea);
                    break;

                case "complete":
                    dao.updateLogStatus(
                            Integer.parseInt(req.getParameter("logId")), "Done"
                    );
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
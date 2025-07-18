package controller;

import dal.MaintenanceDAO;
import dal.MaintenanceLogDAO;
import model.MaintenanceLog;
import model.MaintenanceRequest;
import model.MaintenanceSchedule;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.text.SimpleDateFormat;
import java.time.*;
import java.util.*;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.Arrays;


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
        String role = user.getRole().getName();
        String action = req.getParameter("action");
        if (action == null) {
            action = role.equalsIgnoreCase("Staff") ? "staffView" : "list";
        }

        switch (action) {
            case "list":
                if (role.equalsIgnoreCase("Admin") || role.equalsIgnoreCase("Manager")) {
                    List<MaintenanceSchedule> templates = dao.getAllTemplates();
                    req.setAttribute("schedules", templates);
                    req.getRequestDispatcher("maintenance.jsp").forward(req, resp);
                } else {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                }
                break;

            case "staffView":
                if (role.equalsIgnoreCase("Staff")) {
                    List<MaintenanceLog> logs = dao.getLogsByStaff(user.getId());
                    req.setAttribute("logs", logs);
                    req.getRequestDispatcher("maintenance-staff.jsp").forward(req, resp);
                } else {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                }
                break;

            case "staffDetail":
                int scheduleId = Integer.parseInt(req.getParameter("scheduleId"));
                LocalDate today       = LocalDate.now();
                LocalDate startOfWeek = today.with(DayOfWeek.MONDAY);
                LocalDate endOfWeek   = today.with(DayOfWeek.SUNDAY);

                MaintenanceSchedule sch = dao.getTemplateById(scheduleId);
                req.setAttribute("schedule", sch);

                // Lấy tuần logs
                List<MaintenanceLog> weekLogs = dao.getLogsForWeek(scheduleId, user.getId());
                req.setAttribute("weekLogs", weekLogs);

                // Build dailyStatus map
                Map<String, Boolean> dailyStatus = new LinkedHashMap<>();
                for (int i = 0; i < 7; i++) {
                    LocalDate d = startOfWeek.plusDays(i);
                    boolean done = weekLogs.stream().anyMatch(log -> {
                        // Chuyển java.sql.Date về LocalDate
                        LocalDate logDate = ((java.sql.Date) log.getMaintenanceDate()).toLocalDate();
                        return logDate.equals(d) && "Done".equals(log.getStatus());
                    });
                    dailyStatus.put(d.getDayOfWeek().toString(), done);
                }
                req.setAttribute("dailyStatus", dailyStatus);

                // Tính weekStatus
                String weekStatus = today.isBefore(endOfWeek)
                        ? "Doing"
                        : (dailyStatus.values().stream().allMatch(v -> v) ? "Done" : "Missed");
                req.setAttribute("weekStatus", weekStatus);

                // Lấy areaId để form post
                int areaId = weekLogs.isEmpty()
                        ? sch.getPoolAreaId()
                        : weekLogs.get(0).getPoolAreaId();
                req.setAttribute("areaId", areaId);

                req.getRequestDispatcher("maintenance-week.jsp").forward(req, resp);
                return;

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

            default:
                resp.sendRedirect("MaintenanceServlet");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        String role = user.getRole().getName();
        String action = req.getParameter("action");

        switch (action) {
            case "create":
                String tplParam = req.getParameter("templateId");
                String title, description, frequency;
                Time schedTime;
                if (tplParam != null && !tplParam.isEmpty()) {
                    int tplId = Integer.parseInt(tplParam);
                    MaintenanceSchedule tpl = dao.getTemplateById(tplId);
                    title = tpl.getTitle();
                    description = tpl.getDescription();
                    frequency = tpl.getFrequency();
                    schedTime = tpl.getScheduledTime();
                } else {
                    title = req.getParameter("title");
                    description = req.getParameter("description");
                    frequency = req.getParameter("frequency");
                    String t = req.getParameter("scheduledTime");
                    schedTime = (t != null && !t.isEmpty())
                            ? Time.valueOf(t)
                            : new Time(System.currentTimeMillis());
                }
                int areaId = Integer.parseInt(req.getParameter("areaId"));
                int staffId = Integer.parseInt(req.getParameter("staffId"));

                int newScheduleId = dao.insertSchedule(title, description, frequency, schedTime, user.getId());
                if (newScheduleId > 0) {
                    dao.insertLog(newScheduleId, staffId, areaId);
                }
                break;

            case "complete":
                int logId = Integer.parseInt(req.getParameter("logId"));
                dao.updateLogStatus(logId, "Done");
                break;

            case "completeWeek":
                int scheduleId = Integer.parseInt(req.getParameter("scheduleId"));
                int weekAreaId = Integer.parseInt(req.getParameter("areaId"));
                // lấy các ngày được check
                String[] dates = req.getParameterValues("dates");
                Set<String> sel = dates == null
                        ? Collections.emptySet()
                        : new HashSet<>(Arrays.asList(dates));

                // build tuần Mon→Sun
                SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");
                Calendar cal = Calendar.getInstance();
                int dow = cal.get(Calendar.DAY_OF_WEEK);
                cal.add(Calendar.DATE, (dow == Calendar.SUNDAY ? -6 : Calendar.MONDAY - dow));
                List<String> week = new ArrayList<>();
                for (int i = 0; i < 7; i++) {
                    week.add(fmt.format(cal.getTime()));
                    cal.add(Calendar.DATE, 1);
                }

                // chèn log cho mỗi ngày
                for (String d : week) {
                    Date date = Date.valueOf(d);
                    if (sel.contains(d)) {
                        dao.insertLogOnDate(scheduleId, user.getId(), weekAreaId, date, "Done");
                    } else {
                        dao.insertLogOnDate(scheduleId, user.getId(), weekAreaId, date, "Missed");
                    }
                }
                break;

            case "request":
                int areaReq = Integer.parseInt(req.getParameter("areaId"));
                String reqDesc = req.getParameter("description");
                // Sửa lại dòng này để truyền cả areaId
                dao.insertRequest(new MaintenanceRequest(user.getId(), reqDesc, areaReq));
                break;

            case "submitWeekStatus":
                int scheduleId1 = Integer.parseInt(req.getParameter("scheduleId"));
                int areaId1     = Integer.parseInt(req.getParameter("areaId"));
                String[] days   = req.getParameterValues("dates");

                LocalDate today = LocalDate.now();
                if (days == null || !Arrays.asList(days).contains(today.toString())) {
                    req.setAttribute("error", "Bạn phải tick ngày hôm nay trước khi submit.");
                    req.setAttribute("scheduleId", scheduleId1);
                    doGet(req, resp);
                    return;
                }

                MaintenanceLogDAO logDao = new MaintenanceLogDAO();
                for (String d : days) {
                    java.sql.Date sqlDate   = java.sql.Date.valueOf(d);
                    LocalDate localDate     = sqlDate.toLocalDate();
                    if (!logDao.checkLogExists(scheduleId1, user.getId(), localDate)) {
                        logDao.insertLog(scheduleId1, user.getId(), areaId1, localDate, "Done");
                    }
                }

                // Thay vì gửi về staffDetail, ta redirect về staffView:
                resp.sendRedirect("MaintenanceServlet?action=staffView");
                return;

        }

        if (role.equalsIgnoreCase("Staff")) {
            resp.sendRedirect("MaintenanceServlet?action=staffView");
        } else {
            resp.sendRedirect("MaintenanceServlet?action=list");
        }
    }
}

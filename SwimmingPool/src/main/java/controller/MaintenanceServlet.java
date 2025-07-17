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
import java.time.DayOfWeek;
import java.time.LocalDate;
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
                // scheduleId truyền qua URL hoặc doPost gán attribute
                int scheduleId = -1;
                try {
                    scheduleId = Integer.parseInt(req.getParameter("scheduleId"));
                } catch (Exception e) {
                    Object attr = req.getAttribute("scheduleId");
                    if (attr != null) {
                        scheduleId = (Integer) attr;
                    } else {
                        resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing scheduleId");
                        return;
                    }
                }

                LocalDate today = LocalDate.now();
                LocalDate startOfWeek = today.with(DayOfWeek.MONDAY);
                LocalDate endOfWeek = today.with(DayOfWeek.SUNDAY);

                MaintenanceSchedule sch = dao.getTemplateById(scheduleId);
                req.setAttribute("schedule", sch);

                List<LocalDate> doneDays = new MaintenanceLogDAO()
                        .getCompletedDays(user.getId(), scheduleId, startOfWeek);

                Map<String, Boolean> dailyStatus = new LinkedHashMap<>();
                for (int i = 0; i < 7; i++) {
                    LocalDate d = startOfWeek.plusDays(i);
                    dailyStatus.put(d.getDayOfWeek().toString(), doneDays.contains(d));
                }
                req.setAttribute("dailyStatus", dailyStatus);

                String weekStatus = today.isBefore(endOfWeek) ? "Doing"
                        : (doneDays.size() == 7 ? "Done" : "Missed");
                req.setAttribute("weekStatus", weekStatus);

                req.getRequestDispatcher("maintenance_week.jsp").forward(req, resp);
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
                dao.insertRequest(new MaintenanceRequest(user.getId(), reqDesc));
                break;

            case "submitWeekStatus":
                int scheduleId1 = Integer.parseInt(req.getParameter("scheduleId"));
                int areaId1     = Integer.parseInt(req.getParameter("areaId"));
                String[] checkedDays = req.getParameterValues("completedDays");

                LocalDate today = LocalDate.now();
                String todayName = today.getDayOfWeek().toString();

                if (checkedDays == null || !Arrays.asList(checkedDays).contains(todayName)) {
                    req.setAttribute("error", "Bạn phải tick chọn ngày hôm nay trước khi submit.");
                    req.setAttribute("scheduleId", scheduleId1); // 👈 Gán lại cho doGet dùng
                    doGet(req, resp); // 👈 Gọi lại staffDetail
                    return;
                }

                LocalDate weekStart = today.with(DayOfWeek.MONDAY);
                MaintenanceLogDAO logDao = new MaintenanceLogDAO();
                for (String dayName : checkedDays) {
                    DayOfWeek dayOfWeek = DayOfWeek.valueOf(dayName.toUpperCase());
                    LocalDate date = weekStart.plusDays(dayOfWeek.getValue() - 1);
                    if (!logDao.checkLogExists(scheduleId1, user.getId(), date)) {
                        logDao.insertLog(scheduleId1, user.getId(), areaId1, date, "Done");
                    }
                }

                resp.sendRedirect("MaintenanceServlet?action=staffDetail&scheduleId=" + scheduleId1);
                return;
        }

        if (role.equalsIgnoreCase("Staff")) {
            resp.sendRedirect("MaintenanceServlet?action=staffView");
        } else {
            resp.sendRedirect("MaintenanceServlet?action=list");
        }
    }
}

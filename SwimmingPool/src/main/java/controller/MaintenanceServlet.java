package controller;

import dal.MaintenanceDAO;
import model.MaintenanceLog;
import model.MaintenanceRequest;
import model.MaintenanceSchedule;
import model.PoolArea;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

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
        String action = req.getParameter("action");
        if (action == null) {
            action = user.getRole().getName().equalsIgnoreCase("Staff") ? "staffView" : "list";
        }

        switch (action) {
            case "list":
                if (user.getRole().getName().equalsIgnoreCase("Admin") || user.getRole().getName().equalsIgnoreCase("Manager")) {
                    List<MaintenanceSchedule> templates = dao.getAllTemplates();
                    req.setAttribute("schedules", templates);
                    req.getRequestDispatcher("maintenance.jsp").forward(req, resp);
                } else {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                }
                break;

            case "staffView":
                if (user.getRole().getName().equalsIgnoreCase("Staff")) {
                    List<MaintenanceLog> logs = dao.getLogsByStaff(user.getId());
                    req.setAttribute("logs", logs);
                    req.getRequestDispatcher("maintenance-staff.jsp").forward(req, resp);
                } else {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                }
                break;

            case "showForm":
                if (user.getRole().getName().equalsIgnoreCase("Admin") || user.getRole().getName().equalsIgnoreCase("Manager")) {
                    req.setAttribute("templates", dao.getAllTemplates());
                    req.setAttribute("areas", dao.getAllPoolAreas());
                    req.setAttribute("staffs", dao.getAllStaff());
                    req.getRequestDispatcher("maintenance-form.jsp").forward(req, resp);
                } else {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                }
                break;

            case "showRequestForm":
                if (user.getRole().getName().equalsIgnoreCase("Staff")) {
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
        String action = req.getParameter("action");

        switch (action) {
            case "create":
                int tplId   = Integer.parseInt(req.getParameter("templateId"));
                int areaId  = Integer.parseInt(req.getParameter("areaId"));
                int staffId = Integer.parseInt(req.getParameter("staffId"));
                MaintenanceSchedule tpl = dao.getTemplateById(tplId);
                tpl.setPoolAreaId(areaId);
                tpl.setStaffId(staffId);
                tpl.setCreatedBy(user.getId());
                dao.insertSchedule(tpl);
                break;

            case "complete":
                int logId = Integer.parseInt(req.getParameter("logId"));
                dao.updateLogStatus(logId, "Done");
                break;

            case "request":
                int aId    = Integer.parseInt(req.getParameter("areaId"));
                String desc= req.getParameter("description");
                MaintenanceRequest r = new MaintenanceRequest(user.getId(), desc);
                dao.insertRequest(r);
                break;
        }

        if (user.getRole().getName().equalsIgnoreCase("Staff")) {
            resp.sendRedirect("MaintenanceServlet?action=staffView");
        } else {
            resp.sendRedirect("MaintenanceServlet?action=list");
        }
    }
}

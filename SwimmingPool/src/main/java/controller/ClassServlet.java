package controller;

import dal.ClassDAO;
import model.Class;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

public class ClassServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try (Connection conn = utils.DBConnect.getConnection()) {
            ClassDAO dao = new ClassDAO(conn);

            if ("add".equals(action)) {
                request.getRequestDispatcher("/class-form.jsp").forward(request, response);

            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Class c = dao.getById(id);
                request.setAttribute("class", c);
                request.getRequestDispatcher("/class-form.jsp").forward(request, response);

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.delete(id);
                response.sendRedirect("class-list");

            } else {
                List<Class> list = dao.getAll();
                request.setAttribute("classes", list);
                request.getRequestDispatcher("/class-list.jsp").forward(request, response);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try (Connection conn = utils.DBConnect.getConnection()) {
            ClassDAO dao = new ClassDAO(conn);

            int id = request.getParameter("id") != null && !request.getParameter("id").isEmpty()
                    ? Integer.parseInt(request.getParameter("id")) : 0;

            String name = request.getParameter("name");
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            int coachId = Integer.parseInt(request.getParameter("coachId"));
            String status = request.getParameter("status");
            String note = request.getParameter("note");

            Class c = new Class();
            c.setName(name);
            c.setCourseId(courseId);
            c.setCoachId(coachId);
            c.setStatus(status);
            c.setNote(note);

            if (id > 0) {
                c.setId(id);
                dao.update(c);
            } else {
                dao.insert(c);
            }

            response.sendRedirect("class-list");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

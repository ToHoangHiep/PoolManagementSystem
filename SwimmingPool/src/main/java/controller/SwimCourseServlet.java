package controller;

import dal.CoachDAO;
import dal.SwimCourseDAO;
import model.SwimCourse;
import model.Coach;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

public class SwimCourseServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try (Connection conn = utils.DBConnect.getConnection()) {
            SwimCourseDAO courseDAO = new SwimCourseDAO(conn);
            CoachDAO coachDAO = new CoachDAO(conn);

            if ("add".equals(action)) {
                List<Coach> coaches = coachDAO.getAllCoaches();
                request.setAttribute("coaches", coaches);
                request.getRequestDispatcher("/add_course.jsp").forward(request, response);
                return;
            } else if ("edit".equals(action)) {
                int courseId = Integer.parseInt(request.getParameter("id"));
                SwimCourse course = courseDAO.getCourseById(courseId);
                List<Coach> coaches = coachDAO.getAllCoaches();
                request.setAttribute("course", course);
                request.setAttribute("coaches", coaches);
                request.getRequestDispatcher("/edit_course.jsp").forward(request, response);
                return;
            } else if ("delete".equals(action)) {
                int courseId = Integer.parseInt(request.getParameter("id"));
                courseDAO.deleteCourse(courseId);
                response.sendRedirect("swimcourse");
                return;
            }

            List<SwimCourse> courses = courseDAO.getAllCoursesWithCoach();
            request.setAttribute("courses", courses);
            request.getRequestDispatcher("/swimcourse.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try (Connection conn = utils.DBConnect.getConnection()) {
            SwimCourseDAO courseDAO = new SwimCourseDAO(conn);

            int id = request.getParameter("id") != null ? Integer.parseInt(request.getParameter("id")) : 0;
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            int duration = Integer.parseInt(request.getParameter("duration"));
            int coachId = Integer.parseInt(request.getParameter("coachId"));

            SwimCourse course = new SwimCourse();
            course.setName(name);
            course.setDescription(description);
            course.setPrice(price);
            course.setDuration(duration);
            course.setCoachId(coachId);
            course.setStatus("Inactive");

            if (id > 0) {
                course.setId(id);
                courseDAO.updateCourse(course);
            } else {
                courseDAO.addCourse(course);
            }

            response.sendRedirect("swimcourse");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

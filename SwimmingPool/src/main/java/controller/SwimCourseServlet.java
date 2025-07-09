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
                request.getRequestDispatcher("/swimcourse.jsp").forward(request, response);
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

            courseDAO.addCourse(course);
            response.sendRedirect("swimcourse");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
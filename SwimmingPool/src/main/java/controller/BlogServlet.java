package controller;

import dal.CoachDAO;
import dal.CourseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet; // Make sure this is imported
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Coach;
import model.Course;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Collections;
import java.util.List;
import java.util.Map;

public class BlogServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Default action
        }

        try {
            switch (action) {
                case "view_coach":
                    viewCoach(request, response);
                    break;
                // Add this new case to handle viewing a course's details
                case "view_course":
                    viewCourse(request, response);
                    break;
                case "list":
                default:
                    listDirectory(request, response);
                    break;
            }
        } catch (Exception e) {
            log("Error in BlogsServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    /**
     * Fetches details for a single coach and forwards to the coach details page.
     */
    private void viewCoach(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        try {
            int coachId = Integer.parseInt(request.getParameter("coachId"));
            Coach coach = CoachDAO.getCoachById(coachId);

            if (coach == null) {
                request.getSession().setAttribute("alert_message", "The requested coach could not be found.");
                response.sendRedirect("blogs"); // Redirect to the main directory
                return;
            }

            request.setAttribute("coach", coach);
            request.getRequestDispatcher("blog_coach.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("alert_message", "Invalid coach ID provided.");
            response.sendRedirect("blogs");
        }
    }

    /**
     * Fetches details for a single course and forwards to the course details page.
     */
    private void viewCourse(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            Course course = CourseDAO.getCourseById(courseId);

            if (course == null) {
                request.getSession().setAttribute("alert_message", "The requested course could not be found.");
                response.sendRedirect("blogs"); // Redirect to the main directory
                return;
            }

            // Get the registration count for this specific course
            Map<Integer, Integer> courseCounts = CourseDAO.getCourseRegistrationCounts();
            int registrationCount = courseCounts.getOrDefault(courseId, 0);

            request.setAttribute("course", course);
            request.setAttribute("registrationCount", registrationCount);
            request.getRequestDispatcher("blog_course.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("alert_message", "Invalid course ID provided.");
            response.sendRedirect("blogs");
        }
    }

    /**
     * Fetches all data needed for the main directory page (blogs.jsp) and forwards to it.
     */
    private void listDirectory(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        // ... (this method remains the same)
        List<Course> courses = CourseDAO.getAllCourses();
        List<Coach> coaches = CoachDAO.getAllCoaches();
        Map<Integer, Integer> courseCounts = CourseDAO.getCourseRegistrationCounts();
        request.setAttribute("courses", courses != null ? courses : Collections.emptyList());
        request.setAttribute("coaches", coaches != null ? coaches : Collections.emptyList());
        request.setAttribute("courseCounts", courseCounts != null ? courseCounts : Collections.emptyMap());
        request.getRequestDispatcher("blog_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
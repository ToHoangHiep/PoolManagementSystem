package controller;

import dal.SwimCourseDAO;
import model.SwimCourse;
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

            if ("add".equals(action)) {
                request.getRequestDispatcher("/add_course.jsp").forward(request, response);
                return;
            } else if ("edit".equals(action)) {
                int courseId = Integer.parseInt(request.getParameter("id"));
                SwimCourse course = courseDAO.getCourseById(courseId);
                request.setAttribute("course", course);
                request.getRequestDispatcher("/edit_course.jsp").forward(request, response);
                return;
            } else if ("delete".equals(action)) {
                int courseId = Integer.parseInt(request.getParameter("id"));
                courseDAO.deleteCourse(courseId);
                response.sendRedirect("swimcourse");
                return;
            }


            // Mặc định: hiển thị danh sách
            List<SwimCourse> courses = courseDAO.getAllCourses();
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

            int id = request.getParameter("id") != null && !request.getParameter("id").isEmpty()
                    ? Integer.parseInt(request.getParameter("id")) : 0;

            String name = request.getParameter("name");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            int duration = Integer.parseInt(request.getParameter("duration"));
            String estimatedSessionTime = request.getParameter("estimatedSessionTime");
            String studentDescription = request.getParameter("studentDescription");
            String scheduleDescription = request.getParameter("scheduleDescription");

            SwimCourse course = new SwimCourse();
            course.setName(name);
            course.setDescription(description);
            course.setPrice(price);
            course.setDuration(duration);
            course.setEstimatedSessionTime(estimatedSessionTime);
            course.setStudentDescription(studentDescription);
            course.setScheduleDescription(scheduleDescription);
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

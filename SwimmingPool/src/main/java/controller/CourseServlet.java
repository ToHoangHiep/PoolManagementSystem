package controller;

import dal.SwimCourseDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.SwimCourse;

import java.io.IOException;
import java.sql.*;
import java.util.*;

public class CourseServlet extends HttpServlet {

    private int defaultCoachId = 3;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try (Connection conn = utils.DBConnect.getConnection()) {
            SwimCourseDAO dao = new SwimCourseDAO(conn);

            String status = request.getParameter("status");
            String keyword = request.getParameter("keyword");
            List<SwimCourse> courses = dao.getCoursesByCoach(defaultCoachId, status, keyword);
            request.setAttribute("courses", courses);

            if (action == null || action.isEmpty()) {
                // Luôn load danh sách khi action null hoặc rỗng
                request.getRequestDispatcher("/courselist.jsp").forward(request, response);
                return;
            }

            switch (action) {
                case "edit": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    SwimCourse course = dao.getById(id);
                    request.setAttribute("course", course);
                    request.getRequestDispatcher("/edit_course.jsp").forward(request, response);
                    break;
                }
                case "add": {
                    request.getRequestDispatcher("/add_course.jsp").forward(request, response);
                    break;
                }
                case "delete": {
                    int id = Integer.parseInt(request.getParameter("id"));

                    boolean hasRegistrations = dao.hasRegistrations(id);
                    if (hasRegistrations) {
                        request.setAttribute("error", "Không thể xóa khóa học vì đã có học viên đăng ký.");
                        request.getRequestDispatcher("/courselist.jsp").forward(request, response);
                    } else {
                        dao.deleteCourse(id);
                        response.sendRedirect("coachcourse");
                    }
                    break;
                }
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try (Connection conn = utils.DBConnect.getConnection()) {
            SwimCourseDAO dao = new SwimCourseDAO(conn);

            switch (action == null ? "" : action) {
                case "add": {
                    try {
                        SwimCourse c = new SwimCourse();
                        c.setName(request.getParameter("name"));
                        c.setDescription(request.getParameter("description"));
                        c.setPrice(Double.parseDouble(request.getParameter("price")));
                        c.setDuration(Integer.parseInt(request.getParameter("duration")));
                        c.setCoachId(defaultCoachId);

                        dao.addCourse(c);
                        System.out.println(">>> Đã thêm khóa học: " + c.getName());
                        response.sendRedirect("coachcourse");
                    } catch (NumberFormatException e) {
                        request.setAttribute("error", "Giá hoặc thời lượng không hợp lệ.");
                        request.getRequestDispatcher("/add_course.jsp").forward(request, response);
                    }
                    break;
                }
                case "edit": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    String name = request.getParameter("name");
                    String description = request.getParameter("description");
                    double price = Double.parseDouble(request.getParameter("price"));
                    int duration = Integer.parseInt(request.getParameter("duration"));

                    SwimCourse course = new SwimCourse();
                    course.setId(id);
                    course.setName(name);
                    course.setDescription(description);
                    course.setPrice(price);
                    course.setDuration(duration);
                    course.setCoachId(defaultCoachId);

                    dao.updateCourse(course);
                    response.sendRedirect("coachcourse");
                    break;
                }
                case "delete": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    boolean hasRegistrations = dao.hasRegistrations(id);
                    if (hasRegistrations) {
                        request.setAttribute("error", "Không thể xóa khóa học vì đã có học viên đăng ký.");
                        List<SwimCourse> courses = dao.getCoursesByCoach(defaultCoachId, null, null);
                        request.setAttribute("courses", courses);
                        request.getRequestDispatcher("/courselist.jsp").forward(request, response);
                    } else {
                        dao.deleteCourse(id);
                        response.sendRedirect("coachcourse");
                    }
                    break;
                }
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

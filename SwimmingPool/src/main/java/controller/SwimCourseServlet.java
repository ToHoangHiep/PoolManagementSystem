package controller;

import dal.SwimCourseDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.SwimCourse;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

public class SwimCourseServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");
        if (keyword == null) keyword = "";
        if (status == null) status = "";

        try (Connection conn = utils.DBConnect.getConnection()) {
            SwimCourseDAO dao = new SwimCourseDAO(conn);

            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.deleteCourse(id);
                response.sendRedirect("swimcourse");
                return;

            } else if ("toggleStatus".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.toggleStatus(id);
                response.sendRedirect("swimcourse");
                return;
            }

            // Load danh sách tất cả các khóa học (do coach yêu cầu tạo)
            List<SwimCourse> courses = dao.getAllCoursesByCoachRequest(status, keyword);
            request.setAttribute("courses", courses);
            request.getRequestDispatcher("/swimcourse.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

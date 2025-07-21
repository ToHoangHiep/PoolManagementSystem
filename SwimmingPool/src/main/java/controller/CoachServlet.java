package controller;

import dal.CoachDAO;
import model.Coach;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

public class CoachServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try (Connection conn = utils.DBConnect.getConnection()) {
            CoachDAO dao = new CoachDAO(conn);

            if ("add".equals(action)) {
                request.getRequestDispatcher("/coach-form.jsp").forward(request, response);

            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Coach coach = dao.getById(id);
                request.setAttribute("coach", coach);
                request.getRequestDispatcher("/coach-form.jsp").forward(request, response);

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
//                if (dao.isCoachUsed(id)) {
//                    request.setAttribute("error", "Không thể xóa vì huấn luyện viên đang được phân công lớp học.");
//                    List<Coach> list = dao.getAll();
//                    request.setAttribute("coaches", list);
//                    request.getRequestDispatcher("/coach-list.jsp").forward(request, response);
//                }
//                else {
//
//                }
                dao.delete(id);
                response.sendRedirect("coach");

            } else {
                // Mặc định hiển thị danh sách
                List<Coach> list = dao.getAll();
                request.setAttribute("coaches", list);
                request.getRequestDispatcher("/coach-list.jsp").forward(request, response);
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try (Connection conn = utils.DBConnect.getConnection()) {
            CoachDAO dao = new CoachDAO(conn);

            int id = request.getParameter("id") != null && !request.getParameter("id").isEmpty()
                    ? Integer.parseInt(request.getParameter("id")) : 0;

            String name = request.getParameter("fullName");
            String phone = request.getParameter("phoneNumber");
            String email = request.getParameter("email");
            String gender = request.getParameter("gender");
            String bio = request.getParameter("bio");
            String picture = request.getParameter("profilePicture");

            Coach coach = new Coach();
            coach.setFullName(name);
            coach.setPhone(phone);
            coach.setEmail(email);
            coach.setGender(gender);
            coach.setBio(bio);
            coach.setProfilePicture(picture);

            if (id > 0) {
                coach.setId(id);
                dao.update(coach);
            } else {
                dao.insert(coach);
            }

            response.sendRedirect("coach");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

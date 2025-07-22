package controller;

import dal.CoachDAO;
import model.Coach;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,       // 1MB
        maxFileSize = 5 * 1024 * 1024,         // 5MB
        maxRequestSize = 10 * 1024 * 1024      // 10MB
)
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
                if (dao.isCoachUsed(id)) {
                    request.setAttribute("error", "Không thể xóa vì huấn luyện viên đang được phân công lớp học.");
                    List<Coach> list = dao.getAll();
                    request.setAttribute("coaches", list);
                    request.getRequestDispatcher("/coach-list.jsp").forward(request, response);
                } else {
                    dao.delete(id);
                    response.sendRedirect("coach-list");
                }

            } else {
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
            request.setCharacterEncoding("UTF-8");

            int id = request.getParameter("id") != null && !request.getParameter("id").isEmpty()
                    ? Integer.parseInt(request.getParameter("id")) : 0;

            String name = request.getParameter("fullName");
            String phone = request.getParameter("phoneNumber");
            String email = request.getParameter("email");
            String gender = request.getParameter("gender");
            String bio = request.getParameter("bio");
            boolean isActive = request.getParameter("active") != null;

            // 👇 Lưu ảnh vào thư mục cố định trong thư mục webapp/images
            Part filePart = request.getPart("profilePicture");
            String fileName = null;

            if (filePart != null && filePart.getSize() > 0) {
                fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();

                // Lưu vào thư mục webapp/images
                String uploadDir = getServletContext().getRealPath("/images");
                File dir = new File(uploadDir);
                if (!dir.exists()) dir.mkdirs();

                filePart.write(uploadDir + File.separator + fileName);
            }

            Coach coach = new Coach();
            coach.setFullName(name);
            coach.setPhone(phone);
            coach.setEmail(email);
            coach.setGender(gender);
            coach.setBio(bio);
            coach.setActive(isActive);

            if (id > 0) {
                coach.setId(id);
                if (fileName != null) {
                    coach.setProfilePicture(fileName);
                } else {
                    coach.setProfilePicture(dao.getById(id).getProfilePicture());
                }
                dao.update(coach);
            } else {
                coach.setProfilePicture(fileName != null ? fileName : "");
                dao.insert(coach);
            }

            response.sendRedirect("coach-list");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

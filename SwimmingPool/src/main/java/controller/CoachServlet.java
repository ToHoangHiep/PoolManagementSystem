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
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 5 * 1024 * 1024,   // 5MB
        maxRequestSize = 10 * 1024 * 1024 // 10MB
)
public class CoachServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try (Connection conn = utils.DBConnect.getConnection()) {
            CoachDAO dao = new CoachDAO(conn);

            if ("add".equals(action)) {
                request.getRequestDispatcher("/coach-form.jsp").forward(request, response);
                return;
            }

            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Coach coach = dao.getCoachById(id);
                request.setAttribute("coach", coach);
                request.getRequestDispatcher("/coach-form.jsp").forward(request, response);
                return;
            }

            // Danh sách mặc định
            List<Coach> list = dao.getAllCoaches();
            request.setAttribute("coaches", list);
            request.getRequestDispatcher("/coach-list.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Lỗi xử lý GET: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        try (Connection conn = utils.DBConnect.getConnection()) {
            CoachDAO dao = new CoachDAO(conn);

            // XÓA HUẤN LUYỆN VIÊN
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.deleteCoach(id);
                response.sendRedirect("coach-list");
                return;
            }

            // THÊM / CẬP NHẬT
            int id = request.getParameter("id") != null && !request.getParameter("id").isEmpty()
                    ? Integer.parseInt(request.getParameter("id")) : 0;

            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phoneNumber");
            String gender = request.getParameter("gender");
            String bio = request.getParameter("bio");
            boolean active = request.getParameter("active") != null;

            // Xử lý file ảnh
            Part filePart = request.getPart("profilePicture");
            String fileName = null;
            if (filePart != null && filePart.getSize() > 0) {
                fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String uploadPath = getServletContext().getRealPath("/") + "images";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();
                filePart.write(uploadPath + File.separator + fileName);
            }

            Coach coach = new Coach();
            coach.setFullName(fullName);
            coach.setEmail(email);
            coach.setPhone(phone);
            coach.setGender(gender);
            coach.setBio(bio);
            coach.setActive(active);

            if (fileName != null) {
                coach.setProfilePicture(fileName);
            } else if (id > 0) {
                // nếu không upload ảnh mới, giữ nguyên ảnh cũ
                Coach old = dao.getCoachById(id);
                coach.setProfilePicture(old.getProfilePicture());
            }

            if (id > 0) {
                coach.setId(id);
                dao.updateCoach(coach);
            } else {
                dao.insertCoach(coach);
            }

            response.sendRedirect("coach-list");

        } catch (Exception e) {
            throw new ServletException("Lỗi xử lý POST: " + e.getMessage(), e);
        }
    }
}

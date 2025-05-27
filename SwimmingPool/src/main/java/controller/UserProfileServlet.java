package controller;

import dal.UserProfileDAO;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import model.UserProfile;
import utils.DBConnect;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Date;

@WebServlet("/userProfile")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class UserProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        try (var conn = DBConnect.getConnection()) {
            UserProfileDAO dao = new UserProfileDAO(conn);
            UserProfile profile = dao.getUserById(user.getId());

            if (profile == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User profile not found");
                return;
            }

            // Get flash message from session if available
            String message = (String) session.getAttribute("message");
            if (message != null) {
                request.setAttribute("message", message);
                session.removeAttribute("message");
            }

            request.setAttribute("user", profile);
            request.getRequestDispatcher("userprofile.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User userSession = (User) session.getAttribute("user");
        int userId = userSession.getId();

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phoneNumber");
        String gender = request.getParameter("gender");
        String address = request.getParameter("address");
        String email = request.getParameter("email");
        String dobString = request.getParameter("dob");

        Date dob = null;
        if (dobString != null && !dobString.trim().isEmpty()) {
            try {
                dob = Date.valueOf(dobString);
            } catch (IllegalArgumentException ignored) {
            }
        }

        // Handle avatar upload
        Part filePart = request.getPart("avatar");
        String avatarPath = null;

        // Upload directory inside webapp
        String uploadDirPath = getServletContext().getRealPath("/uploads");
        File uploadDir = new File(uploadDirPath);
        if (!uploadDir.exists()) {
            if (!uploadDir.mkdirs()) {
                throw new IOException("Cannot create uploads directory at " + uploadDirPath);
            }
        }

        if (filePart != null && filePart.getSize() > 0) {
            String submittedFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString(); // lấy tên file an toàn
            if (submittedFileName != null && !submittedFileName.isEmpty()) {
                String fileName = "user_" + userId + "_" + System.currentTimeMillis() + "_" + submittedFileName.replaceAll("[^a-zA-Z0-9\\.\\-_]", "_");
                File fileSaveDir = new File(uploadDirPath);
                if (!fileSaveDir.exists()) {
                    fileSaveDir.mkdirs();
                }
                String savePath = uploadDirPath + File.separator + fileName;
                try {
                    filePart.write(savePath);
                } catch (IOException e) {
                    e.printStackTrace();
                    throw new IOException("Error saving uploaded file", e);
                }
                avatarPath = "uploads/" + fileName;
            }



    }



        try (var conn = DBConnect.getConnection()) {
            UserProfileDAO dao = new UserProfileDAO(conn);
            String existingAvatar = dao.getUserById(userId).getProfile_picture();

            if (avatarPath == null || avatarPath.isEmpty()) {
                avatarPath = existingAvatar; // Keep old avatar if no new upload
            }

            UserProfile updated = new UserProfile(userId, fullName, phone, gender, address, dob, email, avatarPath);
            dao.updateUser(updated);

            // Update session message or keep as is
            session.setAttribute("message", "Profile updated successfully!");
            response.sendRedirect("userProfile");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating profile");
        }
    }
}

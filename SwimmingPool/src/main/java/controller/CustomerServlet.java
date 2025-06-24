package controller;

import dal.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Customer;
import model.User;
import utils.DBConnect;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Date;

@WebServlet("/userprofile")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50)
public class CustomerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User userSession = (User) session.getAttribute("user");

        try (var conn = DBConnect.getConnection()) {
            CustomerDAO dao = new CustomerDAO(conn);
            Customer profile = dao.getCustomerById(userSession.getId());

            if (profile == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User profile not found");
                return;
            }

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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

        Part filePart = request.getPart("avatar");
        String avatarPath = null;

        String uploadDirPath = getServletContext().getRealPath("/uploads");
        File uploadDir = new File(uploadDirPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        if (filePart != null && filePart.getSize() > 0) {
            String submittedFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String fileName = "user_" + userId + "_" + System.currentTimeMillis() + "_" +
                    submittedFileName.replaceAll("[^a-zA-Z0-9\\.\\-_]", "_");
            String savePath = uploadDirPath + File.separator + fileName;
            filePart.write(savePath);
            avatarPath = "uploads/" + fileName;
        }

        try (var conn = DBConnect.getConnection()) {
            CustomerDAO dao = new CustomerDAO(conn);
            Customer existing = dao.getCustomerById(userId);

            if (avatarPath == null || avatarPath.isEmpty()) {
                avatarPath = existing != null ? existing.getProfilePicture() : null;
            }

            Customer updated = new Customer(userId, fullName, phone, dob, gender, address, avatarPath, email);
            boolean success = dao.updateUser(updated);

            if (success) {
                session.setAttribute("message", "Profile updated successfully!");
                userSession.setFullName(updated.getFullName());
                session.setAttribute("user", userSession);
            } else {
                session.setAttribute("message", "Failed to update profile!");
            }
            response.sendRedirect("userprofile");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating profile");
        }
    }
}

package controller;

import dal.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Customer;
import model.User; // Đảm bảo lớp User tồn tại và có getId()
import utils.DBConnect;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Date;

@WebServlet("/userprofile")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50) // 50MB
public class CustomerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp"); // Chuyển hướng nếu chưa đăng nhập
            return;
        }

        User userSession = (User) session.getAttribute("user"); // Lấy đối tượng User từ session

        try (var conn = DBConnect.getConnection()) {
            CustomerDAO dao = new CustomerDAO(conn);
            // Lấy profile khách hàng từ DB; bây giờ nó sẽ có thông tin Role
            Customer profile = dao.getCustomerById(userSession.getId());

            if (profile == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User profile not found");
                return;
            }

            // Xử lý thông báo (nếu có)
            String message = (String) session.getAttribute("message");
            if (message != null) {
                request.setAttribute("message", message);
                session.removeAttribute("message");
            }

            request.setAttribute("user", profile); // Đặt đối tượng Customer (có Role) vào request
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
        int userId = userSession.getId(); // Lấy ID người dùng từ session

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
                // Xử lý lỗi chuyển đổi ngày tháng nếu cần
            }
        }

        Part filePart = request.getPart("avatar");
        String avatarPath = null;

        // Đường dẫn thư mục tải lên
        String uploadDirPath = getServletContext().getRealPath("/uploads");
        File uploadDir = new File(uploadDirPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs(); // Tạo thư mục nếu nó không tồn tại
        }

        // Xử lý tải lên ảnh đại diện
        if (filePart != null && filePart.getSize() > 0) {
            String submittedFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            // Tạo tên file duy nhất
            String fileName = "user_" + userId + "_" + System.currentTimeMillis() + "_" +
                    submittedFileName.replaceAll("[^a-zA-Z0-9\\.\\-_]", "_");
            String savePath = uploadDirPath + File.separator + fileName;
            filePart.write(savePath);
            avatarPath = "uploads/" + fileName; // Lưu đường dẫn tương đối để dễ sử dụng trong JSP
        }

        try (var conn = DBConnect.getConnection()) {
            CustomerDAO dao = new CustomerDAO(conn);
            Customer existing = dao.getCustomerById(userId); // Lấy thông tin hiện có

            // Nếu không có ảnh mới, giữ ảnh cũ
            if (avatarPath == null || avatarPath.isEmpty()) {
                avatarPath = existing != null ? existing.getProfilePicture() : null;
            }

            // Tạo đối tượng Customer đã cập nhật
            Customer updated = new Customer(userId, fullName, phone, dob, gender, address, avatarPath, email);
            // Lưu ý: Vai trò không được cập nhật từ form này, nó giữ nguyên từ DB.

            boolean success = dao.updateUser(updated); // Cập nhật thông tin người dùng

            if (success) {
                session.setAttribute("message", "Profile updated successfully!");
                // Cập nhật thông tin user trong session (ví dụ: fullName)
                // Tuy nhiên, để đảm bảo Role luôn được cập nhật, bạn có thể tải lại User từ DB và đặt vào session
                // Hoặc đơn giản là không cần cập nhật User session ở đây,
                // vì doGet sẽ tải lại dữ liệu từ DB mỗi khi trang profile được truy cập.
                userSession.setFullName(updated.getFullName()); // Cập nhật tên trong session nếu cần
                session.setAttribute("user", userSession); // Cập nhật session (không cần thiết lắm vì doGet sẽ tải lại)
            } else {
                session.setAttribute("message", "Failed to update profile!");
            }
            response.sendRedirect("userprofile"); // Chuyển hướng lại trang profile
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating profile");
        }
    }
}
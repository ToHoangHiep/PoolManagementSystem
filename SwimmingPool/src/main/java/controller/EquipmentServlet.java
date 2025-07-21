package controller;

import dal.EquipmentDAO;
import model.EquipmentRental;
import model.EquipmentSale;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet("/equipment")
public class EquipmentServlet extends HttpServlet {  // Có thể rename thành EquipmentServlet nếu muốn

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String mode = request.getParameter("mode");
        if (mode == null || mode.isEmpty()) mode = "rental";  // Default rental

        Integer categoryId = null;
        String catParam = request.getParameter("categoryId");
        if (catParam != null && !catParam.isEmpty()) {
            try {
                categoryId = Integer.parseInt(catParam);
            } catch (NumberFormatException e) { /* Default null = all */ }
        }

        try {
            List<Map<String, Object>> equipmentList = EquipmentDAO.getEquipmentStatus(mode, categoryId);
            List<Map<String, Object>> categories = EquipmentDAO.getAllCategories(mode);

            request.setAttribute("equipmentList", equipmentList);
            request.setAttribute("categories", categories);
            request.setAttribute("selectedCategoryId", categoryId);

            if ("rental".equals(mode)) {
                List<EquipmentRental> activeRentals = EquipmentDAO.getActiveRentals();
                request.setAttribute("activeRentals", activeRentals);
                request.getRequestDispatcher("/rental.jsp").forward(request, response);
            } else if ("buy".equals(mode)) {
                request.getRequestDispatcher("/buy.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Invalid mode");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String mode = request.getParameter("mode");  // Giữ mode từ form

        try {
            if ("rental".equals(action)) {
                // Code processRental hiện tại của bạn (không thay đổi, giả sử bạn có EquipmentRental object từ param)
                // Ví dụ:
                EquipmentRental rental = new EquipmentRental(/* parse params */);
                boolean success = EquipmentDAO.processRental(rental);
                if (success) {
                    response.sendRedirect("equipment?mode=rental");
                } else {
                    request.setAttribute("error", "Rental failed");
                    doGet(request, response);  // Reload trang với error
                }
            } else if ("sale".equals(action)) {
                // Code processSale tương tự
                EquipmentSale sale = new EquipmentSale(/* parse params */);
                boolean success = EquipmentDAO.processSale(sale);
                if (success) {
                    response.sendRedirect("equipment?mode=buy");
                } else {
                    request.setAttribute("error", "Sale failed");
                    doGet(request, response);
                }
            } else if ("return".equals(action)) {
                // Code processReturn
                int rentalId = Integer.parseInt(request.getParameter("rentalId"));
                boolean success = EquipmentDAO.processReturn(rentalId);
                if (success) {
                    response.sendRedirect("equipment?mode=rental");
                } else {
                    request.setAttribute("error", "Return failed");
                    doGet(request, response);
                }
            } else {
                request.setAttribute("error", "Invalid action");
                doGet(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            doGet(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid input");
            doGet(request, response);
        }
    }
}
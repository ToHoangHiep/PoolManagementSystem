package controller;

import dal.EquipmentDAO;
import jakarta.servlet.http.HttpSession;
import model.EquipmentRental;
import model.EquipmentSale;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet("/equipment-rental")
public class EquipmentRentalServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra user đã login chưa
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

//        // Kiểm tra role - chỉ cho phép Admin(1) và Staff(5)
//        int roleId = user.getRole().getId();
//        if (roleId != 1 && roleId != 5) {
//            request.setAttribute("error", "Access denied. Only Admin and Staff can access this page.");
//            request.getRequestDispatcher("error.jsp").forward(request, response);
//            return;
//        }

        try {
            EquipmentDAO equipmentDAO = new EquipmentDAO();

            // Lấy danh sách thiết bị với filter
            List<Map<String, Object>> equipmentList = equipmentDAO.getEquipmentStatus();
            System.out.println("equipmentList: " + equipmentList);
            // Lấy active rentals
            List<EquipmentRental> activeRentals = equipmentDAO.getActiveRentals();


            // Set attributes
            request.setAttribute("equipmentList", equipmentList);
            request.setAttribute("activeRentals", activeRentals);

            // Forward to JSP
            request.getRequestDispatcher("equipment_rental.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading equipment: " + e.getMessage());
            request.getRequestDispatcher("equipment_rental.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || user.getRole() == null || !(user.getRole().getId() == 2 || user.getRole().getId() == 5)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String currentFilter = request.getParameter("currentFilter");

        try {
            EquipmentDAO equipmentDAO = new EquipmentDAO();

            switch (action) {
                case "rental":
                    handleRental(request, equipmentDAO, user);
                    break;
                case "sale":
                    handleSale(request, equipmentDAO, user);
                    break;
                case "return":
                    handleReturn(request, equipmentDAO);
                    break;
                default:
                    request.getSession().setAttribute("error", "Invalid action specified");
                    break;
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error processing request: " + e.getMessage());
        }

        // Redirect back với filter
        String redirectUrl = "equipment-rental";
        if (currentFilter != null && !currentFilter.isEmpty()) {
            redirectUrl += "?type=" + currentFilter;
        }
        response.sendRedirect(redirectUrl);
    }

    private void handleRental(HttpServletRequest request, EquipmentDAO equipmentDAO, User user)
            throws SQLException {

        int inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
        String customerName = request.getParameter("customerName");
        String customerIdCard = request.getParameter("customerIdCard");
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        // Lấy thông tin thiết bị
        Map<String, Object> equipment = equipmentDAO.getEquipmentById(inventoryId);
        if (equipment == null) {
            request.setAttribute("error", "Equipment not found");
            return;
        }

        double rentPrice = (Double) equipment.get("rentPrice");
        if (rentPrice <= 0) {
            request.setAttribute("error", "This equipment is not available for rental");
            return;
        }

        double totalAmount = rentPrice * quantity;

        // Tạo đối tượng rental
        EquipmentRental rental = new EquipmentRental();
        rental.setCustomerName(customerName);
        rental.setCustomerIdCard(customerIdCard);
        rental.setStaffId(user.getId());
        rental.setInventoryId(inventoryId);
        rental.setQuantity(quantity);
        rental.setRentalDate(new java.sql.Date(System.currentTimeMillis()));
        rental.setRentPrice(rentPrice);
        rental.setTotalAmount(totalAmount);
        rental.setStatus("active");

        // Xử lý thuê
        if (equipmentDAO.processRental(rental)) {
            request.getSession().setAttribute("success",
                    "Equipment rented successfully! Rental ID: #" + rental.getRentalId());
        } else {
            request.getSession().setAttribute("error",
                    "Failed to process rental. Equipment may be out of stock.");
        }
    }

    private void handleSale(HttpServletRequest request, EquipmentDAO equipmentDAO, User user)
            throws SQLException {

        int inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
        String customerName = request.getParameter("customerName");
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        // Lấy thông tin thiết bị
        Map<String, Object> equipment = equipmentDAO.getEquipmentById(inventoryId);
        if (equipment == null) {
            request.getSession().setAttribute("error", "Equipment not found");
            return;
        }

        double salePrice = (Double) equipment.get("salePrice");
        if (salePrice <= 0) {
            request.getSession().setAttribute("error", "This equipment is not available for sale");
            return;
        }

        double totalAmount = salePrice * quantity;

        // Tạo đối tượng sale
        EquipmentSale sale = new EquipmentSale();
        sale.setCustomerName(customerName);
        sale.setStaffId(user.getId());
        sale.setInventoryId(inventoryId);
        sale.setQuantity(quantity);
        sale.setSalePrice(salePrice);
        sale.setTotalAmount(totalAmount);

        // Xử lý bán
        if (equipmentDAO.processSale(sale)) {
            request.getSession().setAttribute("success",
                    "Equipment sold successfully! Sale ID: #" + sale.getSaleId());
        } else {
            request.getSession().setAttribute("error",
                    "Failed to process sale. Equipment may be out of stock.");
        }
    }

    private void handleReturn(HttpServletRequest request, EquipmentDAO equipmentDAO)
            throws SQLException {

        int rentalId = Integer.parseInt(request.getParameter("rentalId"));

        if (equipmentDAO.processReturn(rentalId)) {
            request.getSession().setAttribute("success", "Equipment returned successfully!");
        } else {
            request.getSession().setAttribute("error",
                    "Failed to process return. Rental may not exist or already returned.");
        }
    }
}
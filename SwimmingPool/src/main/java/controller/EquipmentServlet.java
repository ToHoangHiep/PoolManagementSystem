package controller;

import dal.EquipmentDAO;
import model.EquipmentRental;
import model.EquipmentSale;
import model.Cart;
import model.CartItem;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet("/equipment")
public class EquipmentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Code gốc của bạn ở đây (không sửa)
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

        // DEBUG: In ra các tham số để kiểm tra
        System.out.println("[DEBUG] Action received: " + action);
        System.out.println("[DEBUG] Mode received: " + mode);
        System.out.println("[DEBUG] All parameters:");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        int staffId = (user != null) ? user.getId() : 1;  // Fallback nếu chưa login

        try {
            if ("rental".equals(action) || "sale".equals(action) || "add".equals(action)) {
                // Gộp xử lý rental, sale, add thành add to cart
                String inventoryIdStr = request.getParameter("inventoryId");
                if (inventoryIdStr == null || inventoryIdStr.isEmpty()) {
                    request.setAttribute("error", "Inventory ID is missing");
                    doGet(request, response);
                    return;
                }
                // DEBUG: Kiểm tra mode trước khi tạo CartItem
                System.out.println("[DEBUG] Mode before creating CartItem: " + mode);
                System.out.println("[DEBUG] Will create type: " + (mode.equals("rental") ? "EquipmentRental" : "EquipmentBuy"));

                int inventoryId = Integer.parseInt(inventoryIdStr);
                String customerName = request.getParameter("customerName");
                String customerIdCard = request.getParameter("customerIdCard");
                String quantityStr = request.getParameter("quantity");  // Thêm validation cho quantity
                if (quantityStr == null || quantityStr.isEmpty()) {
                    request.setAttribute("error", "Quantity is missing");
                    doGet(request, response);
                    return;
                }
                int qty = Integer.parseInt(quantityStr);

                // Sửa: Lấy price dựa vào mode (buy → salePrice, rental → rentPrice)
                String priceParamName = "buy".equals(mode) ? "salePrice" : "rentPrice";
                String priceStr = request.getParameter(priceParamName);
                if (priceStr == null || priceStr.trim().isEmpty()) {
                    throw new NumberFormatException("Price is missing for mode: " + mode);  // Thêm chi tiết mode để debug dễ hơn
                }
                BigDecimal price = new BigDecimal(priceStr.trim());  // Thêm trim() để tr

                EquipmentDAO equipmentDAO = new EquipmentDAO();
                String itemName = equipmentDAO.getItemNameByInventoryId(inventoryId);

                Cart cart = (Cart) session.getAttribute("cart");
                if (cart == null) {
                    cart = new Cart();
                    session.setAttribute("cart", cart);
                }

                // Set customer info nếu chưa có
                if (cart.getCustomerName() == null || cart.getCustomerName().isEmpty()) {
                    cart.setCustomerName(customerName);
                    cart.setCustomerIdCard(customerIdCard);
                }

                // Add item to cart với type phù hợp
                String itemType = mode.equals("rental") ? "EquipmentRental" : "EquipmentBuy";
                System.out.println("[DEBUG] Final itemType: " + itemType);

                CartItem item = new CartItem(inventoryId, qty, price, itemType, itemName);
                cart.addItem(item);

                // Redirect dựa trên redirectTo
                String redirectTo = request.getParameter("redirectTo");
                if ("cart".equals(redirectTo)) {
                    response.sendRedirect("cart");  // Từ "Rent" hoặc "Buy" → Chuyển sang giỏ hàng
                } else {
                    response.sendRedirect("equipment?mode=" + mode);  // Từ "Add to Cart" → Ở lại trang
                }
            } else if ("return".equals(action)) {
                // Giữ nguyên return (không liên quan cart)
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
            e.printStackTrace();
            request.setAttribute("error", "Invalid input: " + e.getMessage());
            doGet(request, response);
        }
    }
}
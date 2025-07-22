package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Cart;
import model.CartItem;
import model.Ticket;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        System.out.println("Debug: doGet CartServlet - Cart items: " +
                (cart.getItems() != null ? cart.getItems().size() : 0) +
                ", Total: " + cart.getTotal());

        // Debug: In ra từng item trong cart
        if (cart.getItems() != null) {
            for (int i = 0; i < cart.getItems().size(); i++) {
                CartItem item = cart.getItems().get(i);
                System.out.println("  Item " + i + ": Type=" + item.getType() +
                        ", Name=" + item.getItemName() +
                        ", Qty=" + item.getQty() +
                        ", Price=" + item.getPrice());
            }
        }

        request.setAttribute("cart", cart);
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        System.out.println("Debug: doPost CartServlet - Action: " + action);

        try {
            if ("remove".equals(action)) {
                int index = Integer.parseInt(request.getParameter("index"));
                if (index >= 0 && index < cart.getItems().size()) {
                    CartItem removedItem = cart.getItems().get(index);
                    cart.removeItem(index);
                    System.out.println("Debug: Removed item '" + removedItem.getItemName() +
                            "' at index " + index + ", New cart items: " + cart.getItems().size());
                    request.setAttribute("success", "Đã xóa '" + removedItem.getItemName() + "' khỏi giỏ!");
                } else {
                    request.setAttribute("error", "Index không hợp lệ!");
                }

            } else if ("update".equals(action)) {
                int index = Integer.parseInt(request.getParameter("index"));
                int newQty = Integer.parseInt(request.getParameter("newQty"));

                if (index >= 0 && index < cart.getItems().size() && newQty > 0) {
                    CartItem item = cart.getItems().get(index);
                    int oldQty = item.getQty();
                    cart.updateItemQty(index, newQty);
                    System.out.println("Debug: Updated qty of '" + item.getItemName() +
                            "' from " + oldQty + " to " + newQty +
                            ", New total: " + cart.getTotal());
                    request.setAttribute("success", "Đã cập nhật số lượng của '" + item.getItemName() + "'!");
                } else {
                    request.setAttribute("error", "Dữ liệu cập nhật không hợp lệ!");
                }

            } else if ("checkout".equals(action)) {
                if (cart.isEmpty()) {
                    System.out.println("Debug: Checkout failed - Cart empty");
                    request.setAttribute("error", "Giỏ hàng rỗng!");
                } else {
                    // Xác định loại cart
                    String cartType = determineCartType(cart);
                    System.out.println("Debug: Checkout successful - Cart type: " + cartType +
                            ", Total items: " + cart.getItems().size() +
                            ", Total amount: " + cart.getTotal());

                    // Redirect tới payment với type phù hợp
                    response.sendRedirect("payment?action=confirm&for=" + cartType);
                    return;
                }
            } else {
                System.out.println("Debug: Unknown action: " + action);
                request.setAttribute("error", "Hành động không hợp lệ: " + action);
            }

            request.setAttribute("cart", cart);
            request.getRequestDispatcher("cart.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            System.out.println("Debug: NumberFormatException in doPost: " + e.getMessage());
            request.setAttribute("error", "Dữ liệu số không hợp lệ: " + e.getMessage());
            request.setAttribute("cart", cart);
            request.getRequestDispatcher("cart.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Debug: Exception in doPost: " + e.getMessage());
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.setAttribute("cart", cart);
            request.getRequestDispatcher("cart.jsp").forward(request, response);
        }
    }

    /**
     * Xác định loại cart dựa trên các items bên trong
     * @param cart Cart cần phân tích
     * @return String type: "ticket", "equipment_rental", "equipment_buy", hoặc "mixed"
     */
    private String determineCartType(Cart cart) {
        if (cart.getItems() == null || cart.getItems().isEmpty()) {
            System.out.println("Debug: determineCartType - Empty cart, defaulting to ticket");
            return "ticket"; // Default fallback
        }

        // Đếm số lượng từng loại item
        int ticketCount = 0;
        int rentalCount = 0;
        int buyCount = 0;

        for (CartItem item : cart.getItems()) {
            String type = item.getType();
            if (type != null) {
                if (type.startsWith("Ticket")) {
                    ticketCount++;
                } else if ("EquipmentRental".equals(type)) {
                    rentalCount++;
                } else if ("EquipmentBuy".equals(type)) {
                    buyCount++;
                } else {
                    System.out.println("Debug: Unknown item type: " + type);
                }
            }
        }

        System.out.println("Debug: Cart analysis - Tickets: " + ticketCount +
                ", Rentals: " + rentalCount + ", Buys: " + buyCount);

        // Đếm số loại khác nhau
        int distinctTypes = 0;
        if (ticketCount > 0) distinctTypes++;
        if (rentalCount > 0) distinctTypes++;
        if (buyCount > 0) distinctTypes++;

        // Logic xác định type
        if (distinctTypes > 1) {
            System.out.println("Debug: Mixed cart detected - " + distinctTypes + " different types");
            return "mixed";  // Có nhiều hơn 1 loại → Mixed
        } else if (ticketCount > 0) {
            System.out.println("Debug: Pure ticket cart");
            return "ticket";
        } else if (rentalCount > 0) {
            System.out.println("Debug: Pure rental cart");
            return "equipment_rental";
        } else if (buyCount > 0) {
            System.out.println("Debug: Pure buy cart");
            return "equipment_buy";
        } else {
            System.out.println("Debug: No recognizable items, defaulting to ticket");
            return "ticket"; // Fallback
        }
    }
}
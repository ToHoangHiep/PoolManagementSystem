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

        // Thêm phần này: Lấy "from" và lưu lastCartMode
        String from = request.getParameter("from");
        if (from != null && !from.isEmpty()) {
            // Chuyển "rental" -> "equipment_rental", "buy" -> "equipment_buy" để khớp với determineCartType
            String lastMode = from;
            if ("rental".equals(from)) {
                lastMode = "equipment_rental";
            } else if ("buy".equals(from)) {
                lastMode = "equipment_buy";
            } else if ("ticket".equals(from)) {
                lastMode = "ticket";
            }
            session.setAttribute("lastCartMode", lastMode);
        }

        // Set attribute cho JSP (dùng lastCartMode từ session, nếu có)
        String lastMode = (String) session.getAttribute("lastCartMode");
        if (lastMode == null) {
            lastMode = "ticket";  // Default nếu không có
        }
        request.setAttribute("lastMode", lastMode);

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



        try {
            if ("remove".equals(action)) {
                int index = Integer.parseInt(request.getParameter("index"));
                if (index >= 0 && index < cart.getItems().size()) {
                    CartItem removedItem = cart.getItems().get(index);
                    cart.removeItem(index);
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
                    request.setAttribute("success", "Đã cập nhật số lượng của '" + item.getItemName() + "'!");
                } else {
                    request.setAttribute("error", "Dữ liệu cập nhật không hợp lệ!");
                }

            } else if ("checkout".equals(action)) {
                if (cart.isEmpty()) {
                    request.setAttribute("error", "Giỏ hàng rỗng!");
                } else {
                    // Xác định loại cart
                    String cartType = determineCartType(cart);
                    response.sendRedirect("payment?action=confirm&for=" + cartType);
                    return;
                }
            } else {
                request.setAttribute("error", "Hành động không hợp lệ: " + action);
            }

            request.setAttribute("cart", cart);
            request.getRequestDispatcher("cart.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu số không hợp lệ: " + e.getMessage());
            request.setAttribute("cart", cart);
            request.getRequestDispatcher("cart.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
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
                }
            }
        }

        // Đếm số loại khác nhau
        int distinctTypes = 0;
        if (ticketCount > 0) distinctTypes++;
        if (rentalCount > 0) distinctTypes++;
        if (buyCount > 0) distinctTypes++;

        // Logic xác định type
        if (distinctTypes > 1) {
            return "mixed";  // Có nhiều hơn 1 loại → Mixed
        } else if (ticketCount > 0) {
            return "ticket";
        } else if (rentalCount > 0) {
            return "equipment_rental";
        } else if (buyCount > 0) {
            return "equipment_buy";
        } else {
            return "ticket"; // Fallback
        }
    }
}
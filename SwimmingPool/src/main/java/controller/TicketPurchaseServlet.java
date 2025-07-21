package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Cart;
import model.CartItem;
import model.Ticket;
import model.Ticket.TicketTypeName;
import dal.TicketDAO;
import model.User;
import model.Role;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/purchase")
public class TicketPurchaseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRole().getId() != 5) {  // Chỉ staff (role_id=2) được truy cập
            request.setAttribute("error", "Chức năng chỉ dành cho nhân viên!");
            response.sendRedirect("home.jsp");
            return;
        }
        request.getRequestDispatcher("ticketPurchase.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String typeStr = request.getParameter("ticketType");
            String quantityStr = request.getParameter("quantity");
            String customerName = request.getParameter("customerName");
            String customerIdCard = request.getParameter("customerIdCard");

            System.out.println("Debug: doPost TicketPurchaseServlet - Input: ticketType=" + typeStr + ", quantity=" + quantityStr + ", customerName=" + customerName + ", customerIdCard=" + customerIdCard);

            if (typeStr == null || quantityStr == null || customerName == null || customerIdCard == null ||
                    typeStr.isEmpty() || quantityStr.isEmpty() || customerName.isEmpty() || customerIdCard.isEmpty()) {
                System.out.println("Debug: Error - Missing input fields");
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin.");
                request.getRequestDispatcher("ticketPurchase.jsp").forward(request, response);
                return;
            }

            int quantity;
            try {
                quantity = Integer.parseInt(quantityStr);
                if (quantity <= 0) {
                    throw new NumberFormatException();
                }
            } catch (NumberFormatException e) {
                System.out.println("Debug: Error - Invalid quantity: " + quantityStr);
                request.setAttribute("error", "Số lượng vé phải là số nguyên dương.");
                request.getRequestDispatcher("ticketPurchase.jsp").forward(request, response);
                return;
            }

            TicketTypeName ticketType = TicketTypeName.valueOf(typeStr);

            BigDecimal price = TicketDAO.getTicketTypePrice(ticketType);
            System.out.println("Debug: Price from DB for " + ticketType + ": " + price);
            if (price == null) {
                System.out.println("Debug: Error - Price null from DB");
                request.setAttribute("error", "Không lấy được giá vé từ hệ thống. Vui lòng thử lại sau.");
                request.getRequestDispatcher("ticketPurchase.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user == null || user.getRole().getId() != 5) {  // Chỉ staff được add
                request.setAttribute("error", "Chức năng chỉ dành cho nhân viên!");
                response.sendRedirect("home.jsp");
                return;
            }

            CartItem cartItem = new CartItem(ticketType, quantity, price);

            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null) {
                cart = new Cart();
                session.setAttribute("cart", cart);
            }

            cart.addItem(cartItem);
            cart.setCustomerName(customerName);
            cart.setCustomerIdCard(customerIdCard);

            System.out.println("Debug: Cart after add - Items: " + cart.getItems().size() + ", Total: " + cart.getTotal());

            session.setAttribute("success", "Đã thêm vé vào giỏ hàng!");
            response.sendRedirect("ticketPurchase.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Debug: Exception in doPost: " + e.getMessage());
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher("ticketPurchase.jsp").forward(request, response);
        }
    }
}
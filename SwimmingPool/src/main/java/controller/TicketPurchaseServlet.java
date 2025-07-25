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
        // Cho phép admin (roleId = 1) và staff (roleId = 5) truy cập
        if (user == null || (user.getRole().getId() != 1 && user.getRole().getId() != 5)) {
            request.setAttribute("error", "Chức năng chỉ dành cho admin và nhân viên!");
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


            if (typeStr == null || quantityStr == null || customerName == null || customerIdCard == null ||
                    typeStr.isEmpty() || quantityStr.isEmpty() || customerName.isEmpty() || customerIdCard.isEmpty()) {
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
                request.setAttribute("error", "Số lượng vé phải là số nguyên dương.");
                request.getRequestDispatcher("ticketPurchase.jsp").forward(request, response);
                return;
            }

            TicketTypeName ticketType = TicketTypeName.valueOf(typeStr);

            BigDecimal price = TicketDAO.getTicketTypePrice(ticketType);
            if (price == null) {
                request.setAttribute("error", "Không lấy được giá vé từ hệ thống. Vui lòng thử lại sau.");
                request.getRequestDispatcher("ticketPurchase.jsp").forward(request, response);
                return;
            }


            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            // Cho phép admin (roleId = 1) và staff (roleId = 5) thực hiện mua vé
            if (user == null || (user.getRole().getId() != 1 && user.getRole().getId() != 5)) {
                request.setAttribute("error", "Chức năng chỉ dành cho admin và nhân viên!");
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


            session.setAttribute("success", "Đã thêm vé vào giỏ hàng!");
            response.sendRedirect("ticketPurchase.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher("ticketPurchase.jsp").forward(request, response);
        }
    }
}
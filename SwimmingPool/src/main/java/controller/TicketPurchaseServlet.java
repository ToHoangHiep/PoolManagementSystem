package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Ticket;
import model.Ticket.PaymentStatus;
import model.Ticket.TicketStatus;
import model.Ticket.TicketTypeName;
import model.User;
import validate.TicketValid;
import dal.TicketDAO;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@WebServlet("/purchase")
public class TicketPurchaseServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 1. Lấy dữ liệu từ form
            String typeStr = request.getParameter("ticketType");
            String quantityStr = request.getParameter("quantity");

            // 2. Kiểm tra dữ liệu null
            if (typeStr == null || quantityStr == null ||
                    typeStr.isEmpty() || quantityStr.isEmpty()) {
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin.");
                request.getRequestDispatcher("ticketPurchase.jsp").forward(request, response);
                return;
            }

            // 3. Parse và validate số lượng
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

            // 4. Parse loại vé
            TicketTypeName ticketType = TicketTypeName.valueOf(typeStr);

            // 5. Xác định ngày bắt đầu và ngày kết thúc
            LocalDate startDate = LocalDate.now(); // luôn là hôm nay
            LocalDate endDate = TicketValid.calculateEndDate(ticketType, startDate); // tự tính


            // 6. Lấy thông tin loại vé từ DB
            int ticketTypeId = TicketDAO.getTicketTypeIdByEnum(ticketType);
            BigDecimal price = TicketDAO.getTicketTypePrice(ticketType);
            BigDecimal total = price.multiply(BigDecimal.valueOf(quantity));

            // 7. Lấy người dùng từ session
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            if (user == null) {
                response.sendRedirect("home.jsp");
                return;
            }

            // 8. Tạo đối tượng vé
            Ticket ticket = new Ticket();
            ticket.setUserId(user.getId());
            ticket.setTicketTypeName(ticketType.name());
            ticket.setTicketTypeId(ticketTypeId);
            ticket.setPrice(price);
            ticket.setQuantity(quantity);
            ticket.setStartDate(startDate);
            ticket.setEndDate(endDate);
            ticket.setTotal(total);
            ticket.setTicketStatus(TicketStatus.Cancelled); // chưa thanh toán thì Cancelled
            ticket.setPaymentStatus(PaymentStatus.Unpaid);
            ticket.setCreatedAt(LocalDateTime.now());

            // 9. Lưu vào DB
            Integer ticketId = new TicketDAO().saveTicket(ticket);

            if (ticketId != null) {
                ticket.setTicketId(ticketId);
                session.setAttribute("ticket", ticket);
                response.sendRedirect("checkout.jsp");
            } else {
                request.setAttribute("error", "Lỗi cơ sở dữ liệu. Không thể lưu vé.");
                request.getRequestDispatcher("ticketPurchase.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher("ticketPurchase.jsp").forward(request, response);
        }
    }
}

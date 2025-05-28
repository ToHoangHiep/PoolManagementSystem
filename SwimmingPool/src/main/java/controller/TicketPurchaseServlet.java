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
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");

            // 2. Kiểm tra dữ liệu null
            if (typeStr == null || quantityStr == null || startDateStr == null || endDateStr == null ||
                    typeStr.isEmpty() || quantityStr.isEmpty() || startDateStr.isEmpty() || endDateStr.isEmpty()) {
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin.");
                request.getRequestDispatcher("ticketPurchase.jsp").forward(request, response);
                return;
            }

            // 3. Parse và validate quantity
            int quantity = Integer.parseInt(quantityStr);
            if (quantity <= 0) {
                request.setAttribute("error", "Số lượng vé phải lớn hơn 0.");
                request.getRequestDispatcher("ticketPurchase.jsp").forward(request, response);
                return;
            }

            // 4. Parse kiểu vé và ngày
            TicketTypeName ticketType = TicketTypeName.valueOf(typeStr);
            LocalDate startDate = LocalDate.parse(startDateStr);
            LocalDate endDate = LocalDate.parse(endDateStr);

            // 5. Kiểm tra ngày kết thúc hợp lệ
            if (!TicketValid.isEndDateValid(ticketType, startDate, endDate)) {
                request.setAttribute("error", "Ngày kết thúc không phù hợp với loại vé đã chọn.");
                request.getRequestDispatcher("ticketPurchase.jsp").forward(request, response);
                return;
            }

            // 6. Lấy ID và giá vé từ DB
            int ticketTypeId = TicketDAO.getTicketTypeIdByEnum(ticketType);
            BigDecimal price = TicketDAO.getTicketTypePrice(ticketType);
            BigDecimal total = price.multiply(BigDecimal.valueOf(quantity));

            //get userr id from sesssion
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            Ticket ticket = new Ticket();
            if (user != null) {
                // 7. Tạo vé
                ticket.setUserId(user.getId());
                ticket.setTicketTypeName(ticketType.name());
                ticket.setPrice(price);
                ticket.setTicketTypeId(ticketTypeId);
                ticket.setQuantity(quantity);
                ticket.setStartDate(startDate);
                ticket.setEndDate(endDate);
                ticket.setTicketStatus(TicketStatus.Cancelled);
                ticket.setPaymentStatus(PaymentStatus.Unpaid);
                ticket.setCreatedAt(LocalDateTime.now());
                ticket.setTotal(total);
            }
            // 8. Lưu vé
            Integer ticket_id = new TicketDAO().saveTicket(ticket);

            if (ticket_id != null) {
                // Lưu vào session để dùng tiếp ở checkout.jsp
                ticket.setTicketId(ticket_id);
                session.setAttribute("ticket", ticket);

                // Chuyển sang trang thanh toán
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

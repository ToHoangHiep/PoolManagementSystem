package controller;

import dal.TicketDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Ticket;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Ticket ticket = (Ticket) (session != null ? session.getAttribute("ticket") : null);

        if (ticket == null) {
            request.setAttribute("error", "Không tìm thấy thông tin vé để thanh toán.");
            request.getRequestDispatcher("ticketPurchase.jsp").forward(request, response);
            return;
        }

        // Tính tổng tiền: price * quantity
        BigDecimal total = ticket.getPrice().multiply(BigDecimal.valueOf(ticket.getQuantity()));
        total = total.setScale(2, RoundingMode.HALF_UP);

        // Gửi dữ liệu sang checkout.jsp
        request.setAttribute("ticket", ticket);
        request.setAttribute("total", total);

        String action = request.getParameter("action");

        try {
            TicketDAO ticketDAO = new TicketDAO();

            if ("confirm".equals(action)) {
                //  Xác nhận thanh toán
                ticket.setPaymentStatus(Ticket.PaymentStatus.Paid);
                ticket.setTicketStatus(Ticket.TicketStatus.Active);
                boolean updated = ticketDAO.updateTicketStatus(ticket.getTicketId(), ticket.getTicketStatus(), ticket.getPaymentStatus());

                if (updated) {
                    session.removeAttribute("ticket"); // clear khỏi session
                    //  CHUYỂN SANG TRANG ticket_success.jsp
                    response.sendRedirect("ticket_success.jsp");
                    return;
                } else {
                    throw new Exception("Cập nhật trạng thái thất bại");
                }

            } else if ("cancel".equals(action)) {
                //  Hủy thanh toán
                boolean deleted = ticketDAO.deleteTicketById(ticket.getTicketId());

                if (deleted) {
                    session.removeAttribute("ticket");
                    request.setAttribute("message", "Đã hủy thanh toán và xóa vé.");
                    //  QUAY LẠI TRANG ticketPurchase.jsp
                    request.getRequestDispatcher("ticketPurchase.jsp").forward(request, response);
                } else {
                    throw new Exception("Xóa vé thất bại");
                }
            }

        } catch (Exception e) {
            request.setAttribute("error", "Lỗi xử lý: " + e.getMessage());
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        }
    }
//        request.getRequestDispatcher("checkout.jsp").forward(request, response);
    }


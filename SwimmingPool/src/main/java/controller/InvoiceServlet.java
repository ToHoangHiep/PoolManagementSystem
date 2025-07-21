package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Ticket;
import dal.TicketDAO;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/invoice")
public class InvoiceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String type = request.getParameter("type");
        if ("ticket".equals(type)) {
            String idsStr = request.getParameter("ids");
            if (idsStr != null && !idsStr.isEmpty()) {
                String[] idsArr = idsStr.split(",");
                List<Integer> ids = new ArrayList<>();
                for (String id : idsArr) {
                    try {
                        ids.add(Integer.parseInt(id.trim()));
                    } catch (NumberFormatException e) {
                        // Bỏ qua id không hợp lệ
                    }
                }

                TicketDAO ticketDAO = new TicketDAO();
                List<Ticket> tickets = null;
                try {
                    tickets = ticketDAO.getTicketsByIds(ids);
                } catch (SQLException e) {
                    request.setAttribute("error", "Lỗi khi tải thông tin vé: " + e.getMessage());
                    request.getRequestDispatcher("error.jsp").forward(request, response);
                    return;
                }

                if (tickets == null || tickets.isEmpty()) {
                    request.setAttribute("error", "Không tìm thấy vé với IDs: " + idsStr);
                    request.getRequestDispatcher("error.jsp").forward(request, response);
                    return;
                }

                BigDecimal totalAmount = BigDecimal.ZERO;
                for (Ticket ticket : tickets) {
                    BigDecimal ticketTotal = ticket.getTotal();
                    if (ticketTotal == null) {
                        ticketTotal = BigDecimal.ZERO;  // Fix null → 0
                    }
                    totalAmount = totalAmount.add(ticketTotal);
                }

                String customerName = tickets.isEmpty() ? "Unknown" : tickets.get(0).getCustomerName();
                String customerIdCard = tickets.isEmpty() ? "Unknown" : tickets.get(0).getCustomerIdCard();

                request.setAttribute("tickets", tickets);
                request.setAttribute("totalAmount", totalAmount);
                request.setAttribute("customerName", customerName);
                request.setAttribute("customerIdCard", customerIdCard);
                request.setAttribute("invoiceNumber", "TICKET-" + idsStr.replace(",", "-"));

                request.getRequestDispatcher("invoice_pay.jsp").forward(request, response);
                return;
            }
        }

        request.setAttribute("error", "Invalid invoice");
        request.getRequestDispatcher("error.jsp").forward(request, response);
    }
}
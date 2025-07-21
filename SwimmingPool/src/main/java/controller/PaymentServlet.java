package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Cart;
import model.CartItem;
import model.Payment;
import model.Ticket;
import model.Ticket.PaymentStatus;
import model.Ticket.TicketStatus;
import model.User;
import dal.PaymentDAO;
import dal.TicketDAO;
import utils.DBConnect;
import validate.TicketValid;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String forType = request.getParameter("for");

        if ("confirm".equals(action) && "ticket".equals(forType)) {
            HttpSession session = request.getSession();
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null || cart.isEmpty()) {
                request.setAttribute("error", "Giỏ hàng rỗng!");
                request.getRequestDispatcher("ticketPurchase.jsp").forward(request, response);
                return;
            }

            request.setAttribute("cart", cart);
            request.setAttribute("type", "ticket");
            request.getRequestDispatcher("payment-form.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Invalid request");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String forType = request.getParameter("for");

        if ("confirm".equals(action) && "ticket".equals(forType)) {
            HttpSession session = request.getSession();
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null || cart.isEmpty()) {
                request.setAttribute("error", "Giỏ hàng rỗng!");
                request.getRequestDispatcher("payment-form.jsp").forward(request, response);
                return;
            }

            BigDecimal amount;
            try {
                amount = new BigDecimal(request.getParameter("amount").replace(",", ""));
                if (amount.compareTo(cart.getTotal()) != 0) {
                    request.setAttribute("error", "Số tiền phải bằng tổng hóa đơn!");
                    request.setAttribute("cart", cart);
                    request.getRequestDispatcher("payment-form.jsp").forward(request, response);
                    return;
                }
            } catch (Exception e) {
                request.setAttribute("error", "Định dạng số tiền không hợp lệ!");
                request.setAttribute("cart", cart);
                request.getRequestDispatcher("payment-form.jsp").forward(request, response);
                return;
            }

            String method = request.getParameter("paymentMethod");
            String notes = request.getParameter("notes");

            User user = (User) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            Connection conn = null;
            try {
                conn = DBConnect.getConnection();
                conn.setAutoCommit(false);

                TicketDAO ticketDAO = new TicketDAO();
                List<Integer> ticketIds = new ArrayList<>();

                for (CartItem item : cart.getItems()) {
                    LocalDate startDate = LocalDate.now();
                    LocalDate endDate = TicketValid.calculateEndDate(item.getType(), startDate);

                    Ticket ticket = new Ticket();
                    ticket.setUserId(user.getId());
                    ticket.setTicketTypeName(item.getType().name());
                    ticket.setTicketTypeId(ticketDAO.getTicketTypeIdByEnum(item.getType()));
                    ticket.setPrice(item.getPrice());
                    ticket.setQuantity(item.getQty());

                    // Thêm debug cho đoạn liên quan lỗi Total Amount
                    BigDecimal itemPrice = item.getPrice();
                    System.out.println("Debug: Item Price for " + item.getType() + ": " + itemPrice);
                    if (itemPrice == null) {
                        System.out.println("Debug: Error - Item Price is null, setting to 0");
                        itemPrice = BigDecimal.ZERO;
                    }

                    int itemQty = item.getQty();
                    System.out.println("Debug: Item Quantity: " + itemQty);

                    BigDecimal ticketTotal = itemPrice.multiply(BigDecimal.valueOf(itemQty));
                    System.out.println("Debug: Calculated ticketTotal (price * qty): " + ticketTotal);

                    if (ticketTotal == null) {
                        System.out.println("Debug: Warning - ticketTotal is null, setting to 0");
                        ticketTotal = BigDecimal.ZERO;
                    } else if (ticketTotal.compareTo(BigDecimal.ZERO) <= 0) {
                        System.out.println("Debug: Warning - ticketTotal is 0 or negative, setting to default price");
                        ticketTotal = itemPrice; // Fallback nếu qty sai
                    }

                    ticket.setTotal(ticketTotal);
                    System.out.println("Debug: Set ticket.total for " + item.getType() + ": " + ticket.getTotal());

                    ticket.setStartDate(startDate);
                    ticket.setEndDate(endDate);
                    ticket.setTicketStatus(TicketStatus.Cancelled);
                    ticket.setPaymentStatus(PaymentStatus.Unpaid);
                    ticket.setCreatedAt(LocalDateTime.now());
                    ticket.setCustomerName(cart.getCustomerName());
                    ticket.setCustomerIdCard(cart.getCustomerIdCard());

                    Integer ticketId = ticketDAO.saveTicket(ticket);
                    if (ticketId == null) {
                        throw new SQLException("Save ticket failed for item: " + item.getType());
                    }
                    ticketIds.add(ticketId);
                    System.out.println("Debug: Inserted ticket ID: " + ticketId);
                }

                if (ticketIds.isEmpty()) {
                    throw new SQLException("No tickets saved");
                }

                Payment payment = new Payment();
                payment.setUserId(user.getId());
                payment.setCustomerName(cart.getCustomerName());
                payment.setCustomerIdCard(cart.getCustomerIdCard());
                payment.setAmount(cart.getTotal());
                payment.setPaymentMethod(method);
                payment.setPaymentFor("ticket");
                payment.setReferenceId(ticketIds.get(0));
                payment.setStatus("completed");
                payment.setNotes(notes + " | Ticket IDs: " + ticketIds);

                if (!PaymentDAO.addPayment(payment)) {
                    throw new SQLException("Add payment failed");
                }

                for (Integer ticketId : ticketIds) {
                    if (!ticketDAO.updateTicketStatus(ticketId, TicketStatus.Active, PaymentStatus.Paid)) {
                        throw new SQLException("Update status failed for ticket ID: " + ticketId);
                    }
                }

                conn.commit();

                cart.clear();
                session.setAttribute("cart", cart);

                String idsStr = String.join(",", ticketIds.stream().map(String::valueOf).toArray(String[]::new));
                response.sendRedirect("invoice?type=ticket&ids=" + idsStr);

            } catch (SQLException e) {
                if (conn != null) { try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); } }
                e.printStackTrace();
                request.setAttribute("error", "Lỗi thanh toán: " + e.getMessage());
                request.setAttribute("cart", cart);
                request.getRequestDispatcher("payment-form.jsp").forward(request, response);
            } finally {
                if (conn != null) { try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { ex.printStackTrace(); } }
            }
        }
    }
}
package controller;

import dal.EquipmentDAO;
import dal.PaymentDAO;
import dal.TicketDAO;
import model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
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

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            if ("confirm".equals(action)) {
                // Hiển thị trang xác nhận payment
                Cart cart = (Cart) session.getAttribute("cart");
                if (cart == null || cart.isEmpty()) {
                    request.setAttribute("error", "Cart is empty");
                    request.getRequestDispatcher("/cart.jsp").forward(request, response);
                    return;
                }

                // Xác định loại payment từ cart hoặc parameter
                if (forType == null || forType.isEmpty()) {
                    forType = determinePaymentType(cart);
                }

                request.setAttribute("cart", cart);
                request.setAttribute("paymentFor", forType);
                request.getRequestDispatcher("/payment-form.jsp").forward(request, response);
            } else {
                response.sendRedirect("home.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System error: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String forType = request.getParameter("for");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            if ("confirm".equals(action)) {
                processPayment(request, response, session, user, forType);
            } else {
                response.sendRedirect("home.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Payment failed: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private void processPayment(HttpServletRequest request, HttpServletResponse response,
                                HttpSession session, User user, String paymentFor)
            throws ServletException, IOException, SQLException {

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            request.setAttribute("error", "Cart is empty");
            request.getRequestDispatcher("/cart.jsp").forward(request, response);
            return;
        }

        // Lấy thông tin payment
        String notes = request.getParameter("notes");
        BigDecimal totalAmount = cart.getTotal();

        // Xác định customer info từ cart
        String customerName = cart.getCustomerName();
        String customerIdCard = cart.getCustomerIdCard();

        if (customerName == null || customerName.trim().isEmpty()) {
            customerName = user.getFullName();
        }

        // Danh sách IDs đã tạo
        List<Integer> ticketIds = new ArrayList<>();
        List<Integer> rentalIds = new ArrayList<>();
        List<Integer> saleIds = new ArrayList<>();
        boolean success = true;

        try {
            // Xử lý từng item trong cart
            for (CartItem item : cart.getItems()) {
                String itemType = item.getType();

                if (itemType.startsWith("Ticket_")) {
                    // Xử lý ticket
                    int ticketId = processTicketItem(item, user, customerName, customerIdCard);
                    if (ticketId > 0) {
                        ticketIds.add(ticketId);
                    } else {
                        success = false;
                        break;
                    }

                } else if ("EquipmentRental".equals(itemType)) {
                    // Xử lý equipment rental
                    int rentalId = processEquipmentRentalItem(item, user, customerName, customerIdCard);
                    if (rentalId > 0) {
                        rentalIds.add(rentalId);
                    } else {
                        success = false;
                        break;
                    }

                } else if ("EquipmentBuy".equals(itemType)) {
                    // Xử lý equipment buy
                    int saleId = processEquipmentBuyItem(item, user, customerName);
                    if (saleId > 0) {
                        saleIds.add(saleId);
                    } else {
                        success = false;
                        break;
                    }
                }
            }

            if (success) {
                // Tạo payment record
                Payment payment = new Payment();
                payment.setUserId(user.getId());
                payment.setCustomerName(customerName);
                payment.setCustomerIdCard(customerIdCard);
                payment.setAmount(totalAmount);
                payment.setPaymentMethod("cash"); // Default
                payment.setPaymentFor(paymentFor != null ? paymentFor : "mixed");
                payment.setStatus("completed");
                payment.setNotes(notes);
                payment.setStaffId(user.getId());

                // Set reference ID (lấy ID đầu tiên)
                if (!ticketIds.isEmpty()) {
                    payment.setReferenceId(ticketIds.get(0));
                } else if (!rentalIds.isEmpty()) {
                    payment.setReferenceId(rentalIds.get(0));
                } else if (!saleIds.isEmpty()) {
                    payment.setReferenceId(saleIds.get(0));
                }

                boolean paymentSuccess = PaymentDAO.addPayment(payment);

                if (paymentSuccess) {
                    // Update ticket status nếu có
                    TicketDAO ticketDAO = new TicketDAO();
                    for (Integer ticketId : ticketIds) {
                        try {
                            ticketDAO.updateTicketStatus(ticketId, Ticket.TicketStatus.Active, Ticket.PaymentStatus.Paid);
                        } catch (Exception e) {
                            System.err.println("Warning: Could not update ticket status for ID: " + ticketId);
                        }
                    }

                    // Clear cart
                    cart.clear();

                    // Redirect to invoice dựa trên loại
                    String invoiceUrl = "";
                    if (!ticketIds.isEmpty() && rentalIds.isEmpty() && saleIds.isEmpty()) {
                        // Chỉ có ticket
                        invoiceUrl = "invoice?type=ticket&ids=" +
                                String.join(",", ticketIds.stream().map(String::valueOf).toArray(String[]::new));
                    } else if (!rentalIds.isEmpty() && ticketIds.isEmpty() && saleIds.isEmpty()) {
                        // Chỉ có rental
                        invoiceUrl = "invoice?type=equipment_rental&ids=" +
                                String.join(",", rentalIds.stream().map(String::valueOf).toArray(String[]::new));
                    } else if (!saleIds.isEmpty() && ticketIds.isEmpty() && rentalIds.isEmpty()) {
                        // Chỉ có buy
                        invoiceUrl = "invoice?type=equipment_buy&ids=" +
                                String.join(",", saleIds.stream().map(String::valueOf).toArray(String[]::new));
                    } else {
                        // Mixed
                        List<String> allIds = new ArrayList<>();
                        ticketIds.forEach(id -> allIds.add("T" + id));
                        rentalIds.forEach(id -> allIds.add("R" + id));
                        saleIds.forEach(id -> allIds.add("S" + id));
                        invoiceUrl = "invoice?type=mixed&ids=" + String.join(",", allIds);
                    }

                    response.sendRedirect(invoiceUrl);
                } else {
                    throw new SQLException("Failed to create payment record");
                }
            } else {
                throw new SQLException("Failed to process cart items");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Payment processing failed: " + e.getMessage());
            request.getRequestDispatcher("/payment-form.jsp").forward(request, response);
        }
    }

    private int processTicketItem(CartItem item, User user, String customerName, String customerIdCard)
            throws SQLException {
        TicketDAO ticketDAO = new TicketDAO();

        // Tạo ticket
        Ticket ticket = new Ticket();
        ticket.setUserId(user.getId());
        ticket.setCustomerName(customerName);
        ticket.setCustomerIdCard(customerIdCard);

        // Lấy ticket type từ item type (e.g., "Ticket_Single" -> "Single")
        String ticketTypeName = item.getType().replace("Ticket_", "");

        // Set ticket type ID
        int ticketTypeId = TicketDAO.getTicketTypeIdByEnum(Ticket.TicketTypeName.valueOf(ticketTypeName));
        ticket.setTicketTypeId(ticketTypeId);
        ticket.setTicketTypeName(ticketTypeName);

        ticket.setQuantity(item.getQty());
        ticket.setPrice(item.getPrice());
        ticket.setTotal(item.getSubtotal());

        // Set dates
        LocalDate startDate = LocalDate.now();
        LocalDate endDate = calculateEndDate(startDate, Ticket.TicketTypeName.valueOf(ticketTypeName));
        ticket.setStartDate(startDate);
        ticket.setEndDate(endDate);

        ticket.setTicketStatus(Ticket.TicketStatus.Active);
        ticket.setPaymentStatus(Ticket.PaymentStatus.Paid);
        ticket.setCreatedAt(LocalDateTime.now());

        // Save ticket
        Integer ticketId = ticketDAO.saveTicket(ticket);
        return ticketId != null ? ticketId : -1;
    }

    private LocalDate calculateEndDate(LocalDate startDate, Ticket.TicketTypeName type) {
        switch (type) {
            case Single:
                return startDate; // Same day
            case Monthly:
                return startDate.plusMonths(1);
            case ThreeMonthly:
                return startDate.plusMonths(3);
            case SixMonthly:
                return startDate.plusMonths(6);
            case Year:
                return startDate.plusYears(1);
            default:
                return startDate;
        }
    }

    private int processEquipmentRentalItem(CartItem item, User user, String customerName, String customerIdCard)
            throws SQLException {
        int inventoryId = item.getInventoryId();
        int quantity = item.getQty();
        double rentPrice = item.getPrice().doubleValue();
        double totalAmount = item.getSubtotal().doubleValue();

        EquipmentRental rental = new EquipmentRental(customerName, customerIdCard,
                user.getId(), // staff ID
                inventoryId,
                quantity,
                new java.sql.Date(System.currentTimeMillis()),
                rentPrice,
                totalAmount
        );

        boolean success = EquipmentDAO.processRental(rental);
        return success ? rental.getRentalId() : -1;
    }

    private int processEquipmentBuyItem(CartItem item, User user, String customerName)
            throws SQLException {
        int inventoryId = item.getInventoryId();
        int quantity = item.getQty();
        double salePrice = item.getPrice().doubleValue();
        double totalAmount = item.getSubtotal().doubleValue();

        EquipmentSale sale = new EquipmentSale(
                customerName,
                user.getId(), // staff ID
                inventoryId,
                quantity,
                salePrice,
                totalAmount
        );

        boolean success = EquipmentDAO.processSale(sale);
        return success ? sale.getSaleId() : -1;
    }

    private String determinePaymentType(Cart cart) {
        if (cart == null || cart.getItems().isEmpty()) {
            return "unknown";
        }

        boolean hasTicket = false;
        boolean hasRental = false;
        boolean hasBuy = false;

        for (CartItem item : cart.getItems()) {
            String type = item.getType();
            if (type != null) {
                if (type.startsWith("Ticket_")) {
                    hasTicket = true;
                } else if ("EquipmentRental".equals(type)) {
                    hasRental = true;
                } else if ("EquipmentBuy".equals(type)) {
                    hasBuy = true;
                }
            }
        }

        // Xác định loại payment
        int typeCount = 0;
        if (hasTicket) typeCount++;
        if (hasRental) typeCount++;
        if (hasBuy) typeCount++;

        if (typeCount > 1) {
            return "mixed";
        } else if (hasTicket) {
            return "ticket";
        } else if (hasRental) {
            return "equipment_rental";
        } else if (hasBuy) {
            return "equipment_buy";
        } else {
            return "unknown";
        }
    }
}
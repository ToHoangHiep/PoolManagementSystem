package controller;

import dal.EquipmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.EquipmentRental;
import model.EquipmentSale;
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
        String idsStr = request.getParameter("ids");

        if (idsStr == null || idsStr.isEmpty()) {
            request.setAttribute("error", "IDs are missing");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        BigDecimal totalAmount = BigDecimal.ZERO;
        String customerName = "Unknown";
        String customerIdCard = "Unknown";

        if ("ticket".equals(type)) {
            TicketDAO ticketDAO = new TicketDAO();
            List<Integer> ids = new ArrayList<>();
            for (String id : idsStr.split(",")) {
                try {
                    ids.add(Integer.parseInt(id.trim()));
                } catch (NumberFormatException e) {
                    System.out.println("[WARN Invoice] Bỏ qua ID không hợp lệ: " + id + " - Lỗi: " + e.getMessage());
                }
            }

            if (ids.isEmpty()) {
                request.setAttribute("error", "Invalid IDs: " + idsStr);
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }

            List<Ticket> tickets;
            try {
                tickets = ticketDAO.getTicketsByIds(ids);
            } catch (SQLException e) {
                System.out.println("[ERROR Invoice] Lỗi khi lấy ticket: " + e.getMessage());
                request.setAttribute("error", "Lỗi khi tải thông tin vé: " + e.getMessage());
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }

            if (tickets == null || tickets.isEmpty()) {
                System.out.println("[ERROR Invoice] Không tìm thấy vé nào với IDs: " + idsStr);
                request.setAttribute("error", "Không tìm thấy vé với IDs: " + idsStr);
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }

            for (Ticket ticket : tickets) {
                BigDecimal ticketTotal = ticket.getTotal() != null ? ticket.getTotal() : BigDecimal.ZERO;
                totalAmount = totalAmount.add(ticketTotal);
            }

            customerName = tickets.get(0).getCustomerName();
            customerIdCard = tickets.get(0).getCustomerIdCard();

            request.setAttribute("tickets", tickets);
            request.setAttribute("type", type);

        } else if ("equipment_rental".equals(type)) {
            EquipmentDAO equipmentDAO = new EquipmentDAO();
            List<Integer> ids = new ArrayList<>();
            for (String id : idsStr.split(",")) {
                try {
                    ids.add(Integer.parseInt(id.trim()));
                } catch (NumberFormatException e) {
                    System.out.println("[WARN Invoice] Bỏ qua ID không hợp lệ: " + id + " - Lỗi: " + e.getMessage());
                }
            }

            if (ids.isEmpty()) {
                request.setAttribute("error", "Invalid IDs: " + idsStr);
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }

            List<EquipmentRental> rentals;
            try {
                rentals = equipmentDAO.getRentalsByIds(ids);
            } catch (SQLException e) {
                System.out.println("[ERROR Invoice] Lỗi khi lấy rental: " + e.getMessage());
                request.setAttribute("error", "Lỗi khi tải thông tin thuê: " + e.getMessage());
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }

            if (rentals == null || rentals.isEmpty()) {
                request.setAttribute("error", "Không tìm thấy thuê với IDs: " + idsStr);
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }

            for (EquipmentRental rental : rentals) {
                totalAmount = totalAmount.add(BigDecimal.valueOf(rental.getTotalAmount()));
            }

            customerName = rentals.get(0).getCustomerName();
            customerIdCard = rentals.get(0).getCustomerIdCard();

            request.setAttribute("rentals", rentals);
            request.setAttribute("type", type);

        } else if ("equipment_buy".equals(type)) {
            EquipmentDAO equipmentDAO = new EquipmentDAO();
            List<Integer> ids = new ArrayList<>();
            for (String id : idsStr.split(",")) {
                try {
                    ids.add(Integer.parseInt(id.trim()));
                } catch (NumberFormatException e) {
                    System.out.println("[WARN Invoice] Bỏ qua ID không hợp lệ: " + id + " - Lỗi: " + e.getMessage());
                }
            }

            if (ids.isEmpty()) {
                request.setAttribute("error", "Invalid IDs: " + idsStr);
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }

            List<EquipmentSale> sales;
            try {
                sales = equipmentDAO.getSalesByIds(ids);
            } catch (SQLException e) {
                System.out.println("[ERROR Invoice] Lỗi khi lấy sale: " + e.getMessage());
                request.setAttribute("error", "Lỗi khi tải thông tin mua: " + e.getMessage());
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }

            if (sales == null || sales.isEmpty()) {
                request.setAttribute("error", "Không tìm thấy mua với IDs: " + idsStr);
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }

            for (EquipmentSale sale : sales) {
                totalAmount = totalAmount.add(BigDecimal.valueOf(sale.getTotalAmount()));
            }

            customerName = sales.get(0).getCustomerName();

            request.setAttribute("sales", sales);
            request.setAttribute("type", type);

        } else if ("mixed".equals(type)) {
            TicketDAO ticketDAO = new TicketDAO();
            EquipmentDAO equipmentDAO = new EquipmentDAO();

            List<Integer> ticketIds = new ArrayList<>();
            List<Integer> rentalIds = new ArrayList<>();
            List<Integer> saleIds = new ArrayList<>();

            // Parse ids với prefix
            for (String idStr : idsStr.split(",")) {
                try {
                    if (idStr.startsWith("T")) {
                        ticketIds.add(Integer.parseInt(idStr.substring(1).trim()));
                    } else if (idStr.startsWith("R")) {
                        rentalIds.add(Integer.parseInt(idStr.substring(1).trim()));
                    } else if (idStr.startsWith("S")) {
                        saleIds.add(Integer.parseInt(idStr.substring(1).trim()));
                    } else {
                        System.out.println("[WARN Invoice Mixed] Bỏ qua ID không có prefix: " + idStr);
                    }
                } catch (NumberFormatException e) {
                    System.out.println("[WARN Invoice Mixed] Bỏ qua ID không hợp lệ: " + idStr + " - Lỗi: " + e.getMessage());
                }
            }

            // Kiểm tra nếu tất cả lists đều rỗng
            if (ticketIds.isEmpty() && rentalIds.isEmpty() && saleIds.isEmpty()) {
                request.setAttribute("error", "Invalid IDs: " + idsStr);
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }

            List<Ticket> tickets = new ArrayList<>();
            List<EquipmentRental> rentals = new ArrayList<>();
            List<EquipmentSale> sales = new ArrayList<>();

            try {
                if (!ticketIds.isEmpty()) {
                    tickets = ticketDAO.getTicketsByIds(ticketIds);
                }
                if (!rentalIds.isEmpty()) {
                    rentals = equipmentDAO.getRentalsByIds(rentalIds);
                }
                if (!saleIds.isEmpty()) {
                    sales = equipmentDAO.getSalesByIds(saleIds);
                }
            } catch (SQLException e) {
                System.out.println("[ERROR Invoice Mixed] Lỗi khi lấy thông tin mixed: " + e.getMessage());
                request.setAttribute("error", "Lỗi khi tải thông tin mixed: " + e.getMessage());
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }

            // Tính total
            for (Ticket ticket : tickets) {
                totalAmount = totalAmount.add(ticket.getTotal() != null ? ticket.getTotal() : BigDecimal.ZERO);
            }
            for (EquipmentRental rental : rentals) {
                totalAmount = totalAmount.add(BigDecimal.valueOf(rental.getTotalAmount()));
            }
            for (EquipmentSale sale : sales) {
                totalAmount = totalAmount.add(BigDecimal.valueOf(sale.getTotalAmount()));
            }

            // Lấy customer info từ item đầu tiên có info
            if (!tickets.isEmpty()) {
                customerName = tickets.get(0).getCustomerName();
                customerIdCard = tickets.get(0).getCustomerIdCard();
            } else if (!rentals.isEmpty()) {
                customerName = rentals.get(0).getCustomerName();
                customerIdCard = rentals.get(0).getCustomerIdCard();
            } else if (!sales.isEmpty()) {
                customerName = sales.get(0).getCustomerName();
            }

            request.setAttribute("tickets", tickets);
            request.setAttribute("rentals", rentals);
            request.setAttribute("sales", sales);
            request.setAttribute("type", type);
        } else {
            request.setAttribute("error", "Invalid invoice type: " + type);
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        String backUrl = request.getContextPath() + "/staff_dashboard.jsp";
        if ("ticket".equals(type)) {
            backUrl = request.getContextPath() + "/purchase";
        } else if ("equipment_rental".equals(type)) {
            backUrl = request.getContextPath() + "/equipment?mode=rental";
        } else if ("equipment_buy".equals(type)) {
            backUrl = request.getContextPath() + "/equipment?mode=buy";
        } else if ("mixed".equals(type)) {
            backUrl = request.getContextPath() + "/staff_dashboard.jsp";
        }
        request.setAttribute("backUrl", backUrl);

        request.setAttribute("totalAmount", totalAmount);
        request.setAttribute("customerName", customerName);
        request.setAttribute("customerIdCard", customerIdCard);
        request.setAttribute("invoiceNumber", "INV-" + idsStr.replace(",", "-"));


        request.getRequestDispatcher("invoice_pay.jsp").forward(request, response);
    }
}
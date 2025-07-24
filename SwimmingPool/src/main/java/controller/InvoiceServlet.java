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
            System.out.println("[ERROR] Thiếu tham số ids");
            request.setAttribute("error", "IDs are missing");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        String[] idsArr = idsStr.split(",");
        List<Integer> ids = new ArrayList<>();
        for (String id : idsArr) {
            try {
                ids.add(Integer.parseInt(id.trim()));
            } catch (NumberFormatException e) {
                System.out.println("[WARN] Bỏ qua ID không hợp lệ: " + id);
            }
        }


        if (ids.isEmpty()) {
            request.setAttribute("error", "Invalid IDs: " + idsStr);
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        BigDecimal totalAmount = BigDecimal.ZERO;
        String customerName = "Unknown";
        String customerIdCard = "Unknown";


        if ("ticket".equals(type)) {
            TicketDAO ticketDAO = new TicketDAO();
            List<Ticket> tickets;

            try {
                tickets = ticketDAO.getTicketsByIds(ids);
            } catch (SQLException e) {
                request.setAttribute("error", "Lỗi khi tải thông tin vé: " + e.getMessage());
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }

            if (tickets == null || tickets.isEmpty()) {
                System.out.println("[ERROR] Không tìm thấy vé nào với IDs: " + idsStr);
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
            List<EquipmentRental> rentals;

            try {
                rentals = equipmentDAO.getRentalsByIds(ids);
            } catch (SQLException e) {
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
            List<EquipmentSale> sales;

            try {
                sales = equipmentDAO.getSalesByIds(ids);
            } catch (SQLException e) {
                System.out.println("[ERROR] Lỗi khi lấy thông tin mua: " + e.getMessage());
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
            // customerIdCard không có

            request.setAttribute("sales", sales);
            request.setAttribute("type", type);

        } else if ("mixed".equals(type)) {
            TicketDAO ticketDAO = new TicketDAO();
            EquipmentDAO equipmentDAO = new EquipmentDAO();

            List<Ticket> tickets;
            List<EquipmentRental> rentals;
            List<EquipmentSale> sales;

            try {
                tickets = ticketDAO.getTicketsByIds(ids);
                rentals = equipmentDAO.getRentalsByIds(ids);
                sales = equipmentDAO.getSalesByIds(ids);


            } catch (SQLException e) {
                System.out.println("[ERROR] Lỗi khi lấy thông tin mixed: " + e.getMessage());
                request.setAttribute("error", "Lỗi khi tải thông tin mixed: " + e.getMessage());
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }

            for (Ticket ticket : tickets) {
                totalAmount = totalAmount.add(ticket.getTotal() != null ? ticket.getTotal() : BigDecimal.ZERO);
            }

            for (EquipmentRental rental : rentals) {
                totalAmount = totalAmount.add(BigDecimal.valueOf(rental.getTotalAmount()));
            }

            for (EquipmentSale sale : sales) {
                totalAmount = totalAmount.add(BigDecimal.valueOf(sale.getTotalAmount()));
            }

            if (!tickets.isEmpty()) {
                customerName = tickets.get(0).getCustomerName();
                customerIdCard = tickets.get(0).getCustomerIdCard();
            } else if (!rentals.isEmpty()) {
                customerName = rentals.get(0).getCustomerName();
                customerIdCard = rentals.get(0).getCustomerIdCard();
            } else if (!sales.isEmpty()) {
                customerName = sales.get(0).getCustomerName();
                // customerIdCard không có
            }

            request.setAttribute("tickets", tickets);
            request.setAttribute("rentals", rentals);
            request.setAttribute("sales", sales);
            request.setAttribute("type", type);
        } else {
            System.out.println("[ERROR] Loại invoice không hợp lệ: " + type);
            request.setAttribute("error", "Invalid invoice type: " + type);
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        // Thiết lập URL quay lại theo type
        String backUrl = request.getContextPath() + "/home";  // Default

        if ("ticket".equals(type)) {
            backUrl = request.getContextPath() + "/purchase";  // Giữ nguyên nếu /purchase là servlet load data cho ticket
            // Nếu ticketpurchase.jsp cần servlet, đổi thành "/ticket-servlet" hoặc tương tự
        } else if ("equipment_rental".equals(type)) {
            backUrl = request.getContextPath() + "/equipment?mode=rental";  // Gọi servlet để load data rồi forward rental.jsp
        } else if ("equipment_buy".equals(type)) {
            backUrl = request.getContextPath() + "/equipment?mode=buy";  // Gọi servlet để load data rồi forward buy.jsp
        } else if ("mixed".equals(type)) {
            backUrl = request.getContextPath() + "/home";

        }
        request.setAttribute("backUrl", backUrl);

        request.setAttribute("totalAmount", totalAmount);
        request.setAttribute("customerName", customerName);
        request.setAttribute("customerIdCard", customerIdCard);
        request.setAttribute("invoiceNumber", "INV-" + idsStr.replace(",", "-"));

        System.out.println("[DEBUG] Kết thúc xử lý, forward tới invoice_pay.jsp");
        request.getRequestDispatcher("invoice_pay.jsp").forward(request, response);
    }
}
package controller;

import dal.*;
import model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/compensation")
public class CompensationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            switch (action != null ? action : "list") {
                case "list":
                    showCompensationList(request, response);
                    break;
                case "create":
                    showCreateForm(request, response);
                    break;
                case "view":
                    showCompensationDetail(request, response);
                    break;
//                case "payment":
//                    showPaymentForm(request, response);
//                    break;
                case "invoice":  // THÊM CASE NÀY
                    showInvoice(request, response);
                    break;
                default:
                    showCompensationList(request, response);
                    break;
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
        System.out.println("=== doPost called with action: " + action + " ===");  // THÊM DÒNG NÀY
        try {
            switch (action != null ? action : "") {
                case "calculate":
                    handleCalculation(request, response);
                    break;
                case "create":
                    handleCreateCompensation(request, response);
                    break;
//                case "payment":
//                    handlePayment(request, response);
//                    break;
                default:
                    response.sendRedirect("compensation?action=list");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System error: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    // ===================== GET HANDLERS =====================

    /**
     * Hiển thị danh sách tất cả compensations
     */
    private void showCompensationList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<EquipmentCompensation> compensations = CompensationDAO.getAllCompensations();

        request.setAttribute("compensations", compensations);
        request.getRequestDispatcher("/compensation-list.jsp").forward(request, response);
    }

    /**
     * Hiển thị form tạo compensation
     */
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String rentalIdParam = request.getParameter("rentalId");

        if (rentalIdParam != null && !rentalIdParam.trim().isEmpty()) {
            try {
                int rentalId = Integer.parseInt(rentalIdParam);

                // Gọi static method
                EquipmentRental rental = EquipmentDAO.getRentalById(rentalId);

                if (rental != null && "active".equals(rental.getStatus())) {
                    Map<String, Object> equipment = EquipmentDAO.getEquipmentById(rental.getInventoryId());
                    request.setAttribute("rental", rental);
                    request.setAttribute("equipment", equipment);
                } else {
                    request.setAttribute("error", "Rental not found or not active");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid rental ID");
            } catch (SQLException e) {
                System.err.println("Database error in showCreateForm: " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("error", "Database error: " + e.getMessage());
            }
        }

        try {
            // Gọi static method
            List<EquipmentRental> activeRentals = EquipmentDAO.getActiveRentals();

            Map<Integer, Map<String, Object>> equipmentDataMap = new HashMap<>();
            for (EquipmentRental rental : activeRentals) {
                try {
                    Map<String, Object> equipment = EquipmentDAO.getEquipmentById(rental.getInventoryId());
                    if (equipment != null) {
                        equipmentDataMap.put(rental.getInventoryId(), equipment);
                    }
                } catch (SQLException e) {
                    System.err.println("Error loading equipment for ID " + rental.getInventoryId() + ": " + e.getMessage());
                    // Continue with other equipment
                }
            }

            request.setAttribute("activeRentals", activeRentals);
            request.setAttribute("equipmentDataMap", equipmentDataMap);

        } catch (SQLException e) {
            System.err.println("Database error loading rentals: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Database error loading rentals: " + e.getMessage());
        }

        request.getRequestDispatcher("/compensation-form.jsp").forward(request, response);
    }

    /**
     * Hiển thị chi tiết compensation
     */
    private void showCompensationDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String compensationIdParam = request.getParameter("id");

        if (compensationIdParam != null) {
            try {
                int compensationId = Integer.parseInt(compensationIdParam);

                // Lấy compensation info
                EquipmentCompensation compensation = CompensationDAO.getCompensationById(compensationId);

                if (compensation != null) {
                    // Lấy rental info
                    EquipmentRental rental = EquipmentDAO.getRentalById(compensation.getRentalId());

                    // SỬA: Lấy payments từ PaymentDAO thay vì CompensationDAO
                    List<Payment> payments = PaymentDAO.getPaymentsByReference("compensation", compensationId);


                    // Lấy repairs nếu có
                    List<EquipmentRepair> repairs = CompensationDAO.getRepairsByCompensationId(compensationId);

                    request.setAttribute("compensation", compensation);
                    request.setAttribute("rental", rental);
                    request.setAttribute("payments", payments);  // Giờ là List<Payment> thay vì List<CompensationPayment>
                    request.setAttribute("repairs", repairs);

                } else {
                    request.setAttribute("error", "Compensation not found");
                }

            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid compensation ID");
            } catch (SQLException e) {
                System.err.println("Database error in showCompensationDetail: " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("error", "Database error: " + e.getMessage());
            }
        }

        request.getRequestDispatcher("/compensation-detail.jsp").forward(request, response);
    }

    /**
     * Hiển thị form payment
     */
//    private void showPaymentForm(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String compensationIdParam = request.getParameter("compensationId");
//
//        if (compensationIdParam != null) {
//            try {
//                int compensationId = Integer.parseInt(compensationIdParam);
//                EquipmentCompensation compensation = CompensationDAO.getCompensationById(compensationId);
//
//                if (compensation != null) {
//                    // Tính remaining amount
//                    BigDecimal remainingAmount = compensation.getTotalAmount().subtract(compensation.getPaidAmount());
//                    request.setAttribute("compensation", compensation);
//                    request.setAttribute("remainingAmount", remainingAmount);
//                } else {
//                    request.setAttribute("error", "Compensation not found or already paid");
//                }
//
//            } catch (NumberFormatException e) {
//                request.setAttribute("error", "Invalid compensation ID");
//            }
//        }
//
//        request.getRequestDispatcher("/payment-form.jsp").forward(request, response);
//    }
    private void handleCalculation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int rentalId = Integer.parseInt(request.getParameter("rentalId"));
            String compensationType = request.getParameter("compensationType");
            String rateStr = request.getParameter("compensationRate");

            System.out.println("=== DEBUG CALCULATION ===");
            System.out.println("rentalId: " + rentalId);
            System.out.println("compensationType: " + compensationType);
            System.out.println("compensationRate: " + rateStr);

            if (rateStr != null && !rateStr.trim().isEmpty()) {
                double rate = Double.parseDouble(rateStr);

//                // Validation rate
//                if (rate < 0 || rate > 1) {
//                    request.setAttribute("error", "Compensation rate must be between 0.0 and 1.0");
//                    showCreateForm(request, response);
//                    return;
//                }

                try {
                    // Gọi static method trực tiếp
                    EquipmentRental rental = EquipmentDAO.getRentalById(rentalId);
                    if (rental == null) {
                        request.setAttribute("error", "Rental not found");
                        showCreateForm(request, response);
                        return;
                    }

                    Map<String, Object> equipment = EquipmentDAO.getEquipmentById(rental.getInventoryId());
                    if (equipment == null) {
                        request.setAttribute("error", "Equipment not found");
                        showCreateForm(request, response);
                        return;
                    }

                    // Tính toán dựa trên import_price
                    double importPrice = (Double) equipment.get("importPrice");
                    double importPriceTotal = importPrice * rental.getQuantity();
                    double totalAmount = importPriceTotal * rate;

                    System.out.println("importPrice: " + importPrice);
                    System.out.println("quantity: " + rental.getQuantity());
                    System.out.println("importPriceTotal: " + importPriceTotal);
                    System.out.println("totalAmount: " + totalAmount);

                    // Tạo calculation result
                    Map<String, Object> calculationResult = new HashMap<>();
                    calculationResult.put("importPriceTotal", importPriceTotal);
                    calculationResult.put("rate", rate);
                    calculationResult.put("totalAmount", totalAmount);
                    calculationResult.put("importPrice", importPrice);
                    calculationResult.put("quantity", rental.getQuantity());

                    // Set attributes để hiển thị
                    request.setAttribute("calculationResult", calculationResult);
                    request.setAttribute("compensationRate", rate);
                    request.setAttribute("compensationType", compensationType);
                    request.setAttribute("selectedRentalId", rentalId);

                    System.out.println("=== CALCULATION COMPLETE ===");

                } catch (SQLException e) {
                    System.err.println("Database error in calculation: " + e.getMessage());
                    e.printStackTrace();
                    request.setAttribute("error", "Database error: " + e.getMessage());
                }
            }

            // Load lại form với kết quả
            showCreateForm(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid number format");
            showCreateForm(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System error: " + e.getMessage());
            showCreateForm(request, response);
        }
    }

    /**
     * Xử lý tạo compensation
     */
    private void handleCreateCompensation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("=== Starting handleCreateCompensation ===");
        try {
            // Lấy parameters từ form
            int rentalId = Integer.parseInt(request.getParameter("rentalId"));
            String compensationType = request.getParameter("compensationType");
            String damageDescription = request.getParameter("damageDescription");
            BigDecimal compensationRate = new BigDecimal(request.getParameter("compensationRate"));

            System.out.println("Parameters: rentalId=" + rentalId + ", type=" + compensationType + ", rate=" + compensationRate);

            // Lấy rental info
            EquipmentRental rental = EquipmentDAO.getRentalById(rentalId);
            if (rental == null || !"active".equals(rental.getStatus())) {
                System.out.println("Error: Invalid rental or not active");
                request.setAttribute("error", "Invalid rental or rental not active");
                showCreateForm(request, response);
                return;
            }

            // Lấy equipment info
            Map<String, Object> equipment = EquipmentDAO.getEquipmentById(rental.getInventoryId());
            if (equipment == null) {
                System.out.println("Error: Equipment not found");
                request.setAttribute("error", "Equipment not found");
                showCreateForm(request, response);
                return;
            }

            // Tính amounts
            double importPrice = (Double) equipment.get("importPrice");
            BigDecimal importPriceTotal = BigDecimal.valueOf(importPrice * rental.getQuantity());
            BigDecimal totalAmount = importPriceTotal.multiply(compensationRate);

            // Tạo compensation object
            EquipmentCompensation compensation = new EquipmentCompensation();
            compensation.setRentalId(rentalId);
            compensation.setCompensationType(compensationType);
            compensation.setDamageDescription(damageDescription);
            compensation.setImportPriceTotal(importPriceTotal);
            compensation.setCompensationRate(compensationRate);
            compensation.setTotalAmount(totalAmount);
            compensation.setPaidAmount(BigDecimal.ZERO);
            compensation.setPaymentStatus("pending");

            if ("damaged".equals(compensationType)) {
                compensation.setCanRepair(compensationRate.compareTo(BigDecimal.ONE) < 0);
            } else {
                compensation.setCanRepair(false);
            }

            // === THÊM LOGIC TRỪ THIẾT BỊ KHỎI KHO ===
            boolean success = false;

            try {
                // Tạo compensation và trừ inventory trong 1 transaction
                success = CompensationDAO.createCompensationAndDeductInventory(
                        compensation,
                        rental.getInventoryId(),
                        rental.getQuantity(),
                        compensationType
                );
            } catch (Exception e) {
                System.err.println("Error creating compensation: " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("error", "Failed to create compensation: " + e.getMessage());
                showCreateForm(request, response);
                return;
            }

            System.out.println("Create result: " + (success ? "SUCCESS" : "FAILED"));

            if (success) {
                System.out.println("Redirecting to invoice?id=" + compensation.getCompensationId());
                response.sendRedirect("compensation?action=invoice&id=" + compensation.getCompensationId());
            } else {
                request.setAttribute("error", "Failed to create compensation and update inventory");
                showCreateForm(request, response);
            }

        } catch (NumberFormatException e) {
            System.out.println("Error: Invalid input format - " + e.getMessage());
            request.setAttribute("error", "Invalid input format");
            showCreateForm(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("System error: " + e.getMessage());
            request.setAttribute("error", "System error: " + e.getMessage());
            showCreateForm(request, response);
        }

    }


//    private void handlePayment(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        try {
//            int compensationId = Integer.parseInt(request.getParameter("compensationId"));
//            BigDecimal paymentAmount = new BigDecimal(request.getParameter("paymentAmount"));
//            String paymentMethod = request.getParameter("paymentMethod"); // Thêm mới
//            String notes = request.getParameter("notes");
//
//            // Lấy thông tin compensation
//            EquipmentCompensation compensation = CompensationDAO.getCompensationById(compensationId);
//            if (compensation == null) {
//                request.setAttribute("error", "Compensation not found");
//                showPaymentForm(request, response);
//                return;
//            }
//
//
//            BigDecimal remainingAmount = compensation.getTotalAmount().subtract(compensation.getPaidAmount());
//            if (paymentAmount.compareTo(BigDecimal.ZERO) <= 0 ||
//                    paymentAmount.compareTo(remainingAmount) > 0) {
//                request.setAttribute("error", "Invalid payment amount. Maximum: " + remainingAmount);
//                showPaymentForm(request, response);
//                return;
//            }
//
//            // SỬA: Tạo Payment object thay vì CompensationPayment
//            // Lấy thông tin khách hàng từ rental
//            EquipmentRental rental = EquipmentDAO.getRentalById(compensation.getRentalId());
//
//            Payment payment = new Payment();
//            payment.setCustomerName(rental.getCustomerName());
//            payment.setCustomerIdCard(rental.getCustomerIdCard());
//            payment.setAmount(paymentAmount);
//            payment.setPaymentMethod(paymentMethod != null ? paymentMethod : "cash");
//            payment.setPaymentFor("compensation");
//            payment.setReferenceId(compensationId);
//            payment.setNotes(notes);
//
//            // Lấy staff_id từ session
//            User user = (User) request.getSession().getAttribute("user");
//            if (user != null) {
//                payment.setStaffId(user.getId());
//            }
//
//            // SỬA: Gọi method mới trong CompensationDAO
//            boolean success = CompensationDAO.addCompensationPayment(payment);
//
//            if (success) {
//                request.getSession().setAttribute("success", "Payment processed successfully!");
//                response.sendRedirect("compensation?action=view&id=" + compensationId);
//            } else {
//                request.setAttribute("error", "Failed to process payment");
//                showPaymentForm(request, response);
//            }
//
//        } catch (NumberFormatException e) {
//            request.setAttribute("error", "Invalid input format");
//            showPaymentForm(request, response);
//        } catch (Exception e) {
//            e.printStackTrace();
//            request.setAttribute("error", "System error: " + e.getMessage());
//            showPaymentForm(request, response);
//        }
//    }

    private void showInvoice(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int compensationId = Integer.parseInt(idParam);

                // Load dữ liệu compensation
                EquipmentCompensation compensation = CompensationDAO.getCompensationById(compensationId);

                if (compensation != null) {
                    // Load rental và equipment liên quan
                    EquipmentRental rental = EquipmentDAO.getRentalById(compensation.getRentalId());
                    Map<String, Object> equipment = EquipmentDAO.getEquipmentById(rental.getInventoryId());

                    // Set attributes cho JSP (dựa trên compensation-invoice.jsp)
                    request.setAttribute("compensation", compensation);
                    request.setAttribute("rental", rental);
                    request.setAttribute("equipment", equipment);
                    request.setAttribute("invoiceNumber", String.format("COMP-%04d", compensationId));  // Ví dụ format mã hóa đơn

                    // Forward đến trang invoice
                    request.getRequestDispatcher("/compensation-invoice.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Compensation not found");
                    request.getRequestDispatcher("/error.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid compensation ID");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("error", "Database error: " + e.getMessage());
                request.getRequestDispatcher("/error.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Missing compensation ID");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}

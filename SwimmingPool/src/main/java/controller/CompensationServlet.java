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
                case "payment":
                    showPaymentForm(request, response);
                    break;
                case "photos":
                    showDamagePhotos(request, response);
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

        try {
            switch (action != null ? action : "") {
                case "calculate":  // ← THÊM CASE MỚI
                    handleCalculation(request, response);
                    break;
                case "create":
                    handleCreateCompensation(request, response);
                    break;
                case "payment":
                    handlePayment(request, response);
                    break;
                case "upload-photo":
                    handlePhotoUpload(request, response);
                    break;
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

                    // Lấy payments
                    List<CompensationPayment> payments = CompensationDAO.getPaymentsByCompensationId(compensationId);

                    // Lấy damage photos
                    List<EquipmentDamagePhoto> photos = CompensationDAO.getDamagePhotosByCompensationId(compensationId);

                    // Lấy repairs nếu có
                    List<EquipmentRepair> repairs = CompensationDAO.getRepairsByCompensationId(compensationId);

                    request.setAttribute("compensation", compensation);
                    request.setAttribute("rental", rental);
                    request.setAttribute("payments", payments);
                    request.setAttribute("photos", photos);
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
    private void showPaymentForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String compensationIdParam = request.getParameter("compensationId");

        if (compensationIdParam != null) {
            try {
                int compensationId = Integer.parseInt(compensationIdParam);
                EquipmentCompensation compensation = CompensationDAO.getCompensationById(compensationId);

                if (compensation != null && !compensation.isFullyPaid()) {
                    request.setAttribute("compensation", compensation);
                    request.setAttribute("remainingAmount", compensation.getRemainingAmount());
                } else {
                    request.setAttribute("error", "Compensation not found or already paid");
                }

            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid compensation ID");
            }
        }

        request.getRequestDispatcher("/payment-form.jsp").forward(request, response);
    }

    /**
     * Hiển thị damage photos
     */
    private void showDamagePhotos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String compensationIdParam = request.getParameter("compensationId");

        if (compensationIdParam != null) {
            try {
                int compensationId = Integer.parseInt(compensationIdParam);

                EquipmentCompensation compensation = CompensationDAO.getCompensationById(compensationId);
                List<EquipmentDamagePhoto> photos = CompensationDAO.getDamagePhotosByCompensationId(compensationId);

                request.setAttribute("compensation", compensation);
                request.setAttribute("photos", photos);

            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid compensation ID");
            }
        }

        request.getRequestDispatcher("/damage-photos.jsp").forward(request, response);
    }

    // ===================== POST HANDLERS =====================

    /**
     * Xử lý tính toán compensation - ← METHOD MỚI
     */
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

                // Validation rate
                if (rate < 0 || rate > 1) {
                    request.setAttribute("error", "Compensation rate must be between 0.0 and 1.0");
                    showCreateForm(request, response);
                    return;
                }

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

                    // Tính toán ở server
                    double salePrice = (Double) equipment.get("salePrice");
                    double originalPrice = salePrice * rental.getQuantity();
                    double totalAmount = originalPrice * rate;

                    System.out.println("salePrice: " + salePrice);
                    System.out.println("quantity: " + rental.getQuantity());
                    System.out.println("originalPrice: " + originalPrice);
                    System.out.println("totalAmount: " + totalAmount);

                    // Tạo calculation result
                    Map<String, Object> calculationResult = new HashMap<>();
                    calculationResult.put("originalPrice", originalPrice);
                    calculationResult.put("rate", rate);
                    calculationResult.put("totalAmount", totalAmount);
                    calculationResult.put("salePrice", salePrice);
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

        try {
            // Lấy parameters từ form
            int rentalId = Integer.parseInt(request.getParameter("rentalId"));
            String compensationType = request.getParameter("compensationType");
            String damageDescription = request.getParameter("damageDescription");
            String damageLevel = request.getParameter("damageLevel");
            BigDecimal compensationRate = new BigDecimal(request.getParameter("compensationRate"));

            // Validation cơ bản
            if (compensationRate.compareTo(BigDecimal.ZERO) <= 0 ||
                    compensationRate.compareTo(BigDecimal.ONE) > 0) {
                request.setAttribute("error", "Compensation rate must be between 0 and 1");
                showCreateForm(request, response);
                return;
            }

            // Lấy rental info để tính compensation
            EquipmentRental rental = EquipmentDAO.getRentalById(rentalId);
            if (rental == null || !"active".equals(rental.getStatus())) {
                request.setAttribute("error", "Invalid rental or rental not active");
                showCreateForm(request, response);
                return;
            }

            // Check blacklist
            if (BlacklistDAO.isCustomerBanned(rental.getCustomerIdCard())) {
                request.setAttribute("error", "Customer is banned");
                showCreateForm(request, response);
                return;
            }

            // Lấy equipment info để tính original price
            Map<String, Object> equipment = EquipmentDAO.getEquipmentById(rental.getInventoryId());
            if (equipment == null) {
                request.setAttribute("error", "Equipment not found");
                showCreateForm(request, response);
                return;
            }

            // Tính amounts
            double salePrice = (Double) equipment.get("salePrice");
            BigDecimal originalPrice = BigDecimal.valueOf(salePrice * rental.getQuantity());
            BigDecimal totalAmount = originalPrice.multiply(compensationRate);

            // Tạo compensation object
            EquipmentCompensation compensation = new EquipmentCompensation();
            compensation.setRentalId(rentalId);
            compensation.setCompensationType(compensationType);
            compensation.setDamageDescription(damageDescription);
            compensation.setDamageLevel(damageLevel);
            compensation.setOriginalPrice(originalPrice);
            compensation.setCompensationRate(compensationRate);
            compensation.setTotalAmount(totalAmount);
            compensation.setPaidAmount(BigDecimal.ZERO);
            compensation.setPaymentStatus("pending");

            // Set can_repair logic
            if ("damaged".equals(compensationType)) {
                compensation.setCanRepair(!"total".equals(damageLevel));
            } else {
                compensation.setCanRepair(false);
            }

            // Save compensation
            boolean success = CompensationDAO.createCompensation(compensation);

            if (success) {
                // Nếu severity cao, auto add to blacklist
                if (shouldAddToBlacklist(compensationType, damageLevel, totalAmount)) {
                    addCustomerToBlacklist(rental, compensationType, damageLevel);
                }

                response.sendRedirect("compensation?action=view&id=" + compensation.getCompensationId());
            } else {
                request.setAttribute("error", "Failed to create compensation");
                showCreateForm(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid input format");
            showCreateForm(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System error: " + e.getMessage());
            showCreateForm(request, response);
        }
    }

    /**
     * Xử lý payment
     */
    private void handlePayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int compensationId = Integer.parseInt(request.getParameter("compensationId"));
            BigDecimal paymentAmount = new BigDecimal(request.getParameter("paymentAmount"));
            String notes = request.getParameter("notes");

            // Validation
            EquipmentCompensation compensation = CompensationDAO.getCompensationById(compensationId);
            if (compensation == null) {
                request.setAttribute("error", "Compensation not found");
                showPaymentForm(request, response);
                return;
            }

            BigDecimal remainingAmount = compensation.getRemainingAmount();
            if (paymentAmount.compareTo(BigDecimal.ZERO) <= 0 ||
                    paymentAmount.compareTo(remainingAmount) > 0) {
                request.setAttribute("error", "Invalid payment amount. Maximum: " + remainingAmount);
                showPaymentForm(request, response);
                return;
            }

            // Create payment
            CompensationPayment payment = new CompensationPayment();
            payment.setCompensationId(compensationId);
            payment.setPaymentAmount(paymentAmount);
            payment.setNotes(notes);

            boolean success = CompensationDAO.addPayment(payment);

            if (success) {
                response.sendRedirect("compensation?action=view&id=" + compensationId);
            } else {
                request.setAttribute("error", "Failed to process payment");
                showPaymentForm(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid input format");
            showPaymentForm(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System error: " + e.getMessage());
            showPaymentForm(request, response);
        }
    }

    /**
     * Xử lý upload ảnh thiệt hại
     */
    private void handlePhotoUpload(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // TODO: Implement file upload logic
        // For now, just redirect back
        String compensationId = request.getParameter("compensationId");
        response.sendRedirect("compensation?action=photos&compensationId=" + compensationId);
    }

    // ===================== HELPER METHODS =====================

    /**
     * Logic kiểm tra có nên add customer vào blacklist không
     */
    private boolean shouldAddToBlacklist(String compensationType, String damageLevel, BigDecimal totalAmount) {
        // Logic:
        // - Lost items: auto blacklist
        // - Total damage với amount > 500k: auto blacklist
        // - Major damage với amount > 1M: auto blacklist

        if ("lost".equals(compensationType)) {
            return true;
        }

        if ("total".equals(damageLevel) && totalAmount.compareTo(new BigDecimal("500000")) > 0) {
            return true;
        }

        if ("major".equals(damageLevel) && totalAmount.compareTo(new BigDecimal("1000000")) > 0) {
            return true;
        }

        return false;
    }

    /**
     * Add customer vào blacklist
     */
    private void addCustomerToBlacklist(EquipmentRental rental, String compensationType, String damageLevel) {
        try {
            CustomerBlacklist blacklist = new CustomerBlacklist();
            blacklist.setCustomerIdCard(rental.getCustomerIdCard());
            blacklist.setCustomerName(rental.getCustomerName());

            if ("lost".equals(compensationType)) {
                blacklist.setReason("lost_items");
                blacklist.setSeverity("restricted");
            } else if ("total".equals(damageLevel)) {
                blacklist.setReason("frequent_damage");
                blacklist.setSeverity("warning");
            } else {
                blacklist.setReason("frequent_damage");
                blacklist.setSeverity("warning");
            }

            blacklist.setDescription("Auto-added due to compensation: " + compensationType + " - " + damageLevel);

            BlacklistDAO.addToBlacklist(blacklist);

        } catch (Exception e) {
            e.printStackTrace();
            // Log error but don't fail the main process
        }
    }
}
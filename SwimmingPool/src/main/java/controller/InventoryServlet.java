package controller;

import dal.InventoryDAO;
import dal.InventoryRequestDAO;
import model.Inventory;
import model.InventoryRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.RepairRequest;

import java.io.IOException;
import java.util.Date;
import java.util.List;

@WebServlet(name = "InventoryServlet", urlPatterns = {"/inventory"})
public class InventoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";
        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteInventory(request, response);
                break;
            case "search":
                searchInventory(request, response);
                break;
            case "filter":
                filterInventory(request, response);
                break;
            case "lowstock":
                showLowStockItems(request, response);
                break;
            case "requestList":
                listInventoryRequests(request, response);
                break;
            case "broken":
                listInventoryBroken(request, response);
                break;
            case "approvedRequestHistory":
                showApprovedRequestHistory(request, response);
                break;
            case "receivePending":
                showReceivePendingList(request, response);
                break;
            case "repairRequestList":
                showRepairHistory(request, response);
                break;
            case "completedList":
                showCompletedReceiveList(request, response);
                break;


            default:
                listInventory(request, response);
                break;
        }


    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");


        switch (action) {
            case "insert":
                insertInventory(request, response);
                break;
            case "update":
                updateInventory(request, response);
                break;
            case "insertRequest":
                insertRequest(request, response);
                break;
            case "updateRequestStatus":
                updateRequestStatus(request, response);
                break;
            case "updateRepairStatus":
                updateRepairStatus(request, response);
                break;
            case "submitRepair":
                submitRepairRequest(request, response);
                break;
            case "confirmReceive":
                confirmInventoryReceive(request, response);
                break;






            case "approveRequest":  // ✅ Thêm dòng này
            case "rejectRequest":   // (tuỳ logic nếu có)
                approveOrRejectInventoryRequest(request, response);
                break;
        }
    }

    private void listInventory(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy danh sách thiết bị sắp hết kho
        List<Inventory> lowStockItems = InventoryDAO.getLowStockItems();
        request.setAttribute("lowStockItems", lowStockItems); // luôn set kể cả khi rỗng

        // Lấy toàn bộ danh sách thiết bị (không phân trang)
        List<Inventory> inventoryList = InventoryDAO.getAllInventories();
        request.setAttribute("inventoryList", inventoryList);

        // Không cần set currentPage hoặc totalPages nữa
        request.getRequestDispatcher("inventory.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("categoryList", InventoryDAO.getAllCategories());
        request.getRequestDispatcher("form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Inventory inv = InventoryDAO.getInventoryById(id);

        request.setAttribute("inventory", inv);
        request.setAttribute("categoryList", InventoryDAO.getAllCategories());
        request.getRequestDispatcher("form.jsp").forward(request, response);
    }

    private void insertInventory(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Inventory inv = getInventoryFromRequest(request);
        System.out.println(inv.toString());
        boolean success = InventoryDAO.insertInventory(inv);
        HttpSession session = request.getSession();
        session.setAttribute("message", success ? "Thêm thiết bị thành công!" : "Thêm thất bại!");
        response.sendRedirect("inventory");
    }

    private void updateInventory(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Inventory inv = getInventoryFromRequest(request);
        inv.setInventoryId(Integer.parseInt(request.getParameter("id")));
        boolean success = InventoryDAO.updateInventory(inv);
        HttpSession session = request.getSession();
        session.setAttribute("message", success ? "Cập nhật thành công!" : "Cập nhật thất bại!");
        response.sendRedirect("inventory");
    }

    private void deleteInventory(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        boolean success = InventoryDAO.deleteInventory(id);
        HttpSession session = request.getSession();
        session.setAttribute("message", success ? "Xóa thành công!" : "Xóa thất bại!");
        response.sendRedirect("inventory");
    }

    private void searchInventory(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Inventory> inventoryList = InventoryDAO.searchInventory(keyword.trim());

        request.setAttribute("inventoryList", inventoryList);
        request.getRequestDispatcher("/inventory.jsp").forward(request, response);
    }

    private void filterInventory(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String status = request.getParameter("status");
        String usage = request.getParameter("usage");

        List<Inventory> filteredList = InventoryDAO.filterInventoryByStatusAndUsage(status, usage);

        request.setAttribute("inventoryList", filteredList);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("selectedUsage", usage);

        request.getRequestDispatcher("inventory.jsp").forward(request, response);
    }

    private void showLowStockItems(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Inventory> lowStockList = InventoryDAO.getLowStockItems();

        request.setAttribute("inventoryList", lowStockList);
        request.setAttribute("message", "Danh sách thiết bị sắp hết kho");

        request.getRequestDispatcher("lowstock.jsp").forward(request, response);
    }

    private void listInventoryRequests(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<InventoryRequest> requestList = InventoryRequestDAO.getAllRequests();

        request.setAttribute("requestList", requestList);
        request.getRequestDispatcher("inventoryRequestList.jsp").forward(request, response);
    }
    private void approveOrRejectInventoryRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int requestId = Integer.parseInt(request.getParameter("request_id"));
        String action = request.getParameter("statusUD"); // "approve" hoặc "reject"

        boolean success = false;

        if ("approve".equalsIgnoreCase(action)) {
            // ✅ Cập nhật trạng thái + thêm vào bảng Receive_Pending
            InventoryRequestDAO.approveRequest(requestId);  // <-- dùng hàm có transaction
            success = true;
        } else if ("reject".equalsIgnoreCase(action)) {
            success = InventoryRequestDAO.updateStatusOnly(requestId, "rejected");
        }

        HttpSession session = request.getSession();
        session.setAttribute("message", success ? "Cập nhật yêu cầu thành công!" : "Cập nhật yêu cầu thất bại!");
        response.sendRedirect("inventory?action=requestList");


    }





    private void insertRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int inventoryId = Integer.parseInt(request.getParameter("inventory_id"));
        int quantity = Integer.parseInt(request.getParameter("requested_quantity"));
        String reason = request.getParameter("reason");

        InventoryRequestDAO requestDAO = new InventoryRequestDAO();
        boolean success = requestDAO.insertRequest(inventoryId, quantity, reason);

        HttpSession session = request.getSession();
        session.setAttribute("message", success ? "Gửi yêu cầu nhập kho thành công!" : "Gửi yêu cầu thất bại!");
        System.out.println("inventory_id = " + inventoryId); // Thêm dòng này để debug


        response.sendRedirect("inventory?action=lowstock");

    }
    private void updateRequestStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        InventoryRequestDAO dao = new InventoryRequestDAO();
        int requestId = Integer.parseInt(request.getParameter("request_id"));
        String status = request.getParameter("status");
        dao.updateStatusOnly(requestId, status); // DAO
        response.sendRedirect("inventory?action=requestList");
    }


    private void handleApproveRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int requestId = Integer.parseInt(request.getParameter("request_id"));
        String action = request.getParameter("statusUD");
        System.out.println("approve action = " + action);
        System.out.println("requestId = " + requestId);
        String status = "pending";
        if ("approve".equalsIgnoreCase(action)) {
            status = "approved";
            System.out.println("approve action = " + action);
        } else if ("reject".equalsIgnoreCase(action)) {
            status = "rejected";
        }

        boolean success = InventoryRequestDAO.updateStatusOnly(requestId, status);


        HttpSession session = request.getSession();
        session.setAttribute("message", success ? "Cập nhật yêu cầu thành công!" : "Cập nhật yêu cầu thất bại!");
        response.sendRedirect("inventory?action=requestList");
        System.out.println("ID nhận được: " + request.getParameter("id"));
        System.out.println("Action nhận được: " + request.getParameter("action"));

    }

    private void showReceivePendingList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<InventoryRequest> pendingList = InventoryRequestDAO.getReceivePendingList();
        request.setAttribute("pendingList", pendingList);
        request.getRequestDispatcher("receivePendingList.jsp").forward(request, response);
    }

    private void confirmInventoryReceive(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int requestId = Integer.parseInt(request.getParameter("request_id"));
        boolean success = InventoryRequestDAO.confirmReceive(requestId);

        HttpSession session = request.getSession();
        session.setAttribute("message", success ? "Đã xác nhận nhập kho." : "Xác nhận thất bại.");
        response.sendRedirect("inventory?action=receivePending");
    }



    private void showApprovedRequestHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<InventoryRequest> requestList = InventoryRequestDAO.getApprovedRequests();
        request.setAttribute("requestList", requestList);
        request.getRequestDispatcher("requestHistory.jsp").forward(request, response);
    }

    private void listInventoryBroken(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Inventory> brokenList = InventoryDAO.getItemsUnderBroken();

        request.setAttribute("brokenList", brokenList);
        request.getRequestDispatcher("maintenanceInventory.jsp").forward(request, response);
    }




    private void submitRepairRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
        String reason = request.getParameter("reason");

        boolean success = InventoryRequestDAO.createRepairRequest(inventoryId, reason);
        HttpSession session = request.getSession();
        session.setAttribute("message", success ? "Gửi yêu cầu sửa chữa thành công!" : "Gửi yêu cầu thất bại!");

        response.sendRedirect("inventory?action=broken");

    }

    private void showRepairHistory(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<RepairRequest> repairRequests = InventoryRequestDAO.getAllRepairRequests();
        request.setAttribute("repairRequests", repairRequests);
        request.getRequestDispatcher("repairHistory.jsp").forward(request, response);
    }

    private void updateRepairStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int requestId = Integer.parseInt(request.getParameter("requestId"));
        String status = request.getParameter("status");

        System.out.println(">> Gửi cập nhật: requestId = " + requestId + ", status = " + status);

        boolean updated = InventoryRequestDAO.updateStatus(requestId, status);
        System.out.println(">> Kết quả cập nhật: " + updated);

        response.sendRedirect("inventory?action=repairRequestList");
    }
    private void showCompletedReceiveList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<InventoryRequest> completedList = InventoryRequestDAO.getCompletedReceiveRequests();
        request.setAttribute("completedList", completedList);
        request.getRequestDispatcher("completed_receive_list.jsp").forward(request, response);
    }














    private Inventory getInventoryFromRequest(HttpServletRequest request) {
        Inventory inv = new Inventory();
        inv.setManagerId(Integer.parseInt(request.getParameter("manager_id")));
        inv.setItemName(request.getParameter("item_name"));
        inv.setCategoryID(Integer.parseInt(request.getParameter("category_id")));
        inv.setCategoryName(request.getParameter("category_name"));
        inv.setQuantity(Integer.parseInt(request.getParameter("quantity")));
        inv.setUnit(request.getParameter("unit"));
        inv.setImportPrice(Double.parseDouble(request.getParameter("import_price")));
        inv.setStatus(request.getParameter("status"));
        inv.setLastUpdated(new Date());
        inv.setUsageId(Integer.parseInt(request.getParameter("usage_id")));
        return inv;
    }
}

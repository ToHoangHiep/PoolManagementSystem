package controller;

import dal.InventoryDAO;
import dal.InventoryRequestDAO;
import model.Inventory;
import model.InventoryRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Date;
import java.util.List;

@WebServlet(name = "InventoryServlet", urlPatterns = {"/inventory"})
public class InventoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";
        if ("approveRequest".equals(action) || "rejectRequest".equals(action)) {
            handleApproveRequest(request, response); // gọi method bạn đã viết
        } else {
            // các action khác
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
                case "requestForm":
                    showRequestForm(request, response);
                    break;

                default:
                    listInventory(request, response);
                    break;
            }
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
        }
    }

    private void listInventory(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int page = 1;
        int recordsPerPage = 5;

        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }

        List<Inventory> lowStockItems = InventoryDAO.getLowStockItems();
        if (!lowStockItems.isEmpty()) {
            request.setAttribute("lowStockItems", lowStockItems);
        }

        List<Inventory> list = InventoryDAO.getInventoriesByPage((page - 1) * recordsPerPage, recordsPerPage);
        int totalRecords = InventoryDAO.getTotalInventoryCount();
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        request.setAttribute("inventoryList", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

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



    private void insertRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int inventoryId = Integer.parseInt(request.getParameter("inventory_id"));
        int quantity = Integer.parseInt(request.getParameter("requested_quantity"));
        String reason = request.getParameter("reason");

        InventoryRequestDAO requestDAO = new InventoryRequestDAO();
        boolean success = requestDAO.insertRequest(inventoryId, quantity, reason);

        HttpSession session = request.getSession();
        session.setAttribute("message", success ? "Gửi yêu cầu nhập kho thành công!" : "Gửi yêu cầu thất bại!");
        System.out.println("inventory_id = " + inventoryId); // Thêm dòng này để debug


        response.sendRedirect("inventory?action=requestList");

    }
    private void updateRequestStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        InventoryRequestDAO dao = new InventoryRequestDAO();
        int requestId = Integer.parseInt(request.getParameter("request_id"));
        String status = request.getParameter("status");
        dao.updateStatusAndStock(requestId, status); // DAO
        response.sendRedirect("inventory?action=requestList");
    }

    private void showRequestForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Inventory> inventoryList = InventoryDAO.getAllInventories();
        request.setAttribute("inventoryList", inventoryList);

        String selectedId = request.getParameter("inventory_id");
        if (selectedId != null) {
            try {
                int inventoryId = Integer.parseInt(selectedId);
                Inventory inventory = InventoryDAO.getInventoryById(inventoryId);
                request.setAttribute("inventory", inventory);
                request.setAttribute("selectedInventoryId", inventoryId);
            } catch (NumberFormatException e) {
                System.out.println("Lỗi parse inventory_id: " + e.getMessage());
            }
        }

        request.getRequestDispatcher("requestImportForm.jsp").forward(request, response);
    }
    private void handleApproveRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int requestId = Integer.parseInt(request.getParameter("id"));
        String action = request.getParameter("action");

        String status = "pending";
        if ("approve".equalsIgnoreCase(action)) {
            status = "approved";
        } else if ("reject".equalsIgnoreCase(action)) {
            status = "rejected";
        }

        boolean success = InventoryRequestDAO.updateStatusAndStock(requestId, status);

        HttpSession session = request.getSession();
        session.setAttribute("message", success ? "Cập nhật yêu cầu thành công!" : "Cập nhật yêu cầu thất bại!");
        response.sendRedirect("inventory?action=requestList");
        System.out.println("ID nhận được: " + request.getParameter("id"));
        System.out.println("Action nhận được: " + request.getParameter("action"));

    }






    private Inventory getInventoryFromRequest(HttpServletRequest request) {
        Inventory inv = new Inventory();
        inv.setManagerId(Integer.parseInt(request.getParameter("manager_id")));
        inv.setItemName(request.getParameter("item_name"));
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

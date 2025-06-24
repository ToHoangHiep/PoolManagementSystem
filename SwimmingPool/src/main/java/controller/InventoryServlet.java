package controller;

import dal.InventoryDAO;
import jakarta.servlet.annotation.WebServlet;
import model.Inventory;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Date;
import java.util.List;

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
            case "rentable":
                listRentableItems(request, response);
                break;
            case "sellable":
                listSellableItems(request, response);
                break;
            case "filter-rentable":
                listFilteredRentableItems(request, response);
                break;
            case "filter-sellable":
                listFilteredSellableItems(request, response);
                break;
            case "search-rentable":
                searchRentableInventory(request, response);
                break;
            case "search-sellable":
                searchSellableInventory(request, response);
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
        }
    }

    private void listInventory(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int page = 1;
        int recordsPerPage = 5;

        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }

        List<Inventory> list = InventoryDAO.getInventoriesByPage((page - 1) * recordsPerPage, recordsPerPage);
        int totalRecords = InventoryDAO.getTotalInventoryCount();
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        System.out.println("Total Records: " + totalRecords);
        System.out.println("Total Pages: " + totalPages);

        for (Inventory inventory : list) {
            System.out.println(inventory.getItemName());
        }

        request.setAttribute("inventoryList", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("inventory.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Inventory inv = InventoryDAO.getInventoryById(id);
        request.setAttribute("inventory", inv);
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

    private void searchInventory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Inventory> inventoryList = InventoryDAO.searchInventory(keyword.trim());

        request.setAttribute("inventoryList", inventoryList);
        request.getRequestDispatcher("/inventory.jsp").forward(request, response);
    }

    private void searchRentableInventory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");

        // Gọi DAO dùng usage = "item for rent"
        List<Inventory> rentableItems = InventoryDAO.searchInventoryByUsage(keyword.trim(), "item for rent");

        request.setAttribute("inventoryList", rentableItems);
        request.setAttribute("keyword", keyword);

        if (rentableItems.isEmpty()) {
            request.setAttribute("message", "Không tìm thấy sản phẩm cho thuê phù hợp với từ khóa \"" + keyword + "\".");
        }

        request.getRequestDispatcher("/rentableInventory.jsp").forward(request, response);
    }

    private void searchSellableInventory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");

        // Gọi DAO dùng usage = "item for sold"
        List<Inventory> sellableItems = InventoryDAO.searchInventoryByUsage(keyword.trim(), "item for sold");

        request.setAttribute("inventoryList", sellableItems);
        request.setAttribute("keyword", keyword);

        if (sellableItems.isEmpty()) {
            request.setAttribute("message", "Không tìm thấy sản phẩm cho bán phù hợp với từ khóa \"" + keyword + "\".");
        }

        request.getRequestDispatcher("/sellableInventory.jsp").forward(request, response);
    }


    private void filterInventory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String status = request.getParameter("status");
        String usage = request.getParameter("usage");

        List<Inventory> filteredList = InventoryDAO.filterInventoryByStatusAndUsage(status, usage);

        request.setAttribute("inventoryList", filteredList);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("selectedUsage", usage);

        request.getRequestDispatcher("inventory.jsp").forward(request, response);
    }


    private Inventory getInventoryFromRequest(HttpServletRequest request) {
        Inventory inv = new Inventory();
        inv.setManagerId(Integer.parseInt(request.getParameter("manager_id")));
        inv.setItemName(request.getParameter("item_name"));
        inv.setCategory(request.getParameter("category"));
        inv.setQuantity(Integer.parseInt(request.getParameter("quantity")));
        inv.setUnit(request.getParameter("unit"));
        inv.setStatus(request.getParameter("status"));
        inv.setLastUpdated(new Date());
        inv.setUsageId(Integer.parseInt(request.getParameter("usage_id"))); // ⬅️ thêm dòng này
        return inv;
    }


    private void listRentableItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int page = 1;
        int recordsPerPage = 5;

        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // Lấy toàn bộ danh sách sản phẩm cho thuê
        List<Inventory> allRentable = InventoryDAO.getRentableItems();

        // Phân trang thủ công
        int totalRecords = allRentable.size();
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        int start = (page - 1) * recordsPerPage;
        int end = Math.min(start + recordsPerPage, totalRecords);

        List<Inventory> pageList = allRentable.subList(start, end);

        request.setAttribute("inventoryList", pageList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        if (pageList.isEmpty()) {
            request.setAttribute("message", "Không có sản phẩm nào có thể cho thuê.");
        }

        request.getRequestDispatcher("rentableInventory.jsp").forward(request, response);
    }

    private void listSellableItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int page = 1;
        int recordsPerPage = 5;

        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // Lấy toàn bộ danh sách sản phẩm có thể bán
        List<Inventory> allSellable = InventoryDAO.getSellableItems();

        // Phân trang thủ công
        int totalRecords = allSellable.size();
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        int start = (page - 1) * recordsPerPage;
        int end = Math.min(start + recordsPerPage, totalRecords);

        List<Inventory> pageList = allSellable.subList(start, end);

        request.setAttribute("inventoryList", pageList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        if (pageList.isEmpty()) {
            request.setAttribute("message", "Không có sản phẩm nào để bán.");
        }

        request.getRequestDispatcher("sellableInventory.jsp").forward(request, response);
    }

    private void listFilteredRentableItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String status = request.getParameter("status");

        int page = 1;
        int recordsPerPage = 5;

        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // Gọi DAO để lấy danh sách lọc theo status + usage = "item for rent"
        List<Inventory> filteredList = InventoryDAO.searchInventoryByUsageAndStatus("item for rent", status);

        // Tính toán phân trang
        int totalRecords = filteredList.size();
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
        int start = (page - 1) * recordsPerPage;
        int end = Math.min(start + recordsPerPage, totalRecords);
        List<Inventory> pageList = filteredList.subList(start, end);

        request.setAttribute("inventoryList", pageList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("selectedStatus", status); // Giữ dropdown chọn đúng

        if (pageList.isEmpty()) {
            request.setAttribute("message", "Không có sản phẩm nào với trạng thái \"" + status + "\".");
        }

        request.getRequestDispatcher("rentableInventory.jsp").forward(request, response);
    }
    private void listFilteredSellableItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String status = request.getParameter("status");

        List<Inventory> filteredList = InventoryDAO.searchInventoryByUsageAndStatus("item for sold", status);

        request.setAttribute("inventoryList", filteredList);
        request.setAttribute("selectedStatus", status);

        if (filteredList.isEmpty()) {
            request.setAttribute("message", "Không có sản phẩm nào với trạng thái \"" + status + "\".");
        }

        request.getRequestDispatcher("sellableInventory.jsp").forward(request, response);
    }












}

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
                filterByStatus(request, response);
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
            System.out.println(inventory);
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

    private void filterByStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String status = request.getParameter("status");
        List<Inventory> inventoryList = InventoryDAO.filterInventoryByStatus(status);

        request.setAttribute("inventoryList", inventoryList);
        request.getRequestDispatcher("/inventory.jsp").forward(request, response);
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
        return inv;
    }
}

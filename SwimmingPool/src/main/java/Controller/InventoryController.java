package Controller;

import DAO.InventoryDAO;
import entities.Inventory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

        import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/inventory")
public class InventoryController extends HttpServlet {
    private InventoryDAO inventoryDAO;

    @Override
    public void init() {
        inventoryDAO = new InventoryDAO();
    }

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
        List<Inventory> list = inventoryDAO.getAllInventories();
        request.setAttribute("inventoryList", list);
        request.getRequestDispatcher("list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Inventory inv = inventoryDAO.getInventoryById(id);
        request.setAttribute("inventory", inv);
        request.getRequestDispatcher("form.jsp").forward(request, response);
    }

    private void insertInventory(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Inventory inv = getInventoryFromRequest(request);
        boolean success = inventoryDAO.insertInventory(inv);
        HttpSession session = request.getSession();
        session.setAttribute("message", success ? "Thêm thiết bị thành công!" : "Thêm thất bại!");
        response.sendRedirect("inventory");
    }

    private void updateInventory(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Inventory inv = getInventoryFromRequest(request);
        inv.setInventoryId(Integer.parseInt(request.getParameter("id")));
        boolean success = inventoryDAO.updateInventory(inv);
        HttpSession session = request.getSession();
        session.setAttribute("message", success ? "Cập nhật thành công!" : "Cập nhật thất bại!");
        response.sendRedirect("inventory");
    }

    private void deleteInventory(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        boolean success = inventoryDAO.deleteInventory(id);
        HttpSession session = request.getSession();
        session.setAttribute("message", success ? "Xóa thành công!" : "Xóa thất bại!");
        response.sendRedirect("inventory");
    }

    private void searchInventory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Inventory> inventoryList = inventoryDAO.searchInventory(keyword.trim());

        request.setAttribute("inventoryList", inventoryList);
        request.getRequestDispatcher("/list.jsp").forward(request, response);
    }




    private Inventory getInventoryFromRequest(HttpServletRequest request) {
        Inventory inv = new Inventory();
        inv.setManagerId(Integer.parseInt(request.getParameter("manager_id")));
        inv.setItemName(request.getParameter("item_name"));
        inv.setCategory(request.getParameter("category"));
        inv.setQuantity(Integer.parseInt(request.getParameter("quantity")));
        inv.setUnit(request.getParameter("unit"));
        inv.setStatus(request.getParameter("status"));
        inv.setLastUpdated(LocalDateTime.now());
        return inv;
    }
}

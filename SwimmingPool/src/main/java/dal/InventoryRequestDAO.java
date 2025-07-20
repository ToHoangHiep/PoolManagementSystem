package dal;
import model.InventoryRequest;
import model.Inventory;
import java.sql.*;
import utils.DBConnect;
import java.util.ArrayList;
import java.util.List;

public class InventoryRequestDAO {

    public boolean insertRequest(int inventoryId, int quantity, String reason) {
        String sql = "INSERT INTO Inventory_Request (inventory_id, requested_quantity, reason, status, requested_at) VALUES (?, ?, ?, 'pending', NOW())";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, inventoryId);
            stmt.setInt(2, quantity);
            stmt.setString(3, reason);
            int rowsInserted = stmt.executeUpdate();

            return rowsInserted > 0; // trả về true nếu insert thành công
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }



    public static List<InventoryRequest> getAllRequests() {
        List<InventoryRequest> list = new ArrayList<>();
        String sql = "SELECT r.*, i.item_name FROM Inventory_Request r JOIN Inventory i ON r.inventory_id = i.inventory_id";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                InventoryRequest r = new InventoryRequest();
                r.setRequestId(rs.getInt("request_id"));
                r.setInventoryId(rs.getInt("inventory_id"));
                r.setItemName(rs.getString("item_name"));
                r.setRequestedQuantity(rs.getInt("requested_quantity"));
                r.setReason(rs.getString("reason"));
                r.setStatus(rs.getString("status"));
                r.setRequestedAt(rs.getTimestamp("requested_at"));
                r.setApprovedAt(rs.getTimestamp("approved_at"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }


    public static boolean updateStatusAndStock(int requestId, String status) {
        String updateStatusSql = "UPDATE Inventory_Request SET status = ?, approved_at = CURRENT_TIMESTAMP WHERE request_id = ?";
        String updateInventorySql = "UPDATE Inventory i JOIN Inventory_Request r ON i.inventory_id = r.inventory_id SET i.quantity = i.quantity + r.requested_quantity WHERE r.request_id = ?";
        try (Connection conn = DBConnect.getConnection()) {
            conn.setAutoCommit(false);
            try (
                    PreparedStatement statusStmt = conn.prepareStatement(updateStatusSql);
                    PreparedStatement inventoryStmt = conn.prepareStatement(updateInventorySql)) {
                statusStmt.setString(1, status);
                statusStmt.setInt(2, requestId);
                statusStmt.executeUpdate();
                if ("approved".equals(status)) {
                    inventoryStmt.setInt(1, requestId);
                    inventoryStmt.executeUpdate();
                }
                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static void main(String[] args) {
        InventoryRequestDAO dao = new InventoryRequestDAO();
        boolean success = dao.insertRequest(15, 10, "Thêm để phục vụ lớp mới");

        if (success) {
            System.out.println("Thêm yêu cầu thành công");
        } else {
            System.out.println("Thêm yêu cầu thất bại");
        }
    }





}

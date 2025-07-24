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
            conn.setAutoCommit(false); // Transaction đảm bảo tính toàn vẹn

            try (
                    PreparedStatement statusStmt = conn.prepareStatement(updateStatusSql);
                    PreparedStatement inventoryStmt = conn.prepareStatement(updateInventorySql)
            ) {
                // Cập nhật trạng thái (approve/reject)
                statusStmt.setString(1, status);
                statusStmt.setInt(2, requestId);
                int affectedRows = statusStmt.executeUpdate();

                // Nếu trạng thái là "approved", cập nhật tồn kho
                if ("approved".equalsIgnoreCase(status) && affectedRows > 0) {
                    System.out.println("Đang cập nhật tồn kho cho request_id = " + requestId);
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

    public static List<InventoryRequest> getApprovedRequests() {
        List<InventoryRequest> list = new ArrayList<>();
        String sql = "SELECT r.*, i.item_name FROM Inventory_Request r " +
                "JOIN Inventory i ON r.inventory_id = i.inventory_id " +
                "WHERE r.status = 'approved' " +
                "ORDER BY r.approved_at DESC";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                InventoryRequest req = new InventoryRequest();
                req.setRequestId(rs.getInt("request_id"));
                req.setInventoryId(rs.getInt("inventory_id"));
                req.setItemName(rs.getString("item_name"));
                req.setRequestedQuantity(rs.getInt("requested_quantity"));
                req.setReason(rs.getString("reason"));
                req.setStatus(rs.getString("status"));
                req.setRequestedAt(rs.getTimestamp("requested_at"));
                req.setApprovedAt(rs.getTimestamp("approved_at"));

                list.add(req);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }



    public static void main(String[] args) {
        boolean result = updateStatusAndStock(1, "approved");
        System.out.println("Cập nhật: " + result);
    }






}

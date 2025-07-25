package dal;
import model.InventoryRequest;
import model.RepairRequest;
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

    public static boolean approveRequest(int requestId) {
        String approveSql = "UPDATE Inventory_Request SET status = 'approved', approved_at = NOW() WHERE request_id = ?";
        String insertPendingSql = "INSERT INTO Inventory_Receive_Pending (request_id, status) VALUES (?, 'waiting')";

        try (Connection conn = DBConnect.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement ps1 = conn.prepareStatement(approveSql);
                 PreparedStatement ps2 = conn.prepareStatement(insertPendingSql)) {

                ps1.setInt(1, requestId);
                int updatedRows = ps1.executeUpdate();

                if (updatedRows == 0) {
                    conn.rollback();
                    System.out.println("Không tìm thấy request để duyệt!");
                    return false;
                }

                ps2.setInt(1, requestId);
                ps2.executeUpdate();

                conn.commit();
                System.out.println("Duyệt yêu cầu thành công và thêm vào danh sách chờ nhập.");
                return true;

            } catch (SQLException e) {
                conn.rollback();
                System.out.println("Lỗi khi duyệt yêu cầu: " + e.getMessage());
                return false;
            }

        } catch (SQLException e) {
            System.out.println("Lỗi kết nối cơ sở dữ liệu: " + e.getMessage());
            return false;
        }
    }

    public static List<InventoryRequest> getCompletedReceiveRequests() {
        List<InventoryRequest> list = new ArrayList<>();

        String sql = "SELECT p.id, p.request_id, p.status, p.received_at, " +
                "       i.item_name, r.requested_quantity, r.reason " +
                "FROM Inventory_Receive_Pending p " +
                "JOIN Inventory_Request r ON p.request_id = r.request_id " +
                "JOIN Inventory i ON r.inventory_id = i.inventory_id " +
                "WHERE p.status = 'completed' " +
                "ORDER BY p.received_at DESC";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                InventoryRequest rp = new InventoryRequest();
                rp.setId(rs.getInt("id"));
                rp.setRequestId(rs.getInt("request_id"));
                rp.setStatus(rs.getString("status"));
                rp.setCompletedAt(rs.getTimestamp("received_at"));
                rp.setItemName(rs.getString("item_name"));
                rp.setRequestedQuantity(rs.getInt("requested_quantity"));
                rp.setReason(rs.getString("reason"));
                list.add(rp);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }


    public static List<InventoryRequest> getReceivePendingList() {
        List<InventoryRequest> list = new ArrayList<>();
        String sql = "SELECT ir.request_id, ir.inventory_id, i.item_name, ir.requested_quantity, ir.reason, p.status, p.received_at " +
                "FROM Inventory_Request ir " +
                "JOIN Inventory_Receive_Pending p ON ir.request_id = p.request_id " +
                "JOIN Inventory i ON ir.inventory_id = i.inventory_id " +
                "WHERE p.status = 'waiting'";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                InventoryRequest r = new InventoryRequest();
                r.setRequestId(rs.getInt("request_id"));
                r.setInventoryId(rs.getInt("inventory_id"));
                r.setItemName(rs.getString("item_name"));
                r.setRequestedQuantity(rs.getInt("requested_quantity"));
                r.setReason(rs.getString("reason"));
                // có thể thêm trường received_at nếu muốn
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public static boolean confirmReceive(int requestId) {
        String updateReceive = "UPDATE Inventory_Receive_Pending SET status = 'completed', received_at = NOW() WHERE request_id = ?";
        String updateInventory = "UPDATE Inventory SET quantity = quantity + " +
                "(SELECT requested_quantity FROM Inventory_Request WHERE request_id = ?) " +
                "WHERE inventory_id = (SELECT inventory_id FROM Inventory_Request WHERE request_id = ?)";

        try (Connection conn = DBConnect.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement ps1 = conn.prepareStatement(updateReceive);
                 PreparedStatement ps2 = conn.prepareStatement(updateInventory)) {

                ps1.setInt(1, requestId);
                ps1.executeUpdate();

                ps2.setInt(1, requestId);
                ps2.setInt(2, requestId);
                ps2.executeUpdate();

                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
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




    public static boolean updateStatusOnly(int requestId, String status) {
        String updateStatusSql = "UPDATE Inventory_Request SET status = ?, approved_at = CURRENT_TIMESTAMP WHERE request_id = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(updateStatusSql)) {

            stmt.setString(1, status);
            stmt.setInt(2, requestId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
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


    public static boolean createRepairRequest(int inventoryId, String reason) {
        String sql = "INSERT INTO Repair_Request (inventory_id, reason) VALUES (?, ?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, inventoryId);
            stmt.setString(2, reason);
            int rows = stmt.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }


        public static List<RepairRequest> getAllRepairRequests() {
            List<RepairRequest> list = new ArrayList<>();
            String sql = "SELECT rr.*, i.item_name " +
                    "FROM Repair_Request rr " +
                    "JOIN inventory i ON rr.inventory_id = i.inventory_id " ;

            try (Connection conn = DBConnect.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    RepairRequest req = new RepairRequest();
                    req.setRequestId(rs.getInt("request_id"));
                    req.setInventoryId(rs.getInt("inventory_id"));
                    req.setItemName(rs.getString("item_name"));
                    req.setReason(rs.getString("reason"));
                    req.setStatus(rs.getString("status"));
                    req.setRequestedAt(rs.getTimestamp("requested_at"));
                    req.setReviewedAt(rs.getTimestamp("reviewed_at"));

                    list.add(req);
                }

            } catch (SQLException e) {
                e.printStackTrace();
            }

            return list;
        }

    public static boolean updateStatus(int requestId, String status) {
        String sql = "UPDATE Repair_Request SET status = ?, reviewed_at = NOW() WHERE request_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, requestId);
            int affected = stmt.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }






    public static void main(String[] args) {
        List<InventoryRequest> pendingList = getCompletedReceiveRequests();
        System.out.println("Danh sách yêu cầu đang chờ xác nhận nhập kho:");
        for (InventoryRequest req : pendingList) {
            System.out.println("Request ID: " + req.getRequestId() +
                    ", Thiết bị: " + req.getItemName() +
                    ", Số lượng: " + req.getRequestedQuantity() +
                    ", Lý do: " + req.getReason() +
                    ", Ngày duyệt: " + req.getCompletedAt());
        }
    }










}

package dal;

import model.RepairRequest;
import model.Inventory;
import java.sql.*;
import java.util.*;
import utils.DBConnect;
import java.util.ArrayList;
import java.util.List;

public class RepairRequestDAO {

    public static boolean insertRepairRequest(int inventoryId, String reason) {
        String sql = "INSERT INTO repair_request (inventory_id, reason) VALUES (?, ?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, inventoryId);
            ps.setString(2, reason);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static List<RepairRequest> getAllRequests() {
        List<RepairRequest> list = new ArrayList<>();
        String sql = "SELECT r.*, i.item_name FROM repair_request r JOIN inventory i ON r.inventory_id = i.inventory_id";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                RepairRequest r = new RepairRequest();
                r.setRequestId(rs.getInt("request_id"));
                r.setInventoryId(rs.getInt("inventory_id"));
                r.setItemName(rs.getString("item_name"));
                r.setReason(rs.getString("reason"));
                r.setRequestDate(rs.getTimestamp("request_date"));
                r.setStatus(rs.getString("status"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}

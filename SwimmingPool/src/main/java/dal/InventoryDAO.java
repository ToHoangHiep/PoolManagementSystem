package dal;

import model.Inventory;
import utils.DBConnect;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InventoryDAO {

    public static boolean insertInventory(Inventory inventory) {
        String sql = "INSERT INTO inventory (manager_id, item_name, category, quantity, unit, status, last_updated) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, inventory.getManagerId());
            stmt.setString(2, inventory.getItemName());
            stmt.setString(3, inventory.getCategory());
            stmt.setInt(4, inventory.getQuantity());
            stmt.setString(5, inventory.getUnit());
            stmt.setString(6, inventory.getStatus());
            stmt.setDate(7, new java.sql.Date(inventory.getLastUpdated().getTime()));

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static List<Inventory> getAllInventories() {
        List<Inventory> list = new ArrayList<>();
        String sql = "SELECT i.*, u.usage_name FROM inventory i " +
                "JOIN inventory_usage u ON i.usage_id = u.usage_id ";

        try (Connection conn = DBConnect.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Inventory inv = new Inventory();
                inv.setInventoryId(rs.getInt("inventory_id"));
                inv.setManagerId(rs.getInt("manager_id"));
                inv.setItemName(rs.getString("item_name"));
                inv.setCategory(rs.getString("category"));
                inv.setQuantity(rs.getInt("quantity"));
                inv.setUnit(rs.getString("unit"));
                inv.setStatus(rs.getString("status"));
                inv.setUsageName(rs.getString("usage_name"));
                inv.setLastUpdated(rs.getDate("last_updated"));

                list.add(inv);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public static Inventory getInventoryById(int id) {
        String sql = "SELECT * FROM inventory WHERE inventory_id = ?";
        Inventory inv = null;

        try (Connection conn = DBConnect.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                inv = new Inventory();
                inv.setInventoryId(rs.getInt("inventory_id"));
                inv.setManagerId(rs.getInt("manager_id"));
                inv.setItemName(rs.getString("item_name"));
                inv.setCategory(rs.getString("category"));
                inv.setQuantity(rs.getInt("quantity"));
                inv.setUnit(rs.getString("unit"));
                inv.setStatus(rs.getString("status"));
                inv.setLastUpdated(rs.getDate("last_updated"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return inv;
    }

    public static boolean updateInventory(Inventory inventory) {
        String sql = "UPDATE inventory SET manager_id = ?, item_name = ?, category = ?, quantity = ?, unit = ?, status = ?, last_updated = ? WHERE inventory_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, inventory.getManagerId());
            stmt.setString(2, inventory.getItemName());
            stmt.setString(3, inventory.getCategory());
            stmt.setInt(4, inventory.getQuantity());
            stmt.setString(5, inventory.getUnit());
            stmt.setString(6, inventory.getStatus());
            stmt.setDate(7, new java.sql.Date(inventory.getLastUpdated().getTime()));
            stmt.setInt(8, inventory.getInventoryId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean deleteInventory(int id) {
        String sql = "DELETE FROM inventory WHERE inventory_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static List<Inventory> searchInventory(String keyword) {
        List<Inventory> list = new ArrayList<>();
        String sql = "SELECT * FROM inventory WHERE item_name LIKE ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Inventory item = new Inventory();
                item.setInventoryId(rs.getInt("inventory_id"));
                item.setManagerId(rs.getInt("manager_id"));
                item.setItemName(rs.getString("item_name"));
                item.setCategory(rs.getString("category"));
                item.setQuantity(rs.getInt("quantity"));
                item.setUnit(rs.getString("unit"));
                item.setStatus(rs.getString("status"));
                item.setLastUpdated(rs.getDate("last_updated"));

                list.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public static List<Inventory> getInventoriesByPage(int offset, int limit) {
        List<Inventory> list = new ArrayList<>();
        String sql = "SELECT * FROM inventory ORDER BY inventory_id LIMIT ? OFFSET ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, limit);
            stmt.setInt(2, offset);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Inventory inv = new Inventory();
                inv.setInventoryId(rs.getInt("inventory_id"));
                inv.setManagerId(rs.getInt("manager_id"));
                inv.setItemName(rs.getString("item_name"));
                inv.setCategory(rs.getString("category"));
                inv.setQuantity(rs.getInt("quantity"));
                inv.setUnit(rs.getString("unit"));
                inv.setStatus(rs.getString("status"));
                inv.setLastUpdated(rs.getDate("last_updated"));

                System.out.println("Inventory ID: " + inv.getInventoryId());

                list.add(inv);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public static int getTotalInventoryCount() {
        String sql = "SELECT COUNT(*) FROM inventory";

        try (Connection conn = DBConnect.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public static List<Inventory> filterInventoryByStatus(String status) {
        List<Inventory> list = new ArrayList<>();
        String sql = "SELECT * FROM inventory WHERE status = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Inventory inv = new Inventory();
                inv.setInventoryId(rs.getInt("inventory_id"));
                inv.setManagerId(rs.getInt("manager_id"));
                inv.setItemName(rs.getString("item_name"));
                inv.setCategory(rs.getString("category"));
                inv.setQuantity(rs.getInt("quantity"));
                inv.setUnit(rs.getString("unit"));
                inv.setStatus(rs.getString("status"));
                inv.setLastUpdated(rs.getDate("last_updated"));

                list.add(inv);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Inventory> getLowStockItems() {
        List<Inventory> lowStockItems = new ArrayList<>();
        String sql = "SELECT * FROM Inventory WHERE quantity < threshold_quantity";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Inventory item = new Inventory();
                item.setInventoryId(rs.getInt("inventory_id"));
                item.setItemName(rs.getString("item_name"));
                item.setQuantity(rs.getInt("quantity"));
                item.setThresholdQuantity(rs.getInt("threshold_quantity"));
                lowStockItems.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lowStockItems;
    }



    public static List<Inventory> getRentableItems() {
        List<Inventory> list = new ArrayList<>();
        String sql = "SELECT i.*, u.usage_name FROM inventory i " +
                "JOIN inventory_usage u ON i.usage_id = u.usage_id " +
                "WHERE u.usage_name = 'item for rent'";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Inventory inv = new Inventory();
                inv.setInventoryId(rs.getInt("inventory_id"));
                inv.setManagerId(rs.getInt("manager_id"));
                inv.setItemName(rs.getString("item_name"));
                inv.setCategory(rs.getString("category"));
                inv.setQuantity(rs.getInt("quantity"));
                inv.setUnit(rs.getString("unit"));
                inv.setStatus(rs.getString("status"));
                inv.setLastUpdated(rs.getTimestamp("last_updated"));
                inv.setUsageName(rs.getString("usage_name"));

                list.add(inv);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public static void main(String[] args) {
        List<Inventory> rentableItems = getAllInventories();


            System.out.println("Danh sách thiết bị ");
            for (Inventory inv : rentableItems) {
                System.out.println("ID: " + inv.getInventoryId() +
                        " | Tên: " + inv.getItemName() +
                        " | Loại: " + inv.getCategory() +
                        " | SL: " + inv.getQuantity() +
                        " | Đơn vị: " + inv.getUnit() +
                        " | Trạng thái: " + inv.getStatus() +
                        " | Mục đích sử dụng: " + inv.getUsageName());
            }

    }











}



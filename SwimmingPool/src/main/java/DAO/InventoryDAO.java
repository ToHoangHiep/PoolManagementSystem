package DAO;

import entities.Inventory;
import utils.DBConnect;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InventoryDAO {

    public boolean insertInventory(Inventory inventory) {
        String sql = "INSERT INTO Inventory (manager_id, item_name, category, quantity, unit, status, last_updated) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, inventory.getManagerId());
            stmt.setString(2, inventory.getItemName());
            stmt.setString(3, inventory.getCategory());
            stmt.setInt(4, inventory.getQuantity());
            stmt.setString(5, inventory.getUnit());
            stmt.setString(6, inventory.getStatus());
            stmt.setTimestamp(7, java.sql.Timestamp.valueOf(inventory.getLastUpdated()));


            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    public List<Inventory> getAllInventories() {
        List<Inventory> list = new ArrayList<>();
        String sql = "SELECT * FROM Inventory";

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
                inv.setLastUpdated(rs.getTimestamp("last_updated").toLocalDateTime());

                list.add(inv);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public Inventory getInventoryById(int id) {
        String sql = "SELECT * FROM Inventory WHERE inventory_id = ?";
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
                inv.setLastUpdated(rs.getTimestamp("last_updated").toLocalDateTime());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return inv;
    }

    public boolean updateInventory(Inventory inventory) {
        String sql = "UPDATE Inventory SET manager_id = ?, item_name = ?, category = ?, quantity = ?, unit = ?, status = ?, last_updated = ? WHERE inventory_id = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, inventory.getManagerId());
            stmt.setString(2, inventory.getItemName());
            stmt.setString(3, inventory.getCategory());
            stmt.setInt(4, inventory.getQuantity());
            stmt.setString(5, inventory.getUnit());
            stmt.setString(6, inventory.getStatus());
            stmt.setTimestamp(7, java.sql.Timestamp.valueOf(inventory.getLastUpdated()));

            stmt.setInt(8, inventory.getInventoryId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    public boolean deleteInventory(int id) {
        String sql = "DELETE FROM Inventory WHERE inventory_id = ?";
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

    public List<Inventory> searchInventory(String keyword) {
        List<Inventory> list = new ArrayList<>();
        String sql = "SELECT * FROM Inventory WHERE item_name LIKE ?";

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
                item.setLastUpdated(rs.getTimestamp("last_updated").toLocalDateTime());

                list.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }



}

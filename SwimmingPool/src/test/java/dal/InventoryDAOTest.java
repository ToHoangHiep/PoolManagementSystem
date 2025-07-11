package dal;



import model.Inventory;
import org.junit.jupiter.api.*;
import utils.DBConnect;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;



class InventoryDAOTest {

    @BeforeAll
    static void setupDatabase() throws SQLException {
        // Prepare test database with required data
        try (Connection conn = DBConnect.getConnection();
             Statement stmt = conn.createStatement()) {
            // Clean up tables
            stmt.execute("DELETE FROM inventory");
            stmt.execute("DELETE FROM inventory_usage");

            // Insert usages
            stmt.execute("INSERT INTO inventory_usage (usage_id, usage_name) VALUES (1, 'item for rent'), (2, 'item for sold'), (3, 'other')");

            // Insert inventory items
            stmt.execute("INSERT INTO inventory (inventory_id, manager_id, item_name, category, quantity, unit, status, last_updated, usage_id) " +
                    "VALUES (100, 1, 'Bike', 'Sport', 5, 'pcs', 'available', CURRENT_DATE(), 1)," +
                    "(101, 2, 'Ball', 'Sport', 10, 'pcs', 'rented', CURRENT_DATE(), 1)," +
                    "(102, 3, 'Towel', 'Accessories', 20, 'pcs', 'available', CURRENT_DATE(), 2)," +
                    "(103, 4, 'Cap', 'Accessories', 15, 'pcs', 'maintenance', CURRENT_DATE(), 3)");
        }
    }

    @AfterAll
    static void cleanupDatabase() throws SQLException {
        try (Connection conn = DBConnect.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute("DELETE FROM inventory");
            stmt.execute("DELETE FROM inventory_usage");
        }
    }

    @Test
    void testGetRentableItems() {
        List<Inventory> rentable = InventoryDAO.getRentableItems();
        assertNotNull(rentable);
        assertFalse(rentable.isEmpty(), "Rentable items should not be empty");
        for (Inventory inv : rentable) {
            assertEquals("item for rent", inv.getUsageName());
        }
        // Should contain the inserted 'Bike' and 'Ball'
        assertTrue(rentable.stream().anyMatch(i -> i.getItemName().equals("Bike")));
        assertTrue(rentable.stream().anyMatch(i -> i.getItemName().equals("Ball")));
    }

    @Test
    void testFilterInventoryByStatusAndUsage_BothParams() {
        List<Inventory> filtered = InventoryDAO.filterInventoryByStatusAndUsage("available", "item for rent");
        assertNotNull(filtered);
        // Only 'Bike' is available and for rent
        assertEquals(1, filtered.size());
        Inventory item = filtered.get(0);
        assertEquals("Bike", item.getItemName());
        assertEquals("available", item.getStatus());
        assertEquals("item for rent", item.getUsageName());
    }

    @Test
    void testFilterInventoryByStatusAndUsage_OnlyStatus() {
        List<Inventory> filtered = InventoryDAO.filterInventoryByStatusAndUsage("maintenance", "");
        assertNotNull(filtered);
        // Only 'Cap' is in maintenance
        assertEquals(1, filtered.size());
        assertEquals("Cap", filtered.get(0).getItemName());
    }

    @Test
    void testFilterInventoryByStatusAndUsage_OnlyUsage() {
        List<Inventory> filtered = InventoryDAO.filterInventoryByStatusAndUsage("", "item for sold");
        assertNotNull(filtered);
        // Only 'Towel' is for sold
        assertEquals(1, filtered.size());
        assertEquals("Towel", filtered.get(0).getItemName());
    }

    @Test
    void testFilterInventoryByStatusAndUsage_NoParams() {
        List<Inventory> filtered = InventoryDAO.filterInventoryByStatusAndUsage("", "");
        assertNotNull(filtered);
        // Should return all items
        assertTrue(filtered.size() >= 4);
    }
}
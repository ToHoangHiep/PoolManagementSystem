import dal.EquipmentDAO;
import model.EquipmentRental;
import model.EquipmentSale;
import org.junit.jupiter.api.*;

import java.sql.Date;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class EquipmentDAOTest {

    private static EquipmentDAO dao;

    @BeforeAll
    public static void setup() {
        dao = new EquipmentDAO();
    }

    @Test
    @Order(1)
    public void testGetAvailableQuantity_ValidId() throws Exception {
        int available = dao.getAvailableQuantity(1);
        assertTrue(available >= 0, "Available quantity should not be negative");
    }

    @Test
    @Order(2)
    public void testGetAvailableQuantity_InvalidId() throws Exception {
        int available = dao.getAvailableQuantity(-999);
        assertEquals(0, available, "Non-existent inventory should return 0");
    }

    @Test
    @Order(3)
    public void testCheckAvailability_EnoughStock() throws Exception {
        boolean available = dao.checkAvailability(1, 1);
        assertTrue(available, "Should be available if enough stock exists");
    }

    @Test
    @Order(4)
    public void testCheckAvailability_NotEnoughStock() throws Exception {
        boolean available = dao.checkAvailability(1, 99999);
        assertFalse(available, "Should not be available if requested quantity too high");
    }

    @Test
    @Order(5)
    public void testGetEquipmentStatus() throws Exception {
        List<Map<String, Object>> list = dao.getEquipmentStatus();
        assertNotNull(list, "Equipment status list should not be null");
        assertFalse(list.isEmpty(), "Equipment status list should not be empty");
    }

    @Test
    @Order(6)
    public void testGetEquipmentById_ValidId() throws Exception {
        Map<String, Object> equipment = dao.getEquipmentById(1);
        assertNotNull(equipment, "Equipment should not be null");
        assertEquals(1, equipment.get("inventoryId"));
    }

    @Test
    @Order(7)
    public void testGetEquipmentById_InvalidId() throws Exception {
        Map<String, Object> equipment = dao.getEquipmentById(-999);
        assertNull(equipment, "Should return null for non-existent ID");
    }

    @Test
    @Order(8)
    public void testProcessRentalAndReturn() throws Exception {
        EquipmentRental rental = new EquipmentRental();
        rental.setCustomerName("JUnit Tester");
        rental.setCustomerIdCard("123456789");
        rental.setStaffId(1);
        rental.setInventoryId(1);
        rental.setQuantity(1);
        rental.setRentalDate(new Date(System.currentTimeMillis()));
        rental.setRentPrice(100.0);
        rental.setTotalAmount(100.0);

        boolean success = dao.processRental(rental);
        assertTrue(success, "Rental should be processed successfully");

        // Return device
        boolean returned = dao.processReturn(rental.getRentalId());
        assertTrue(returned, "Rental should be marked as returned successfully");
    }

    @Test
    @Order(9)
    public void testProcessSale() throws Exception {
        EquipmentSale sale = new EquipmentSale();
        sale.setCustomerName("JUnit Buyer");
        sale.setStaffId(1);
        sale.setInventoryId(1);
        sale.setQuantity(1);
        sale.setSalePrice(200.0);
        sale.setTotalAmount(200.0);

        boolean success = dao.processSale(sale);
        assertTrue(success, "Sale should be processed successfully");
    }

    @Test
    @Order(10)
    public void testGetActiveRentals() throws Exception {
        List<EquipmentRental> rentals = dao.getActiveRentals();
        assertNotNull(rentals, "Active rentals list should not be null");
    }
}
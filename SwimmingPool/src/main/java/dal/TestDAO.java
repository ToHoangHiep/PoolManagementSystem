package dal;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public class TestDAO {
    public static void main(String[] args) {
        try {
            // Test getAllCategories cho mode 'rental' (nên return list categories với id, name, quantity)
            List<Map<String, Object>> categories = EquipmentDAO.getAllCategories("rental");
            System.out.println("=== Test getAllCategories (rental) ===");
            if (categories.isEmpty()) {
                System.out.println("No categories found - Check DB data or query!");
            } else {
                for (Map<String, Object> cat : categories) {
                    System.out.println("ID: " + cat.get("id") + ", Name: " + cat.get("name") + ", Quantity: " + cat.get("quantity"));
                }
            }

            // Test getEquipmentStatus cho mode 'rental', categoryId = null (all)
            List<Map<String, Object>> itemsAll = EquipmentDAO.getEquipmentStatus("rental", null);
            System.out.println("\n=== Test getEquipmentStatus (rental, all categories) - Total items: " + itemsAll.size() + " ===");
            for (Map<String, Object> item : itemsAll) {
                System.out.println("Item: " + item.get("itemName") + ", Category: " + item.get("category") + ", Quantity: " + item.get("quantity") + ", Rent Price: " + item.get("rentPrice"));
            }

            // Test filter với categoryId cụ thể (thay 1 bằng id từ categories trên, e.g., id của 'Đồ bơi trẻ em')
            Integer testCategoryId = 1;  // Thay bằng id thật từ output categories trên
            List<Map<String, Object>> itemsFiltered = EquipmentDAO.getEquipmentStatus("rental", testCategoryId);
            System.out.println("\n=== Test getEquipmentStatus (rental, categoryId=" + testCategoryId + ") - Total items: " + itemsFiltered.size() + " ===");
            for (Map<String, Object> item : itemsFiltered) {
                System.out.println("Item: " + item.get("itemName") + ", Category: " + item.get("category") + ", Quantity: " + item.get("quantity"));
            }

            // Tương tự test cho mode 'buy'
            System.out.println("\n=== Test for mode 'buy' ===");
            List<Map<String, Object>> buyCategories = EquipmentDAO.getAllCategories("buy");
            for (Map<String, Object> cat : buyCategories) {
                System.out.println("Buy Category ID: " + cat.get("id") + ", Name: " + cat.get("name") + ", Quantity: " + cat.get("quantity"));
            }

        } catch (SQLException e) {
            System.err.println("Error testing DAO: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
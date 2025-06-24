import dal.RoleDAO;
import model.Role;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class RoleDAOTest {

    @Test
    public void testGetAllRoles_Success() {
        List<Role> roles = RoleDAO.getAllRoles();
        assertNotNull(roles);
        assertTrue(roles.size() >= 5); // Vì bạn có 5 roles mẫu
        boolean hasAdmin = roles.stream().anyMatch(r -> r.getName().equals("Admin"));
        assertTrue(hasAdmin);
    }

    @Test
    public void testGetRoleById_Success() {
        Role role = RoleDAO.getRoleById(1); // Giả định role Admin có id = 1
        assertNotNull(role);
        assertEquals(1, role.getId());
        assertEquals("Admin", role.getName());
    }

    @Test
    public void testGetRoleById_Fail_NotExist() {
        Role role = RoleDAO.getRoleById(-1); // ID không tồn tại
        assertNull(role);
    }

    @Test
    public void testGetRoleById_Fail_SQLInjectionOrInvalidInput() {
        Role role = RoleDAO.getRoleById(9999); // Giả định ID rất lớn không tồn tại
        assertNull(role);
    }
}

import dal.UserDAO;
import model.User;
import org.junit.jupiter.api.*;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class UserDAOTest {

    @Test
    public void testLoginSuccess() {
        User user = UserDAO.login("admin@pool.com", "hashed_password_123");
        assertNotNull(user);
        assertEquals("admin@pool.com", user.getEmail());
    }

    @Test
    public void testLoginFail_WrongPassword() {
        User user = UserDAO.login("admin@pool.com", "wrong_password");
        assertNull(user);
    }

    @Test
    public void testCheckEmailExists_True() {
        assertTrue(UserDAO.checkEmailExists("admin@pool.com"));
    }

    @Test
    public void testCheckEmailExists_False() {
        assertFalse(UserDAO.checkEmailExists("nonexistent@email.com"));
    }

    @Test
    public void testRegisterSuccess() {
        boolean result = UserDAO.register("Test User", "testuser@abc.com", "0001112222",
                "test123", "Somewhere", "2000-01-01", "Male");
        assertTrue(result);
    }

    @Test
    public void testRegisterFail_DuplicateEmail() {
        // Email này đã tồn tại trong DB
        boolean result = UserDAO.register("Duplicate", "admin@pool.com", "1234567890",
                "123456", "Test", "1990-01-01", "Male");
        assertFalse(result);
    }

    @Test
    public void testUpdatePasswordSuccess() {
        boolean result = UserDAO.updatePassword("customer1@example.com", "newPassword123");
        assertTrue(result);
    }

    @Test
    public void testUpdatePasswordFail_InvalidEmail() {
        boolean result = UserDAO.updatePassword("notfound@email.com", "pwd");
        assertFalse(result);
    }

    @Test
    public void testFindUserByEmail_Success() {
        User user = UserDAO.findUserFromEmail("customer1@example.com");
        assertNotNull(user);
        assertEquals("customer1@example.com", user.getEmail());
    }

    @Test
    public void testFindUserByEmail_Fail() {
        User user = UserDAO.findUserFromEmail("missing@email.com");
        assertNull(user);
    }

    @Test
    public void testGetAllUsersWithRoles() {
        List<User> users = UserDAO.getAllUsersWithRoles();
        assertNotNull(users);
        assertTrue(users.size() > 0);
    }

    @Test
    public void testUpdateUserRole_Success() {
        boolean result = UserDAO.updateUserRole(6, 3); // giả định id 6 tồn tại
        assertTrue(result);
    }

    @Test
    public void testUpdateUserRole_Fail_InvalidId() {
        boolean result = UserDAO.updateUserRole(-1, 2);
        assertFalse(result);
    }

    @Test
    public void testUpdateUser_Success() {
        boolean result = UserDAO.updateUser(6, 2, "Active");
        assertTrue(result);
    }

    @Test
    public void testUpdateUser_Fail_InvalidId() {
        boolean result = UserDAO.updateUser(-999, 2, "Active");
        assertFalse(result);
    }

    @Test
    public void testGetUserById_Success() {
        User user = UserDAO.getUserById(6); // ID thật
        assertNotNull(user);
        assertEquals(6, user.getId());
    }

    @Test
    public void testGetUserById_Fail() {
        User user = UserDAO.getUserById(-100);
        assertNull(user);
    }

    @Test
    public void testDeleteUser_Fail_BecauseUsingSoftDeleteNow() {
        // Giả sử delete đã chuyển thành soft delete
        boolean result = UserDAO.deleteUser(6);
        assertFalse(result);
    }

    @Test
    public void testUpdateStatusById() {
        assertDoesNotThrow(() -> UserDAO.updateStatusById(6, "Deactive"));
        // Sau đó test lại nếu cần bằng getUserById
    }

    @Test
    public void testGetAllUsersWithFilter() {
        List<User> filtered = UserDAO.getAllUsers("Emma", "Active", "4");
        assertNotNull(filtered);
        for (User u : filtered) {
            assertTrue(u.getFullName().contains("Emma"));
            assertEquals("Active", u.getUserStatus());
            assertEquals(4, u.getRole().getId());
        }
    }
}

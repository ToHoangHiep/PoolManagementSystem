package dal;

import model.SwimCourse;
import org.junit.jupiter.api.*;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class SwimCourseDAOTest {

    private Connection conn;
    private SwimCourseDAO dao;

    @BeforeAll
    public void setup() throws Exception {
        conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/swimming_pool_management",
                "root",
                "1234"
        );
        dao = new SwimCourseDAO(conn);
    }

    @Test
    @Order(1)
    public void testAddCourse_validCourse_shouldBeAdded() throws Exception {
        SwimCourse course = new SwimCourse();
        course.setName("JUnit Test Beginner");
        course.setDescription("This is a test course");
        course.setPrice(199.99);
        course.setDuration(60);
        course.setStatus("Active");

        dao.addCourse(course);

        List<SwimCourse> result = dao.getCourses("Active", "JUnit Test Beginner");
        assertFalse(result.isEmpty(), "Course should be added successfully");
    }

    @Test
    @Order(2)
    public void testAddCourse_emptyName_shouldThrowException() {
        SwimCourse course = new SwimCourse();
        course.setName("");
        course.setDescription("Desc");
        course.setPrice(100);
        course.setDuration(30);
        course.setStatus("Active");

        assertThrows(Exception.class, () -> dao.addCourse(course));
    }

    @Test
    @Order(3)
    public void testAddCourse_invalidStatus_shouldFail() {
        SwimCourse course = new SwimCourse();
        course.setName("Invalid Status Test");
        course.setDescription("Test desc");
        course.setPrice(100);
        course.setDuration(45);
        course.setStatus("UnknownStatus");

        try {
            dao.addCourse(course);
            List<SwimCourse> result = dao.getCourses("UnknownStatus", "Invalid Status Test");
            assertTrue(result.isEmpty(), "Course with invalid status should not be added");
        } catch (Exception e) {
            assertTrue(true);
        }
    }
    @Test
    @Order(4)
    public void testAddCourse_invalidName_shouldThrow() {
        SwimCourse course = new SwimCourse();
        course.setName("!!@#$");
        course.setDescription("desc");
        course.setPrice(100);
        course.setDuration(30);
        course.setStatus("Active");

        Exception ex = assertThrows(IllegalArgumentException.class, () -> dao.addCourse(course));
        assertEquals("Course name cannot contain special characters", ex.getMessage());
    }

    @Test
    @Order(5)
    public void testAddCourse_negativePrice_shouldThrow() {
        SwimCourse course = new SwimCourse();
        course.setName("Course A");
        course.setDescription("desc");
        course.setPrice(-10);
        course.setDuration(30);
        course.setStatus("Active");

        Exception ex = assertThrows(IllegalArgumentException.class, () -> dao.addCourse(course));
        assertEquals("Price must be >= 0", ex.getMessage());
    }

    @Test
    @Order(6)
    public void testAddCourse_zeroDuration_shouldThrow() {
        SwimCourse course = new SwimCourse();
        course.setName("Course A");
        course.setDescription("desc");
        course.setPrice(100);
        course.setDuration(0);
        course.setStatus("Active");

        Exception ex = assertThrows(IllegalArgumentException.class, () -> dao.addCourse(course));
        assertEquals("Duration must be > 0", ex.getMessage());
    }

    @Test
    @Order(7)
    public void testAddCourse_invalidStatus_shouldThrow() {
        SwimCourse course = new SwimCourse();
        course.setName("Course A");
        course.setDescription("desc");
        course.setPrice(100);
        course.setDuration(30);
        course.setStatus("Pending");

        Exception ex = assertThrows(IllegalArgumentException.class, () -> dao.addCourse(course));
        assertEquals("Status must be 'Active' or 'Inactive'", ex.getMessage());
    }


    @AfterAll
    public void cleanup() throws Exception {
        if (conn != null && !conn.isClosed()) {
            conn.createStatement().executeUpdate("DELETE FROM Courses WHERE name LIKE 'JUnit Test%'");
            conn.close();
        }
    }
}

package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import model.CourseForm;
import utils.DBConnect;

public class CourseFormDAO {
    public static List<CourseForm> getAll() {
        String sql = "SELECT * FROM courseform";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                CourseForm courseForm = new CourseForm();
                courseForm.setId(rs.getInt("id"));
                courseForm.setUser_id(rs.getInt("user_id"));
                courseForm.setUser_fullName(rs.getString("user_fullName"));
                courseForm.setUser_email(rs.getString("user_email"));
                courseForm.setUser_phone(rs.getString("user_phone"));
                courseForm.setCoach_id(rs.getInt("coach_id"));
                courseForm.setCourse_id(rs.getInt("course_id"));
                courseForm.setRequest_date(rs.getDate("request_date"));
                courseForm.setHas_processed(rs.getBoolean("has_processed"));

                return List.of(courseForm);
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return null;
    }

    public static CourseForm getById(int id) {
        String sql = "SELECT * FROM courseform WHERE id = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                CourseForm courseForm = new CourseForm();
                courseForm.setId(rs.getInt("id"));
                courseForm.setUser_id(rs.getInt("user_id"));
                courseForm.setUser_fullName(rs.getString("user_fullName"));
                courseForm.setUser_email(rs.getString("user_email"));
                courseForm.setUser_phone(rs.getString("user_phone"));
                courseForm.setCoach_id(rs.getInt("coach_id"));
                courseForm.setCourse_id(rs.getInt("course_id"));
                courseForm.setRequest_date(rs.getDate("request_date"));
                courseForm.setHas_processed(rs.getBoolean("has_processed"));

                return courseForm;
            }
        }
        catch (Exception e) {
            throw new RuntimeException(e);
        }

        return null;
    }

    public static boolean create(CourseForm courseForm) {
        String sql = "";

        if (courseForm.getUser_id() == -1) {
            sql = "INSERT INTO courseform ( user_fullName, user_email, user_phone, coach_id, course_id) VALUES (?,?,?,?,?)";
        } else {
            sql = "INSERT INTO courseform (user_id, coach_id, course_id) VALUES (?,?,?)";
        }

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (courseForm.getUser_id() == -1) {
                ps.setString(1, courseForm.getUser_fullName());
                ps.setString(2, courseForm.getUser_email());
                ps.setString(3, courseForm.getUser_phone());
                ps.setInt(4, courseForm.getCoach_id());
                ps.setInt(5, courseForm.getCourse_id());
            } else {
                ps.setInt(1, courseForm.getUser_id());
                ps.setInt(2, courseForm.getCoach_id());
                ps.setInt(3, courseForm.getCourse_id());
            }

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static boolean setFormStatus(int formId) {
        String sql = "UPDATE courseform SET has_processed = true WHERE id = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setInt(1, formId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
        catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}

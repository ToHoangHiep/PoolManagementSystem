package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.CourseForm;
import utils.DBConnect;

public class CourseFormDAO {
    public static List<CourseForm> getAll() {
        List<CourseForm> list = new ArrayList<>();
        String sql = "SELECT * FROM course_form";
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
                courseForm.setHas_processed(rs.getInt("has_processed"));
                courseForm.setRejected_reason(rs.getString("rejected_reason"));

                list.add(courseForm);
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return list;
    }

    public static CourseForm getById(int id) {
        String sql = "SELECT * FROM course_form WHERE id = ?";

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
                courseForm.setHas_processed(rs.getInt("has_processed"));
                courseForm.setRejected_reason(rs.getString("rejected_reason"));

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
            sql = "INSERT INTO course_form ( user_fullName, user_email, user_phone, coach_id, course_id) VALUES (?,?,?,?,?)";
        } else {
            sql = "INSERT INTO course_form (user_id, coach_id, course_id) VALUES (?,?,?)";
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

    public static boolean setFormStatus(int formId, int status, String reason) {
        String sql = "UPDATE course_form SET has_processed = ?, rejected_reason = ? WHERE id = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setInt(1, status);

            if (status == 2 && reason != null && !reason.trim().isEmpty()) {
                ps.setString(2, reason);
            } else {
                ps.setNull(2, Types.VARCHAR);
            }

            ps.setInt(3, formId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
        catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}

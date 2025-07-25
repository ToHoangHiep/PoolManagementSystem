package dal;

import model.Feedback;
import utils.DBConnect;
import utils.Utils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {
    public static boolean createFeedback(int userId, String feedbackType, Integer coachId, Integer courseId, String generalFeedbackType, String content, int rating) {
        String sql = "INSERT INTO Feedbacks (user_id, feedback_type, coach_id, course_id, general_feedback_type, content, rating) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, feedbackType);

            switch (feedbackType) {
                case "Coach":
                    ps.setInt(3, coachId);
                    ps.setNull(4, Types.INTEGER);
                    ps.setNull(5, Types.VARCHAR);
                    break;
                case "Course":
                    ps.setNull(3, Types.INTEGER);
                    ps.setInt(4, courseId);
                    ps.setNull(5, Types.VARCHAR);
                    break;
                case "General":
                    ps.setNull(3, Types.INTEGER);
                    ps.setNull(4, Types.INTEGER);
                    ps.setString(5, generalFeedbackType);
                    break;
                default:
                    return false;
            }

            ps.setString(6, content);
            ps.setInt(7, rating);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace(); 
        }

        return false;
    }

    public static Feedback getSpecificFeedback(int postId) {
        String sql = "SELECT f.*, u.full_name, u.email FROM Feedbacks f INNER JOIN Users u ON f.user_id = u.id WHERE f.id = ?";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Feedback fb = new Feedback();
                fb.setId(rs.getInt("id"));
                fb.setUserId(rs.getInt("user_id"));
                fb.setFeedbackType(rs.getString("feedback_type"));
                fb.setCoachId(rs.getInt("coach_id"));
                fb.setCourseId(rs.getInt("course_id"));
                fb.setGeneralFeedbackType(rs.getString("general_feedback_type"));
                fb.setContent(rs.getString("content"));
                fb.setRating(rs.getInt("rating"));
                fb.setCreatedAt(rs.getTimestamp("created_at"));
                fb.setUpdatedAt(rs.getTimestamp("updated_at"));
                fb.setUserName(rs.getString("full_name"));
                fb.setUserEmail(rs.getString("email"));
                return fb;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }

        return null;
    }

    public static boolean updateFeedback(int postId, String content, Integer rating) {
        if (content == null && rating == null) {
            return false;
        }

        StringBuilder sql = new StringBuilder("UPDATE Feedbacks SET ");
        List<Object> params = new ArrayList<>();

        if (content != null) {
            sql.append("content = ?");
            params.add(content);
        }
        if (rating != null) {
            if (!params.isEmpty()) sql.append(", ");
            sql.append("rating = ?");
            params.add(rating);
        }
        sql.append(", updated_at = NOW() WHERE id = ?");
        params.add(postId);

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean deleteFeedback(int feedbackId) {
        Connection conn = null;
        PreparedStatement deleteRepliesStmt = null;
        PreparedStatement deleteFeedbackStmt = null;
        try {
            conn = DBConnect.getConnection();
            conn.setAutoCommit(false);

            // Delete feedback
            String deleteFeedbackSql = "DELETE FROM Feedbacks WHERE id = ?";
            deleteFeedbackStmt = conn.prepareStatement(deleteFeedbackSql);
            deleteFeedbackStmt.setInt(1, feedbackId);
            int affectedRows = deleteFeedbackStmt.executeUpdate();

            conn.commit();
            return affectedRows > 0;
        } catch (Exception e) {
            if (conn != null) try { conn.rollback(); } catch (Exception ex) {}
            e.printStackTrace();
            return false;
        } finally {
            try { if (deleteRepliesStmt != null) deleteRepliesStmt.close(); } catch (Exception e) {}
            try { if (deleteFeedbackStmt != null) deleteFeedbackStmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    public static List<Feedback> getAllFeedbacks() {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT f.*, u.full_name, u.email FROM Feedbacks f " +
                    "INNER JOIN Users u ON f.user_id = u.id " +
                    "ORDER BY f.created_at DESC";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Feedback fb = new Feedback();
                fb.setId(rs.getInt("id"));
                fb.setUserId(rs.getInt("user_id"));
                fb.setFeedbackType(rs.getString("feedback_type"));
                fb.setCoachId(rs.getInt("coach_id"));
                fb.setCourseId(rs.getInt("course_id"));
                fb.setGeneralFeedbackType(rs.getString("general_feedback_type"));
                fb.setContent(rs.getString("content"));
                fb.setRating(rs.getInt("rating"));
                fb.setCreatedAt(rs.getTimestamp("created_at"));
                fb.setUpdatedAt(rs.getTimestamp("updated_at"));
                fb.setUserName(rs.getString("full_name"));
                fb.setUserEmail(rs.getString("email"));
                feedbacks.add(fb);
            }

            return feedbacks;   
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public static List<Feedback> sortFeedbacks(
            Integer coachId,
            Integer courseId,
            String feedbackType,
            String generalFeedbackType,
            String sortBy, // "created_at", "updated_at", "rating",
            boolean desc // true for DESC, false for ASC
    ) {
        List<Feedback> feedbacks = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT f.*, u.full_name, u.email FROM Feedbacks f " +
            "INNER JOIN Users u ON f.user_id = u.id WHERE 1=1"
        );

        if (coachId != null && coachId > 0) {
            sql.append(" AND f.coach_id = ?");
        }
        if (courseId != null && courseId > 0) {
            sql.append(" AND f.course_id = ?");
        }
        if (feedbackType != null && !feedbackType.isEmpty()) {
            sql.append(" AND f.feedback_type = ?");
        }
        if (generalFeedbackType != null && !generalFeedbackType.isEmpty()) {
            sql.append(" AND f.general_feedback_type = ?");
        }

        // Sorting
        if (sortBy != null && !sortBy.isEmpty()) {
            sql.append(" ORDER BY f.").append(sortBy);
            if (desc) {
                sql.append(" DESC");
            } else {
                sql.append(" ASC");
            }
        } else {
            sql.append(" ORDER BY f.created_at DESC");
        }

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            if (coachId != null && coachId > 0) ps.setInt(idx++, coachId);
            if (courseId != null && courseId > 0) ps.setInt(idx++, courseId);
            if (feedbackType != null && !feedbackType.isEmpty()) ps.setString(idx++, feedbackType);
            if (generalFeedbackType != null && !generalFeedbackType.isEmpty()) ps.setString(idx++, generalFeedbackType);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Feedback fb = new Feedback();
                fb.setId(rs.getInt("id"));
                fb.setUserId(rs.getInt("user_id"));
                fb.setFeedbackType(rs.getString("feedback_type"));
                fb.setCoachId(rs.getInt("coach_id"));
                fb.setCourseId(rs.getInt("course_id"));
                fb.setGeneralFeedbackType(rs.getString("general_feedback_type"));
                fb.setContent(rs.getString("content"));
                fb.setRating(rs.getInt("rating"));
                fb.setCreatedAt(rs.getTimestamp("created_at"));
                fb.setUpdatedAt(rs.getTimestamp("updated_at"));
                fb.setUserName(rs.getString("full_name"));
                fb.setUserEmail(rs.getString("email"));
                feedbacks.add(fb);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbacks;
    }
}

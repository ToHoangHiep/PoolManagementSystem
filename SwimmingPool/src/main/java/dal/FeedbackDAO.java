package dal;

import model.Feedback;
import utils.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {
    public static boolean createFeedback() {
        return false;
    }

    public static Feedback getSpecificFeedback(int postId) {
        return null;
    }

    public static boolean updateFeedback(int postId, String content) {
        return false;
    }

    public static boolean updateFeedback(int postId, int rating) {
        return false;
    }

    public static boolean deleteFeedback() {
        return false;
    }

    public static List<Feedback> getAllFeedback() {
        return null;
    }

    public static List<Feedback> getFeedbacks(
            Integer coachId,
            Integer courseId,
            String feedbackType,
            String generalFeedbackType,
            String sortBy, // "created_at", "updated_at", "rating"
            boolean desc // true for DESC, false for ASC
    ) {
        List<Feedback> feedbacks = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Feedbacks WHERE 1=1");

        if (coachId != null && coachId > 0) {
            sql.append(" AND coach_id = ?");
        }
        if (courseId != null && courseId > 0) {
            sql.append(" AND course_id = ?");
        }
        if (feedbackType != null && !feedbackType.isEmpty()) {
            sql.append(" AND feedback_type = ?");
        }
        if (generalFeedbackType != null && !generalFeedbackType.isEmpty()) {
            sql.append(" AND general_feedback_type = ?");
        }

        // Sorting
        if (sortBy != null && !sortBy.isEmpty()) {
            sql.append(" ORDER BY ").append(sortBy);
            if (desc) {
                sql.append(" DESC");
            } else {
                sql.append(" ASC");
            }
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
                feedbacks.add(fb);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbacks;
    }

    public static List<Feedback> getAllFeedback(int userId) {
        return null;
    }

    public static List<Feedback> getFeedbacks(
            int userId,
            Integer coachId,
            Integer courseId,
            String feedbackType,
            String generalFeedbackType,
            String sortBy, // "created_at", "updated_at", "rating"
            boolean desc // true for DESC, false for ASC
    ) {
        List<Feedback> feedbacks = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Feedbacks WHERE user_id = ?");

        if (coachId != null && coachId > 0) {
            sql.append(" AND coach_id = ?");
        }
        if (courseId != null && courseId > 0) {
            sql.append(" AND course_id = ?");
        }
        if (feedbackType != null && !feedbackType.isEmpty()) {
            sql.append(" AND feedback_type = ?");
        }
        if (generalFeedbackType != null && !generalFeedbackType.isEmpty()) {
            sql.append(" AND general_feedback_type = ?");
        }

        // Sorting
        if (sortBy != null && !sortBy.isEmpty()) {
            sql.append(" ORDER BY ").append(sortBy);
            if (desc) {
                sql.append(" DESC");
            } else {
                sql.append(" ASC");
            }
        }

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            ps.setInt(1, userId);
            int idx = 2;
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
                feedbacks.add(fb);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbacks;
    }
}

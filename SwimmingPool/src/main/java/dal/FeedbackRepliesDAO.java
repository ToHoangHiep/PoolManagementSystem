package dal;

import model.FeedbackReplies;
import utils.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FeedbackRepliesDAO {
    
    // Create a feedback reply
    public static boolean createFeedbackReply(int feedbackId, int userId, String content) {
        String sql = "INSERT INTO FeedbackReplies (feedback_id, user_id, content) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, feedbackId);
            ps.setInt(2, userId);
            ps.setString(3, content);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }


    // Delete a feedback reply
    public static boolean deleteFeedbackReply(int id) {
        String sql = "DELETE FROM FeedbackReplies WHERE id = ?";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    // Retrieve all replies for a specific feedback with user names
    public static List<FeedbackReplies> getRepliesByFeedbackId(int feedbackId) {
        List<FeedbackReplies> replies = new ArrayList<>();
        String sql = "SELECT fr.*, u.full_name FROM FeedbackReplies fr " +
                    "INNER JOIN Users u ON fr.user_id = u.id " +
                    "WHERE fr.feedback_id = ? " +
                    "ORDER BY fr.created_at ASC";
        
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, feedbackId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                FeedbackReplies reply = new FeedbackReplies();
                reply.setId(rs.getInt("id"));
                reply.setFeedbackId(rs.getInt("feedback_id"));
                reply.setUserId(rs.getInt("user_id"));
                reply.setContent(rs.getString("content"));
                reply.setCreatedAt(rs.getTimestamp("created_at"));
                reply.setUserName(rs.getString("full_name"));
                replies.add(reply);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return replies;
    }
}

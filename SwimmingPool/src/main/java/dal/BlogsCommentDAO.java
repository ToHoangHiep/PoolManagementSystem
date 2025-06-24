package dal;

import model.BlogsComment;
import utils.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BlogsCommentDAO {
	
	// Add a comment to a blog
	public static boolean addComment(BlogsComment comment) {
		String sql = "INSERT INTO blog_comments (blog_id, user_id, content) VALUES (?, ?, ?)";
		
		try (Connection conn = DBConnect.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, comment.getBlogId());
			ps.setInt(2, comment.getUserId());
			ps.setString(3, comment.getContent());
			
			int rowsAffected = ps.executeUpdate();
			return rowsAffected > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return false;
	}

	// Get all comments for a specific blog with user names
	public static List<BlogsComment> getCommentsByBlogId(int blogId) {
		List<BlogsComment> comments = new ArrayList<>();
		String sql = "SELECT bc.*, u.full_name FROM blog_comments bc " +
					"INNER JOIN Users u ON bc.user_id = u.id " +
					"WHERE bc.blog_id = ? " +
					"ORDER BY bc.created_at ASC";
		
		try (Connection conn = DBConnect.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, blogId);
			ResultSet rs = ps.executeQuery();
			
			while (rs.next()) {
				BlogsComment comment = new BlogsComment(
					rs.getInt("id"),
					rs.getInt("blog_id"),
					rs.getInt("user_id"),
					rs.getString("content")
				);
				comment.setCreatedAt(rs.getTimestamp("created_at"));
				comment.setUserName(rs.getString("full_name"));
				comments.add(comment);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return comments;
	}
	
	// Delete a comment
	public static boolean deleteComment(int commentId) {
		String sql = "DELETE FROM blog_comments WHERE id = ?";
		
		try (Connection conn = DBConnect.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, commentId);
			
			int rowsAffected = ps.executeUpdate();
			return rowsAffected > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return false;
	}
	
	// Get comments count for a blog
	public static int getCommentsCount(int blogId) {
		String sql = "SELECT COUNT(*) FROM blog_comments WHERE blog_id = ?";
		
		try (Connection conn = DBConnect.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, blogId);
			ResultSet rs = ps.executeQuery();
			
			if (rs.next()) {
				return rs.getInt(1);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return 0;
	}
	
	// Get a specific comment by ID
	public static BlogsComment getCommentById(int commentId) {
		String sql = "SELECT bc.*, u.full_name FROM blog_comments bc " +
					"INNER JOIN Users u ON bc.user_id = u.id " +
					"WHERE bc.id = ?";
		
		try (Connection conn = DBConnect.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, commentId);
			ResultSet rs = ps.executeQuery();
			
			if (rs.next()) {
				BlogsComment comment = new BlogsComment(
					rs.getInt("id"),
					rs.getInt("blog_id"),
					rs.getInt("user_id"),
					rs.getString("content")
				);
				comment.setCreatedAt(rs.getTimestamp("created_at"));
				comment.setUserName(rs.getString("full_name"));
				return comment;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return null;
	}
	
	// Update a comment
	public static boolean updateComment(int commentId, String content) {
		String sql = "UPDATE blog_comments SET content = ? WHERE id = ?";
		
		try (Connection conn = DBConnect.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, content);
			ps.setInt(2, commentId);
			
			int rowsAffected = ps.executeUpdate();
			return rowsAffected > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return false;
	}
}

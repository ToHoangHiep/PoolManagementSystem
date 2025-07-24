package dal;

import utils.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import model.Blogs;

public class BlogsDAO {
	public static boolean createBlog(String title, String content, int authorId, int courseId, String tags) {
		String sql = "INSERT INTO Blogs (title, content, author_id, course_id, tags, active) VALUES (?, ?, ?, ?, ?, ?)";

		try (Connection conn = DBConnect.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, title);
			ps.setString(2, content);
			ps.setInt(3, authorId);
			ps.setInt(4, courseId);
			ps.setString(5, tags);
			ps.setBoolean(6, false); // New blogs are inactive by default

			int rowsAffected = ps.executeUpdate();
			return rowsAffected > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return false;
	}

	public static boolean updateBlog(int id, String title, String content, int authorId, int courseId, String tags) {
		String sql = "UPDATE Blogs SET title = ?, content = ?, author_id = ?, course_id = ?, tags = ? WHERE id = ?";

		try (Connection conn = DBConnect.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, title);
			ps.setString(2, content);
			ps.setInt(3, authorId);
			ps.setInt(4, courseId);
			ps.setString(5, tags);
			ps.setInt(6, id);

			int rowsAffected = ps.executeUpdate();
			return rowsAffected > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return false;
	}

	// New method to activate/deactivate blogs
	public static boolean updateBlogActiveStatus(int id, boolean active) {
		String sql = "UPDATE Blogs SET active = ? WHERE id = ?";

		try (Connection conn = DBConnect.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setBoolean(1, active);
			ps.setInt(2, id);

			int rowsAffected = ps.executeUpdate();
			return rowsAffected > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return false;
	}

	public static boolean deleteBlog(int id) {
		String sql = "DELETE FROM Blogs WHERE id = ?";

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

	public static List<Blogs> getAllBlogs() {
		List<Blogs> blogsList = new ArrayList<>();
		String sql = "SELECT b.*, u.full_name FROM Blogs b " +
					"INNER JOIN Users u ON b.author_id = u.id " +
					"ORDER BY b.published_at DESC";

		try (Connection conn = DBConnect.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql);
			 ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {
				Blogs blog = new Blogs(
					rs.getInt("id"),
					rs.getString("title"),
					rs.getString("content"),
					rs.getInt("author_id"),
					rs.getInt("course_id"),
					rs.getString("tags"),
					rs.getInt("likes"),
					rs.getTimestamp("published_at"),
					rs.getBoolean("active")
				);
				blog.setAuthorName(rs.getString("full_name"));
				blogsList.add(blog);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return blogsList;
	}

	public static Blogs getBlogById(int id) {
		String sql = "SELECT b.*, u.full_name FROM Blogs b " +
					"INNER JOIN Users u ON b.author_id = u.id " +
					"WHERE b.id = ?";

		try (Connection conn = DBConnect.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				Blogs blog = new Blogs(
					rs.getInt("id"),
					rs.getString("title"),
					rs.getString("content"),
					rs.getInt("author_id"),
					rs.getInt("course_id"),
					rs.getString("tags"),
					rs.getInt("likes"),
					rs.getTimestamp("published_at"),
					rs.getBoolean("active")
					);
				blog.setAuthorName(rs.getString("full_name"));
				return blog;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return null;
	}

   public static List<Blogs> sortBlogs(int authorId, int minLikes, Date startDate, Date endDate, String sortBy, boolean desc) {
       List<Blogs> blogsList = new ArrayList<>();
       StringBuilder sql = new StringBuilder("SELECT b.*, u.full_name FROM Blogs b " +
                                            "INNER JOIN Users u ON b.author_id = u.id WHERE b.active = true");

       // Build dynamic WHERE clause
       if (authorId > 0) {
           sql.append(" AND b.author_id = ?");
       }
       if (minLikes > 0) {
           sql.append(" AND b.likes >= ?");
       }
       if (startDate != null) {
           sql.append(" AND b.published_at >= ?");
       }
       if (endDate != null) {
           sql.append(" AND b.published_at <= ?");
       }

       // Add ORDER BY clause
       if (sortBy != null && !sortBy.isEmpty()) {
           sql.append(" ORDER BY b.").append(sortBy);
           if (desc) {
               sql.append(" DESC");
           } else {
               sql.append(" ASC");
           }
       } else {
           // Default sorting by published_at DESC
           sql.append(" ORDER BY b.published_at DESC");
       }

       try (Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql.toString())) {

           int idx = 1;
           if (authorId > 0) ps.setInt(idx++, authorId);
           if (minLikes > 0) ps.setInt(idx++, minLikes);
           if (startDate != null) ps.setTimestamp(idx++, new java.sql.Timestamp(startDate.getTime()));
           if (endDate != null) ps.setTimestamp(idx++, new java.sql.Timestamp(endDate.getTime()));

           ResultSet rs = ps.executeQuery();
           while (rs.next()) {
               Blogs blog = new Blogs(
                   rs.getInt("id"),
                   rs.getString("title"),
                   rs.getString("content"),
                   rs.getInt("author_id"),
                   rs.getInt("course_id"),
                   rs.getString("tags"),
                   rs.getInt("likes"),
                   rs.getTimestamp("published_at"),
                   rs.getBoolean("active")
               );
               blog.setAuthorName(rs.getString("full_name"));
               blogsList.add(blog);
           }
       } catch (SQLException e) {
           e.printStackTrace();
       }

       return blogsList;
   }
}

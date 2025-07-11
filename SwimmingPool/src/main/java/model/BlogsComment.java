package model;

import java.util.Date;

public class BlogsComment {
	private int id;
	private int blogId;
	private int userId;
	private String content;
	private Date createdAt;
	
	// User details
	private String userName;

	public BlogsComment(int id, int blogId, int userId, String content) {
		this.id = id;
		this.blogId = blogId;
		this.userId = userId;
		this.content = content;
	}

	public BlogsComment() {}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getBlogId() {
		return blogId;
	}

	public void setBlogId(int blogId) {
		this.blogId = blogId;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}
}

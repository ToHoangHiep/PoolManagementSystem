package model;

import java.util.Date;

public class Blogs {
	private int id;
	private String title;
	private String content;
	private int authorId;
	private int courseId;
	private String tags;
	private int likes;
	private Date publishedAt;
	private boolean active; // New field for activation status
	
	// User details
	private String authorName;

	public Blogs(String title, String content, int authorId, int courseId, String tags) {
		this.title = title;
		this.content = content;
		this.authorId = authorId;
		this.courseId = courseId;
		this.tags = tags;
		this.likes = 0; // Mặc định likes là 0
		this.publishedAt = new Date(System.currentTimeMillis()); // Thời gian hiện tại
		this.active = false; // New blogs are inactive by default
	}

	public Blogs(int id, String title, String content, int authorId, int courseId, String tags, int likes, Date publishedAt) {
		this.id = id;
		this.title = title;
		this.content = content;
		this.authorId = authorId;
		this.courseId = courseId;
		this.tags = tags;
		this.likes = likes;
		this.publishedAt = publishedAt;
		this.active = false; // Default inactive
	}

	// Constructor with active field
	public Blogs(int id, String title, String content, int authorId, int courseId, String tags, int likes, Date publishedAt, boolean active) {
		this.id = id;
		this.title = title;
		this.content = content;
		this.authorId = authorId;
		this.courseId = courseId;
		this.tags = tags;
		this.likes = likes;
		this.publishedAt = publishedAt;
		this.active = active;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public int getAuthorId() {
		return authorId;
	}

	public void setAuthorId(int authorId) {
		this.authorId = authorId;
	}

	public int getCourseId() {
		return courseId;
	}

	public void setCourseId(int courseId) {
		this.courseId = courseId;
	}

	public String getTags() {
		return tags;
	}

	public void setTags(String tags) {
		this.tags = tags;
	}

	public int getLikes() {
		return likes;
	}

	public void setLikes(int likes) {
		this.likes = likes;
	}

	public Date getPublishedAt() {
		return publishedAt;
	}

	public void setPublishedAt(Date publishedAt) {
		this.publishedAt = publishedAt;
	}

	public String getAuthorName() {
		return authorName;
	}

	public void setAuthorName(String authorName) {
		this.authorName = authorName;
	}

	// Getter and setter for active field
	public boolean isActive() {
		return active;
	}

	public void setActive(boolean active) {
		this.active = active;
	}
}

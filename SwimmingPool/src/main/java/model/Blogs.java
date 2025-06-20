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

	public Blogs(String title, String content, int authorId, int courseId, String tags) {
		this.title = title;
		this.content = content;
		this.authorId = authorId;
		this.courseId = courseId;
		this.tags = tags;
		this.likes = 0; // Mặc định likes là 0
		this.publishedAt = new Date(System.currentTimeMillis()); // Thời gian hiện tại
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

	
	
}

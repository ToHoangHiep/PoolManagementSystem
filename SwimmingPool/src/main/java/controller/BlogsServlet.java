package controller;
//
//import dal.BlogsDAO;
//import dal.BlogsCommentDAO;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import model.Blogs;
//import model.BlogsComment;
//import model.User;
//import utils.Utils;
//
//import java.io.IOException;
//import java.text.ParseException;
//import java.text.SimpleDateFormat;
//import java.util.Arrays;
//import java.util.Date;
//import java.util.List;
//
//public class BlogsServlet extends HttpServlet {
//
//    private static final String alert_message = "alert_message";
//    private static final String alert_action = "alert_action";
//    private static final String error = "error";
//
//    private static final String list_link = "blogs?action=list";
//    private static final String error_link = "error.jsp";
//    private static final String login_link = "login";
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        String action = request.getParameter("action");
//
//        if (action == null) {
//            action = "list";
//        }
//
//        try {
//            switch (action) {
//                case "create" -> createBlog(request, response);
//                case "list" -> listBlog(request, response);
//                case "sort" -> sortBlog(request, response);
//                case "view" -> viewBlog(request, response);
//                case "edit" -> editBlog(request, response);
//                case "delete" -> deleteBlog(request, response);
//                case "manage" -> manageBlog(request, response);
//                case "activate" -> activateBlog(request, response);
//                default -> {
//                    response.sendRedirect(error_link);
//                }
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//            response.sendRedirect(error_link);
//        }
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        String action = request.getParameter("action");
//
//        try {
//            switch (action) {
//                case "create" -> createAction(request, response);
//                case "update" -> updateAction(request, response);
//                case "add_comment" -> addComment(request, response);
//                case "edit_comment" -> editCommentAction(request, response);
//                case "delete_comment" -> deleteComment(request, response);
//                default -> {
//                    response.sendRedirect(error_link);
//                }
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//            response.sendRedirect(error_link);
//        }
//    }
//
//    private void listBlog(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        List<Blogs> blogsList = BlogsDAO.getAllBlogs();
//
//        request.setAttribute("blogs_list", blogsList);
//        request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//    }
//
//    private void sortBlog(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//
//        // Get sorting parameters
//        String authorIdStr = request.getParameter("author_id");
//        String minLikesStr = request.getParameter("min_likes");
//        String startDateStr = request.getParameter("start_date");
//        String endDateStr = request.getParameter("end_date");
//        String sortBy = request.getParameter("sort_by");
//        String sortOrder = request.getParameter("sort_order");
//
//        int authorId = 0;
//        int minLikes = 0;
//        Date startDate = null;
//        Date endDate = null;
//        boolean desc = "desc".equals(sortOrder);
//
//        try {
//            if (!Utils.CheckIfEmpty(authorIdStr)) {
//                authorId = Integer.parseInt(authorIdStr);
//            }
//            if (!Utils.CheckIfEmpty(minLikesStr)) {
//                minLikes = Integer.parseInt(minLikesStr);
//            }
//
//            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
//            if (!Utils.CheckIfEmpty(startDateStr)) {
//                startDate = dateFormat.parse(startDateStr);
//            }
//            if (!Utils.CheckIfEmpty(endDateStr)) {
//                endDate = dateFormat.parse(endDateStr);
//            }
//        } catch (NumberFormatException | ParseException e) {
//            request.setAttribute(alert_message, "Invalid search parameters. Please check your input.");
//            request.setAttribute(alert_action, list_link);
//            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//            return;
//        }
//
//        List<Blogs> blogsList = BlogsDAO.sortBlogs(authorId, minLikes, startDate, endDate, sortBy, desc);
//
//        request.setAttribute("blogs_list", blogsList);
//
//        // Keep the search parameters
//        request.setAttribute("author_id", authorIdStr);
//        request.setAttribute("min_likes", minLikesStr);
//        request.setAttribute("start_date", startDateStr);
//        request.setAttribute("end_date", endDateStr);
//        request.setAttribute("sort_by", sortBy);
//        request.setAttribute("sort_order", sortOrder);
//
//        request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//    }
//
//    private void viewBlog(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        String idParam = request.getParameter("id");
//
//        if (Utils.CheckIfEmpty(idParam)) {
//            request.setAttribute(alert_message, "Blog ID is required to view the blog.");
//            request.setAttribute(alert_action, list_link);
//            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//            return;
//        }
//
//        try {
//            int blogId = Integer.parseInt(idParam);
//            Blogs blog = BlogsDAO.getBlogById(blogId);
//
//            if (blog == null) {
//                request.setAttribute(alert_message, "Blog not found. It may have been deleted or doesn't exist.");
//                request.setAttribute(alert_action, list_link);
//                request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//                return;
//            }
//
//            List<BlogsComment> comments = BlogsCommentDAO.getCommentsByBlogId(blogId);
//
//            request.setAttribute("blog", blog);
//            request.setAttribute("comments", comments);
//
//            request.getRequestDispatcher("blog_detail.jsp").forward(request, response);
//        } catch (NumberFormatException e) {
//            request.setAttribute(alert_message, "Invalid blog ID format.");
//            request.setAttribute(alert_action, list_link);
//            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//        }
//    }
//
//    private void createBlog(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        User user = (User) request.getSession().getAttribute("user");
//        if (user == null) {
//            request.setAttribute(alert_message, "Please sign in to create blog posts.");
//            request.setAttribute(alert_action, login_link);
//            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//            return;
//        }
//
//        boolean allowCreatePost = user.getRole().getId() == 1;
//        if (!allowCreatePost) {
//            request.setAttribute(alert_message, "You don't have permission to create blogs. Only coachs can create blog posts.");
//            request.setAttribute(alert_action, list_link);
//            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//            return;
//        }
//
//        request.getRequestDispatcher("blog_form.jsp").forward(request, response);
//    }
//
//    private void editBlog(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        User user = (User) request.getSession().getAttribute("user");
//        if (user == null) {
//            request.setAttribute(alert_message, "Please sign in to edit blog posts.");
//            request.setAttribute(alert_action, login_link);
//            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//            return;
//        }
//
//        String idParam = request.getParameter("id");
//
//        if (Utils.CheckIfEmpty(idParam)) {
//            request.setAttribute(alert_message, "Blog ID is required to edit the blog.");
//            request.setAttribute(alert_action, list_link);
//            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//            return;
//        }
//
//        try {
//            int blogId = Integer.parseInt(idParam);
//            Blogs blog = BlogsDAO.getBlogById(blogId);
//            boolean isAdmin = !Arrays.asList(3, 4).contains(user.getRole().getId());
//
//            if (blog == null) {
//                request.setAttribute(alert_message, "Blog not found. It may have been deleted.");
//                request.setAttribute(alert_action, list_link);
//                request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//                return;
//            }
//
//            if (!isAdmin && blog.getAuthorId() != user.getId()) {
//                request.setAttribute(alert_message, "You don't have permission to edit this blog. You can only edit your own blog posts.");
//                request.setAttribute(alert_action, list_link);
//                request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//                return;
//            }
//
//            request.setAttribute("blog", blog);
//            request.setAttribute("edit_mode", true);
//            request.getRequestDispatcher("blog_form.jsp").forward(request, response);
//        } catch (NumberFormatException e) {
//            request.setAttribute(alert_message, "Invalid blog ID format.");
//            request.setAttribute(alert_action, list_link);
//            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//        }
//    }
//
//    private void deleteBlog(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
//        User user = (User) request.getSession().getAttribute("user");
//        if (user == null) {
//            request.setAttribute(alert_message, "Please sign in to delete blog posts.");
//            request.setAttribute(alert_action, login_link);
//            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//            return;
//        }
//
//        String idParam = request.getParameter("id");
//
//        if (Utils.CheckIfEmpty(idParam)) {
//            request.setAttribute(alert_message, "Blog ID is required to delete the blog.");
//            request.setAttribute(alert_action, list_link);
//            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//            return;
//        }
//
//        try {
//            int blogId = Integer.parseInt(idParam);
//            Blogs blog = BlogsDAO.getBlogById(blogId);
//            boolean isAdmin = !Arrays.asList(3, 4).contains(user.getRole().getId());
//
//            if (blog == null) {
//                request.setAttribute(alert_message, "Blog not found. It may have already been deleted.");
//                request.setAttribute(alert_action, list_link);
//                request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//                return;
//            }
//
//            if (!isAdmin && blog.getAuthorId() != user.getId()) {
//                request.setAttribute(alert_message, "You don't have permission to delete this blog. You can only delete your own blog posts.");
//                request.setAttribute(alert_action, list_link);
//                request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//                return;
//            }
//
//            if (BlogsDAO.deleteBlog(blogId)) {
//                request.setAttribute(alert_message, "Blog deleted successfully!");
//                request.setAttribute(alert_action, list_link);
//                request.setAttribute(error, false);
//            } else {
//                request.setAttribute(alert_message, "Failed to delete blog. Please try again.");
//                request.setAttribute(alert_action, list_link);
//                request.setAttribute(error, "Failed to delete blog. Please try again.");
//            }
//        } catch (NumberFormatException e) {
//            request.setAttribute(alert_message, "Invalid blog ID format.");
//            request.setAttribute(alert_action, list_link);
//        }
//
//        request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//    }
//
//    private void deleteComment(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
//        User user = (User) request.getSession().getAttribute("user");
//        if (user == null) {
//            request.setAttribute(alert_message, "Please sign in to delete comments.");
//            request.setAttribute(alert_action, login_link);
//            request.getRequestDispatcher("blog_detail.jsp").forward(request, response);
//            return;
//        }
//
//        String commentIdParam = request.getParameter("comment_id");
//        String blogIdParam = request.getParameter("blog_id");
//
//        if (Utils.CheckIfEmpty(commentIdParam) || Utils.CheckIfEmpty(blogIdParam)) {
//            request.setAttribute(alert_message, "Comment ID and Blog ID are required to delete the comment.");
//            request.setAttribute(alert_action, list_link);
//            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//            return;
//        }
//
//        try {
//            int commentId = Integer.parseInt(commentIdParam);
//            int blogId = Integer.parseInt(blogIdParam);
//
//            BlogsComment comment = BlogsCommentDAO.getCommentById(commentId);
//            boolean isAdmin = !Arrays.asList(3, 4).contains(user.getRole().getId());
//
//            if (comment == null) {
//                request.setAttribute(alert_message, "Comment not found. It may have already been deleted.");
//                request.setAttribute(alert_action, "blogs?action=view&id=" + blogId);
//                request.getRequestDispatcher("blog_detail.jsp").forward(request, response);
//                return;
//            }
//
//            if (!isAdmin && comment.getUserId() != user.getId()) {
//                request.setAttribute(alert_message, "You don't have permission to delete this comment. You can only delete your own comments.");
//                request.setAttribute(alert_action, "blogs?action=view&id=" + blogId);
//                request.getRequestDispatcher("blog_detail.jsp").forward(request, response);
//                return;
//            }
//
//            if (BlogsCommentDAO.deleteComment(commentId)) {
//                request.setAttribute(alert_message, "Comment deleted successfully!");
//            } else {
//                request.setAttribute(alert_message, "Failed to delete comment. Please try again.");
//            }
//            request.setAttribute(alert_action, "blogs?action=view&id=" + blogId);
//
//            // Reload the blog view
//            viewBlog(request, response);
//        } catch (NumberFormatException e) {
//            request.setAttribute(alert_message, "Invalid comment or blog ID format.");
//            request.setAttribute(alert_action, list_link);
//            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//        }
//    }
//
//    private void createAction(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
//        String title = request.getParameter("title");
//        String content = request.getParameter("content");
//        String courseIdStr = request.getParameter("course_id");
//        String tags = request.getParameter("tags");
//
//        User user = (User) request.getSession().getAttribute("user");
//
//        if (user == null) {
//            request.setAttribute(alert_message, "Please sign in to create blog posts.");
//            request.setAttribute(alert_action, login_link);
//            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//            return;
//        }
//
//        if (Utils.CheckIfEmpty(title) || Utils.CheckIfEmpty(content)) {
//            request.setAttribute(error, "Title and content are required to create a blog.");
//            request.getRequestDispatcher("blog_form.jsp").forward(request, response);
//            return;
//        }
//
//        // Validate course ID
//        if (!Utils.CheckIfEmpty(courseIdStr)) {
//            request.setAttribute(alert_message, "Invalid course ID format.");
//            request.setAttribute(alert_action, "blogs?action=create_form");
//            request.getRequestDispatcher("blog_form.jsp").forward(request, response);
//            return;
//        }
//
//        try {
//            int courseId = Integer.parseInt(courseIdStr);
//
//            if (BlogsDAO.createBlog(title, content, user.getId(), courseId, tags)) {
//                request.setAttribute(alert_message, "Blog created successfully! Your blog post is pending approval and will be visible once activated by an admin or manager.");
//                request.setAttribute(alert_action, list_link);
//            } else {
//                request.setAttribute(alert_message, "Failed to create blog. Please try again.");
//                request.setAttribute(alert_action, "blogs?action=create_form");
//            }
//        } catch (NumberFormatException e) {
//            request.setAttribute(alert_message, "Invalid course ID format.");
//            request.setAttribute(alert_action, "blogs?action=create_form");
//        }
//
//        request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//    }
//
//    private void updateAction(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
//        String idParam = request.getParameter("id");
//        String title = request.getParameter("title");
//        String content = request.getParameter("content");
//        String courseIdStr = request.getParameter("course_id");
//        String tags = request.getParameter("tags");
//
//        if (Utils.CheckIfEmpty(idParam) || Utils.CheckIfEmpty(title) || Utils.CheckIfEmpty(content)) {
//            request.setAttribute(alert_message, "Blog ID, title and content are required to update the blog.");
//            request.setAttribute(alert_action, list_link);
//            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//            return;
//        }
//
//        try {
//            int blogId = Integer.parseInt(idParam);
//            int courseId = Utils.CheckIfEmpty(courseIdStr) ? 0 : Integer.parseInt(courseIdStr);
//
//            Blogs blog = BlogsDAO.getBlogById(blogId);
//            User user = (User) request.getSession().getAttribute("user");
//            boolean isAdmin = user != null && !Arrays.asList(3, 4).contains(user.getRole().getId());
//
//            if (blog == null) {
//                request.setAttribute(alert_message, "Blog not found. It may have been deleted.");
//                request.setAttribute(alert_action, list_link);
//                request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//                return;
//            }
//
//            if (!isAdmin && blog.getAuthorId() != user.getId()) {
//                request.setAttribute(alert_message, "You don't have permission to update this blog.");
//                request.setAttribute(alert_action, list_link);
//                request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//                return;
//            }
//
//            if (BlogsDAO.updateBlog(blogId, title, content, blog.getAuthorId(), courseId, tags)) {
//                request.setAttribute(alert_message, "Blog updated successfully! Your changes have been saved.");
//                request.setAttribute(alert_action, "blogs?action=view&id=" + blogId);
//            } else {
//                request.setAttribute(alert_message, "Failed to update blog. Please try again.");
//                request.setAttribute(alert_action, "blogs?action=edit&id=" + blogId);
//            }
//        } catch (NumberFormatException e) {
//            request.setAttribute(alert_message, "Invalid blog ID or course ID format.");
//            request.setAttribute(alert_action, list_link);
//        }
//
//        // Redirect to appropriate page based on success/failure
//        String action = (String) request.getAttribute(alert_action);
//        if (action.contains("view")) {
//            viewBlog(request, response);
//        } else {
//            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//        }
//    }
//
//    private void addComment(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
//        String blogIdParam = request.getParameter("blog_id");
//        String content = request.getParameter("content");
//
//        if (Utils.CheckIfEmpty(blogIdParam) || Utils.CheckIfEmpty(content)) {
//            request.setAttribute(alert_message, "Blog ID and comment content are required to add a comment.");
//            request.setAttribute(alert_action, list_link);
//            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//            return;
//        }
//
//        try {
//            int blogId = Integer.parseInt(blogIdParam);
//            User user = (User) request.getSession().getAttribute("user");
//
//            BlogsComment comment = new BlogsComment();
//            comment.setBlogId(blogId);
//            comment.setUserId(user.getId());
//            comment.setContent(content);
//            if (BlogsCommentDAO.addComment(comment)) {
//                request.setAttribute(alert_action, "blogs?action=view&id=" + blogId);
//            } else {
//                request.setAttribute(error, "Failed to add comment. Please try again.");
//            }
//
//            // Reload the blog view
//            viewBlog(request, response);
//        } catch (NumberFormatException e) {
//            request.setAttribute(alert_message, "Invalid blog ID format.");
//            request.setAttribute(alert_action, list_link);
//            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//        }
//    }
//
//    private void editCommentAction(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
//        String commentIdParam = request.getParameter("comment_id");
//        String blogIdParam = request.getParameter("blog_id");
//        String content = request.getParameter("content");
//
//        if (Utils.CheckIfEmpty(commentIdParam) || Utils.CheckIfEmpty(blogIdParam) || Utils.CheckIfEmpty(content)) {
//            request.setAttribute(alert_message, "Comment ID, blog ID and content are required to update the comment.");
//            request.setAttribute(alert_action, list_link);
//            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//            return;
//        }
//
//        try {
//            int commentId = Integer.parseInt(commentIdParam);
//            int blogId = Integer.parseInt(blogIdParam);
//
//            BlogsComment comment = BlogsCommentDAO.getCommentById(commentId);
//            User user = (User) request.getSession().getAttribute("user");
//
//            if (comment == null) {
//                request.setAttribute(alert_message, "Comment not found. It may have been deleted.");
//                request.setAttribute(alert_action, "blogs?action=view&id=" + blogId);
//                viewBlog(request, response);
//                return;
//            }
//
//            if (comment.getUserId() != user.getId()) {
//                request.setAttribute(alert_message, "You don't have permission to edit this comment.");
//                request.setAttribute(alert_action, "blogs?action=view&id=" + blogId);
//                viewBlog(request, response);
//                return;
//            }
//
//            if (BlogsCommentDAO.updateComment(commentId, content)) {
//                request.setAttribute(alert_message, "Comment updated successfully! Your changes have been saved.");
//            } else {
//                request.setAttribute(alert_message, "Failed to update comment. Please try again.");
//            }
//            request.setAttribute(alert_action, "blogs?action=view&id=" + blogId);
//
//            // Reload the blog view
//            viewBlog(request, response);
//        } catch (NumberFormatException e) {
//            request.setAttribute(alert_message, "Invalid comment or blog ID format.");
//            request.setAttribute(alert_action, list_link);
//            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//        }
//    }
//
//    // New method for blog management page (admin/manager only)
//    private void manageBlog(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        User user = (User) request.getSession().getAttribute("user");
//        if (user == null) {
//            request.setAttribute(alert_message, "Please sign in to access blog management.");
//            request.setAttribute(alert_action, login_link);
//            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//            return;
//        }
//
//        // Check if user is admin or manager (roles 1 and 2)
//        boolean isAdminOrManager = Arrays.asList(1, 2).contains(user.getRole().getId());
//        if (!isAdminOrManager) {
//            request.setAttribute(alert_message, "Access denied. Only administrators and managers can access blog management.");
//            request.setAttribute(alert_action, list_link);
//            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//            return;
//        }
//
//        // Get all blogs (both active and inactive) for management
//        List<Blogs> allBlogs = BlogsDAO.getAllBlogs();
//        List<Blogs> inactiveBlogs = allBlogs.stream().filter(blog -> !blog.isActive()).toList();
//
//        request.setAttribute("all_blogs", allBlogs);
//        request.setAttribute("inactive_blogs", inactiveBlogs);
//        request.getRequestDispatcher("blog_manage.jsp").forward(request, response);
//    }
//
//    // New method to activate/deactivate blogs
//    private void activateBlog(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
//        User user = (User) request.getSession().getAttribute("user");
//        if (user == null) {
//            request.setAttribute(alert_message, "Please sign in to manage blog status.");
//            request.setAttribute(alert_action, login_link);
//            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//            return;
//        }
//
//        // Check if user is admin or manager (roles 1 and 2)
//        boolean isAdminOrManager = Arrays.asList(1, 2).contains(user.getRole().getId());
//        if (!isAdminOrManager) {
//            request.setAttribute(alert_message, "Access denied. Only administrators and managers can manage blog status.");
//            request.setAttribute(alert_action, list_link);
//            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
//            return;
//        }
//
//        String idParam = request.getParameter("id");
//        String statusParam = request.getParameter("status");
//
//        if (Utils.CheckIfEmpty(idParam) || Utils.CheckIfEmpty(statusParam)) {
//            request.setAttribute(alert_message, "Blog ID and status are required to update blog status.");
//            request.setAttribute(alert_action, "blogs?action=manage");
//            request.getRequestDispatcher("blog_manage.jsp").forward(request, response);
//            return;
//        }
//
//        try {
//            int blogId = Integer.parseInt(idParam);
//            boolean active = "activate".equals(statusParam);
//
//            Blogs blog = BlogsDAO.getBlogById(blogId);
//            if (blog == null) {
//                request.setAttribute(alert_message, "Blog not found. It may have been deleted.");
//                request.setAttribute(alert_action, "blogs?action=manage");
//                manageBlog(request, response);
//                return;
//            }
//
//            if (BlogsDAO.updateBlogActiveStatus(blogId, active)) {
//                String action = active ? "activated" : "deactivated";
//                request.setAttribute(alert_message, "Blog has been " + action + " successfully!");
//            } else {
//                request.setAttribute(alert_message, "Failed to update blog status. Please try again.");
//            }
//            request.setAttribute(alert_action, "blogs?action=manage");
//
//            // Reload the management page
//            manageBlog(request, response);
//        } catch (NumberFormatException e) {
//            request.setAttribute(alert_message, "Invalid blog ID format.");
//            request.setAttribute(alert_action, "blogs?action=manage");
//            manageBlog(request, response);
//        }
//    }
//}

import dal.BlogsDAO;
import dal.BlogsCommentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Blogs;
import model.BlogsComment;
import model.User;
import utils.Utils;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

public class BlogsServlet extends HttpServlet {

    private static final String alert_message = "alert_message";
    private static final String alert_action = "alert_action";
    private static final String error = "error";

    private static final String list_link = "blogs?action=list";
    private static final String error_link = "error.jsp";
    private static final String login_link = "login";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "create" -> createBlog(request, response);
                case "list" -> listBlog(request, response);
                case "sort" -> sortBlog(request, response);
                case "view" -> viewBlog(request, response);
                case "edit" -> editBlog(request, response);
                case "delete" -> deleteBlog(request, response);
                case "manage" -> manageBlog(request, response);
                case "activate" -> activateBlog(request, response);
                default -> {
                    response.sendRedirect(error_link);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(error_link);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "create" -> createAction(request, response);
                case "update" -> updateAction(request, response);
                case "add_comment" -> addComment(request, response);
                case "edit_comment" -> editCommentAction(request, response);
                case "delete_comment" -> deleteComment(request, response);
                default -> {
                    response.sendRedirect(error_link);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(error_link);
        }
    }

    private void listBlog(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Blogs> blogsList = BlogsDAO.getAllBlogs();

        request.setAttribute("blogs_list", blogsList);
        request.getRequestDispatcher("blog_list.jsp").forward(request, response);
    }

    private void sortBlog(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Get sorting parameters
        String authorIdStr = request.getParameter("author_id");
        String minLikesStr = request.getParameter("min_likes");
        String startDateStr = request.getParameter("start_date");
        String endDateStr = request.getParameter("end_date");
        String sortBy = request.getParameter("sort_by");
        String sortOrder = request.getParameter("sort_order");

        int authorId = 0;
        int minLikes = 0;
        Date startDate = null;
        Date endDate = null;
        boolean desc = "desc".equals(sortOrder);

        try {
            if (!Utils.CheckIfEmpty(authorIdStr)) {
                authorId = Integer.parseInt(authorIdStr);
            }
            if (!Utils.CheckIfEmpty(minLikesStr)) {
                minLikes = Integer.parseInt(minLikesStr);
            }

            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            if (!Utils.CheckIfEmpty(startDateStr)) {
                startDate = dateFormat.parse(startDateStr);
            }
            if (!Utils.CheckIfEmpty(endDateStr)) {
                endDate = dateFormat.parse(endDateStr);
            }
        } catch (NumberFormatException | ParseException e) {
            request.setAttribute(alert_message, "Invalid search parameters. Please check your input.");
            request.setAttribute(alert_action, list_link);
            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
            return;
        }

        List<Blogs> blogsList = BlogsDAO.sortBlogs(authorId, minLikes, startDate, endDate, sortBy, desc);

        request.setAttribute("blogs_list", blogsList);

        // Keep the search parameters
        request.setAttribute("author_id", authorIdStr);
        request.setAttribute("min_likes", minLikesStr);
        request.setAttribute("start_date", startDateStr);
        request.setAttribute("end_date", endDateStr);
        request.setAttribute("sort_by", sortBy);
        request.setAttribute("sort_order", sortOrder);

        request.getRequestDispatcher("blog_list.jsp").forward(request, response);
    }

    private void viewBlog(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");

        if (Utils.CheckIfEmpty(idParam)) {
            request.setAttribute(alert_message, "Blog ID is required to view the blog.");
            request.setAttribute(alert_action, list_link);
            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
            return;
        }

        try {
            int blogId = Integer.parseInt(idParam);
            Blogs blog = BlogsDAO.getBlogById(blogId);

            if (blog == null) {
                request.setAttribute(alert_message, "Blog not found. It may have been deleted or doesn't exist.");
                request.setAttribute(alert_action, list_link);
                request.getRequestDispatcher("blog_list.jsp").forward(request, response);
                return;
            }

            List<BlogsComment> comments = BlogsCommentDAO.getCommentsByBlogId(blogId);

            request.setAttribute("blog", blog);
            request.setAttribute("comments", comments);

            request.getRequestDispatcher("blog_detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute(alert_message, "Invalid blog ID format.");
            request.setAttribute(alert_action, list_link);
            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
        }
    }

    private void createBlog(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            request.setAttribute(alert_message, "Please sign in to create blog posts.");
            request.setAttribute(alert_action, login_link);
            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
            return;
        }

        boolean allowCreatePost = user.getRole().getId() == 1;
        if (!allowCreatePost) {
            request.setAttribute(alert_message, "You don't have permission to create blogs. Only coachs can create blog posts.");
            request.setAttribute(alert_action, list_link);
            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
            return;
        }

        request.getRequestDispatcher("blog_form.jsp").forward(request, response);
    }

    private void editBlog(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            request.setAttribute(alert_message, "Please sign in to edit blog posts.");
            request.setAttribute(alert_action, login_link);
            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
            return;
        }

        String idParam = request.getParameter("id");

        if (Utils.CheckIfEmpty(idParam)) {
            request.setAttribute(alert_message, "Blog ID is required to edit the blog.");
            request.setAttribute(alert_action, list_link);
            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
            return;
        }

        try {
            int blogId = Integer.parseInt(idParam);
            Blogs blog = BlogsDAO.getBlogById(blogId);
            boolean isAdmin = !Arrays.asList(3, 4).contains(user.getRole().getId());

            if (blog == null) {
                request.setAttribute(alert_message, "Blog not found. It may have been deleted.");
                request.setAttribute(alert_action, list_link);
                request.getRequestDispatcher("blog_list.jsp").forward(request, response);
                return;
            }

            if (!isAdmin && blog.getAuthorId() != user.getId()) {
                request.setAttribute(alert_message, "You don't have permission to edit this blog. You can only edit your own blog posts.");
                request.setAttribute(alert_action, list_link);
                request.getRequestDispatcher("blog_list.jsp").forward(request, response);
                return;
            }

            request.setAttribute("blog", blog);
            request.setAttribute("edit_mode", true);
            request.getRequestDispatcher("blog_form.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute(alert_message, "Invalid blog ID format.");
            request.setAttribute(alert_action, list_link);
            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
        }
    }

    private void deleteBlog(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            request.setAttribute(alert_message, "Please sign in to delete blog posts.");
            request.setAttribute(alert_action, login_link);
            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
            return;
        }

        String idParam = request.getParameter("id");

        if (Utils.CheckIfEmpty(idParam)) {
            request.setAttribute(alert_message, "Blog ID is required to delete the blog.");
            request.setAttribute(alert_action, list_link);
            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
            return;
        }

        try {
            int blogId = Integer.parseInt(idParam);
            Blogs blog = BlogsDAO.getBlogById(blogId);
            boolean isAdmin = !Arrays.asList(3, 4).contains(user.getRole().getId());

            if (blog == null) {
                request.setAttribute(alert_message, "Blog not found. It may have already been deleted.");
                request.setAttribute(alert_action, list_link);
                request.getRequestDispatcher("blog_list.jsp").forward(request, response);
                return;
            }

            if (!isAdmin && blog.getAuthorId() != user.getId()) {
                request.setAttribute(alert_message, "You don't have permission to delete this blog. You can only delete your own blog posts.");
                request.setAttribute(alert_action, list_link);
                request.getRequestDispatcher("blog_list.jsp").forward(request, response);
                return;
            }

            if (BlogsDAO.deleteBlog(blogId)) {
                request.setAttribute(alert_message, "Blog deleted successfully!");
                request.setAttribute(alert_action, list_link);
                request.setAttribute(error, false);
            } else {
                request.setAttribute(alert_message, "Failed to delete blog. Please try again.");
                request.setAttribute(alert_action, list_link);
                request.setAttribute(error, "Failed to delete blog. Please try again.");
            }
        } catch (NumberFormatException e) {
            request.setAttribute(alert_message, "Invalid blog ID format.");
            request.setAttribute(alert_action, list_link);
        }

        request.getRequestDispatcher("blog_list.jsp").forward(request, response);
    }

    private void deleteComment(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            request.setAttribute(alert_message, "Please sign in to delete comments.");
            request.setAttribute(alert_action, login_link);
            request.getRequestDispatcher("blog_detail.jsp").forward(request, response);
            return;
        }

        String commentIdParam = request.getParameter("comment_id");
        String blogIdParam = request.getParameter("id");

        if (Utils.CheckIfEmpty(commentIdParam) || Utils.CheckIfEmpty(blogIdParam)) {
            request.setAttribute(alert_message, "Comment ID and Blog ID are required to delete the comment.");
            request.setAttribute(alert_action, list_link);
            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
            return;
        }

        try {
            int commentId = Integer.parseInt(commentIdParam);
            int blogId = Integer.parseInt(blogIdParam);

            BlogsComment comment = BlogsCommentDAO.getCommentById(commentId);
            boolean isAdmin = !Arrays.asList(3, 4).contains(user.getRole().getId());

            if (comment == null) {
                request.setAttribute(alert_message, "Comment not found. It may have already been deleted.");
                request.setAttribute(alert_action, "blogs?action=view&id=" + blogId);
                request.getRequestDispatcher("blog_detail.jsp").forward(request, response);
                return;
            }

            if (!isAdmin && comment.getUserId() != user.getId()) {
                request.setAttribute(alert_message, "You don't have permission to delete this comment. You can only delete your own comments.");
                request.setAttribute(alert_action, "blogs?action=view&id=" + blogId);
                request.getRequestDispatcher("blog_detail.jsp").forward(request, response);
                return;
            }

            if (BlogsCommentDAO.deleteComment(commentId)) {
                request.setAttribute(alert_message, "Comment deleted successfully!");
            } else {
                request.setAttribute(alert_message, "Failed to delete comment. Please try again.");
            }
            request.setAttribute(alert_action, "blogs?action=view&id=" + blogId);

            // Reload the blog view
            viewBlog(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute(alert_message, "Invalid comment or blog ID format.");
            request.setAttribute(alert_action, list_link);
            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
        }
    }

    private void createAction(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String courseIdStr = request.getParameter("course_id");
        String tags = request.getParameter("tags");

        User user = (User) request.getSession().getAttribute("user");

        if (user == null) {
            request.setAttribute(alert_message, "Please sign in to create blog posts.");
            request.setAttribute(alert_action, login_link);
            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
            return;
        }

        if (Utils.CheckIfEmpty(title) || Utils.CheckIfEmpty(content)) {
            request.setAttribute(error, "Title and content are required to create a blog.");
            request.getRequestDispatcher("blog_form.jsp").forward(request, response);
            return;
        }

        // Validate course ID
        if (!Utils.CheckIfEmpty(courseIdStr)) {
            request.setAttribute(alert_message, "Invalid course ID format.");
            request.setAttribute(alert_action, "blogs?action=create_form");
            request.getRequestDispatcher("blog_form.jsp").forward(request, response);
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdStr);

            if (BlogsDAO.createBlog(title, content, user.getId(), courseId, tags)) {
                request.setAttribute(alert_message, "Blog created successfully! Your blog post is pending approval and will be visible once activated by an admin or manager.");
                request.setAttribute(alert_action, list_link);
            } else {
                request.setAttribute(alert_message, "Failed to create blog. Please try again.");
                request.setAttribute(alert_action, "blogs?action=create_form");
            }
        } catch (NumberFormatException e) {
            request.setAttribute(alert_message, "Invalid course ID format.");
            request.setAttribute(alert_action, "blogs?action=create_form");
        }

        request.getRequestDispatcher("blog_list.jsp").forward(request, response);
    }

    private void updateAction(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String idParam = request.getParameter("id");
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String courseIdStr = request.getParameter("course_id");
        String tags = request.getParameter("tags");

        if (Utils.CheckIfEmpty(idParam) || Utils.CheckIfEmpty(title) || Utils.CheckIfEmpty(content)) {
            request.setAttribute(alert_message, "Blog ID, title and content are required to update the blog.");
            request.setAttribute(alert_action, list_link);
            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
            return;
        }

        try {
            int blogId = Integer.parseInt(idParam);
            int courseId = Utils.CheckIfEmpty(courseIdStr) ? 0 : Integer.parseInt(courseIdStr);

            Blogs blog = BlogsDAO.getBlogById(blogId);
            User user = (User) request.getSession().getAttribute("user");
            boolean isAdmin = user != null && !Arrays.asList(3, 4).contains(user.getRole().getId());

            if (blog == null) {
                request.setAttribute(alert_message, "Blog not found. It may have been deleted.");
                request.setAttribute(alert_action, list_link);
                request.getRequestDispatcher("blog_list.jsp").forward(request, response);
                return;
            }

            if (!isAdmin && blog.getAuthorId() != user.getId()) {
                request.setAttribute(alert_message, "You don't have permission to update this blog.");
                request.setAttribute(alert_action, list_link);
                request.getRequestDispatcher("blog_list.jsp").forward(request, response);
                return;
            }

            if (BlogsDAO.updateBlog(blogId, title, content, blog.getAuthorId(), courseId, tags)) {
                request.setAttribute(alert_message, "Blog updated successfully! Your changes have been saved.");
                request.setAttribute(alert_action, "blogs?action=view&id=" + blogId);
            } else {
                request.setAttribute(alert_message, "Failed to update blog. Please try again.");
                request.setAttribute(alert_action, "blogs?action=edit&id=" + blogId);
            }
        } catch (NumberFormatException e) {
            request.setAttribute(alert_message, "Invalid blog ID or course ID format.");
            request.setAttribute(alert_action, list_link);
        }

        // Redirect to appropriate page based on success/failure
        String action = (String) request.getAttribute(alert_action);
        if (action.contains("view")) {
            viewBlog(request, response);
        } else {
            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
        }
    }

    private void addComment(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String blogIdParam = request.getParameter("id");
        String content = request.getParameter("content");

        if (Utils.CheckIfEmpty(blogIdParam) || Utils.CheckIfEmpty(content)) {
            request.setAttribute(alert_message, "Blog ID and comment content are required to add a comment.");
            request.setAttribute(alert_action, list_link);
            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
            return;
        }

        try {
            int blogId = Integer.parseInt(blogIdParam);
            User user = (User) request.getSession().getAttribute("user");

            if (user == null) {
                request.setAttribute(alert_message, "Please sign in to add comments.");
                request.setAttribute(alert_action, login_link);
                request.getRequestDispatcher("blog_list.jsp").forward(request, response);
                return;
            }

            BlogsComment comment = new BlogsComment();
            comment.setBlogId(blogId);
            comment.setUserId(user.getId());
            comment.setContent(content);
            
            if (!BlogsCommentDAO.addComment(comment)) {
                request.setAttribute(alert_message, "Failed to add comment. Please try again.");
            }

            // Reload the blog view
            viewBlog(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute(alert_message, "Invalid blog ID format.");
            request.setAttribute(alert_action, list_link);
            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
        }
    }

    private void editCommentAction(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String commentIdParam = request.getParameter("comment_id");
        String blogIdParam = request.getParameter("id");
        String content = request.getParameter("content");

        if (Utils.CheckIfEmpty(commentIdParam) || Utils.CheckIfEmpty(blogIdParam) || Utils.CheckIfEmpty(content)) {
            request.setAttribute(alert_message, "Comment ID, blog ID and content are required to update the comment.");
            request.setAttribute(alert_action, list_link);
            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
            return;
        }

        try {
            int commentId = Integer.parseInt(commentIdParam);
            int blogId = Integer.parseInt(blogIdParam);

            BlogsComment comment = BlogsCommentDAO.getCommentById(commentId);
            User user = (User) request.getSession().getAttribute("user");

            if (comment == null) {
                request.setAttribute(alert_message, "Comment not found. It may have been deleted.");
                request.setAttribute(alert_action, "blogs?action=view&id=" + blogId);
                viewBlog(request, response);
                return;
            }

            if (comment.getUserId() != user.getId()) {
                request.setAttribute(alert_message, "You don't have permission to edit this comment.");
                request.setAttribute(alert_action, "blogs?action=view&id=" + blogId);
                viewBlog(request, response);
                return;
            }

            if (BlogsCommentDAO.updateComment(commentId, content)) {
                request.setAttribute(alert_message, "Comment updated successfully! Your changes have been saved.");
            } else {
                request.setAttribute(alert_message, "Failed to update comment. Please try again.");
            }
            request.setAttribute(alert_action, "blogs?action=view&id=" + blogId);

            // Reload the blog view
            viewBlog(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute(alert_message, "Invalid comment or blog ID format.");
            request.setAttribute(alert_action, list_link);
            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
        }
    }

    // New method for blog management page (admin/manager only)
    private void manageBlog(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            request.setAttribute(alert_message, "Please sign in to access blog management.");
            request.setAttribute(alert_action, login_link);
            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
            return;
        }

        // Check if user is admin or manager (roles 1 and 2)
        boolean isAdminOrManager = Arrays.asList(1, 2).contains(user.getRole().getId());
        if (!isAdminOrManager) {
            request.setAttribute(alert_message, "Access denied. Only administrators and managers can access blog management.");
            request.setAttribute(alert_action, list_link);
            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
            return;
        }

        // Get all blogs (both active and inactive) for management
        List<Blogs> allBlogs = BlogsDAO.getAllBlogs();
        List<Blogs> inactiveBlogs = allBlogs.stream().filter(blog -> !blog.isActive()).toList();

        request.setAttribute("all_blogs", allBlogs);
        request.setAttribute("inactive_blogs", inactiveBlogs);
        request.getRequestDispatcher("blog_manage.jsp").forward(request, response);
    }

    // New method to activate/deactivate blogs
    private void activateBlog(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            request.setAttribute(alert_message, "Please sign in to manage blog status.");
            request.setAttribute(alert_action, login_link);
            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
            return;
        }

        // Check if user is admin or manager (roles 1 and 2)
        boolean isAdminOrManager = Arrays.asList(1, 2).contains(user.getRole().getId());
        if (!isAdminOrManager) {
            request.setAttribute(alert_message, "Access denied. Only administrators and managers can manage blog status.");
            request.setAttribute(alert_action, list_link);
            request.getRequestDispatcher("blog_list.jsp").forward(request, response);
            return;
        }

        String idParam = request.getParameter("id");
        String statusParam = request.getParameter("status");

        if (Utils.CheckIfEmpty(idParam) || Utils.CheckIfEmpty(statusParam)) {
            request.setAttribute(alert_message, "Blog ID and status are required to update blog status.");
            request.setAttribute(alert_action, "blogs?action=manage");
            request.getRequestDispatcher("blog_manage.jsp").forward(request, response);
            return;
        }

        try {
            int blogId = Integer.parseInt(idParam);
            boolean active = "activate".equals(statusParam);

            Blogs blog = BlogsDAO.getBlogById(blogId);
            if (blog == null) {
                request.setAttribute(alert_message, "Blog not found. It may have been deleted.");
                request.setAttribute(alert_action, "blogs?action=manage");
                manageBlog(request, response);
                return;
            }

            if (BlogsDAO.updateBlogActiveStatus(blogId, active)) {
                String action = active ? "activated" : "deactivated";
                request.setAttribute(alert_message, "Blog has been " + action + " successfully!");
            } else {
                request.setAttribute(alert_message, "Failed to update blog status. Please try again.");
            }
            request.setAttribute(alert_action, "blogs?action=manage");

            // Reload the management page
            manageBlog(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute(alert_message, "Invalid blog ID format.");
            request.setAttribute(alert_action, "blogs?action=manage");
            manageBlog(request, response);
        }
    }
}

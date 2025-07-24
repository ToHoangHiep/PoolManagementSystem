package controller;

import dal.CoachDAO;
import dal.CourseDAO;
import dal.FeedbackDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.*;
import utils.Utils;

import java.io.IOException;
import java.sql.SQLException;
import java.util.*;
import java.util.stream.Collectors;

public class FeedbackServlet extends HttpServlet {
    private static final String alert_message = "alert_message";
    private static final String alert_action = "alert_action";
    private static final String error = "error";

    private static final String list_link = "feedback?mode=list";
    private static final String error_link = "error.jsp";
    private static final String login_link = "login";


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action) {
            case "create"          -> submitAction(request, response);
            case "delete"          -> deleteAction(request, response);
            case "delete_multiple" -> deleteMultipleAction(request, response);
            case "sort"            -> sortAction(request, response);
            default                -> response.sendRedirect(error_link);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        // Handle action parameter if present
        if (action != null) {
            switch (action) {
                case "create" -> {
                    // Just display the empty form for creation
                    showFeedbackForm(request, response);
                    return;
                }
                case "details" -> {
                    User user = (User) request.getSession().getAttribute("user");

                    // User must be logged in to view details
                    if (user == null) {
                        response.sendRedirect(login_link);
                        return;
                    }

                    // Authorization: Only admins can view feedback details.
                    // Assuming roles 3 (Coach) and 4 (Customer) are non-admins
                    List<Integer> nonAdminRoles = Arrays.asList(3, 4);
                    boolean isAdmin = !nonAdminRoles.contains(user.getRole().getId());

                    if (!isAdmin) {
                        request.getSession().setAttribute(alert_message, "You do not have permission to view this page.");
                        response.sendRedirect("home.jsp"); // Redirect non-admins to home
                        return;
                    }

                    int feedbackId;
                    try {
                        feedbackId = Integer.parseInt(request.getParameter("id"));
                    } catch (NumberFormatException e) {
                        // Handle cases where ID is not a valid number
                        request.getSession().setAttribute(alert_message, "Invalid feedback ID.");
                        response.sendRedirect("feedback?action=list");
                        return;
                    }

                    Feedback feedback = FeedbackDAO.getSpecificFeedback(feedbackId);

                    if (feedback == null) {
                        request.getSession().setAttribute(alert_message, "Feedback not found.");
                        response.sendRedirect("feedback?action=list");
                        return;
                    }

                    // --- NEW LOGIC ---
                    // Based on the feedback type, fetch the related entity (Course or Coach)
                    try {
                        if ("Course".equals(feedback.getFeedbackType()) && feedback.getCourseId() > 0) {
                            Course course = CourseDAO.getCourseById(feedback.getCourseId());
                            request.setAttribute("relatedCourse", course); // Pass the course object to the JSP
                        } else if ("Coach".equals(feedback.getFeedbackType()) && feedback.getCoachId() > 0) {
                            Coach coach = CoachDAO.getById(feedback.getCoachId());
                            request.setAttribute("relatedCoach", coach); // Pass the coach object to the JSP
                        }
                    } catch (SQLException e) {
                        throw new ServletException("Database error fetching related feedback data", e);
                    }
                    // --- END NEW LOGIC ---

                    // Set feedback attribute and forward to the details page.
                    request.setAttribute("feedback", feedback);
                    request.getRequestDispatcher("feedback_details.jsp").forward(request, response);
                    return; // Important to stop further execution
                }
                case "list" -> {
                    listMode(request, response);
                    return;
                }
                default -> {
                    response.sendRedirect(error_link);
                    return;
                }
            }
        }

        // Existing code for handling id parameter
        String urlId = request.getParameter("id");
        if (!Utils.CheckIfEmpty(urlId)) {
            User user = (User) request.getSession().getAttribute("user");

            // User must be logged in to view details
            if (user == null) {
                response.sendRedirect(login_link);
                return;
            }

            // Authorization: Only admins can view feedback details.
            // Assuming roles 3 (Coach) and 4 (Customer) are non-admins
            List<Integer> nonAdminRoles = Arrays.asList(3, 4);
            boolean isAdmin = !nonAdminRoles.contains(user.getRole().getId());

            if (!isAdmin) {
                request.getSession().setAttribute(alert_message, "You do not have permission to view this page.");
                response.sendRedirect("home.jsp"); // Redirect non-admins to home
                return;
            }

            int id = Integer.parseInt(urlId);
            Feedback f = FeedbackDAO.getSpecificFeedback(id);
            request.setAttribute("feedback", f);
            return;
        }

        response.sendRedirect("feedback?action=create"); // for feedback form use: /feedback?action=create
    }

    // In your FeedbackServlet.java

    // This method should be called when action is "create" or "edit"
    private void showFeedbackForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Your existing security check for logged-in user...
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // If editing, load the existing feedback object
            String action = request.getParameter("action");
            if ("edit".equals(action)) {
                // Your logic to load the feedback object and set it as a request attribute
                // request.setAttribute("feedback", loadedFeedback);
            }

            // --- NEW LOGIC ---
            // Fetch lists for the dropdowns from your DAOs
            List<Course> courses = CourseDAO.getAllCourses();
            List<Coach> coaches = CoachDAO.getAll();

            // Set the lists as request attributes so the JSP can access them
            request.setAttribute("courses", courses);
            request.setAttribute("coaches", coaches);

        } catch (SQLException e) {
            // Handle database errors
            throw new ServletException("Database error fetching data for feedback form", e);
        }

        // Forward to the JSP
        request.getRequestDispatcher("feedback.jsp").forward(request, response);
    }

    //region Actions
    private void submitAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userId = ((User) request.getSession().getAttribute("user")).getId();

        if (userId <= 0) {
            request.setAttribute(alert_message, "Bạn cần đăng nhập để gửi phản hồi.");
            request.setAttribute(alert_action, login_link);
            request.getRequestDispatcher("feedback.jsp").forward(request, response);
            return;
        }

        String feedBackType        = request.getParameter("feedback_type");
        Integer coachId            = null;
        Integer courseId           = null;
        String generalFeedbackType = "";

        switch(feedBackType.toLowerCase()) {
            case "general" -> generalFeedbackType = request.getParameter("general_feedback_type");
            case "coach"   -> coachId = Integer.valueOf(request.getParameter("coach_id"));
            case "course"  -> courseId = Integer.valueOf(request.getParameter("course_id"));
        }

        if (coachId == null && courseId == null && Utils.CheckIfEmpty(generalFeedbackType)) {
            request.setAttribute(error, "Vui lòng chọn loại phản hồi hợp lệ.");
            request.getRequestDispatcher("feedback.jsp").forward(request, response);
            return;
        }

        String content = request.getParameter("content");
        int rating     = Integer.parseInt(request.getParameter("rating"));

        if (Utils.CheckIfEmpty(content) || rating < 0 || rating > 10) {
            request.setAttribute(error, "Vui lòng điền đầy đủ thông tin và đánh giá hợp lệ (0-10).");
            request.getRequestDispatcher("feedback.jsp").forward(request, response);
            return;
        }

        boolean success = FeedbackDAO.createFeedback(userId, feedBackType, coachId, courseId, generalFeedbackType, content, rating);

        if (success) {
            request.setAttribute(alert_message, "Phản hồi đã được gửi thành công.");
        } else {
            request.setAttribute(alert_message, "Không thể gửi phản hồi. Vui lòng thử lại sau.");
        }

        request.setAttribute(alert_action, list_link);
        request.getRequestDispatcher("feedback.jsp").forward(request, response);
    }

    private void deleteAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int feedbackId = Integer.parseInt(request.getParameter("id"));

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            request.setAttribute(alert_message, "Bạn cần đăng nhập để xóa phản hồi.");
            request.setAttribute(alert_action, login_link);
            request.getRequestDispatcher("feedback.jsp").forward(request, response);
            return;
        }

        boolean success = FeedbackDAO.deleteFeedback(feedbackId);
        if (success) {
            request.setAttribute(alert_message, "Xóa phản hồi thành công.");
        } else {
            request.setAttribute(alert_message, "Không thể xóa phản hồi (ID: " + feedbackId + ").");
        }
        request.setAttribute(alert_action, list_link);
        request.getRequestDispatcher("feedback.jsp").forward(request, response);
    }

    private void deleteMultipleAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String[] feedbackIds = request.getParameterValues("id");

        if (feedbackIds == null || feedbackIds.length == 0) {
            request.setAttribute(alert_message, "Không có phản hồi nào được chọn để xóa.");
            request.getRequestDispatcher("feedback.jsp").forward(request, response);
            return;
        }

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            request.setAttribute(alert_message, "Bạn cần đăng nhập để xóa phản hồi.");
            request.setAttribute(alert_action, login_link);
            request.getRequestDispatcher("feedback.jsp").forward(request, response);
            return;
        }

        List<String> failedIds = new ArrayList<>();
        for (String feedbackId : feedbackIds) {
            boolean success = FeedbackDAO.deleteFeedback(Integer.parseInt(feedbackId));
            if (!success) {
                failedIds.add(feedbackId);
            }
        }

        if (failedIds.isEmpty()) {
            request.setAttribute(alert_message, "Xóa tất cả phản hồi đã chọn thành công.");
        } else {
            request.setAttribute(alert_message, "Không thể xóa các phản hồi với ID: " + String.join(", ", failedIds));
        }
        request.setAttribute(alert_action, list_link);
        request.getRequestDispatcher("feedback.jsp").forward(request, response);
    }

    private void sortAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        if (user == null) {
            request.setAttribute(alert_message, "Bạn cần đăng nhập để xem phản hồi.");
            request.setAttribute(alert_action, login_link);
            request.getRequestDispatcher("feedback.jsp").forward(request, response);
            return;
        }

        // Check if the current sorting is the same as the one in session
        FeedbackSorting f_sort = (FeedbackSorting) request.getSession().getAttribute("feedback_sorting");

        if (f_sort == null) {
            f_sort = new FeedbackSorting("all", null, null, null, null, false);
        }

        // Begin sorting data retrieval
        String feedBackType = !Objects.equals(request.getParameter("feedback_type"), "all") ? request.getParameter("feedback_type") : null;

        // Redirect to error page if feedback type is coach or course
        if (feedBackType != null && (feedBackType.equalsIgnoreCase("coach") || feedBackType.equalsIgnoreCase("course"))) {
            response.sendRedirect(error_link);
            return;
        }

        Integer coachId            = !Objects.equals(request.getParameter("coach_id"), "all") ? Integer.valueOf(request.getParameter("coach_id")) : null;
        Integer courseId           = !Objects.equals(request.getParameter("course_id"), "all") ? Integer.valueOf(request.getParameter("course_id")) : null;
        String generalFeedbackType = !Objects.equals(request.getParameter("general_feedback_type"), "all") ? request.getParameter("general_feedback_type") : null;
        String sortBy              = !Objects.equals(request.getParameter("sort_by"), "none") ? request.getParameter("sort_by") : null;
        boolean sortOrder          = !Objects.equals(request.getParameter("sort_order"), "ASC");

        // Check if the sorting parameters are the same as the current session
        if (isSameSorting(f_sort, feedBackType, coachId, courseId, generalFeedbackType, sortBy, sortOrder)) {
            return;
        } else {
            f_sort = new FeedbackSorting(feedBackType, coachId, courseId, generalFeedbackType, sortBy, sortOrder);
            request.getSession().setAttribute("feedback_sorting", f_sort);
        }

        // Check if the user wants to see all feedbacks or just their own
        boolean showAll = request.getParameter("show_all") != null && request.getParameter("show_all").equals("true");

        List<Feedback> f_list_all = FeedbackDAO.sortFeedbacks(coachId, courseId, feedBackType, generalFeedbackType, sortBy, showAll);
        List<Feedback> f_list_result = new ArrayList<>();

        if (showAll) {
            if (!Arrays.asList(3, 4).contains(user.getRole().getId())) {
                response.sendRedirect(error_link);
            } else {
                f_list_result = f_list_all;
            }
        } else {
            f_list_result = f_list_all.stream().filter(f -> f.getUserId() == user.getId()).toList();
        }

        request.setAttribute("feedback_list", f_list_result);
        request.getRequestDispatcher("feedback_history.jsp").forward(request, response);
    }
    //endregion

    //region DoGet Method
// In FeedbackServlet.java

    private void listMode(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect(login_link);
            return;
        }

        // Authorization check: Only non-customers can view the feedback list.
        // Adjust role IDs as needed.
        if (user.getRole().getId() == 4) { // Assuming 4 is Customer role
            request.getSession().setAttribute(alert_message, "You do not have permission to view this page.");
            response.sendRedirect("home.jsp");
            return;
        }

        try {
            // 1. Fetch all feedback entries
            List<Feedback> allFeedback = FeedbackDAO.getAllFeedbacks();

            // 2. Fetch all courses and coaches to easily look up their names
            List<Course> allCourses = CourseDAO.getAllCourses();
            List<Coach> allCoaches = CoachDAO.getAll();

            // 3. Convert lists to Maps for efficient O(1) lookups in the JSP
            // This prevents multiple database calls inside a loop
            Map<Integer, Course> courseMap = allCourses.stream()
                    .collect(Collectors.toMap(Course::getId, course -> course));

            Map<Integer, Coach> coachMap = allCoaches.stream()
                    .collect(Collectors.toMap(Coach::getId, coach -> coach));

            // 4. Set all the necessary data as request attributes
            request.setAttribute("feedbackList", allFeedback);
            request.setAttribute("courseMap", courseMap);
            request.setAttribute("coachMap", coachMap);

            // 5. Forward to the new history/list page
            request.getRequestDispatcher("feedback_history.jsp").forward(request, response);

        } catch (SQLException e) {
            log("Database error while fetching feedback list and related data.", e);
            throw new ServletException("Could not retrieve feedback data.", e);
        }
    }

    private boolean isSameSorting(FeedbackSorting f_sort, String feedBackType, Integer coachId, Integer courseId, String generalFeedbackType, String sortBy, boolean sortOrder) {
        return Objects.equals(f_sort.getFeedbackType(), feedBackType)
                && Objects.equals(f_sort.getCoachId(), coachId)
                && Objects.equals(f_sort.getCourseId(), courseId)
                && Objects.equals(f_sort.getGeneralFeedbackType(), generalFeedbackType)
                && Objects.equals(f_sort.getSortBy(), sortBy)
                && f_sort.isSortOrder() == sortOrder;
    }
    //endregion
}

package controller;

import dal.FeedbackDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Feedback;
import model.FeedbackSorting;
import model.User;
import utils.Utils;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;

public class FeedbackServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action) {
            case "create"          -> submitAction(request, response);
            case "edit"            -> editAction(request, response);
            case "confirm_edit"    -> confirmEditAction(request, response);
            case "delete"          -> deleteAction(request, response);
            case "delete_multiple" -> deleteMultipleAction(request, response);
            case "sort"            -> sortAction(request, response);
            default                -> response.sendRedirect("error.jsp");
        }
    }

    //region Actions
    private void submitAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userId = ((User) request.getSession().getAttribute("user")).getId();

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
            request.setAttribute("error", "Vui lòng chọn loại phản hồi hợp lệ.");
            request.getRequestDispatcher("feedback.jsp").forward(request, response);
            return;
        }

        String content = request.getParameter("content");
        int rating     = Integer.parseInt(request.getParameter("rating"));

        if (Utils.CheckIfEmpty(content) || rating < 0 || rating > 10) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin và đánh giá hợp lệ (0-10).");
            request.getRequestDispatcher("feedback.jsp").forward(request, response);
            return;
        }

        boolean success = FeedbackDAO.createFeedback(userId, feedBackType, coachId, courseId, generalFeedbackType, content, rating);
    }

    private void editAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int f_id   = Integer.parseInt(request.getParameter("id"));
        Feedback f = FeedbackDAO.getSpecificFeedback(f_id);

        if (f == null) {
            request.setAttribute("alert_message", "Không tìm thấy phản hồi để chỉnh sửa.");
            request.setAttribute("alert_action", "/feedback?mode=list");
            request.getRequestDispatcher("feedback.jsp").forward(request, response);
            return;
        }

        if (f.getUserId() != ((User) request.getSession().getAttribute("user")).getId()) {
            request.setAttribute("return_error", "Bạn không có quyền chỉnh sửa phản hồi này.");
            request.setAttribute("return_action", "/feedback?mode=list");
            request.getRequestDispatcher("feedback.jsp").forward(request, response);
            return;
        }

        request.getSession().setAttribute("feedback", f);
        response.sendRedirect("feedback?action=edit&id=" + f_id);
    }

    private void confirmEditAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int feedbackId = Integer.parseInt(request.getParameter("id"));
        User user      = (User) request.getSession().getAttribute("user");
        String content = request.getParameter("content");
        int rating     = Integer.parseInt(request.getParameter("rating"));

        Feedback f_old = FeedbackDAO.getSpecificFeedback(feedbackId);

        if (f_old == null) {
            request.setAttribute("alert_message", "Không tìm thấy phản hồi để chỉnh sửa.");
            request.setAttribute("alert_action", "/feedback?mode=list");
            request.getRequestDispatcher("feedback.jsp").forward(request, response);
            return;
        }

        if (f_old.getUserId() != user.getId()) {
            request.setAttribute("alert_message", "Bạn không có quyền chỉnh sửa phản hồi này.");
            request.setAttribute("alert_action", "/feedback?mode=list");
            request.getRequestDispatcher("feedback.jsp").forward(request, response);
            return;
        }

        if (f_old.getContent().equals(content) && f_old.getRating() == rating) {
            request.setAttribute("error", "Không có thay đổi nào được thực hiện.");
            request.getRequestDispatcher("feedback.jsp").forward(request, response);
            return;
        }

        if (Utils.CheckIfEmpty(content) || rating < 0 || rating > 10) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin và đánh giá hợp lệ (0-10).");
            request.getRequestDispatcher("feedback.jsp").forward(request, response);
            return;
        }

        boolean success = FeedbackDAO.updateFeedback(feedbackId, content, rating);
    }

    private void deleteAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int feedbackId = Integer.parseInt(request.getParameter("id"));

        boolean success = FeedbackDAO.deleteFeedback(feedbackId);
    }

    private void deleteMultipleAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String[] feedbackIds = request.getParameterValues("id");

        for (String feedbackId : feedbackIds) {
            boolean success = FeedbackDAO.deleteFeedback(Integer.parseInt(feedbackId));
        }
    }

    private void sortAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if the current sorting is the same as the one in session
        FeedbackSorting f_sort = (FeedbackSorting) request.getSession().getAttribute("feedback_sorting");

        if (f_sort == null) {
            f_sort = new FeedbackSorting("all", null, null, null, null, false);
        }

        // Begin sorting data retrieval
        String feedBackType = !Objects.equals(request.getParameter("feedback_type"), "all") ? request.getParameter("feedback_type") : null;

        // Redirect to error page if feedback type is coach or course
        if (feedBackType != null && (feedBackType.equalsIgnoreCase("coach") || feedBackType.equalsIgnoreCase("course"))) {
            response.sendRedirect("error.jsp");
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

        User user = (User) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Feedback> f_list = new ArrayList<>();

        if (showAll) {
            if (!Arrays.asList(3, 4).contains(user.getRole().getId())) {
                response.sendRedirect("error.jsp");
            } else {
                f_list = FeedbackDAO.sortFeedbacks_admin(coachId, courseId, feedBackType, generalFeedbackType, sortBy, sortOrder);

            }
        } else {
            f_list = FeedbackDAO.sortFeedback_user(user.getId(), coachId, courseId, feedBackType, generalFeedbackType, sortBy, sortOrder);
        }

        request.setAttribute("feedback_list", f_list);
        request.getRequestDispatcher("feedback_history.jsp").forward(request, response);
    }

    //endregion

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String mode = request.getParameter("mode");
        boolean listMode = mode != null && mode.equals("list");

        // Existing code for mode=list
        if (listMode) {
            User user = (User) request.getSession().getAttribute("user");
            boolean show_all = request.getParameter("show_all") != null && request.getParameter("show_all").equals("true");

            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            Integer[] show_all_banned_role = new Integer[]{3, 4};
            boolean is_admin = !Arrays.asList(show_all_banned_role).contains(user.getRole().getId());

            if (!is_admin && show_all) {
                request.setAttribute("alert_message", "Bạn không có quyền xem tất cả phản hồi.");
                request.setAttribute("alert_action", "/feedback?mode=list");
                request.getRequestDispatcher("feedback_history.jsp").forward(request, response);
                return;
            }

            List<Feedback> f_list;

            if (is_admin && show_all) {
                f_list = FeedbackDAO.getAllFeedbacks_admin();
            } else {
                f_list = FeedbackDAO.getAllFeedbacks_user(user.getId());
            }

            request.setAttribute("feedback_list", f_list);
            request.getRequestDispatcher("feedback_history.jsp").forward(request, response);

            return;
        }

        String action = request.getParameter("action");
        // Handle action parameter if present
        if (action != null) {
            switch (action) {
                case "create" -> {
                    // Just display the empty form for creation
                    request.getRequestDispatcher("feedback.jsp").forward(request, response);
                    return;
                }
                case "edit" -> {
                    Feedback f = (Feedback) request.getSession().getAttribute("feedback");

                    if (f == null) {
                        // Get the ID from the URL
                        String idParam = request.getParameter("id");

                        if (idParam == null || idParam.isEmpty()) {
                            response.sendRedirect("error.jsp");
                        }

                        int id = Integer.parseInt(idParam);

                        f = FeedbackDAO.getSpecificFeedback(id);

                        if (f == null) {
                            request.setAttribute("alert_message", "Không tìm thấy phản hồi để chỉnh sửa.");
                            request.setAttribute("alert_action", "/feedback?mode=list");
                            request.getRequestDispatcher("feedback.jsp").forward(request, response);
                            return;
                        }

                        if (f.getUserId() != ((User) request.getSession().getAttribute("user")).getId()) {
                            request.setAttribute("alert_message", "Bạn không có quyền chỉnh sửa phản hồi này.");
                            request.setAttribute("alert_action", "/feedback?mode=list");
                            request.getRequestDispatcher("feedback.jsp").forward(request, response);
                            return;
                        }

                        request.setAttribute("feedback", f);
                        request.getRequestDispatcher("feedback.jsp").forward(request, response);

                        return;
                    }

                    request.getSession().removeAttribute("feedback");
                    request.setAttribute("feedback", f);
                    request.getRequestDispatcher("feedback.jsp").forward(request, response);

                    return;
                }
                case "delete" -> {
                    // Handle delete action
                    String idParam = request.getParameter("id");

                    if (idParam == null || idParam.isEmpty()) {
                        response.sendRedirect("error.jsp");
                        return;
                    }

                    deleteAction(request, response);
                    response.sendRedirect("feedback?mode=list");

                    return;
                }
                default -> {
                    response.sendRedirect("error.jsp");
                    return;
                }
            }
        }

        // Existing code for handling id parameter
        String urlId = request.getParameter("id");
        if (!Utils.CheckIfEmpty(urlId)) {
            int id = Integer.parseInt(urlId);
            Feedback f = FeedbackDAO.getSpecificFeedback(id);
            request.setAttribute("feedback", f);
        }

        // If no specific action or id is provided, just forward to the feedback.jsp
        request.getRequestDispatcher("error.jsp").forward(request, response);
    }

    private boolean isSameSorting(FeedbackSorting f_sort, String feedBackType, Integer coachId, Integer courseId, String generalFeedbackType, String sortBy, boolean sortOrder) {
        return Objects.equals(f_sort.getFeedbackType(), feedBackType)
                && Objects.equals(f_sort.getCoachId(), coachId)
                && Objects.equals(f_sort.getCourseId(), courseId)
                && Objects.equals(f_sort.getGeneralFeedbackType(), generalFeedbackType)
                && Objects.equals(f_sort.getSortBy(), sortBy)
                && f_sort.isSortOrder() == sortOrder;
    }
}
   
package controller;

import dal.FeedbackDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Feedback;
import model.User;
import utils.Utils;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;

public class FeedbackServlet extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");

		switch (action) {
			case "create":
				submitAction(request, response);
				break;
			case "edit":
				editAction(request, response);
				break;
            case "delete":
				deleteAction(request, response);
				break;
			case "delete_multiple":
				deleteMultipleAction(request, response);
				break;
			case "sort":
				sortAction(request, response);
				break;
			default:
				response.sendRedirect("error.jsp");
		}
	}

	//region Actions
	private void submitAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int userId = ((User) request.getSession().getAttribute("user")).getId();

		String feedBackType = request.getParameter("feedback_type");
		Integer coachId = null;
		Integer courseId = null;
		String generalFeedbackType = "";

		if (feedBackType.equalsIgnoreCase("general")) {
			generalFeedbackType = request.getParameter("general_feedback_type");
		} 
		else {
			if (feedBackType.equalsIgnoreCase("coach")) {
				coachId = Integer.parseInt(request.getParameter("coach_id"));
			}
			else if (feedBackType.equalsIgnoreCase("course")) {
				courseId = Integer.parseInt(request.getParameter("course_id"));

				// TODO - Add Later when coaches are implemented
			} 
		}

		if (coachId == null && courseId == null && Utils.CheckIfEmpty(generalFeedbackType)) {
        	response.sendRedirect("error.jsp");
        	return;
    	}

		String content = request.getParameter("content");
		int rating = Integer.parseInt(request.getParameter("rating"));

		if (Utils.CheckIfEmpty(content) || rating < 0 || rating > 10) {
			request.setAttribute("error", "Vui lòng điền đầy đủ thông tin và đánh giá hợp lệ (0-10).");
			request.getRequestDispatcher("feedback.jsp").forward(request, response);
			return;
		}

		FeedbackDAO.createFeedback(userId, feedBackType, coachId, courseId, generalFeedbackType, content, rating);
	}

	private void editAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int feedbackId = Integer.parseInt(request.getParameter("feedback_id"));
		String content = request.getParameter("content");
		int rating = Integer.parseInt(request.getParameter("rating"));

		if (Utils.CheckIfEmpty(content) || rating < 0 || rating > 10) {
			request.setAttribute("error", "Vui lòng điền đầy đủ thông tin và đánh giá hợp lệ (0-10).");
			request.getRequestDispatcher("feedback.jsp").forward(request, response);
			return;
		}

		Feedback f_old = FeedbackDAO.getSpecificFeedback(feedbackId);

		if (f_old == null) {
			request.setAttribute("error", "Không tìm thấy phản hồi để chỉnh sửa.");
			request.getRequestDispatcher("feedback.jsp").forward(request, response);
			return;
		}


		if (f_old.getContent().equals(content) && f_old.getRating() == rating) {
			request.setAttribute("error", "Không có thay đổi nào được thực hiện.");
			request.getRequestDispatcher("feedback.jsp").forward(request, response);
			return;
		}

		if (f_old.getContent().equals(content)) {
			FeedbackDAO.updateFeedback(feedbackId, content);
		} 

		if (f_old.getRating() == rating) {
			FeedbackDAO.updateFeedback(feedbackId, rating);
		}

	}

	private void deleteAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int feedbackId = Integer.parseInt(request.getParameter("feedback_id"));

		FeedbackDAO.deleteFeedback(feedbackId);
	}

	private void deleteMultipleAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String[] feedbackIds = request.getParameterValues("feedback_id");

		for (String feedbackId : feedbackIds) {
			FeedbackDAO.deleteFeedback(Integer.parseInt(feedbackId));
		}
	}

	private void sortAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Integer coachId = !Objects.equals(request.getParameter("coach_id"), "all") ? Integer.parseInt(request.getParameter("coach_id")) : null;
		Integer courseId = !Objects.equals(request.getParameter("course_id"), "all") ? Integer.parseInt(request.getParameter("course_id")) : null;
		String generalFeedbackType = !Objects.equals(request.getParameter("general_feedback_type"), "all") ? request.getParameter("general_feedback_type") : null;
		String feedBackType = !Objects.equals(request.getParameter("feedback_type"), "all") ? request.getParameter("feedback_type") : null;
		String sortBy = !Objects.equals(request.getParameter("sort_by"), "none") ? request.getParameter("sort_by") : null;
		boolean sortOrder = !Objects.equals(request.getParameter("sort_order"), "ASC");

		boolean showAll = request.getParameter("admin_show") != null;

		User user = (User) request.getSession().getAttribute("user");

		if (user == null) {
			response.sendRedirect("login.jsp");
			return;
		}

		if (showAll) {
			if (!Arrays.asList(3, 4).contains(user.getRole().getId())) {
				response.sendRedirect("error.jsp");
			} else {
				List<Feedback> f_list = FeedbackDAO.getFeedbacks(coachId, courseId, generalFeedbackType, feedBackType, sortBy, sortOrder);
				request.setAttribute("feedback_list", f_list);
				request.getRequestDispatcher("feedback_list.jsp").forward(request, response);
			}
		} 
		else {
			List<Feedback> f_list = FeedbackDAO.getFeedbacks(user.getId(), coachId, courseId, generalFeedbackType, feedBackType, sortBy, sortOrder);
			request.setAttribute("feedback_list", f_list);
			request.getRequestDispatcher("feedback_list.jsp").forward(request, response);
		}
	}

	//endregion

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String mode = request.getParameter("mode");
		System.out.println("Mode: " + mode);

		if (mode != null && mode.equals("list")){
			User user = (User) request.getSession().getAttribute("user");
			boolean show_all = request.getParameter("admin_show") != null;

			if (user == null) {
				response.sendRedirect("login.jsp");
				return;
			}

			Integer[] show_all_banned_role = new Integer[] {3, 4};

			List<Feedback> f_list;

			if (!Arrays.asList(show_all_banned_role).contains(user.getRole().getId()) && show_all) {
				f_list = FeedbackDAO.getAllFeedback(user.getId());
			} else {
				f_list = FeedbackDAO.getAllFeedback();
			}

			request.setAttribute("feedback_list", f_list);
			request.getRequestDispatcher("feedback_list.jsp").forward(request, response);

			System.out.println("Reached List");
			return;
		}

		String urlId = request.getParameter("id");
		System.out.println("url requested id: " + urlId);

		if (!Utils.CheckIfEmpty(urlId)){
			int id = Integer.parseInt(urlId);
			Feedback f = FeedbackDAO.getSpecificFeedback(id);
			request.setAttribute("feedback", f);
		}

		request.getRequestDispatcher("feedback.jsp").forward(request, response);
	}


}

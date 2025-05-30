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
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class FeedbackServlet extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");

		switch (action) {
			case "submit":
				submitAction(request, response);
				break;
			case "edit":
				editAction(request, response);
				break;
            case "delete":
				deleteAction(request, response);
				break;
			case "sort":
				sortAction(request, response);
				break;
			default:
				response.sendRedirect("error.jsp");
		}
	}

	//region Actions
	private boolean submitAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int userId = (int) request.getSession().getAttribute("user_id");

		String feedBackType = request.getParameter("feedback_type");
		Integer coachId = null;
		Integer courseId = null;
		String generalFeedbackType = "";

		

		
		return false;
	}

	private boolean editAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


		return false;
	}

	private boolean deleteAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


		return false;
	}

	private boolean sortAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


		return false;
	}

	//endregion

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String mode = request.getParameter("mode");
		System.out.println("Mode: " + mode);

		if (mode.equals("list")){
			User user = (User) request.getSession().getAttribute("user");
			boolean show_all = request.getParameter("admin_show") != null;

			if (user == null) {
				response.sendRedirect("login.jsp");
				return;
			}

			Integer[] show_all_banned_role = new Integer[] {3, 4};

			List<Feedback> f_list;

			if (Arrays.asList(show_all_banned_role).contains(user.getRole().getId()) && show_all) {
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

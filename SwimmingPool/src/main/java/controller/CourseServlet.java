
package controller;

import dal.UserDAO;
import dal.CoachDAO;
import dal.CourseDAO;
import dal.CourseFormDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Coach;
import model.Course;
import model.CourseForm;
import model.User;
import utils.EmailUtils;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class CourseServlet extends HttpServlet {
    private static final String alert_message = "alert_message";
    private static final String alert_action = "alert_action";
    private static final String error = "error";

    private static final String error_link = "error.jsp";
    private static final String login_link = "login";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            listCourse(request, response);
            return;
        }

        switch (action) {
            case "create" -> createCourse(request, response);
            case "view" -> detailCourse(request, response);
            case "edit" -> editCourse(request, response);
            case "delete" -> deleteCourse(request, response);
            case "create_form" -> createCourseForm(request, response);
            case "list_form" -> courseFormManage(request, response);
            case "view_form" -> courseFormDetails(request, response);
            default -> listCourse(request, response);
        }
    }

    private void createCourse(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isUserAllowed(request, response, "course_create.jsp")) {
            response.sendRedirect("home.jsp");
            return;
        }

        request.getRequestDispatcher("course_create.jsp").forward(request, response);
    }

    private void listCourse(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<Course> courses = CourseDAO.getAllCourses();
            request.setAttribute("courses", courses);
            request.getRequestDispatcher("course_list.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void detailCourse(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        Course course = CourseDAO.getCourseById(courseId);

        request.setAttribute("course", course);
        request.getRequestDispatcher("course_details.jsp").forward(request, response);
    }

    private void editCourse(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isUserAllowed(request, response, "course_edit.jsp")) {
            response.sendRedirect("home.jsp");
            return;
        }

        int courseId = Integer.parseInt(request.getParameter("courseId"));
        Course course = CourseDAO.getCourseById(courseId);
        request.setAttribute("course", course);
        request.getRequestDispatcher("course_edit.jsp").forward(request, response);
    }

    private void deleteCourse(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isUserAllowed(request, response, "course_delete.jsp")) {
            response.sendRedirect("home.jsp");
            return;
        }

        int courseId = Integer.parseInt(request.getParameter("courseId"));
        Course course = CourseDAO.getCourseById(courseId);
        request.setAttribute("course", course);
        request.getRequestDispatcher("course_delete.jsp").forward(request, response);
    }

// In CourseServlet.java

    private void createCourseForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Handle pre-selected course ID (from course list page)
            String courseIdParam = request.getParameter("courseId");
            if (courseIdParam != null) {
                try {
                    request.setAttribute("preselectedCourseId", Integer.parseInt(courseIdParam));
                } catch (NumberFormatException e) {
                    // Log or ignore invalid ID
                    log("Invalid pre-selected courseId: " + courseIdParam);
                }
            }

            // NEW: Handle pre-selected coach ID (from coach details page)
            String coachIdParam = request.getParameter("coachId");
            if (coachIdParam != null) {
                try {
                    request.setAttribute("preselectedCoachId", Integer.parseInt(coachIdParam));
                } catch (NumberFormatException e) {
                    // Log or ignore invalid ID
                    log("Invalid pre-selected coachId: " + coachIdParam);
                }
            }

            // Fetch all data needed for the form dropdowns
            List<Course> courses = CourseDAO.getAllCourses();
            List<Coach> coaches = CoachDAO.getAll();
            request.setAttribute("courses", courses);
            request.setAttribute("coaches", coaches);

            // Forward to the registration form
            request.getRequestDispatcher("course_signup.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void courseFormDetails(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isUserAllowed(request, response, "course_form_details.jsp")) {
            response.sendRedirect("home.jsp");
            return;
        }

        try {
            int formId = Integer.parseInt(request.getParameter("formId"));
            CourseForm courseForm = CourseFormDAO.getById(formId);

            Course course = CourseDAO.getCourseById(courseForm.getCourse_id());
            Coach coach = CoachDAO.getById(courseForm.getCoach_id());

            if (courseForm.getUser_id() != -1){
                request.setAttribute("user", UserDAO.getUserById(courseForm.getUser_id()));
            }

            request.setAttribute("course", course);
            request.setAttribute("coach", coach);
            request.setAttribute("courseForm", courseForm);
            request.getRequestDispatcher("course_form_details.jsp").forward(request, response);
        } catch (SQLException e) {
            log("Could not finish SQL Query for finding course details");
        }
    }

    private void courseFormManage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect(login_link);
            return;
        }

        boolean isManagement = user.getRole().getId() != 3;

        List<CourseForm> courseForms = CourseFormDAO.getAll();

        if (!isManagement) {
            courseForms = courseForms.stream()
                    .filter(form -> form.getUser_id() == user.getId())
                    .toList();
        }

        request.setAttribute("courseForms", courseForms);
        request.getRequestDispatcher("course_form_manage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        switch (action) {
            case "create" -> createCoursePost(request, response);
            case "edit" -> editCoursePost(request, response);
            case "delete" -> deleteCoursePost(request, response);
            case "create_form" -> createCourseFormPost(request, response);
            case "form_confirmed" -> confirmForm(request, response);
            case "deactivate" -> deactivateCourse(request, response);
            default -> listCourse(request, response);
        }
    }

    private void deactivateCourse(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            CourseDAO courseDAO = new CourseDAO();
            boolean success = courseDAO.updateCourseStatus(courseId, "Inactive");

            if (success) {
                request.getSession().setAttribute("alert_message", "Khóa học đã được tạm ngưng thành công.");
            } else {
                request.getSession().setAttribute("alert_message", "Tạm ngưng khóa học thất bại.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("alert_message", "Mã khóa học không hợp lệ.");
        }
        response.sendRedirect("course?action=list");
    }

    private void createCoursePost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isUserAllowed(request, response, "course_create.jsp")) {
            response.sendRedirect("home.jsp");
            return;
        }

        Course c = new Course();
        c.setName(request.getParameter("name"));
        c.setDescription(request.getParameter("description"));
        c.setPrice(Double.parseDouble(request.getParameter("price")));
        c.setDuration(Integer.parseInt(request.getParameter("duration")));
        c.setEstimated_session_time(request.getParameter("estimated_session_time"));
        c.setSchedule_description(request.getParameter("schedule_description"));
        c.setStatus(request.getParameter("status"));

        if (!CourseDAO.createCourse(c)) {
            request.setAttribute("error", "Failed to create course.");
            request.getRequestDispatcher("course_create.jsp").forward(request, response);
        } else {
            response.sendRedirect("course");
        }
    }

    private void editCoursePost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isUserAllowed(request, response, "course_edit.jsp")) {
            response.sendRedirect("home.jsp");
            return;
        }

        int courseId = Integer.parseInt(request.getParameter("courseId"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        double price = Double.parseDouble(request.getParameter("price"));
        int duration = Integer.parseInt(request.getParameter("duration"));
        String estimatedSessionTime = request.getParameter("estimated_session_time");
        String scheduleDescription = request.getParameter("schedule_description");
        String status = request.getParameter("status");

        Course course = new Course();
        course.setId(courseId);
        course.setName(name);
        course.setDescription(description);
        course.setPrice(price); 
        course.setDuration(duration);
        course.setEstimated_session_time(estimatedSessionTime);
        course.setSchedule_description(scheduleDescription);    
        course.setStatus(status);

        if (!CourseDAO.updateCourse(course)) {
            request.setAttribute("error", "Failed to update course.");
            request.getRequestDispatcher("course_edit.jsp").forward(request, response);
        } else {
            response.sendRedirect("course");
        }
    }

    private void deleteCoursePost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isUserAllowed(request, response, "course_delete.jsp")) {
            response.sendRedirect("home.jsp");
            return;
        }

        int courseId = Integer.parseInt(request.getParameter("courseId"));
        if (!CourseDAO.deleteCourse(courseId)){
            request.setAttribute("error", "Failed to delete course.");
            request.getRequestDispatcher("course_delete.jsp").forward(request, response);
        }
    }

    private void confirmForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Authorization Check
        if (isUserAllowed(request, response, "course_form_details.jsp")) {
            response.sendRedirect("home.jsp");
            return;
        }

        int formId;
        try {
            formId = Integer.parseInt(request.getParameter("formId"));
        } catch (NumberFormatException e) {
            request.getSession().setAttribute(alert_message, "Invalid Form ID provided.");
            response.sendRedirect("course?action=list_form");
            return;
        }

        try {
            // 2. Fetch all required data from the database
            CourseForm form = CourseFormDAO.getById(formId);
            if (form == null) {
                request.getSession().setAttribute(alert_message, "Course form with ID " + formId + " not found.");
                response.sendRedirect("course?action=list_form");
                return;
            }

            // Prevent re-sending emails for an already confirmed form
            if (form.isHas_processed()) {
                request.getSession().setAttribute(alert_message, "This form has already been confirmed.");
                response.sendRedirect("course?action=list_form");
                return;
            }

            Course course = CourseDAO.getCourseById(form.getCourse_id());
            Coach coach = CoachDAO.getById(form.getCoach_id());

            if (course == null || coach == null) {
                request.getSession().setAttribute(alert_message, "Could not retrieve full details (missing course or coach). Cannot send emails.");
                response.sendRedirect("course?action=list_form");
                return;
            }

            // 3. Determine student's name and email
            String studentEmail;
            String studentName;
            if (form.getUser_id() > 0) {
                // Case 1: A registered user signed up
                User student = UserDAO.getUserById(form.getUser_id());
                if (student != null) {
                    studentEmail = student.getEmail();
                    studentName = student.getFullName(); // Assumes User model has getFullName()
                } else {
                    // This is an edge case, but good to handle
                    request.getSession().setAttribute(alert_message, "Registered user with ID " + form.getUser_id() + " not found. Cannot send email.");
                    response.sendRedirect("course?action=list_form");
                    return;
                }
            } else {
                // Case 2: A guest signed up
                studentEmail = form.getUser_email();
                studentName = form.getUser_fullName();
            }

            // 4. Update the form status in the database
            if (!CourseFormDAO.setFormStatus(formId)){
                request.getSession().setAttribute(alert_message, "Failed to update form status.");
                return;
            }

            // 5. Compose and send emails
            // --- Email to Student ---
            String studentSubject = "Course Registration Confirmed: " + course.getName();
            String studentBody = "Dear " + studentName + ",\n\n"
                    + "We are pleased to confirm your registration for the course: '" + course.getName() + "'.\n"
                    + "Your assigned coach is " + coach.getFullName() + ".\n\n"
                    + "We look forward to seeing you at the pool!\n\n"
                    + "Best regards,\n"
                    + "The Swimming Pool Management Team";
            EmailUtils.sendEmail(studentEmail, studentSubject, studentBody);

            // --- Email to Coach ---
            String coachEmail = coach.getEmail();
            String coachSubject = "New Student Confirmed for Your Course: " + course.getName();
            String coachBody = "Dear Coach " + coach.getFullName() + ",\n\n"
                    + "A new student, " + studentName + " (Email: " + studentEmail + "), has been confirmed for your course: '" + course.getName() + "'.\n\n"
                    + "Please prepare for their upcoming sessions.\n\n"
                    + "Thank you,\n"
                    + "System Administrator";
            EmailUtils.sendEmail(coachEmail, coachSubject, coachBody);

            request.getSession().setAttribute(alert_message, "Form confirmed successfully. Emails have been sent to the student and coach.");

        } catch (SQLException e) {
            log("Database error during form confirmation: " + e.getMessage());
            request.getSession().setAttribute(alert_message, "A database error occurred. Please try again.");
        } catch (Exception e) {
            // This will catch potential email sending errors
            log("Error sending confirmation email: " + e.getMessage());
            request.getSession().setAttribute(alert_message, "An error occurred while sending emails. The form status may not have been updated.");
        }

        // 6. Redirect back to the management page to prevent re-submission on refresh
        response.sendRedirect("course?action=list_form");
    }

    private void createCourseFormPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        int coachId = Integer.parseInt(request.getParameter("coachId"));

        CourseForm courseForm = new CourseForm();
        courseForm.setCourse_id(courseId);
        courseForm.setCoach_id(coachId);

        if (user != null) {
            courseForm.setUser_id(user.getId());
        } else {
            courseForm.setUser_fullName(request.getParameter("name"));
            courseForm.setUser_email(request.getParameter("email"));
            courseForm.setUser_phone(request.getParameter("phone"));
        }

        var result = CourseFormDAO.create(courseForm);
        if (!result) {
            request.setAttribute("error", "Failed to create course form.");
            request.getRequestDispatcher("course_signup.jsp").forward(request, response);
        }
        response.sendRedirect("home.jsp"); // Redirect to a success page
    }

    private boolean isUserAllowed(HttpServletRequest request, HttpServletResponse response, String current_page) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect(login_link);
            return false;
        }

        boolean isAllowed = user.getRole().getId() != 3;

        if (!isAllowed) {
            request.setAttribute(alert_message, "You are not allowed to access this page!");
            request.setAttribute(alert_action, "course");
            request.getRequestDispatcher(current_page).forward(request, response);

            return false;
        }

        return true;
    }
}

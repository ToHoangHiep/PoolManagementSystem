<%--
  Created by IntelliJ IDEA.
  User: LAPTOP
  Date: 30-May-25
  Time: 10:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="model.User" %>
<%@ page import="model.Feedback" %>
<%
  User user = (User) session.getAttribute("user");
  if (user == null) {
    response.sendRedirect("login.jsp");
    return;
  }
%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swimming Pool Feedback Form</title>
    <!-- Bootstrap 5.3.7 CSS -->
    <link href="Resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', Arial, sans-serif !important;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
        
        .bg-gradient-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
            border-radius: 20px 20px 0 0 !important;
        }
        
        .card {
            border-radius: 20px;
            border: none;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            overflow: hidden; /* Ensures rounded corners work properly */
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        }
        
        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 10px;
        }
        
        .form-select, .form-control {
            border: 2px solid #e9ecef;
            border-radius: 15px;
            transition: all 0.3s ease;
            font-size: 16px;
            padding: 15px 20px;
        }
        
        .form-select:focus, .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            transform: translateY(-2px);
        }
        
        /* Enhanced Star Rating System - Completely Redesigned */
        .star-rating-container {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-radius: 25px;
            padding: 30px;
            text-align: center;
            transition: all 0.3s ease;
            border: 2px solid #e9ecef;
        }
        
        .star-rating-container:hover {
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.15);
            border-color: #667eea;
        }
        
        .stars-wrapper {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 5px;
            margin: 20px 0;
        }
        
        .star-item {
            position: relative;
            cursor: pointer;
            font-size: 2.5rem;
            color: #dee2e6;
            transition: all 0.3s ease;
            user-select: none;
        }
        
        .star-item:hover {
            transform: scale(1.1);
        }
        
        .star-item.filled {
            color: #ffc107;
        }
        
        .star-item.half-filled {
            background: linear-gradient(90deg, #ffc107 50%, #dee2e6 50%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border: none;
            border-radius: 15px;
            padding: 15px 40px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
        }
        
        .btn-outline-secondary {
            border: 2px solid #6c757d;
            border-radius: 15px;
            padding: 15px 40px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-outline-secondary:hover {
            transform: translateY(-2px);
        }
        
        .alert {
            border-radius: 15px;
            border: none;
            font-weight: 500;
        }
        
        .toast {
            border-radius: 15px;
            border: none;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
        }
        
        /* Character counter styling */
        .char-counter {
            font-weight: 600;
            transition: color 0.3s ease;
        }
        
        .char-counter.warning {
            color: #fd7e14 !important;
        }
        
        .char-counter.danger {
            color: #dc3545 !important;
        }
        
        /* Animation classes */
        .fade-in-up {
            animation: fadeInUp 0.5s ease-out;
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        /* Responsive design */
        @media (max-width: 768px) {
            .star-item {
                font-size: 2rem;
            }
            
            .stars-wrapper {
                gap: 3px;
            }
            
            .card-body {
                padding: 25px !important;
            }
            
            .star-rating-container {
                padding: 20px;
            }
        }
        
        @media (max-width: 576px) {
            .star-item {
                font-size: 1.8rem;
            }
        }
    </style>
</head>

<body class="bg-light">
<%
  Feedback feedback = (Feedback) request.getAttribute("feedback");
  boolean existing = feedback != null;
%>

<%
    if (request.getAttribute("alert_message") != null) {
        String alertMessage = (String) request.getAttribute("alert_message");
        String alertAction = (String) request.getAttribute("alert_action");
        boolean existPostAction = request.getAttribute("alert_action") != null;
%>
<!-- Bootstrap Toast Notification -->
<div class="position-fixed top-0 end-0 p-3" style="z-index: 11000;">
    <div class="toast show" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="toast-header">
            <i class="fas fa-info-circle text-primary me-2"></i>
            <strong class="me-auto">Notification</strong>
            <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
        <div class="toast-body">
            <%= alertMessage %>
        </div>
    </div>
</div>
<script>
    <% if (existPostAction) { %>
    setTimeout(() => {
        window.location.href = "${pageContext.request.contextPath}<%= alertAction %>";
    }, 2000);
    <% } %>
</script>
<%
    }
%>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8 col-xl-7">
            <!-- Header Card -->
            <div class="card border-0 shadow-lg mb-4 fade-in-up">
                <div class="card-body text-center py-5 bg-gradient-primary text-white">
                    <div class="mb-4">
                        <i class="fas fa-comments fa-4x mb-3 opacity-75"></i>
                    </div>
                    <h1 class="h2 mb-3 fw-bold">
                        <%= existing ? "Edit Your Feedback" : "Share Your Experience" %>
                    </h1>
                    <p class="mb-0 opacity-85 lead">
                        <%= existing ? "Update your feedback below" : "Your opinion helps us improve our services" %>
                    </p>
                </div>
            </div>

            <!-- Main Form Card -->
            <div class="card border-0 shadow-lg fade-in-up">
                <div class="card-body p-5">
                    <form action="feedback?action=<%= existing ? "edit" : "create" %>" method="post" id="feedbackForm">
                        <%
                          if (existing) {
                        %>
                          <input type="hidden" name="postId" value="<%= feedback.getId() %>"/>
                        <%
                          }
                        %>

                        <!-- Feedback Type -->
                        <div class="mb-4">
                            <label for="feedback_type" class="form-label fw-semibold">
                                <i class="fas fa-tag me-2 text-primary"></i>Feedback Category
                            </label>
                            <select name="feedback_type" id="feedback_type" class="form-select form-select-lg" required onchange="showHideFields()">
                                <option value="" disabled <%= !existing ? "selected" : "" %>>Select feedback category</option>
                                <option value="Coach" disabled title="Coach feedback is currently unavailable" class="text-muted">
                                    Coach Feedback (Coming Soon)
                                </option>
                                <option value="Course" disabled title="Course feedback is currently unavailable" class="text-muted">
                                    Course Feedback (Coming Soon)
                                </option>
                                <option value="General" <%= existing && "General".equals(feedback.getFeedbackType()) ? "selected" : "" %>>
                                    General Feedback
                                </option>
                            </select>
                            <div class="form-text">
                                <i class="fas fa-info-circle me-1"></i>Choose the type of feedback you'd like to provide
                            </div>
                        </div>

                        <!-- General Feedback Type -->
                        <div class="mb-4 d-none" id="general_feedback_type_group">
                            <label for="general_feedback_type" class="form-label fw-semibold">
                                <i class="fas fa-list me-2 text-success"></i>Specific Category
                            </label>
                            <select name="general_feedback_type" id="general_feedback_type" class="form-select">
                                <option value="" disabled <%= !existing || feedback.getGeneralFeedbackType() == null ? "selected" : "" %>>Select specific category</option>
                                <option value="Food" <%= existing && "Food".equals(feedback.getGeneralFeedbackType()) ? "selected" : "" %>>
                                    🍽️ Food & Dining
                                </option>
                                <option value="Service" <%= existing && "Service".equals(feedback.getGeneralFeedbackType()) ? "selected" : "" %>>
                                    🤝 Customer Service
                                </option>
                                <option value="Facility" <%= existing && "Facility".equals(feedback.getGeneralFeedbackType()) ? "selected" : "" %>>
                                    🏢 Facilities & Amenities
                                </option>
                                <option value="Other" <%= existing && "Other".equals(feedback.getGeneralFeedbackType()) ? "selected" : "" %>>
                                    📝 Other
                                </option>
                            </select>
                        </div>

                        <!-- Content -->
                        <div class="mb-4">
                            <label for="content" class="form-label fw-semibold">
                                <i class="fas fa-edit me-2 text-primary"></i>Your Detailed Feedback
                            </label>
                            <textarea name="content" id="content" rows="6" class="form-control form-control-lg" 
                                      required maxlength="1000" placeholder="Please share your detailed feedback here. Be specific about what you liked or what could be improved..."><%= existing ? feedback.getContent() : "" %></textarea>
                            <div class="form-text d-flex justify-content-between">
                                <span><i class="fas fa-lightbulb me-1"></i>The more specific you are, the better we can improve</span>
                                <span id="charCount" class="char-counter text-muted">0/1000</span>
                            </div>
                        </div>

                        <!-- Enhanced Star Rating -->
                        <div class="mb-4">
                            <label class="form-label fw-semibold">
                                <i class="fas fa-star me-2 text-warning"></i>Overall Rating
                            </label>
                            <div class="star-rating-container">
                                <div class="stars-wrapper" id="starsWrapper">
                                    <!-- Stars will be generated by JavaScript -->
                                </div>
                                <div class="rating-display">
                                    <div class="rating-value" id="ratingValue">Click to rate</div>
                                    <div class="rating-description" id="ratingDescription">How would you rate your overall experience?</div>
                                </div>
                                <input type="hidden" name="rating" id="rating" value="<%= existing ? feedback.getRating() : 0 %>" required>
                            </div>
                            <div class="form-text text-center mt-2">
                                <i class="fas fa-info-circle me-1"></i>Click on stars to rate (supports half-star ratings)
                            </div>
                        </div>

                        <!-- Error Display -->
                        <div id="errorAlert" class="alert alert-danger d-none" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <span id="errorMessage"></span>
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-grid gap-3 d-md-flex justify-content-md-center mt-5">
                            <button type="button" class="btn btn-outline-secondary btn-lg" onclick="window.location.href='home.jsp'">
                                <i class="fas fa-times me-2"></i>Cancel
                            </button>
                            <button type="submit" class="btn btn-primary btn-lg px-5" id="submitBtn">
                                <i class="fas fa-paper-plane me-2"></i>
                                <%= existing ? "Update" : "Submit" %> Feedback
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Help Card -->
            <div class="card border-0 shadow-sm mt-4 fade-in-up">
                <div class="card-body">
                    <h6 class="card-title text-primary mb-3">
                        <i class="fas fa-question-circle me-2"></i>Feedback Tips
                    </h6>
                    <div class="row g-3">
                        <div class="col-md-4">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-lightbulb text-warning me-2"></i>
                                <small>Be specific and detailed</small>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-heart text-danger me-2"></i>
                                <small>Share what you loved</small>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-tools text-info me-2"></i>
                                <small>Suggest improvements</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap 5.3.7 JS -->
<script src="Resources/bootstrap/js/bootstrap.bundle.min.js"></script>

<script>
// Completely Rewritten Simple Star Rating System
class StarRating {
    constructor(container, options = {}) {
        this.container = container;
        this.maxRating = options.maxRating || 5;
        this.allowHalf = options.allowHalf || true;
        this.currentRating = 0;
        this.hoveredRating = 0;
        
        this.ratingDescriptions = {
            0: { text: 'Click to rate', desc: 'How would you rate your overall experience?' },
            0.5: { text: '0.5 Stars', desc: 'Terrible - Extremely poor experience' },
            1: { text: '1 Star', desc: 'Poor - Very unsatisfied' },
            1.5: { text: '1.5 Stars', desc: 'Poor - Mostly unsatisfied' },
            2: { text: '2 Stars', desc: 'Fair - Somewhat unsatisfied' },
            2.5: { text: '2.5 Stars', desc: 'Fair - Could be better' },
            3: { text: '3 Stars', desc: 'Good - Neutral experience' },
            3.5: { text: '3.5 Stars', desc: 'Good - Mostly satisfied' },
            4: { text: '4 Stars', desc: 'Very Good - Satisfied' },
            4.5: { text: '4.5 Stars', desc: 'Very Good - Very satisfied' },
            5: { text: '5 Stars', desc: 'Excellent - Highly satisfied' }
        };
        
        this.init();
    }
    
    init() {
        this.render();
        this.bindEvents();
    }
    
    render() {
        const starsWrapper = document.getElementById('starsWrapper');
        starsWrapper.innerHTML = '';
        
        for (let i = 1; i <= this.maxRating; i++) {
            const star = document.createElement('i');
            star.className = 'fas fa-star star-item';
            star.dataset.rating = i;
            star.setAttribute('tabindex', '0');
            starsWrapper.appendChild(star);
        }
    }
    
    bindEvents() {
        const stars = document.querySelectorAll('.star-item');
        
        stars.forEach((star) => {
            // Mouse events
            star.addEventListener('mouseenter', (e) => this.handleMouseEnter(e));
            star.addEventListener('mousemove', (e) => this.handleMouseMove(e));
            star.addEventListener('mouseleave', () => this.handleMouseLeave());
            star.addEventListener('click', (e) => this.handleClick(e));
            
            // Keyboard support
            star.addEventListener('keydown', (e) => {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    this.handleClick(e);
                }
            });
        });
        
        // Reset on container leave
        this.container.addEventListener('mouseleave', () => {
            this.hoveredRating = 0;
            this.updateDisplay(this.currentRating);
        });
    }
    
    handleMouseEnter(e) {
        const rating = this.getRatingFromEvent(e);
        this.hoveredRating = rating;
        this.updateDisplay(rating, true);
    }
    
    handleMouseMove(e) {
        const rating = this.getRatingFromEvent(e);
        if (rating !== this.hoveredRating) {
            this.hoveredRating = rating;
            this.updateDisplay(rating, true);
        }
    }
    
    handleMouseLeave() {
        this.hoveredRating = 0;
        this.updateDisplay(this.currentRating);
    }
    
    handleClick(e) {
        const rating = this.getRatingFromEvent(e);
        this.setRating(rating);
        
        // Reset all stars to normal size first
        const allStars = document.querySelectorAll('.star-item');
        allStars.forEach(star => {
            star.style.transform = '';
        });
        
        // Add visual feedback to clicked star
        e.currentTarget.style.transform = 'scale(1.3)';
        setTimeout(() => {
            e.currentTarget.style.transform = '';
        }, 200);
        
        // Validate form
        if (window.validateForm) {
            window.validateForm();
        }
    }
    
    getRatingFromEvent(e) {
        const star = e.currentTarget;
        const rect = star.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const width = rect.width;
        const starNumber = parseInt(star.dataset.rating);
        
        if (this.allowHalf && x < width / 2) {
            return starNumber - 0.5;
        } else {
            return starNumber;
        }
    }
    
    setRating(rating) {
        this.currentRating = rating;
        document.getElementById('rating').value = rating;
        this.updateDisplay(rating);
    }
    
    updateDisplay(rating, isHover = false) {
        const stars = document.querySelectorAll('.star-item');
        
        stars.forEach((star, index) => {
            const starNumber = index + 1;
            
            // Reset classes
            star.classList.remove('filled', 'half-filled');
            
            if (rating >= starNumber) {
                // Full star
                star.classList.add('filled');
            } else if (rating >= starNumber - 0.5) {
                // Half star
                star.classList.add('half-filled');
            }
            // Else: empty star (default gray color)
        });
        
        // Update text display
        const ratingInfo = this.ratingDescriptions[rating] || this.ratingDescriptions[0];
        document.getElementById('ratingValue').textContent = ratingInfo.text;
        document.getElementById('ratingDescription').textContent = ratingInfo.desc;
        
        // Update text color
        const ratingValue = document.getElementById('ratingValue');
        if (isHover) {
            ratingValue.style.color = '#ffc107';
        } else {
            ratingValue.style.color = rating > 0 ? '#667eea' : '#6c757d';
        }
    }
}

// Form validation and other functions
function showHideFields() {
    const feedbackType = document.getElementById('feedback_type');
    const generalGroup = document.getElementById('general_feedback_type_group');
    
    if (!feedbackType) return;
    
    const selectedType = feedbackType.value;
    
    // Hide all conditional groups first
    if (generalGroup) {
        generalGroup.classList.add('d-none');
        const select = generalGroup.querySelector('select');
        if (select) {
            select.removeAttribute('required');
        }
    }
    
    // Show relevant group
    if (selectedType === 'General' && generalGroup) {
        generalGroup.classList.remove('d-none');
        generalGroup.classList.add('fade-in-up');
        const select = generalGroup.querySelector('select');
        if (select) {
            select.setAttribute('required', 'required');
        }
    }
    
    validateForm();
}

function validateForm() {
    const form = document.getElementById('feedbackForm');
    const submitBtn = document.getElementById('submitBtn');
    const errorAlert = document.getElementById('errorAlert');
    const errorMessage = document.getElementById('errorMessage');
    
    let isValid = true;
    let errors = [];
    
    // Validate feedback type
    const feedbackType = document.getElementById('feedback_type');
    if (!feedbackType.value) {
        isValid = false;
        errors.push('Please select a feedback category');
    }
    
    // Validate content
    const content = document.getElementById('content');
    if (!content.value.trim()) {
        isValid = false;
        errors.push('Please enter your feedback content');
    } else if (content.value.length > 1000) {
        isValid = false;
        errors.push('Feedback content is too long (maximum 1000 characters)');
    }
    
    // Validate rating
    const rating = document.getElementById('rating');
    if (!rating.value || rating.value === '0') {
        isValid = false;
        errors.push('Please provide a rating');
    }
    
    // Validate general feedback type if selected
    if (feedbackType.value === 'General') {
        const generalType = document.getElementById('general_feedback_type');
        if (!generalType.value) {
            isValid = false;
            errors.push('Please select a specific feedback category');
        }
    }
    
    // Update submit button state
    submitBtn.disabled = !isValid;
    
    // Show/hide errors
    if (errors.length > 0 && !isValid) {
        errorMessage.textContent = errors[0];
        errorAlert.classList.remove('d-none');
    } else {
        errorAlert.classList.add('d-none');
    }
    
    return isValid;
}

// Character counter
function initializeCharacterCounter() {
    const textarea = document.getElementById('content');
    const charCount = document.getElementById('charCount');
    
    if (textarea && charCount) {
        textarea.addEventListener('input', function() {
            const currentLength = this.value.length;
            const maxLength = 1000;
            
            charCount.textContent = `${currentLength}/${maxLength}`;
            charCount.classList.remove('warning', 'danger');
            
            if (currentLength > maxLength * 0.9) {
                charCount.classList.add('danger');
            } else if (currentLength > maxLength * 0.7) {
                charCount.classList.add('warning');
            }
            
            validateForm();
        });
        
        // Initialize counter
        textarea.dispatchEvent(new Event('input'));
    }
}

// Form submission
function initializeFormSubmission() {
    const form = document.getElementById('feedbackForm');
    const submitBtn = document.getElementById('submitBtn');
    
    form.addEventListener('submit', function(e) {
        e.preventDefault();
        
        if (!validateForm()) {
            return;
        }
        
        // Show loading state
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Submitting...';
        
        // Submit after brief delay for UX
        setTimeout(() => {
            form.submit();
        }, 500);
    });
}

// Initialize everything when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    // Initialize star rating
    const starContainer = document.querySelector('.star-rating-container');
    const starRating = new StarRating(starContainer, {
        maxRating: 5,
        allowHalf: true
    });
    
    // Set initial rating if editing
    <% if (existing && feedback.getRating() > 0) { %>
    starRating.setRating(<%= feedback.getRating() %>);
    <% } %>
    
    // Initialize other components
    initializeCharacterCounter();
    initializeFormSubmission();
    showHideFields();
    
    // Initialize Bootstrap tooltips
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
    
    // Global function for form validation
    window.validateForm = validateForm;
});
</script>

</body>
</html>

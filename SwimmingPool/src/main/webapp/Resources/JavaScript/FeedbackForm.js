//region Initialization
// Initialize all functionality when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    initializeStarRating();
    initializeFormValidation();
    initializeCharacterCounter();
    initializeBootstrapComponents();
    initializeConditionalFields();
    initializeFormSubmission();
    
    // Show fields based on existing data
    showHideFields();
});

// Initialize Bootstrap components
function initializeBootstrapComponents() {
    // Initialize tooltips
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
    
    // Initialize toasts
    var toastElList = [].slice.call(document.querySelectorAll('.toast'));
    var toastList = toastElList.map(function (toastEl) {
        return new bootstrap.Toast(toastEl, {
            autohide: true,
            delay: 5000
        });
    });
    
    // Auto-hide alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            const bsAlert = new bootstrap.Alert(alert);
            if (bsAlert) {
                bsAlert.close();
            }
        }, 5000);
    });
}
//endregion

//region Star Rating System
function initializeStarRating() {
    const stars = document.querySelectorAll('.star');
    const ratingInput = document.getElementById('rating');
    const ratingText = document.getElementById('ratingText');
    const ratingDescription = document.getElementById('ratingDescription');
    
    // Rating descriptions
    const ratingDescriptions = {
        0: { text: 'Click to rate', desc: 'Rate your experience' },
        2: { text: '1 Star', desc: 'Poor - Very unsatisfied' },
        4: { text: '2 Stars', desc: 'Fair - Somewhat unsatisfied' },
        6: { text: '3 Stars', desc: 'Good - Neutral experience' },
        8: { text: '4 Stars', desc: 'Very Good - Satisfied' },
        10: { text: '5 Stars', desc: 'Excellent - Highly satisfied' }
    };
    
    stars.forEach((star, index) => {
        // Hover effect
        star.addEventListener('mouseenter', function() {
            const value = parseInt(this.dataset.value);
            highlightStars(value);
            updateRatingDisplay(value, true);
        });
        
        // Click to select
        star.addEventListener('click', function() {
            const value = parseInt(this.dataset.value);
            ratingInput.value = value;
            selectStars(value);
            updateRatingDisplay(value, false);
            
            // Add selection animation
            this.style.transform = 'scale(1.3)';
            setTimeout(() => {
                this.style.transform = 'scale(1.1)';
            }, 150);
            
            // Validate form
            validateForm();
        });
        
        // Keyboard support
        star.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' || e.key === ' ') {
                e.preventDefault();
                this.click();
            }
        });
        
        // Make stars focusable
        star.setAttribute('tabindex', '0');
    });
    
    // Reset on mouse leave
    const starContainer = document.querySelector('.stars');
    starContainer.addEventListener('mouseleave', function() {
        const currentRating = parseInt(ratingInput.value) || 0;
        selectStars(currentRating);
        updateRatingDisplay(currentRating, false);
    });
    
    function highlightStars(rating) {
        stars.forEach((star, index) => {
            const starValue = parseInt(star.dataset.value);
            if (starValue <= rating) {
                star.classList.add('selected');
                star.style.color = '#ffc107';
            } else {
                star.classList.remove('selected');
                star.style.color = '#dee2e6';
            }
        });
    }
    
    function selectStars(rating) {
        stars.forEach((star, index) => {
            const starValue = parseInt(star.dataset.value);
            if (starValue <= rating) {
                star.classList.add('selected');
            } else {
                star.classList.remove('selected');
            }
        });
    }
    
    function updateRatingDisplay(rating, isHover) {
        const ratingInfo = ratingDescriptions[rating] || ratingDescriptions[0];
        ratingText.textContent = ratingInfo.text;
        ratingDescription.textContent = ratingInfo.desc;
        
        if (isHover) {
            ratingText.style.color = '#ffc107';
        } else {
            ratingText.style.color = rating > 0 ? '#667eea' : '#6c757d';
        }
    }
    
    // Initialize with existing rating
    const initialRating = parseInt(ratingInput.value) || 0;
    if (initialRating > 0) {
        selectStars(initialRating);
        updateRatingDisplay(initialRating, false);
    }
}

// Global function for updating star rating (called from JSP)
function updateStarRating(rating) {
    const ratingInput = document.getElementById('rating');
    const stars = document.querySelectorAll('.star');
    const ratingText = document.getElementById('ratingText');
    const ratingDescription = document.getElementById('ratingDescription');
    
    ratingInput.value = rating;
    
    // Update star display
    stars.forEach(star => {
        const starValue = parseInt(star.dataset.value);
        if (starValue <= rating) {
            star.classList.add('selected');
        } else {
            star.classList.remove('selected');
        }
    });
    
    // Update text display
    const ratingDescriptions = {
        0: { text: 'Click to rate', desc: 'Rate your experience' },
        2: { text: '1 Star', desc: 'Poor - Very unsatisfied' },
        4: { text: '2 Stars', desc: 'Fair - Somewhat unsatisfied' },
        6: { text: '3 Stars', desc: 'Good - Neutral experience' },
        8: { text: '4 Stars', desc: 'Very Good - Satisfied' },
        10: { text: '5 Stars', desc: 'Excellent - Highly satisfied' }
    };
    
    const ratingInfo = ratingDescriptions[rating] || ratingDescriptions[0];
    ratingText.textContent = ratingInfo.text;
    ratingDescription.textContent = ratingInfo.desc;
    ratingText.style.color = rating > 0 ? '#667eea' : '#6c757d';
}
//endregion

//region Character Counter
function initializeCharacterCounter() {
    const textarea = document.getElementById('content');
    const charCount = document.getElementById('charCount');
    
    if (textarea && charCount) {
        // Update counter on input
        textarea.addEventListener('input', function() {
            const currentLength = this.value.length;
            const maxLength = parseInt(this.getAttribute('maxlength')) || 1000;
            
            charCount.textContent = `${currentLength}/${maxLength}`;
            
            // Update color based on character count
            charCount.classList.remove('warning', 'danger');
            if (currentLength > maxLength * 0.9) {
                charCount.classList.add('danger');
            } else if (currentLength > maxLength * 0.7) {
                charCount.classList.add('warning');
            }
            
            // Validate form
            validateForm();
        });
        
        // Initialize counter
        textarea.dispatchEvent(new Event('input'));
    }
}
//endregion

//region Form Validation
function initializeFormValidation() {
    const form = document.getElementById('feedbackForm');
    const inputs = form.querySelectorAll('input[required], select[required], textarea[required]');
    
    // Real-time validation for all required fields
    inputs.forEach(input => {
        input.addEventListener('input', validateForm);
        input.addEventListener('change', validateForm);
        input.addEventListener('blur', function() {
            validateField(this);
        });
    });
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
        errors.push('Please select a feedback type');
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
    
    // Validate conditional fields
    const feedbackTypeValue = feedbackType.value;
    if (feedbackTypeValue === 'Coach') {
        const coachId = document.getElementById('coach_id');
        if (!coachId.value) {
            isValid = false;
            errors.push('Please select a coach');
        }
    } else if (feedbackTypeValue === 'Course') {
        const courseId = document.getElementById('course_id');
        if (!courseId.value) {
            isValid = false;
            errors.push('Please select a course');
        }
    } else if (feedbackTypeValue === 'General') {
        const generalType = document.getElementById('general_feedback_type');
        if (!generalType.value) {
            isValid = false;
            errors.push('Please select a general feedback category');
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

function validateField(field) {
    const value = field.value.trim();
    
    // Remove existing validation classes
    field.classList.remove('is-valid', 'is-invalid');
    
    // Add appropriate class based on validation
    if (field.hasAttribute('required')) {
        if (value === '') {
            field.classList.add('is-invalid');
        } else {
            field.classList.add('is-valid');
        }
    }
    
    // Special validation for content length
    if (field.id === 'content' && value.length > 1000) {
        field.classList.add('is-invalid');
        field.classList.remove('is-valid');
    }
}
//endregion

//region Conditional Fields
function initializeConditionalFields() {
    const feedbackType = document.getElementById('feedback_type');
    
    if (feedbackType) {
        feedbackType.addEventListener('change', function() {
            showHideFields();
            validateForm();
        });
    }
}

function showHideFields() {
    const feedbackType = document.getElementById('feedback_type');
    const coachGroup = document.getElementById('coach_id_group');
    const courseGroup = document.getElementById('course_id_group');
    const generalGroup = document.getElementById('general_feedback_type_group');
    
    if (!feedbackType) return;
    
    const selectedType = feedbackType.value;
    
    // Hide all conditional groups first
    [coachGroup, courseGroup, generalGroup].forEach(group => {
        if (group) {
            group.classList.add('d-none');
            group.classList.remove('fade-in');
            
            // Clear required attribute from hidden fields
            const select = group.querySelector('select');
            if (select) {
                select.removeAttribute('required');
                select.classList.remove('is-valid', 'is-invalid');
            }
        }
    });
    
    // Show relevant group with animation
    let targetGroup = null;
    let targetSelect = null;
    
    switch (selectedType) {
        case 'Coach':
            targetGroup = coachGroup;
            targetSelect = document.getElementById('coach_id');
            break;
        case 'Course':
            targetGroup = courseGroup;
            targetSelect = document.getElementById('course_id');
            break;
        case 'General':
            targetGroup = generalGroup;
            targetSelect = document.getElementById('general_feedback_type');
            break;
    }
    
    if (targetGroup && targetSelect) {
        targetGroup.classList.remove('d-none');
        targetGroup.classList.add('fade-in');
        targetSelect.setAttribute('required', 'required');
        
        // Focus the field after animation
        setTimeout(() => {
            targetSelect.focus();
        }, 300);
    }
}
//endregion

//region Form Submission
function initializeFormSubmission() {
    const form = document.getElementById('feedbackForm');
    const submitBtn = document.getElementById('submitBtn');
    
    form.addEventListener('submit', function(e) {
        e.preventDefault();
        
        // Final validation
        if (!validateForm()) {
            showErrorToast('Please fix the errors before submitting');
            return;
        }
        
        // Show loading state
        submitBtn.disabled = true;
        submitBtn.classList.add('loading');
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Submitting...';
        
        // Add loading toast
        showLoadingToast('Submitting your feedback...');
        
        // Submit the form after a brief delay (for UX)
        setTimeout(() => {
            form.submit();
        }, 500);
    });
}
//endregion

//region Utility Functions
// Show success toast
function showSuccessToast(message) {
    const toastHTML = `
        <div class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body">
                    <i class="fas fa-check-circle me-2"></i>${message}
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
    `;
    
    showToast(toastHTML);
}

// Show error toast
function showErrorToast(message) {
    const toastHTML = `
        <div class="toast align-items-center text-white bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body">
                    <i class="fas fa-exclamation-circle me-2"></i>${message}
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
    `;
    
    showToast(toastHTML);
}

// Show loading toast
function showLoadingToast(message = 'Loading...') {
    const toastHTML = `
        <div class="toast align-items-center text-white bg-primary border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body">
                    <i class="fas fa-spinner fa-spin me-2"></i>${message}
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
    `;
    
    showToast(toastHTML);
}

function showToast(toastHTML) {
    // Create toast container if it doesn't exist
    let toastContainer = document.querySelector('.toast-container');
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.className = 'toast-container position-fixed top-0 end-0 p-3';
        toastContainer.style.zIndex = '11000';
        document.body.appendChild(toastContainer);
    }
    
    // Add toast
    const div = document.createElement('div');
    div.innerHTML = toastHTML;
    const toastElement = div.firstElementChild;
    toastContainer.appendChild(toastElement);
    
    // Show toast
    const toast = new bootstrap.Toast(toastElement, {
        autohide: true,
        delay: 5000
    });
    toast.show();
    
    // Remove from DOM after hiding
    toastElement.addEventListener('hidden.bs.toast', () => {
        toastElement.remove();
    });
}

// Enhanced error handling
window.addEventListener('error', function(e) {
    console.error('JavaScript error:', e.error);
    showErrorToast('An unexpected error occurred. Please try again.');
});

// Auto-save draft functionality
function initializeAutoSave() {
    const form = document.getElementById('feedbackForm');
    const inputs = form.querySelectorAll('input, select, textarea');
    
    inputs.forEach(input => {
        input.addEventListener('input', debounce(saveDraft, 1000));
    });
    
    // Load draft on page load
    loadDraft();
}

function saveDraft() {
    const formData = {
        feedback_type: document.getElementById('feedback_type')?.value || '',
        coach_id: document.getElementById('coach_id')?.value || '',
        course_id: document.getElementById('course_id')?.value || '',
        general_feedback_type: document.getElementById('general_feedback_type')?.value || '',
        content: document.getElementById('content')?.value || '',
        rating: document.getElementById('rating')?.value || '0'
    };
    
    localStorage.setItem('feedback_draft', JSON.stringify(formData));
}

function loadDraft() {
    const draftData = localStorage.getItem('feedback_draft');
    if (draftData) {
        try {
            const formData = JSON.parse(draftData);
            
            // Only load draft if form is empty (new feedback)
            const isNewForm = !document.querySelector('input[name="postId"]');
            if (isNewForm) {
                Object.keys(formData).forEach(key => {
                    const element = document.getElementById(key);
                    if (element && formData[key]) {
                        element.value = formData[key];
                        if (element.tagName === 'SELECT') {
                            element.dispatchEvent(new Event('change'));
                        }
                    }
                });
                
                // Update star rating if exists
                if (formData.rating && formData.rating !== '0') {
                    updateStarRating(parseInt(formData.rating));
                }
                
                // Update character counter
                const contentField = document.getElementById('content');
                if (contentField) {
                    contentField.dispatchEvent(new Event('input'));
                }
            }
        } catch (e) {
            console.warn('Failed to load draft:', e);
        }
    }
}

function clearDraft() {
    localStorage.removeItem('feedback_draft');
}

// Debounce utility function
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Initialize auto-save when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    initializeAutoSave();
});

// Clear draft when form is successfully submitted
window.addEventListener('beforeunload', function() {
    // Only clear draft if form was submitted successfully
    if (document.getElementById('submitBtn').classList.contains('loading')) {
        clearDraft();
    }
});
//endregion

// Export functions for global access (for JSP usage)
window.showHideFields = showHideFields;
window.updateStarRating = updateStarRating;
window.showSuccessToast = showSuccessToast;
window.showErrorToast = showErrorToast;
window.showLoadingToast = showLoadingToast;

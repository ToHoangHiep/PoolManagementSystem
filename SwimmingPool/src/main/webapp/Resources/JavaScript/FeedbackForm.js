function showHideFields() {
    var feedbackType = document.getElementById('feedback_type').value;

    // Get references to the select elements
    var coachSelect = document.getElementById('coach_id');
    var courseSelect = document.getElementById('course_id');
    var generalFeedbackTypeSelect = document.getElementById('general_feedback_type');

    // Hide all conditional fields first and remove required attribute
    document.getElementById('coach_id_group').style.display = 'none';
    coachSelect.removeAttribute('required');

    document.getElementById('course_id_group').style.display = 'none';
    courseSelect.removeAttribute('required');

    document.getElementById('general_feedback_type_group').style.display = 'none';
    generalFeedbackTypeSelect.removeAttribute('required');

    // Redirect to error page if Coach or Course is selected
    if (feedbackType === 'Coach' || feedbackType === 'Course') {
        window.location.href = 'error.jsp';
        return;
    }

    // Show relevant fields based on selected feedback type and add required attribute
    if (feedbackType === 'General') {
        document.getElementById('general_feedback_type_group').style.display = 'block';
        generalFeedbackTypeSelect.setAttribute('required', 'required');
    }
}

// Star rating functionality
function initStarRating() {
    const stars = document.querySelectorAll('.star');
    const starsContainer = document.querySelector('.stars');
    const ratingInput = document.getElementById('rating');
    const ratingText = document.querySelector('.rating-text');

    // Initialize stars based on current value
    updateStars(parseInt(ratingInput.value || 0));

    // Add event listener for mouse movement over stars
    starsContainer.addEventListener('mousemove', function(e) {
        const stars = document.querySelectorAll('.star');
        let value = 0;

        // Loop through stars to find which one is being hovered
        for (let i = 0; i < stars.length; i++) {
            const star = stars[i];
            const rect = star.getBoundingClientRect();
            const starValue = parseInt(star.getAttribute('data-value'));

            // Check if mouse is over this star
            if (e.clientX >= rect.left && e.clientX <= rect.right) {
                // Calculate relative position within the star (0 to 1)
                const relativeX = (e.clientX - rect.left) / rect.width;

                // Determine if it's a half-star or full star
                if (relativeX < 0.5) {
                    value = starValue - 1; // Half star
                } else {
                    value = starValue; // Full star
                }
                break;
            } else if (e.clientX < rect.left) {
                break;
            } else if (e.clientX > rect.right) {
                value = starValue;
            }
        }

        highlightStars(value);
    });

    // Add event listener for mouseout
    starsContainer.addEventListener('mouseout', function() {
        // Restore the actual rating
        updateStars(parseInt(ratingInput.value || 0));
    });

    // Add event listener for click
    starsContainer.addEventListener('click', function(e) {
        const stars = document.querySelectorAll('.star');
        let value = 0;

        for (let i = 0; i < stars.length; i++) {
            const star = stars[i];
            const rect = star.getBoundingClientRect();
            const starValue = parseInt(star.getAttribute('data-value'));

            if (e.clientX >= rect.left && e.clientX <= rect.right) {
                const relativeX = (e.clientX - rect.left) / rect.width;

                if (relativeX < 0.5) {
                    value = starValue - 1; // Half star
                } else {
                    value = starValue; // Full star
                }
                break;
            } else if (e.clientX < rect.left) {
                break;
            } else if (e.clientX > rect.right) {
                value = starValue;
            }
        }

        ratingInput.value = value;
        updateStars(value);
    });

    // Function to highlight stars without changing rating
    function highlightStars(value) {
        stars.forEach(star => {
            const starValue = parseInt(star.getAttribute('data-value'));

            // Reset classes
            star.className = 'star fa';

            if (starValue <= value) {
                // Full star
                star.classList.add('fa-star');
                star.classList.add('active');
            } else if (starValue - 1 === value) {
                // Half star
                star.classList.add('fa-star-half-o');
                star.classList.add('active');
            } else {
                // Empty star
                star.classList.add('fa-star-o');
            }
        });

        updateRatingText(value);
    }

    // Function to update stars based on rating value
    function updateStars(value) {
        highlightStars(value);
    }

    // Function to update rating text
    function updateRatingText(value) {
        if (value === 0) {
            ratingText.textContent = '0 stars';
        } else if (value % 2 === 0) {
            ratingText.textContent = (value / 2) + ' stars';
        } else {
            ratingText.textContent = Math.floor(value / 2) + '.5 stars';
        }
    }
}

// Call the functions on page load
window.onload = function() {
    showHideFields();
    initStarRating();
};

// Also call the function when the feedback type changes
document.getElementById('feedback_type').addEventListener('change', showHideFields);

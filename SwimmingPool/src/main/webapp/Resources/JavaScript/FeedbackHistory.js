//region Initialization
// Initialize all functionality when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    initializeSelectAll();
    initializeDeleteFunctionality();
    initializeModalEvents();
    toggleFilterFields();
    
    // Initialize admin view if user is admin
    if (window.isAdmin) {
        initializeAdminView();
    }
});
//endregion

//region Select All Functionality
function initializeSelectAll() {
    const selectAllCheckbox = document.getElementById('selectAll');

    selectAllCheckbox.addEventListener('change', function() {
        const checkboxes = document.querySelectorAll('.feedback-checkbox');
        checkboxes.forEach(checkbox => {
            checkbox.checked = this.checked;
        });
        updateDeleteButton();
    });

    // Individual checkbox handling
    document.addEventListener('change', function (e) {
        if (e.target.classList.contains('feedback-checkbox')) {
            updateDeleteButton();
            updateSelectAll();
        }
    });
}

function updateSelectAll() {
    const allCheckboxes = document.querySelectorAll('.feedback-checkbox');
    const checkedCheckboxes = document.querySelectorAll('.feedback-checkbox:checked');
    const selectAllCheckbox = document.getElementById('selectAll');

    if (checkedCheckboxes.length === allCheckboxes.length && allCheckboxes.length > 0) {
        selectAllCheckbox.checked = true;
        selectAllCheckbox.indeterminate = false;
    } else if (checkedCheckboxes.length > 0) {
        selectAllCheckbox.checked = false;
        selectAllCheckbox.indeterminate = true;
    } else {
        selectAllCheckbox.checked = false;
        selectAllCheckbox.indeterminate = false;
    }
}
//endregion

//region Delete Functionality
function initializeDeleteFunctionality() {
    const deleteButton = document.getElementById('deleteSelectedBtn');

    deleteButton.addEventListener('click', function() {
        const selectedCheckboxes = document.querySelectorAll('.feedback-checkbox:checked');

        if (selectedCheckboxes.length > 0) {
            if (confirm(`Are you sure you want to delete ${selectedCheckboxes.length} feedback record(s)?`)) {
                document.getElementById('deleteForm').submit();
            }
        }
    });
}

function updateDeleteButton() {
    const selectedCheckboxes = document.querySelectorAll('.feedback-checkbox:checked');
    const deleteBtn = document.getElementById('deleteSelectedBtn');
    deleteBtn.disabled = selectedCheckboxes.length === 0;
}

function confirmDelete(feedbackId) {
    if (confirm('Are you sure you want to delete this feedback?')) {
        window.location.href = `feedback?action=delete&feedback_id=${feedbackId}`;
    }
}

function confirmDeleteFromModal(feedbackId) {
    if (confirm('Are you sure you want to delete this feedback?')) {
        window.location.href = `feedback?action=delete&feedback_id=${feedbackId}`;
    }
}
//endregion

//region Modal Functionality
function initializeModalEvents() {
    // Close modal when clicking outside
    window.onclick = function (event) {
        const modal = document.getElementById('previewModal');
        if (event.target === modal) {
            closeModal();
        }
    }

    // ESC key to close modal
    document.addEventListener('keydown', function (event) {
        if (event.key === 'Escape') {
            closeModal();
        }
    });
}

function previewFeedback(feedbackData, allowEdit = false) {
    const modal = document.getElementById('previewModal');
    const modalType = document.getElementById('modalFeedbackType');
    const modalRating = document.getElementById('modalRating');
    const modalDate = document.getElementById('modalDate');
    const modalContent = document.getElementById('modalContent');
    const modalUserName = document.getElementById('modalUserName');
    const modalUserEmail = document.getElementById('modalUserEmail');
    const editBtn = document.getElementById('modalEditBtn');
    const deleteBtn = document.getElementById('modalDeleteBtn');
    const replyBtn = document.getElementById('modalReplyBtn');

    // Populate modal with feedback data
    modalType.textContent = feedbackData.type;
    modalRating.innerHTML = generateStarRating(feedbackData.rating);
    modalDate.textContent = feedbackData.date;
    modalContent.textContent = feedbackData.content;

    // Populate user information
    modalUserName.textContent = feedbackData.userName || 'N/A';
    modalUserEmail.textContent = feedbackData.userEmail || '';

    // Set button actions
    editBtn.href = `feedback?action=edit&feedback_id=${feedbackData.id}`;
    editBtn.style.display = allowEdit ? 'inline-block' : 'none';
    deleteBtn.onclick = () => confirmDeleteFromModal(feedbackData.id);
    replyBtn.href = `feedback?action=chat&id=${feedbackData.id}`;

    // Show modal
    modal.style.display = 'block';
}

function closeModal() {
    document.getElementById('previewModal').style.display = 'none';
}
//endregion

//region Filter Functionality
function toggleFilterFields() {
    const feedbackType = document.getElementById('feedback_type').value;
    const generalGroup = document.getElementById('general_type_group');
    const coachGroup = document.getElementById('coach_group');
    const courseGroup = document.getElementById('course_group');

    // Hide all groups first
    [generalGroup, coachGroup, courseGroup].forEach(group => {
        group.classList.add('hidden');
    });

    // Show relevant group
    switch (feedbackType) {
        case 'General':
            generalGroup.classList.remove('hidden');
            break;
        case 'Coach':
            coachGroup.classList.remove('hidden');
            break;
        case 'Course':
            courseGroup.classList.remove('hidden');
            break;
    }
}
//endregion

//region Admin View Management
function initializeAdminView() {
    const urlParams = new URLSearchParams(window.location.search);
    const showAll = urlParams.get('show_all') === 'true';
    
    // Update toggle state
    const toggle = document.getElementById('viewToggle');
    if (toggle) {
        toggle.checked = showAll;
        updateToggleLabels(showAll);
    }
}

// Simple Toggle View Function (Server-Side)
function toggleView(showAll) {
    // Get current URL parameters
    const urlParams = new URLSearchParams(window.location.search);
    
    // Update or add the show_all parameter
    if (showAll) {
        urlParams.set('show_all', 'true');
    } else {
        urlParams.delete('show_all');
    }
    
    // Keep the mode=list parameter
    urlParams.set('mode', 'list');
    
    // Redirect to the new URL
    window.location.href = `feedback?${urlParams.toString()}`;
}

function updateToggleLabels(showAll) {
    const personalLabel = document.querySelector('.toggle-label:first-of-type');
    const allLabel = document.querySelector('.toggle-label:last-of-type');
    
    if (personalLabel && allLabel) {
        personalLabel.classList.toggle('active', !showAll);
        allLabel.classList.toggle('active', showAll);
    }
}
//endregion

//region Utility Functions
function generateStarRating(rating) {
    let stars = '';
    const starCount = Math.floor(rating / 2);
    const hasHalf = rating % 2 === 1;

    for (let i = 1; i <= 5; i++) {
        if (i <= starCount) {
            stars += "<i class='fas fa-star'></i>";
        } else if (i === starCount + 1 && hasHalf) {
            stars += "<i class='fas fa-star-half-alt'></i>";
        } else {
            stars += "<i class='far fa-star'></i>";
        }
    }

    return `<div class="star-rating">${stars} <span style="margin-left: 8px; color: #6c757d;">(${rating}/10)</span></div>`;
}
//endregion

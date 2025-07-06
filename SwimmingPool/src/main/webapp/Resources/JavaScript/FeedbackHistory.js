//region Initialization
// Initialize all functionality when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    initializeSelectAll();
    initializeDeleteFunctionality();
    initializeModalEvents();
    toggleFilterFields();
    initializeBootstrapComponents();
    
    // Initialize admin view if user is admin
    if (window.isAdmin) {
        initializeAdminView();
    }
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
}
//endregion

//region Select All Functionality
function initializeSelectAll() {
    const selectAllCheckbox = document.getElementById('selectAll');

    if (selectAllCheckbox) {
        selectAllCheckbox.addEventListener('change', function() {
            const checkboxes = document.querySelectorAll('.feedback-checkbox');
            checkboxes.forEach(checkbox => {
                checkbox.checked = this.checked;
            });
            updateDeleteButton();
        });
    }

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

    if (selectAllCheckbox) {
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
}
//endregion

//region Delete Functionality
function initializeDeleteFunctionality() {
    const deleteButton = document.getElementById('deleteSelectedBtn');

    if (deleteButton) {
        deleteButton.addEventListener('click', function() {
            const selectedCheckboxes = document.querySelectorAll('.feedback-checkbox:checked');

            if (selectedCheckboxes.length > 0) {
                // Use Bootstrap modal for confirmation
                showConfirmationModal(
                    'Delete Feedback',
                    `Are you sure you want to delete ${selectedCheckboxes.length} feedback record(s)? This action cannot be undone.`,
                    'danger',
                    function() {
                        document.getElementById('deleteForm').submit();
                    }
                );
            }
        });
    }
}

function updateDeleteButton() {
    const selectedCheckboxes = document.querySelectorAll('.feedback-checkbox:checked');
    const deleteBtn = document.getElementById('deleteSelectedBtn');
    if (deleteBtn) {
        deleteBtn.disabled = selectedCheckboxes.length === 0;
        
        // Update button text
        if (selectedCheckboxes.length > 0) {
            deleteBtn.innerHTML = `<i class="fas fa-trash me-2"></i>Delete Selected (${selectedCheckboxes.length})`;
        } else {
            deleteBtn.innerHTML = `<i class="fas fa-trash me-2"></i>Delete Selected`;
        }
    }
}

function confirmDelete(feedbackId) {
    showConfirmationModal(
        'Delete Feedback',
        'Are you sure you want to delete this feedback? This action cannot be undone.',
        'danger',
        function() {
            window.location.href = `feedback?action=delete&feedback_id=${feedbackId}`;
        }
    );
}

function confirmDeleteFromModal(feedbackId) {
    // Close the preview modal first
    const previewModal = bootstrap.Modal.getInstance(document.getElementById('previewModal'));
    if (previewModal) {
        previewModal.hide();
    }
    
    // Show confirmation after a brief delay
    setTimeout(() => {
        confirmDelete(feedbackId);
    }, 300);
}
//endregion

//region Modal Functionality
function initializeModalEvents() {
    // ESC key to close modal
    document.addEventListener('keydown', function (event) {
        if (event.key === 'Escape') {
            const modal = bootstrap.Modal.getInstance(document.getElementById('previewModal'));
            if (modal) {
                modal.hide();
            }
        }
    });
}

function previewFeedback(feedbackData, allowEdit = false) {
    const modal = document.getElementById('previewModal');
    const modalUserName = document.getElementById('modalUserName');
    const modalUserEmail = document.getElementById('modalUserEmail');
    const modalFeedbackType = document.getElementById('modalFeedbackType');
    const modalRating = document.getElementById('modalRating');
    const modalDate = document.getElementById('modalDate');
    const modalContent = document.getElementById('modalContent');
    const editBtn = document.getElementById('modalEditBtn');
    const deleteBtn = document.getElementById('modalDeleteBtn');
    const replyBtn = document.getElementById('modalReplyBtn');

    // Populate modal with feedback data
    if (modalUserName) modalUserName.textContent = feedbackData.userName || 'N/A';
    if (modalUserEmail) modalUserEmail.textContent = feedbackData.userEmail || '';
    if (modalFeedbackType) modalFeedbackType.textContent = feedbackData.type;
    if (modalRating) modalRating.innerHTML = generateStarRating(feedbackData.rating);
    if (modalDate) modalDate.textContent = feedbackData.date;
    if (modalContent) modalContent.textContent = feedbackData.content;

    // Set button actions
    if (editBtn) {
        editBtn.href = `feedback?action=edit&feedback_id=${feedbackData.id}`;
        editBtn.style.display = allowEdit ? 'inline-flex' : 'none';
    }
    
    if (deleteBtn) {
        deleteBtn.onclick = () => confirmDeleteFromModal(feedbackData.id);
    }
    
    if (replyBtn) {
        replyBtn.href = `feedback?action=chat&id=${feedbackData.id}`;
    }

    // Show modal using Bootstrap
    const bootstrapModal = new bootstrap.Modal(modal);
    bootstrapModal.show();
}

function closeModal() {
    const modal = bootstrap.Modal.getInstance(document.getElementById('previewModal'));
    if (modal) {
        modal.hide();
    }
}

// Generic confirmation modal
function showConfirmationModal(title, message, type = 'warning', confirmCallback = null) {
    // Create modal HTML if it doesn't exist
    let confirmModal = document.getElementById('confirmationModal');
    if (!confirmModal) {
        confirmModal = createConfirmationModal();
        document.body.appendChild(confirmModal);
    }
    
    // Set modal content
    const modalTitle = confirmModal.querySelector('.modal-title');
    const modalBody = confirmModal.querySelector('.modal-body');
    const confirmBtn = confirmModal.querySelector('.btn-confirm');
    
    modalTitle.innerHTML = `<i class="fas fa-exclamation-triangle me-2"></i>${title}`;
    modalBody.textContent = message;
    
    // Set button style based on type
    confirmBtn.className = `btn btn-${type}`;
    
    // Set confirm action
    confirmBtn.onclick = function() {
        if (confirmCallback) confirmCallback();
        const modal = bootstrap.Modal.getInstance(confirmModal);
        modal.hide();
    };
    
    // Show modal
    const bootstrapModal = new bootstrap.Modal(confirmModal);
    bootstrapModal.show();
}

function createConfirmationModal() {
    const modalHTML = `
        <div class="modal fade" id="confirmationModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header border-0">
                        <h5 class="modal-title"></h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body"></div>
                    <div class="modal-footer border-0">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-danger btn-confirm">Confirm</button>
                    </div>
                </div>
            </div>
        </div>
    `;
    
    const div = document.createElement('div');
    div.innerHTML = modalHTML;
    return div.firstElementChild;
}
//endregion

//region Filter Functionality
function toggleFilterFields() {
    const feedbackType = document.getElementById('feedback_type');
    const generalGroup = document.getElementById('general_type_group');
    const coachGroup = document.getElementById('coach_group');
    const courseGroup = document.getElementById('course_group');

    if (!feedbackType) return;

    // Hide all groups first
    [generalGroup, coachGroup, courseGroup].forEach(group => {
        if (group) {
            group.classList.add('d-none');
            group.classList.remove('d-block');
        }
    });

    // Show relevant group
    const selectedType = feedbackType.value;
    let targetGroup = null;
    
    switch (selectedType) {
        case 'General':
            targetGroup = generalGroup;
            break;
        case 'Coach':
            targetGroup = coachGroup;
            break;
        case 'Course':
            targetGroup = courseGroup;
            break;
    }
    
    if (targetGroup) {
        targetGroup.classList.remove('d-none');
        targetGroup.classList.add('d-block');
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
    
    // Show loading state
    showLoadingToast('Switching view...');
    
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

    return `<div class="d-flex align-items-center text-warning">${stars} <small class="text-muted ms-2">(${rating}/10)</small></div>`;
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
        delay: 3000
    });
    toast.show();
    
    // Remove from DOM after hiding
    toastElement.addEventListener('hidden.bs.toast', () => {
        toastElement.remove();
    });
}

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

// Enhanced search functionality
function performSearch(query) {
    const rows = document.querySelectorAll('tbody tr');
    let visibleCount = 0;
    
    rows.forEach(row => {
        const content = row.textContent.toLowerCase();
        const isVisible = content.includes(query.toLowerCase());
        
        row.style.display = isVisible ? '' : 'none';
        if (isVisible) visibleCount++;
    });
    
    // Show/hide no results message
    updateNoResultsMessage(visibleCount === 0 && query.length > 0);
}

function updateNoResultsMessage(show) {
    let noResultsRow = document.getElementById('no-results-row');
    
    if (show && !noResultsRow) {
        const tbody = document.querySelector('tbody');
        noResultsRow = document.createElement('tr');
        noResultsRow.id = 'no-results-row';
        noResultsRow.innerHTML = `
            <td colspan="7" class="text-center py-5">
                <div class="text-muted">
                    <i class="fas fa-search fa-3x mb-3 opacity-50"></i>
                    <h5>No results found</h5>
                    <p class="mb-0">Try adjusting your search terms</p>
                </div>
            </td>
        `;
        tbody.appendChild(noResultsRow);
    } else if (!show && noResultsRow) {
        noResultsRow.remove();
    }
}
//endregion

// Export functions for global access (for JSP onclick handlers)
window.previewFeedback = previewFeedback;
window.confirmDelete = confirmDelete;
window.toggleView = toggleView;
window.toggleFilterFields = toggleFilterFields;

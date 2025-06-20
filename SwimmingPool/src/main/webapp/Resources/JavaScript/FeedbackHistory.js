//region Initialization
// Initialize all functionality when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    initializeSelectAll();
    initializeDeleteFunctionality();
    initializeModalEvents();
    toggleFilterFields();
    checkRefreshNeeded();
    
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
    
    // Render the appropriate dataset
    renderFeedbackTable(showAll);
    
    // Update toggle state
    const toggle = document.getElementById('viewToggle');
    if (toggle) {
        toggle.checked = showAll;
        updateToggleLabels(showAll);
    }
}

// Optimized Toggle View Function (No Server Requests)
function toggleView(showAll) {
    if (window.isAdmin) {
        // For admins: Use client-side data toggle
        renderFeedbackTable(showAll);
        updateToggleLabels(showAll);
        
        // Update URL without page reload (optional, for bookmarking)
        const urlParams = new URLSearchParams(window.location.search);
        if (showAll) {
            urlParams.set('show_all', 'true');
        } else {
            urlParams.delete('show_all');
        }
        urlParams.set('mode', 'list');
        
        // Update URL in browser without reload
        const newUrl = `${window.location.pathname}?${urlParams.toString()}`;
        window.history.replaceState({}, '', newUrl);
        
        // Update hidden form field for filter form
        const hiddenField = document.querySelector('input[name="show_all"]');
        if (hiddenField) {
            hiddenField.value = showAll ? 'true' : 'false';
        }
    } else {
        // For non-admins: Fall back to server request (shouldn't happen)
        const urlParams = new URLSearchParams(window.location.search);
        if (showAll) {
            urlParams.set('show_all', 'true');
        } else {
            urlParams.delete('show_all');
        }
        urlParams.set('mode', 'list');
        window.location.href = `feedback?${urlParams.toString()}`;
    }
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

//region Table Rendering
function renderFeedbackTable(showAll) {
    const tableBody = document.getElementById('feedbackTableBody');
    const feedbackData = showAll ? window.allFeedbackData : window.personalFeedbackData;
    
    if (!feedbackData || feedbackData.length === 0) {
        tableBody.innerHTML = `
            <tr>
                <td colspan="7" class="no-feedback">
                    <i class="fas fa-comments"></i><br>
                    No feedback records found<br>
                    <small>Try adjusting your filters or submit some feedback!</small>
                </td>
            </tr>
        `;
        return;
    }
    
    tableBody.innerHTML = feedbackData.map(feedback => `
        <tr>
            <!-- Checkbox Column -->
            <td>
                <input type="checkbox" 
                       name="selectedIds" 
                       value="${feedback.id}" 
                       class="feedback-checkbox">
            </td>

            <!-- User Information Column -->
            <td>
                <div class="user-info">
                    <div class="user-name">
                        <i class="fas fa-user"></i>
                        ${feedback.userName}
                    </div>
                    <div class="user-email">
                        ${feedback.userEmail}
                    </div>
                </div>
            </td>

            <!-- Feedback Type Column -->
            <td>
                <span class="badge badge-${feedback.feedbackType.toLowerCase()}">
                    ${feedback.feedbackType}
                </span>
            </td>

            <!-- Rating Column -->
            <td>
                <div class="star-rating">
                    ${generateStarRating(feedback.rating)}
                </div>
            </td>

            <!-- Content Preview Column -->
            <td>
                <div class="content-preview" title="${feedback.content}">
                    ${feedback.content.length > 50 ? 
                        feedback.content.substring(0, 47) + "..." : 
                        feedback.content}
                </div>
            </td>

            <!-- Date Column -->
            <td>${feedback.createdAt}</td>

            <!-- Actions Column -->
            <td>
                <div class="action-buttons">
                    <!-- Preview Button -->
                    <button type="button" 
                            class="btn-icon btn-preview" 
                            onclick="previewFeedback({
                                id: ${feedback.id},
                                type: '${feedback.feedbackType}',
                                rating: ${feedback.rating},
                                date: '${feedback.createdAt}',
                                content: '${feedback.content.replace(/'/g, "\\'")}',
                                userName: '${feedback.userName}',
                                userEmail: '${feedback.userEmail}'
                            }, ${feedback.userId === window.currentUserId})"
                            title="Preview">
                        <i class="fas fa-eye"></i>
                    </button>

                    ${feedback.userId === window.currentUserId ? `
                    <!-- Edit Button -->
                    <a href="feedback?action=edit&id=${feedback.id}" 
                       class="btn-icon btn-edit" 
                       title="Edit">
                        <i class="fas fa-edit"></i>
                    </a>
                    ` : ''}

                    <!-- Delete Button -->
                    <button type="button" 
                            class="btn-icon btn-delete" 
                            onclick="confirmDelete(${feedback.id})" 
                            title="Delete">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
            </td>
        </tr>
    `).join('');
    
    // Reinitialize event listeners after table update
    initializeSelectAll();
    updateDeleteButton();
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

//region Data Refresh Management
let lastDataRefresh = new Date();
let isDataStale = false;

// Auto-refresh when user returns to tab
document.addEventListener('visibilitychange', function() {
    if (!document.hidden && isDataStale && window.isAdmin) {
        refreshAdminData();
    }
});

// Refresh data manually
function refreshAdminData() {
    if (!window.isAdmin) return;
    
    const refreshBtn = document.getElementById('refreshBtn');
    if (refreshBtn) {
        refreshBtn.disabled = true;
        refreshBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Refreshing...';
    }
    
    // Get current toggle state
    const currentShowAll = document.getElementById('viewToggle').checked;
    
    // Reload page with current parameters
    const urlParams = new URLSearchParams(window.location.search);
    urlParams.set('mode', 'list');
    urlParams.set('refresh', 'true');
    
    if (currentShowAll) {
        urlParams.set('show_all', 'true');
    } else {
        urlParams.delete('show_all');
    }
    
    window.location.href = `feedback?${urlParams.toString()}`;
}

// Mark data as potentially stale after user actions
function markDataAsStale() {
    isDataStale = true;
    updateRefreshIndicator();
}

// Update refresh indicator
function updateRefreshIndicator() {
    const indicator = document.getElementById('dataFreshnessIndicator');
    const timestamp = document.getElementById('lastUpdated');
    
    if (indicator && timestamp) {
        if (isDataStale) {
            indicator.className = 'freshness-indicator stale';
            indicator.title = 'Data may be outdated. Click refresh to update.';
        } else {
            indicator.className = 'freshness-indicator fresh';
            indicator.title = 'Data is up to date';
            timestamp.textContent = `Last updated: ${lastDataRefresh.toLocaleTimeString()}`;
        }
    }
}

// Override delete functions to refresh data
function confirmDeleteWithRefresh(feedbackId) {
    if (confirm('Are you sure you want to delete this feedback?')) {
        // Set flag to refresh after delete
        sessionStorage.setItem('needsRefresh', 'true');
        window.location.href = `feedback?action=delete&id=${feedbackId}`;
    }
}

// Check if we need to refresh after page load
function checkRefreshNeeded() {
    if (sessionStorage.getItem('needsRefresh') === 'true') {
        sessionStorage.removeItem('needsRefresh');
        isDataStale = false;
        lastDataRefresh = new Date();
        updateRefreshIndicator();
    }
}
//endregion

//region Initialization
// Initialize all functionality when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    initializeCharacterCounters();
    initializeFormValidation();
    initializeAutoSave();
    initializeBootstrapComponents();
    initializeTagSystem();
    initializeFormSubmission();
    initializeWordCount();
    // Removed loadDraft() call from here to prevent double alerts
    // loadDraft() is now only called from the JSP when not in edit mode
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

//region Character Counters
function initializeCharacterCounters() {
    const titleInput = document.getElementById('title');
    const contentTextarea = document.getElementById('content');
    const titleCount = document.getElementById('titleCount');
    const contentCount = document.getElementById('contentCount');
    
    // Title counter
    if (titleInput && titleCount) {
        titleInput.addEventListener('input', function() {
            const currentLength = this.value.length;
            const maxLength = parseInt(this.getAttribute('maxlength')) || 255;
            
            titleCount.textContent = `${currentLength}/${maxLength}`;
            
            // Update color based on character count
            titleCount.classList.remove('warning', 'danger');
            if (currentLength > maxLength * 0.9) {
                titleCount.classList.add('danger');
            } else if (currentLength > maxLength * 0.7) {
                titleCount.classList.add('warning');
            }
        });
        
        // Initialize counter
        titleInput.dispatchEvent(new Event('input'));
    }
    
    // Content counter
    if (contentTextarea && contentCount) {
        contentTextarea.addEventListener('input', function() {
            const currentLength = this.value.length;
            const maxLength = parseInt(this.getAttribute('maxlength')) || 10000;
            
            contentCount.textContent = `${currentLength}/${maxLength}`;
            
            // Update color based on character count
            contentCount.classList.remove('warning', 'danger');
            if (currentLength > maxLength * 0.9) {
                contentCount.classList.add('danger');
            } else if (currentLength > maxLength * 0.7) {
                contentCount.classList.add('warning');
            }
        });
        
        // Initialize counter
        contentTextarea.dispatchEvent(new Event('input'));
    }
}
//endregion

//region Word Count
function initializeWordCount() {
    const contentTextarea = document.getElementById('content');
    
    if (contentTextarea) {
        // Create word count display
        const wordCountDiv = document.createElement('div');
        wordCountDiv.className = 'word-count position-absolute bottom-0 start-0 bg-white px-2 py-1 rounded text-muted';
        wordCountDiv.id = 'wordCount';
        wordCountDiv.style.fontSize = '0.8rem';
        wordCountDiv.style.zIndex = '10';
        
        // Position it relative to the textarea
        const textareaContainer = contentTextarea.parentElement;
        
        // Ensure the container has position relative
        if (!textareaContainer.classList.contains('position-relative')) {
            textareaContainer.classList.add('position-relative');
        }
        
        textareaContainer.appendChild(wordCountDiv);
        
        contentTextarea.addEventListener('input', function() {
            const text = this.value.trim();
            const wordCount = text === '' ? 0 : text.split(/\s+/).filter(word => word.length > 0).length;
            
            if (wordCountDiv) {
                wordCountDiv.textContent = `${wordCount} words`;
            }
        });
        
        // Initialize word count
        contentTextarea.dispatchEvent(new Event('input'));
    }
}
//endregion

//region Form Validation
function initializeFormValidation() {
    const form = document.getElementById('blogForm');
    const inputs = form.querySelectorAll('input[required], textarea[required]');
    
    // Real-time validation for all required fields
    inputs.forEach(input => {
        input.addEventListener('input', validateForm);
        input.addEventListener('blur', function() {
            validateField(this);
        });
    });
}

function validateForm() {
    const form = document.getElementById('blogForm');
    const submitBtn = document.getElementById('submitBtn');
    const errorAlert = document.getElementById('errorAlert');
    const errorMessage = document.getElementById('errorMessage');
    
    // Add null checks to prevent errors
    if (!form || !submitBtn) {
        console.warn('Required form elements not found');
        return false;
    }
    
    let isValid = true;
    let errors = [];
    
    // Validate title
    const title = document.getElementById('title');
    if (title) {
        if (!title.value.trim()) {
            isValid = false;
            errors.push('Please enter a blog title');
        } else if (title.value.length > 255) {
            isValid = false;
            errors.push('Title is too long (maximum 255 characters)');
        }
    }
    
    // Validate content
    const content = document.getElementById('content');
    if (content) {
        if (!content.value.trim()) {
            isValid = false;
            errors.push('Please enter blog content');
        } else if (content.value.length > 10000) {
            isValid = false;
            errors.push('Content is too long (maximum 10,000 characters)');
        } else if (content.value.trim().length < 50) {
            isValid = false;
            errors.push('Content is too short (minimum 50 characters)');
        }
    }
    
    // Update submit button state
    submitBtn.disabled = !isValid;
    
    // Show/hide errors - only if elements exist
    if (errorAlert && errorMessage) {
        if (errors.length > 0 && !isValid) {
            errorMessage.textContent = errors[0];
            errorAlert.classList.remove('d-none');
        } else {
            errorAlert.classList.add('d-none');
        }
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
            // Special validation for content length
            if (field.id === 'content' && value.length < 50) {
                field.classList.add('is-invalid');
            } else if (field.id === 'title' && value.length < 5) {
                field.classList.add('is-invalid');
            } else {
                field.classList.add('is-valid');
            }
        }
    }
}
//endregion

//region Tag System
function initializeTagSystem() {
    const tagsInput = document.getElementById('tags');
    const tagSuggestions = document.getElementById('tagSuggestions');
    
    if (tagsInput) {
        // Show tag suggestions based on input
        tagsInput.addEventListener('input', function() {
            const currentTags = this.value.toLowerCase().split(',').map(tag => tag.trim());
            const lastTag = currentTags[currentTags.length - 1];
            
            if (lastTag.length > 0) {
                showTagSuggestions(lastTag, currentTags);
            } else {
                clearTagSuggestions();
            }
        });
        
        // Handle tag input formatting
        tagsInput.addEventListener('blur', function() {
            formatTags(this);
        });
    }
}

function addTag(tag) {
    const tagsInput = document.getElementById('tags');
    if (!tagsInput) return;
    
    const currentTags = tagsInput.value.split(',').map(t => t.trim()).filter(t => t.length > 0);
    
    // Check if tag already exists
    if (!currentTags.includes(tag)) {
        currentTags.push(tag);
        tagsInput.value = currentTags.join(', ');
        
        // Show feedback
        showSuccessToast(`Added tag: ${tag}`);
        
        // Clear suggestions
        clearTagSuggestions();
        
        // Trigger auto-save
        triggerAutoSave();
    }
}

function showTagSuggestions(inputTag, existingTags) {
    const tagSuggestions = document.getElementById('tagSuggestions');
    if (!tagSuggestions) return;
    
    const allTags = [
        'swimming', 'technique', 'beginner', 'training', 'safety', 'tips',
        'advanced', 'freestyle', 'backstroke', 'breaststroke', 'butterfly',
        'fitness', 'health', 'pool', 'competition', 'coaching', 'drills',
        'breathing', 'stroke', 'endurance', 'speed', 'form', 'equipment'
    ];
    
    const matchingTags = allTags.filter(tag => 
        tag.toLowerCase().includes(inputTag.toLowerCase()) && 
        !existingTags.includes(tag)
    ).slice(0, 5);
    
    if (matchingTags.length > 0) {
        tagSuggestions.innerHTML = matchingTags.map(tag => 
            `<span class="badge bg-secondary cursor-pointer" onclick="addTag('${tag}')">${tag}</span>`
        ).join('');
    } else {
        clearTagSuggestions();
    }
}

function clearTagSuggestions() {
    const tagSuggestions = document.getElementById('tagSuggestions');
    if (tagSuggestions) {
        tagSuggestions.innerHTML = '';
    }
}

function formatTags(tagsInput) {
    // Clean up tags: remove duplicates, trim whitespace, remove empty tags
    const tags = tagsInput.value.split(',')
        .map(tag => tag.trim())
        .filter(tag => tag.length > 0)
        .filter((tag, index, arr) => arr.indexOf(tag) === index); // Remove duplicates
    
    tagsInput.value = tags.join(', ');
}
//endregion

//region Auto-save Functionality
function initializeAutoSave() {
    const form = document.getElementById('blogForm');
    const inputs = form.querySelectorAll('input, textarea, select');
    
    inputs.forEach(input => {
        input.addEventListener('input', debounce(triggerAutoSave, 2000));
    });
    
    // Load draft will be handled separately to avoid double calls
}

function triggerAutoSave() {
    const isEditMode = document.querySelector('input[name="id"]') !== null;
    if (!isEditMode) {
        saveDraft();
    }
}

function saveDraft() {
    const title = document.getElementById('title')?.value || '';
    const content = document.getElementById('content')?.value || '';
    const courseId = document.getElementById('course_id')?.value || '';
    const tags = document.getElementById('tags')?.value || '';
    
    // Don't save empty drafts
    if (!title.trim() && !content.trim()) {
        return;
    }
    
    const draft = {
        title: title,
        content: content,
        courseId: courseId,
        tags: tags,
        timestamp: new Date().toISOString()
    };
    
    try {
        localStorage.setItem('blog_draft', JSON.stringify(draft));
        updateAutoSaveStatus('saved');
        
        // Show notification
        showDraftNotification('Draft saved automatically');
    } catch (e) {
        console.error('Failed to save draft:', e);
        updateAutoSaveStatus('error');
    }
}

function loadDraft() {
    const draftData = localStorage.getItem('blog_draft');
    if (!draftData) return;
    
    try {
        const draft = JSON.parse(draftData);
        
        // Check if draft is recent (within 7 days)
        const draftAge = Date.now() - new Date(draft.timestamp).getTime();
        const maxAge = 7 * 24 * 60 * 60 * 1000; // 7 days
        
        if (draftAge > maxAge) {
            localStorage.removeItem('blog_draft');
            return;
        }
        
        // Ask user if they want to load the draft
        if (confirm('A draft was found. Would you like to load it?')) {
            document.getElementById('title').value = draft.title || '';
            document.getElementById('content').value = draft.content || '';
            document.getElementById('course_id').value = draft.courseId || '';
            document.getElementById('tags').value = draft.tags || '';
            
            // Update character counters
            document.getElementById('title').dispatchEvent(new Event('input'));
            document.getElementById('content').dispatchEvent(new Event('input'));
            
            showSuccessToast('Draft loaded successfully');
        }
    } catch (e) {
        console.error('Failed to load draft:', e);
        localStorage.removeItem('blog_draft');
    }
}

function clearDraft() {
    localStorage.removeItem('blog_draft');
    updateAutoSaveStatus('');
}

function updateAutoSaveStatus(status) {
    const autoSaveStatus = document.getElementById('autoSaveStatus');
    if (!autoSaveStatus) return;
    
    autoSaveStatus.classList.remove('saving', 'saved', 'error');
    
    switch (status) {
        case 'saving':
            autoSaveStatus.classList.add('saving');
            autoSaveStatus.innerHTML = '<i class="fas fa-sync fa-spin me-2"></i><small>Saving...</small>';
            break;
        case 'saved':
            autoSaveStatus.classList.add('saved');
            autoSaveStatus.innerHTML = '<i class="fas fa-check me-2"></i><small>Draft saved</small>';
            break;
        case 'error':
            autoSaveStatus.classList.add('error');
            autoSaveStatus.innerHTML = '<i class="fas fa-exclamation-triangle me-2"></i><small>Save failed</small>';
            break;
        default:
            autoSaveStatus.innerHTML = '<i class="fas fa-cloud me-2"></i><small>Auto-save enabled</small>';
    }
}
//endregion

//region Form Submission
function initializeFormSubmission() {
    const form = document.getElementById('blogForm');
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
        const originalText = submitBtn.innerHTML;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Publishing...';
        
        // Add loading toast
        const isEditMode = document.querySelector('input[name="id"]') !== null;
        showLoadingToast(isEditMode ? 'Updating blog post...' : 'Publishing blog post...');
        
        // Clear draft if creating new blog
        if (!isEditMode) {
            clearDraft();
        }
        
        // Submit the form after a brief delay (for UX)
        setTimeout(() => {
            form.submit();
        }, 1000);
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

// Show draft notification
function showDraftNotification(message) {
    // Remove existing notification
    const existingNotification = document.querySelector('.draft-notification');
    if (existingNotification) {
        existingNotification.remove();
    }
    
    // Create new notification
    const notification = document.createElement('div');
    notification.className = 'draft-notification';
    notification.innerHTML = `<i class="fas fa-save me-2"></i>${message}`;
    
    document.body.appendChild(notification);
    
    // Show notification
    setTimeout(() => {
        notification.classList.add('show');
    }, 100);
    
    // Hide notification after 3 seconds
    setTimeout(() => {
        notification.classList.remove('show');
        setTimeout(() => {
            if (notification.parentNode) {
                notification.remove();
            }
        }, 300);
    }, 3000);
}

// Enhanced error handling
window.addEventListener('error', function(e) {
    console.error('JavaScript error:', e.error);
    showErrorToast('An unexpected error occurred. Please try again.');
});

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

// Keyboard shortcuts
document.addEventListener('keydown', function(e) {
    // Ctrl/Cmd + S to save draft
    if ((e.ctrlKey || e.metaKey) && e.key === 's') {
        e.preventDefault();
        if (!document.querySelector('input[name="id"]')) {
            saveDraft();
            showSuccessToast('Draft saved manually');
        }
    }
    
    // Ctrl/Cmd + Enter to submit form
    if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
        e.preventDefault();
        const submitBtn = document.getElementById('submitBtn');
        if (!submitBtn.disabled) {
            submitBtn.click();
        }
    }
});

// Warn user about unsaved changes
window.addEventListener('beforeunload', function(e) {
    const title = document.getElementById('title')?.value || '';
    const content = document.getElementById('content')?.value || '';
    
    // Check if there are unsaved changes
    if ((title.trim() || content.trim()) && !document.querySelector('.btn.loading')) {
        e.preventDefault();
        e.returnValue = 'You have unsaved changes. Are you sure you want to leave?';
        return e.returnValue;
    }
});

// Content preview functionality
function previewContent() {
    const content = document.getElementById('content').value;
    const title = document.getElementById('title').value;
    
    if (!content.trim()) {
        showErrorToast('Please add some content to preview');
        return;
    }
    
    // Create preview modal
    const previewModal = document.createElement('div');
    previewModal.className = 'modal fade';
    previewModal.innerHTML = `
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-eye me-2"></i>Blog Preview</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <h2>${title || 'Untitled Blog Post'}</h2>
                    <hr>
                    <div class="content-preview">${content.replace(/\n/g, '<br>')}</div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    `;
    
    document.body.appendChild(previewModal);
    
    const modal = new bootstrap.Modal(previewModal);
    modal.show();
    
    // Remove modal from DOM when hidden
    previewModal.addEventListener('hidden.bs.modal', function() {
        previewModal.remove();
    });
}
//endregion

// Export functions for global access (for JSP usage)
window.saveDraft = saveDraft;
window.loadDraft = loadDraft;
window.addTag = addTag;
window.previewContent = previewContent;
window.showSuccessToast = showSuccessToast;
window.showErrorToast = showErrorToast;
window.showLoadingToast = showLoadingToast;
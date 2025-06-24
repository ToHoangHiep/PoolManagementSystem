// Blog Detail Page JavaScript functionality
document.addEventListener('DOMContentLoaded', function() {
    initializeBlogDetail();
});

function initializeBlogDetail() {
    // Initialize all page features
    setupModalInteractions();
    setupCommentFunctionality();
    setupScrollToComment();
    setupKeyboardShortcuts();
    autoHideAlerts();
}

// Modal interactions for guest users
function showInteractionModal(action) {
    const modal = document.getElementById('interactionModal');
    const message = document.getElementById('modalMessage');
    
    if (modal && message) {
        switch(action) {
            case 'comment':
                message.textContent = 'Please sign in to comment on blog posts and join the conversation.';
                break;
            case 'edit':
                message.textContent = 'Please sign in to edit content.';
                break;
            default:
                message.textContent = 'Please sign in to interact with blog posts.';
        }
        
        modal.style.display = 'flex';
    }
}

function hideInteractionModal() {
    const modal = document.getElementById('interactionModal');
    if (modal) {
        modal.style.display = 'none';
    }
}

function setupModalInteractions() {
    // Close modal when clicking outside
    const modal = document.getElementById('interactionModal');
    if (modal) {
        modal.addEventListener('click', function(e) {
            if (e.target === this) {
                hideInteractionModal();
            }
        });
    }
    
    // Escape key to close modal
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            hideInteractionModal();
        }
    });
}

// Comment functionality
function setupCommentFunctionality() {
    // Auto-resize comment textareas
    const textareas = document.querySelectorAll('.form-control.textarea');
    textareas.forEach(textarea => {
        autoResizeTextarea(textarea);
        textarea.addEventListener('input', function() {
            autoResizeTextarea(this);
        });
    });
    
    // Add character counter to comment forms
    const commentTextarea = document.getElementById('content');
    if (commentTextarea) {
        addCommentCharacterCounter(commentTextarea);
    }
    
    // Setup edit form textareas
    const editTextareas = document.querySelectorAll('.edit-form textarea');
    editTextareas.forEach(textarea => {
        addCommentCharacterCounter(textarea);
    });
}

function autoResizeTextarea(textarea) {
    textarea.style.height = 'auto';
    textarea.style.height = textarea.scrollHeight + 'px';
}

function addCommentCharacterCounter(textarea) {
    const maxLength = 1000;
    const counter = document.createElement('div');
    counter.className = 'char-counter';
    counter.style.cssText = `
        text-align: right;
        font-size: 0.8rem;
        color: #6c757d;
        margin-top: 0.25rem;
    `;
    
    textarea.parentNode.appendChild(counter);
    
    function updateCounter() {
        const currentLength = textarea.value.length;
        const remaining = maxLength - currentLength;
        counter.textContent = `${currentLength}/${maxLength} characters`;
        
        // Update counter styling
        if (remaining < maxLength * 0.1) {
            counter.style.color = '#dc3545';
        } else if (remaining < maxLength * 0.2) {
            counter.style.color = '#fd7e14';
        } else {
            counter.style.color = '#6c757d';
        }
    }
    
    textarea.addEventListener('input', updateCounter);
    updateCounter(); // Initial update
}

// Blog and comment deletion confirmations
function confirmDelete(blogId) {
    if (confirm('Are you sure you want to delete this blog? This action cannot be undone and will also delete all comments.')) {
        showLoadingState();
        window.location.href = 'blogs?action=delete&id=' + blogId;
    }
}

function confirmDeleteComment(commentId, blogId) {
    if (confirm('Are you sure you want to delete this comment?')) {
        showLoadingState();
        window.location.href = 'blogs?action=delete_comment&comment_id=' + commentId + '&blog_id=' + blogId;
    }
}

// Comment editing functionality
function toggleEditComment(commentId) {
    const editForm = document.getElementById('edit-form-' + commentId);
    const content = document.getElementById('content-' + commentId);
    
    if (editForm && content) {
        if (editForm.classList.contains('active')) {
            editForm.classList.remove('active');
            content.style.display = 'block';
        } else {
            editForm.classList.add('active');
            content.style.display = 'none';
            
            const textarea = editForm.querySelector('textarea');
            if (textarea) {
                textarea.focus();
                autoResizeTextarea(textarea);
                
                // Position cursor at end
                textarea.setSelectionRange(textarea.value.length, textarea.value.length);
            }
        }
    }
}

// Loading state management
function showLoadingState() {
    // Add loading overlay
    const overlay = document.createElement('div');
    overlay.id = 'loading-overlay';
    overlay.style.cssText = `
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0, 0, 0, 0.5);
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 9999;
    `;
    
    overlay.innerHTML = `
        <div style="background: white; padding: 2rem; border-radius: 10px; text-align: center;">
            <i class="fas fa-spinner fa-spin" style="font-size: 2rem; color: #667eea; margin-bottom: 1rem;"></i>
            <p style="margin: 0; color: #333;">Processing...</p>
        </div>
    `;
    
    document.body.appendChild(overlay);
}

// Scroll to comment functionality
function setupScrollToComment() {
    // Check if there's a comment hash in URL
    const hash = window.location.hash;
    if (hash && hash.startsWith('#comment-')) {
        setTimeout(() => {
            const element = document.querySelector(hash);
            if (element) {
                element.scrollIntoView({ behavior: 'smooth', block: 'center' });
                element.style.background = '#fff3cd';
                setTimeout(() => {
                    element.style.background = '';
                }, 3000);
            }
        }, 500);
    }
}

// Add comment link functionality
function shareComment(commentId) {
    const url = window.location.origin + window.location.pathname + '#comment-' + commentId;
    
    if (navigator.share) {
        navigator.share({
            title: 'Blog Comment',
            url: url
        });
    } else if (navigator.clipboard) {
        navigator.clipboard.writeText(url).then(() => {
            showNotification('Comment link copied to clipboard!');
        });
    } else {
        // Fallback
        const input = document.createElement('input');
        input.value = url;
        document.body.appendChild(input);
        input.select();
        document.execCommand('copy');
        document.body.removeChild(input);
        showNotification('Comment link copied to clipboard!');
    }
}

// Keyboard shortcuts
function setupKeyboardShortcuts() {
    document.addEventListener('keydown', function(e) {
        // Escape to close modal
        if (e.key === 'Escape') {
            hideInteractionModal();
        }
        
        // Ctrl/Cmd + Enter to submit comment
        if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
            const activeTextarea = document.activeElement;
            if (activeTextarea.tagName === 'TEXTAREA') {
                const form = activeTextarea.closest('form');
                if (form) {
                    const submitButton = form.querySelector('button[type="submit"]');
                    if (submitButton) {
                        submitButton.click();
                    }
                }
            }
        }
        
        // Ctrl/Cmd + K to focus on comment box
        if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
            e.preventDefault();
            const commentTextarea = document.getElementById('content');
            if (commentTextarea) {
                commentTextarea.focus();
                commentTextarea.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        }
    });
}

// Auto-hide alerts
function autoHideAlerts() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.transition = 'opacity 0.3s ease';
            alert.style.opacity = '0';
            setTimeout(() => {
                if (alert.parentNode) {
                    alert.remove();
                }
            }, 300);
        }, 5000);
    });
}

// Show notification
function showNotification(message, type = 'success') {
    const notification = document.createElement('div');
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: ${type === 'success' ? '#28a745' : '#dc3545'};
        color: white;
        padding: 1rem 1.5rem;
        border-radius: 5px;
        font-size: 0.9rem;
        z-index: 1000;
        opacity: 0;
        transition: opacity 0.3s ease;
        box-shadow: 0 4px 8px rgba(0,0,0,0.2);
    `;
    notification.textContent = message;
    document.body.appendChild(notification);
    
    // Fade in
    setTimeout(() => {
        notification.style.opacity = '1';
    }, 100);
    
    // Fade out and remove
    setTimeout(() => {
        notification.style.opacity = '0';
        setTimeout(() => {
            if (notification.parentNode) {
                notification.remove();
            }
        }, 300);
    }, 3000);
}

// Like functionality (if implemented)
function toggleLike(blogId) {
    fetch('blogs?action=toggle_like&id=' + blogId, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            const likeButton = document.querySelector('.like-button');
            const likeCount = document.querySelector('.like-count');
            
            if (likeButton && likeCount) {
                likeButton.classList.toggle('liked');
                likeCount.textContent = data.likes + ' likes';
            }
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showNotification('An error occurred. Please try again.', 'error');
    });
}

// Reading progress indicator
function setupReadingProgress() {
    const progressBar = document.createElement('div');
    progressBar.style.cssText = `
        position: fixed;
        top: 0;
        left: 0;
        width: 0%;
        height: 3px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        z-index: 1000;
        transition: width 0.1s ease;
    `;
    document.body.appendChild(progressBar);
    
    window.addEventListener('scroll', () => {
        const scrollTop = window.pageYOffset;
        const docHeight = document.documentElement.scrollHeight - window.innerHeight;
        const scrollPercent = (scrollTop / docHeight) * 100;
        progressBar.style.width = scrollPercent + '%';
    });
}

// Initialize reading progress on load
document.addEventListener('DOMContentLoaded', function() {
    setupReadingProgress();
});

// Export functions for global access
window.BlogDetail = {
    showInteractionModal,
    hideInteractionModal,
    confirmDelete,
    confirmDeleteComment,
    toggleEditComment,
    shareComment,
    toggleLike,
    showNotification
};
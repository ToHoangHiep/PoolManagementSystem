//region Initialization
// Initialize all functionality when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    initializeCharacterCounter();
    initializeFormValidation();
    initializeAutoScroll();
    initializeBootstrapComponents();
    initializeMessageAnimations();
    initializeKeyboardShortcuts();
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

//region Character Counter
function initializeCharacterCounter() {
    const textarea = document.getElementById('replyContent');
    const counter = document.getElementById('charCount');
    
    if (textarea && counter) {
        // Update counter on input
        textarea.addEventListener('input', function() {
            const currentLength = this.value.length;
            const maxLength = parseInt(this.getAttribute('maxlength')) || 500;
            
            counter.textContent = currentLength;
            
            // Change color based on character count
            if (currentLength > maxLength * 0.9) {
                counter.style.color = '#dc3545'; // Red when near limit
            } else if (currentLength > maxLength * 0.7) {
                counter.style.color = '#fd7e14'; // Orange when getting close
            } else {
                counter.style.color = '#6c757d'; // Default gray
            }
            
            // Update character counter background
            const percentage = (currentLength / maxLength) * 100;
            if (percentage > 90) {
                counter.parentElement.style.background = 'rgba(220, 53, 69, 0.1)';
            } else if (percentage > 70) {
                counter.parentElement.style.background = 'rgba(253, 126, 20, 0.1)';
            } else {
                counter.parentElement.style.background = 'rgba(255, 255, 255, 0.9)';
            }
        });
        
        // Initialize counter
        textarea.dispatchEvent(new Event('input'));
    }
}
//endregion

//region Form Validation
function initializeFormValidation() {
    const form = document.getElementById('replyForm');
    const textarea = document.getElementById('replyContent');
    const submitBtn = form ? form.querySelector('button[type="submit"]') : null;
    
    if (!form || !textarea || !submitBtn) return;
    
    // Real-time validation
    textarea.addEventListener('input', function() {
        const content = this.value.trim();
        const isValid = content.length > 0 && content.length <= 500;
        
        // Update button state
        submitBtn.disabled = !isValid;
        
        // Update textarea styling
        if (content.length === 0) {
            this.classList.remove('is-valid', 'is-invalid');
        } else if (isValid) {
            this.classList.add('is-valid');
            this.classList.remove('is-invalid');
        } else {
            this.classList.add('is-invalid');
            this.classList.remove('is-valid');
        }
    });
    
    // Form submission handling
    form.addEventListener('submit', function(e) {
        const content = textarea.value.trim();
        
        if (content.length === 0) {
            e.preventDefault();
            showErrorToast('Please enter a reply message.');
            textarea.focus();
            return;
        }
        
        if (content.length > 500) {
            e.preventDefault();
            showErrorToast('Reply message is too long. Maximum 500 characters allowed.');
            textarea.focus();
            return;
        }
        
        // Show loading state
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Sending...';
        
        // Add loading message to chat
        addLoadingMessage();
    });
}
//endregion

//region Auto Scroll Functionality
function initializeAutoScroll() {
    const chatMessages = document.getElementById('chatMessages');
    if (!chatMessages) return;
    
    // Scroll to bottom on page load
    scrollToBottom();
    
    // Auto-scroll when new content is added
    const observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            if (mutation.type === 'childList' && mutation.addedNodes.length > 0) {
                // Check if user is near bottom before auto-scrolling
                if (isNearBottom()) {
                    scrollToBottom();
                }
            }
        });
    });
    
    observer.observe(chatMessages, {
        childList: true,
        subtree: true
    });
    
    // Smooth scroll button
    addScrollToBottomButton();
}

function scrollToBottom() {
    const chatMessages = document.getElementById('chatMessages');
    if (chatMessages) {
        chatMessages.scrollTo({
            top: chatMessages.scrollHeight,
            behavior: 'smooth'
        });
    }
}

function isNearBottom() {
    const chatMessages = document.getElementById('chatMessages');
    if (!chatMessages) return true;
    
    const threshold = 100; // pixels from bottom
    return chatMessages.scrollHeight - chatMessages.scrollTop - chatMessages.clientHeight < threshold;
}

function addScrollToBottomButton() {
    const chatMessages = document.getElementById('chatMessages');
    if (!chatMessages) return;
    
    // Create scroll button
    const scrollBtn = document.createElement('button');
    scrollBtn.className = 'btn btn-primary btn-sm position-fixed';
    scrollBtn.style.cssText = `
        bottom: 120px;
        right: 30px;
        z-index: 1000;
        border-radius: 50%;
        width: 45px;
        height: 45px;
        display: none;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    `;
    scrollBtn.innerHTML = '<i class="fas fa-chevron-down"></i>';
    scrollBtn.title = 'Scroll to bottom';
    
    document.body.appendChild(scrollBtn);
    
    // Show/hide button based on scroll position
    chatMessages.addEventListener('scroll', function() {
        if (isNearBottom()) {
            scrollBtn.style.display = 'none';
        } else {
            scrollBtn.style.display = 'flex';
            scrollBtn.style.alignItems = 'center';
            scrollBtn.style.justifyContent = 'center';
        }
    });
    
    // Button click handler
    scrollBtn.addEventListener('click', scrollToBottom);
}
//endregion

//region Message Animations
function initializeMessageAnimations() {
    // Add entrance animation to existing messages
    const messages = document.querySelectorAll('.message');
    messages.forEach((message, index) => {
        message.style.animationDelay = `${index * 0.1}s`;
    });
    
    // Intersection Observer for message animations
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, {
        threshold: 0.1,
        rootMargin: '50px'
    });
    
    messages.forEach(message => observer.observe(message));
}

function addLoadingMessage() {
    const chatMessages = document.getElementById('chatMessages');
    if (!chatMessages) return;
    
    const loadingMessage = document.createElement('div');
    loadingMessage.className = 'message message-sent loading-message';
    loadingMessage.innerHTML = `
        <div class="d-inline-block position-relative" style="max-width: 70%;">
            <div class="message-bubble p-3 rounded-3 bg-secondary text-white">
                <div class="message-content d-flex align-items-center">
                    <i class="fas fa-spinner fa-spin me-2"></i>
                    Sending message...
                </div>
            </div>
        </div>
    `;
    
    chatMessages.appendChild(loadingMessage);
    scrollToBottom();
    
    return loadingMessage;
}

function removeLoadingMessage() {
    const loadingMessage = document.querySelector('.loading-message');
    if (loadingMessage) {
        loadingMessage.remove();
    }
}
//endregion

//region Keyboard Shortcuts
function initializeKeyboardShortcuts() {
    const textarea = document.getElementById('replyContent');
    if (!textarea) return;
    
    textarea.addEventListener('keydown', function(e) {
        // Ctrl/Cmd + Enter to send message
        if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
            e.preventDefault();
            const form = document.getElementById('replyForm');
            if (form) {
                form.dispatchEvent(new Event('submit'));
            }
        }
        
        // Shift + Enter for new line (default behavior)
        if (e.shiftKey && e.key === 'Enter') {
            // Allow default behavior (new line)
            return;
        }
        
        // Tab to navigate (accessibility)
        if (e.key === 'Tab') {
            // Allow default tab behavior
            return;
        }
    });
    
    // Add hint about keyboard shortcuts
    const hint = document.createElement('small');
    hint.className = 'text-muted mt-1 d-block';
    hint.innerHTML = '<i class="fas fa-keyboard me-1"></i>Press Ctrl+Enter to send, Shift+Enter for new line';
    
    const formContainer = textarea.closest('.col');
    if (formContainer) {
        formContainer.appendChild(hint);
    }
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

// Format timestamp
function formatTimestamp(timestamp) {
    const date = new Date(timestamp);
    const now = new Date();
    const diffMs = now - date;
    const diffMins = Math.floor(diffMs / 60000);
    const diffHours = Math.floor(diffMs / 3600000);
    const diffDays = Math.floor(diffMs / 86400000);
    
    if (diffMins < 1) return 'Just now';
    if (diffMins < 60) return `${diffMins}m ago`;
    if (diffHours < 24) return `${diffHours}h ago`;
    if (diffDays < 7) return `${diffDays}d ago`;
    
    return date.toLocaleDateString();
}

// Add new message to chat (for real-time updates)
function addNewMessage(messageData) {
    const chatMessages = document.getElementById('chatMessages');
    if (!chatMessages) return;
    
    // Remove loading message if exists
    removeLoadingMessage();
    
    const isCurrentUser = messageData.isCurrentUser;
    const messageHTML = `
        <div class="message mb-3 ${isCurrentUser ? 'text-end' : 'text-start'} new-message">
            <div class="d-inline-block position-relative" style="max-width: 70%;">
                <div class="message-bubble p-3 rounded-3 ${isCurrentUser ? 'bg-primary text-white' : 'bg-light border'}">
                    <div class="message-header mb-2">
                        <div class="d-flex align-items-center justify-content-between">
                            <small class="${isCurrentUser ? 'text-white-50' : 'text-muted'} fw-semibold">
                                <i class="fas fa-user me-1"></i>${messageData.userName}
                            </small>
                            <small class="${isCurrentUser ? 'text-white-50' : 'text-muted'}">
                                <i class="fas fa-clock me-1"></i>Just now
                            </small>
                        </div>
                    </div>
                    <div class="message-content">
                        ${messageData.content}
                    </div>
                </div>
            </div>
        </div>
    `;
    
    chatMessages.insertAdjacentHTML('beforeend', messageHTML);
    scrollToBottom();
    
    // Remove new-message class after animation
    setTimeout(() => {
        const newMessage = chatMessages.querySelector('.new-message');
        if (newMessage) {
            newMessage.classList.remove('new-message');
        }
    }, 500);
}

// Copy message content to clipboard
function copyMessageContent(button) {
    const messageContent = button.closest('.message-bubble').querySelector('.message-content').textContent;
    
    if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(messageContent).then(() => {
            showSuccessToast('Message copied to clipboard');
        }).catch(() => {
            fallbackCopyTextToClipboard(messageContent);
        });
    } else {
        fallbackCopyTextToClipboard(messageContent);
    }
}

function fallbackCopyTextToClipboard(text) {
    const textArea = document.createElement("textarea");
    textArea.value = text;
    textArea.style.top = "0";
    textArea.style.left = "0";
    textArea.style.position = "fixed";
    
    document.body.appendChild(textArea);
    textArea.focus();
    textArea.select();
    
    try {
        const successful = document.execCommand('copy');
        if (successful) {
            showSuccessToast('Message copied to clipboard');
        } else {
            showErrorToast('Failed to copy message');
        }
    } catch (err) {
        showErrorToast('Failed to copy message');
    }
    
    document.body.removeChild(textArea);
}

// Enhanced error handling
window.addEventListener('error', function(e) {
    console.error('JavaScript error:', e.error);
    showErrorToast('An unexpected error occurred. Please refresh the page.');
});

// Enhanced form reset
function resetForm() {
    const form = document.getElementById('replyForm');
    const textarea = document.getElementById('replyContent');
    const submitBtn = form ? form.querySelector('button[type="submit"]') : null;
    
    if (form) form.reset();
    if (textarea) {
        textarea.classList.remove('is-valid', 'is-invalid');
        textarea.dispatchEvent(new Event('input')); // Update character counter
    }
    if (submitBtn) {
        submitBtn.disabled = false;
        submitBtn.innerHTML = '<i class="fas fa-paper-plane me-2"></i>Send';
    }
    
    removeLoadingMessage();
}
//endregion

// Export functions for global access
window.showSuccessToast = showSuccessToast;
window.showErrorToast = showErrorToast;
window.showLoadingToast = showLoadingToast;
window.addNewMessage = addNewMessage;
window.copyMessageContent = copyMessageContent;
window.resetForm = resetForm;
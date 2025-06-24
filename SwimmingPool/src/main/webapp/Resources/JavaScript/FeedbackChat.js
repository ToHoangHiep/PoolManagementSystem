//region Initialization
document.addEventListener('DOMContentLoaded', function() {
    initializeCharCounter();
    scrollToBottom();
    initializeFormValidation();
});
//endregion

//region Character Counter
function initializeCharCounter() {
    const textarea = document.getElementById('replyContent');
    const charCount = document.getElementById('charCount');
    
    if (textarea && charCount) {
        textarea.addEventListener('input', function() {
            const currentLength = this.value.length;
            charCount.textContent = currentLength;
            
            // Update color based on character count
            if (currentLength > 450) {
                charCount.style.color = '#dc3545';
            } else if (currentLength > 400) {
                charCount.style.color = '#fd7e14';
            } else {
                charCount.style.color = '#6c757d';
            }
        });
    }
}
//endregion

//region Chat Functionality
function scrollToBottom() {
    const chatMessages = document.getElementById('chatMessages');
    if (chatMessages) {
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }
}

function addNewMessage(content, isCurrentUser = true, userName = 'You', timestamp = null) {
    const chatMessages = document.getElementById('chatMessages');
    const noMessages = chatMessages.querySelector('.no-messages');
    
    // Remove "no messages" placeholder if it exists
    if (noMessages) {
        noMessages.remove();
    }
    
    // Create new message element
    const messageDiv = document.createElement('div');
    messageDiv.className = `message ${isCurrentUser ? 'message-sent' : 'message-received'}`;
    
    const currentTime = timestamp || new Date().toLocaleString();
    
    messageDiv.innerHTML = `
        <div class="message-bubble">
            <div class="message-header">
                <span class="message-author">
                    <i class="fas fa-user"></i>
                    ${userName}
                </span>
                <span class="message-time">
                    <i class="fas fa-clock"></i>
                    ${currentTime}
                </span>
            </div>
            <div class="message-content">
                ${content}
            </div>
        </div>
    `;
    
    chatMessages.appendChild(messageDiv);
    
    // Animate in the new message
    messageDiv.style.opacity = '0';
    messageDiv.style.transform = 'translateY(20px)';
    
    setTimeout(() => {
        messageDiv.style.transition = 'all 0.3s ease';
        messageDiv.style.opacity = '1';
        messageDiv.style.transform = 'translateY(0)';
    }, 50);
    
    scrollToBottom();
}
//endregion

//region Form Validation
function initializeFormValidation() {
    const form = document.getElementById('replyForm');
    const textarea = document.getElementById('replyContent');
    const sendButton = form.querySelector('.btn-send');
    
    if (form && textarea && sendButton) {
        // Real-time validation
        textarea.addEventListener('input', function() {
            const content = this.value.trim();
            
            if (content.length === 0) {
                sendButton.disabled = true;
                sendButton.innerHTML = '<i class="fas fa-paper-plane"></i> Send Reply';
            } else if (content.length > 500) {
                sendButton.disabled = true;
                sendButton.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Too Long';
            } else {
                sendButton.disabled = false;
                sendButton.innerHTML = '<i class="fas fa-paper-plane"></i> Send Reply';
            }
        });
        
        // Form submission
        form.addEventListener('submit', function(e) {
            const content = textarea.value.trim();
            
            if (content.length === 0) {
                e.preventDefault();
                showError('Please enter a reply before sending.');
                return;
            }
            
            if (content.length > 500) {
                e.preventDefault();
                showError('Reply is too long. Maximum 500 characters allowed.');
                return;
            }
            
            // Show loading state
            sendButton.disabled = true;
            sendButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Sending...';
        });
        
        // Handle Enter key (Shift+Enter for new line, Enter to send)
        textarea.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                if (!sendButton.disabled) {
                    form.submit();
                }
            }
        });
    }
}

function showError(message) {
    // Remove existing error if any
    const existingError = document.querySelector('.error-message');
    if (existingError) {
        existingError.remove();
    }
    
    // Create new error message
    const errorDiv = document.createElement('div');
    errorDiv.className = 'error-message';
    errorDiv.innerHTML = `
        <i class="fas fa-exclamation-triangle"></i>
        ${message}
    `;
    
    const form = document.getElementById('replyForm');
    form.appendChild(errorDiv);
    
    // Auto-remove error after 5 seconds
    setTimeout(() => {
        if (errorDiv.parentNode) {
            errorDiv.remove();
        }
    }, 5000);
}
//endregion
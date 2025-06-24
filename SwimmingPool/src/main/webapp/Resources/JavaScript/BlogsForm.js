// Blog Form JavaScript functionality
document.addEventListener('DOMContentLoaded', function() {
    initializeBlogForm();
});

function initializeBlogForm() {
    // Initialize all form features
    setupAutoResizeTextarea();
    setupFormValidation();
    setupCharacterCounter();
    setupTagSuggestions();
    setupFormSubmission();
    setupAutoSave();
    setupKeyboardShortcuts();
}

// Auto-resize textarea functionality
function setupAutoResizeTextarea() {
    const textarea = document.getElementById('content');
    if (textarea) {
        // Initial resize
        autoResizeTextarea(textarea);
        
        // Resize on input
        textarea.addEventListener('input', function() {
            autoResizeTextarea(this);
        });
        
        // Resize on paste
        textarea.addEventListener('paste', function() {
            setTimeout(() => autoResizeTextarea(this), 0);
        });
    }
}

function autoResizeTextarea(textarea) {
    textarea.style.height = 'auto';
    textarea.style.height = textarea.scrollHeight + 'px';
}

// Form validation
function setupFormValidation() {
    const form = document.querySelector('form');
    const titleInput = document.getElementById('title');
    const contentTextarea = document.getElementById('content');
    
    if (form) {
        form.addEventListener('submit', function(e) {
            if (!validateForm()) {
                e.preventDefault();
                return false;
            }
            
            // Show loading state
            showLoadingState();
        });
    }
    
    // Real-time validation
    if (titleInput) {
        titleInput.addEventListener('blur', () => validateTitle());
        titleInput.addEventListener('input', debounce(() => validateTitle(), 300));
    }
    
    if (contentTextarea) {
        contentTextarea.addEventListener('blur', () => validateContent());
        contentTextarea.addEventListener('input', debounce(() => validateContent(), 300));
    }
}

function validateForm() {
    const titleValid = validateTitle();
    const contentValid = validateContent();
    
    return titleValid && contentValid;
}

function validateTitle() {
    const titleInput = document.getElementById('title');
    const title = titleInput.value.trim();
    
    if (title.length === 0) {
        showFieldError(titleInput, 'Title is required');
        return false;
    }
    
    if (title.length > 255) {
        showFieldError(titleInput, 'Title must be less than 255 characters');
        return false;
    }
    
    if (title.length < 3) {
        showFieldError(titleInput, 'Title must be at least 3 characters');
        return false;
    }
    
    showFieldSuccess(titleInput);
    return true;
}

function validateContent() {
    const contentTextarea = document.getElementById('content');
    const content = contentTextarea.value.trim();
    
    if (content.length === 0) {
        showFieldError(contentTextarea, 'Content is required');
        return false;
    }
    
    if (content.length < 10) {
        showFieldError(contentTextarea, 'Content must be at least 10 characters');
        return false;
    }
    
    if (content.length > 10000) {
        showFieldError(contentTextarea, 'Content must be less than 10,000 characters');
        return false;
    }
    
    showFieldSuccess(contentTextarea);
    return true;
}

function showFieldError(field, message) {
    field.classList.remove('is-valid');
    field.classList.add('is-invalid');
    
    // Remove existing feedback
    const existingFeedback = field.parentNode.querySelector('.invalid-feedback');
    if (existingFeedback) {
        existingFeedback.remove();
    }
    
    // Add new feedback
    const feedback = document.createElement('div');
    feedback.className = 'invalid-feedback';
    feedback.textContent = message;
    field.parentNode.appendChild(feedback);
}

function showFieldSuccess(field) {
    field.classList.remove('is-invalid');
    field.classList.add('is-valid');
    
    // Remove error feedback
    const existingFeedback = field.parentNode.querySelector('.invalid-feedback');
    if (existingFeedback) {
        existingFeedback.remove();
    }
}

// Character counter
function setupCharacterCounter() {
    const titleInput = document.getElementById('title');
    const contentTextarea = document.getElementById('content');
    
    if (titleInput) {
        addCharacterCounter(titleInput, 255);
    }
    
    if (contentTextarea) {
        addCharacterCounter(contentTextarea, 10000);
    }
}

function addCharacterCounter(element, maxLength) {
    const counter = document.createElement('div');
    counter.className = 'char-counter';
    element.parentNode.appendChild(counter);
    
    function updateCounter() {
        const currentLength = element.value.length;
        const remaining = maxLength - currentLength;
        counter.textContent = `${currentLength}/${maxLength} characters`;
        
        // Update counter styling
        counter.classList.remove('warning', 'danger');
        if (remaining < maxLength * 0.1) {
            counter.classList.add('danger');
        } else if (remaining < maxLength * 0.2) {
            counter.classList.add('warning');
        }
    }
    
    element.addEventListener('input', updateCounter);
    updateCounter(); // Initial update
}

// Tag suggestions
function setupTagSuggestions() {
    const tagsInput = document.getElementById('tags');
    if (!tagsInput) return;
    
    const commonTags = [
        'swimming', 'fitness', 'health', 'technique', 'training',
        'beginner', 'advanced', 'safety', 'equipment', 'nutrition',
        'competition', 'pool', 'workout', 'tips', 'guide'
    ];
    
    let suggestionsContainer = null;
    let currentSuggestionIndex = -1;
    
    tagsInput.addEventListener('input', function() {
        const value = this.value;
        const lastCommaIndex = value.lastIndexOf(',');
        const currentTag = value.substring(lastCommaIndex + 1).trim().toLowerCase();
        
        if (currentTag.length > 0) {
            const matches = commonTags.filter(tag => 
                tag.toLowerCase().includes(currentTag) && 
                !value.toLowerCase().includes(tag.toLowerCase())
            );
            
            if (matches.length > 0) {
                showTagSuggestions(matches, currentTag);
            } else {
                hideTagSuggestions();
            }
        } else {
            hideTagSuggestions();
        }
    });
    
    tagsInput.addEventListener('keydown', function(e) {
        if (!suggestionsContainer || suggestionsContainer.style.display === 'none') return;
        
        const suggestions = suggestionsContainer.querySelectorAll('.tag-suggestion');
        
        switch(e.key) {
            case 'ArrowDown':
                e.preventDefault();
                currentSuggestionIndex = Math.min(currentSuggestionIndex + 1, suggestions.length - 1);
                updateSuggestionSelection(suggestions);
                break;
            case 'ArrowUp':
                e.preventDefault();
                currentSuggestionIndex = Math.max(currentSuggestionIndex - 1, 0);
                updateSuggestionSelection(suggestions);
                break;
            case 'Enter':
            case 'Tab':
                if (currentSuggestionIndex >= 0) {
                    e.preventDefault();
                    selectSuggestion(suggestions[currentSuggestionIndex].textContent);
                }
                break;
            case 'Escape':
                hideTagSuggestions();
                break;
        }
    });
    
    function showTagSuggestions(matches, currentTag) {
        if (!suggestionsContainer) {
            suggestionsContainer = document.createElement('div');
            suggestionsContainer.className = 'tag-suggestions';
            tagsInput.parentNode.appendChild(suggestionsContainer);
        }
        
        suggestionsContainer.innerHTML = '';
        currentSuggestionIndex = -1;
        
        matches.forEach(tag => {
            const suggestion = document.createElement('div');
            suggestion.className = 'tag-suggestion';
            suggestion.textContent = tag;
            suggestion.addEventListener('click', () => selectSuggestion(tag));
            suggestionsContainer.appendChild(suggestion);
        });
        
        suggestionsContainer.style.display = 'block';
    }
    
    function hideTagSuggestions() {
        if (suggestionsContainer) {
            suggestionsContainer.style.display = 'none';
        }
        currentSuggestionIndex = -1;
    }
    
    function updateSuggestionSelection(suggestions) {
        suggestions.forEach((suggestion, index) => {
            suggestion.classList.toggle('active', index === currentSuggestionIndex);
        });
    }
    
    function selectSuggestion(tag) {
        const value = tagsInput.value;
        const lastCommaIndex = value.lastIndexOf(',');
        const newValue = value.substring(0, lastCommaIndex + 1) + (lastCommaIndex >= 0 ? ' ' : '') + tag;
        tagsInput.value = newValue;
        hideTagSuggestions();
        tagsInput.focus();
    }
    
    // Hide suggestions when clicking outside
    document.addEventListener('click', function(e) {
        if (!tagsInput.contains(e.target) && !suggestionsContainer?.contains(e.target)) {
            hideTagSuggestions();
        }
    });
}

// Form submission handling
function setupFormSubmission() {
    const form = document.querySelector('form');
    if (form) {
        form.addEventListener('submit', function() {
            // Clean up tags before submission
            const tagsInput = document.getElementById('tags');
            if (tagsInput) {
                const tags = tagsInput.value
                    .split(',')
                    .map(tag => tag.trim())
                    .filter(tag => tag.length > 0)
                    .join(', ');
                tagsInput.value = tags;
            }
        });
    }
}

// Auto-save functionality
function setupAutoSave() {
    const titleInput = document.getElementById('title');
    const contentTextarea = document.getElementById('content');
    const tagsInput = document.getElementById('tags');
    
    const autoSaveKey = 'blog_form_autosave_' + (new Date().toDateString());
    
    // Load saved data
    loadAutoSaveData();
    
    // Save data on input
    [titleInput, contentTextarea, tagsInput].forEach(element => {
        if (element) {
            element.addEventListener('input', debounce(saveAutoSaveData, 1000));
        }
    });
    
    // Clear auto-save on successful submission
    const form = document.querySelector('form');
    if (form) {
        form.addEventListener('submit', function() {
            localStorage.removeItem(autoSaveKey);
        });
    }
    
    function saveAutoSaveData() {
        const data = {
            title: titleInput?.value || '',
            content: contentTextarea?.value || '',
            tags: tagsInput?.value || '',
            timestamp: new Date().toISOString()
        };
        
        localStorage.setItem(autoSaveKey, JSON.stringify(data));
        showAutoSaveIndicator();
    }
    
    function loadAutoSaveData() {
        const savedData = localStorage.getItem(autoSaveKey);
        if (savedData) {
            try {
                const data = JSON.parse(savedData);
                // Only load if fields are empty (don't overwrite existing content)
                if (titleInput && !titleInput.value && data.title) {
                    titleInput.value = data.title;
                }
                if (contentTextarea && !contentTextarea.value && data.content) {
                    contentTextarea.value = data.content;
                    autoResizeTextarea(contentTextarea);
                }
                if (tagsInput && !tagsInput.value && data.tags) {
                    tagsInput.value = data.tags;
                }
            } catch (e) {
                console.error('Error loading auto-save data:', e);
            }
        }
    }
    
    function showAutoSaveIndicator() {
        // Show a subtle indicator that data has been saved
        let indicator = document.getElementById('autosave-indicator');
        if (!indicator) {
            indicator = document.createElement('div');
            indicator.id = 'autosave-indicator';
            indicator.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                background: #28a745;
                color: white;
                padding: 0.5rem 1rem;
                border-radius: 5px;
                font-size: 0.8rem;
                z-index: 1000;
                opacity: 0;
                transition: opacity 0.3s ease;
            `;
            indicator.textContent = 'Draft saved';
            document.body.appendChild(indicator);
        }
        
        indicator.style.opacity = '1';
        setTimeout(() => {
            indicator.style.opacity = '0';
        }, 2000);
    }
}

// Keyboard shortcuts
function setupKeyboardShortcuts() {
    document.addEventListener('keydown', function(e) {
        // Ctrl/Cmd + S to save
        if ((e.ctrlKey || e.metaKey) && e.key === 's') {
            e.preventDefault();
            const submitButton = document.querySelector('button[type="submit"]');
            if (submitButton) {
                submitButton.click();
            }
        }
        
        // Ctrl/Cmd + Enter to submit from textarea
        if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
            const submitButton = document.querySelector('button[type="submit"]');
            if (submitButton) {
                submitButton.click();
            }
        }
    });
}

// Loading state management
function showLoadingState() {
    const submitButton = document.querySelector('button[type="submit"]');
    if (submitButton) {
        const originalText = submitButton.innerHTML;
        submitButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
        submitButton.disabled = true;
        submitButton.classList.add('loading');
        
        // Store original text for potential restoration
        submitButton.dataset.originalHtml = originalText;
    }
}

// Utility functions
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

// Export for global access
window.BlogForm = {
    initializeBlogForm,
    validateForm,
    showLoadingState,
    autoResizeTextarea
};
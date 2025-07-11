

// Interaction modal for guest users
function showInteractionModal(action) {
    const modal = document.getElementById('interactionModal');
    const message = document.getElementById('modalMessage');
    
    if (modal && message) {
        switch(action) {
            case 'create':
                message.textContent = 'Please sign in to create blog posts and share your knowledge with the community.';
                break;
            case 'edit':
                message.textContent = 'Please sign in to edit blog posts.';
                break;
            case 'comment':
                message.textContent = 'Please sign in to comment on blog posts.';
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

// Blog deletion confirmation
function confirmDelete(blogId) {
    if (confirm('Are you sure you want to delete this blog? This action cannot be undone.')) {
        window.location.href = 'blogs?action=delete&id=' + blogId;
    }
}

// Search functionality
function searchBlogs() {
    const searchTerm = document.getElementById('searchInput');
    if (!searchTerm) return;
    
    const searchValue = searchTerm.value.toLowerCase();
    const blogCards = document.querySelectorAll('.blog-card');
    
    blogCards.forEach(card => {
        const title = card.querySelector('.blog-title');
        const excerpt = card.querySelector('.blog-excerpt');
        const author = card.querySelector('.author-info');
        
        if (title && excerpt && author) {
            const titleText = title.textContent.toLowerCase();
            const excerptText = excerpt.textContent.toLowerCase();
            const authorText = author.textContent.toLowerCase();
            
            if (titleText.includes(searchValue) || excerptText.includes(searchValue) || authorText.includes(searchValue)) {
                card.style.display = 'block';
            } else {
                card.style.display = 'none';
            }
        }
    });
    
    updateNoResultsMessage();
}

// Sort functionality
function sortBlogs() {
    const sortBy = document.getElementById('sortSelect');
    if (!sortBy) return;
    
    const sortValue = sortBy.value;
    const blogsGrid = document.querySelector('.blogs-grid');
    const blogCards = Array.from(document.querySelectorAll('.blog-card'));
    
    if (!blogsGrid || blogCards.length === 0) return;
    
    blogCards.sort((a, b) => {
        switch(sortValue) {
            case 'date':
                const dateA = new Date(a.querySelector('.blog-meta span:last-child')?.textContent || '');
                const dateB = new Date(b.querySelector('.blog-meta span:last-child')?.textContent || '');
                return dateB - dateA;
            case 'title':
                const titleA = a.querySelector('.blog-title')?.textContent.toLowerCase() || '';
                const titleB = b.querySelector('.blog-title')?.textContent.toLowerCase() || '';
                return titleA.localeCompare(titleB);
            case 'author':
                const authorA = a.querySelector('.author-info span')?.textContent.toLowerCase() || '';
                const authorB = b.querySelector('.author-info span')?.textContent.toLowerCase() || '';
                return authorA.localeCompare(authorB);
            case 'likes':
                const likesA = parseInt(a.querySelector('.stat-item i.fa-heart + span')?.textContent || '0');
                const likesB = parseInt(b.querySelector('.stat-item i.fa-heart + span')?.textContent || '0');
                return likesB - likesA;
            default:
                return 0;
        }
    });
    
    // Remove all cards and re-append in sorted order
    blogCards.forEach(card => card.remove());
    blogCards.forEach(card => blogsGrid.appendChild(card));
}

// Update no results message
function updateNoResultsMessage() {
    const blogCards = document.querySelectorAll('.blog-card');
    const visibleCards = Array.from(blogCards).filter(card => card.style.display !== 'none');
    const blogsGrid = document.querySelector('.blogs-grid');
    
    if (!blogsGrid) return;
    
    // Remove existing no results message
    const existingMessage = document.querySelector('.no-results-message');
    if (existingMessage) {
        existingMessage.remove();
    }
    
    if (visibleCards.length === 0 && blogCards.length > 0) {
        const noResultsDiv = document.createElement('div');
        noResultsDiv.className = 'no-results-message';
        noResultsDiv.style.cssText = 'grid-column: 1 / -1; text-align: center; padding: 60px 30px; color: #6c757d;';
        noResultsDiv.innerHTML = `
            <i class="fas fa-search" style="font-size: 4em; margin-bottom: 20px; opacity: 0.5;"></i>
            <h3 style="font-size: 1.5em; margin-bottom: 10px;">No blogs found</h3>
            <p>Try adjusting your search terms or filters</p>
        `;
        blogsGrid.appendChild(noResultsDiv);
    }
}

// Clear search
function clearSearch() {
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.value = '';
    }
    
    const blogCards = document.querySelectorAll('.blog-card');
    blogCards.forEach(card => {
        card.style.display = 'block';
    });
    
    // Remove no results message
    const existingMessage = document.querySelector('.no-results-message');
    if (existingMessage) {
        existingMessage.remove();
    }
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

// Initialize page functionality
function initializePage() {
    // Add event listeners for search and sort
    const searchInput = document.getElementById('searchInput');
    const sortSelect = document.getElementById('sortSelect');
    
    if (searchInput) {
        searchInput.addEventListener('input', searchBlogs);
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                searchBlogs();
            }
        });
    }
    
    if (sortSelect) {
        sortSelect.addEventListener('change', sortBlogs);
    }
    
    // Modal close functionality
    const modal = document.getElementById('interactionModal');
    if (modal) {
        modal.addEventListener('click', function(e) {
            if (e.target === this) {
                hideInteractionModal();
            }
        });
    }
    
    // Auto-hide alerts
    autoHideAlerts();
}

// DOM Content Loaded event
document.addEventListener('DOMContentLoaded', function() {
    initializePage();
});

// Additional utility functions for JSP integration
window.BlogsListUtils = {
    toggleCreateForm,
    showInteractionModal,
    hideInteractionModal,
    confirmDelete,
    searchBlogs,
    sortBlogs,
    clearSearch,
    updateNoResultsMessage
};
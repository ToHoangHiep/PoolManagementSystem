// Blog Management functionality
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

// Enhanced confirmation dialogs
function confirmAction(message, action) {
    if (confirm(message)) {
        // Add loading state
        const button = event.target;
        const originalText = button.innerHTML;
        button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
        button.disabled = true;
        
        // Proceed with action
        return true;
    }
    return false;
}

// Table sorting functionality
function sortTable(columnIndex, tableId = 'blog-table') {
    const table = document.getElementById(tableId) || document.querySelector('.blog-table');
    if (!table) return;
    
    const tbody = table.querySelector('tbody');
    const rows = Array.from(tbody.querySelectorAll('tr'));
    
    // Determine sort direction
    const header = table.querySelectorAll('th')[columnIndex];
    const isAscending = !header.classList.contains('sort-desc');
    
    // Clear all sort classes
    table.querySelectorAll('th').forEach(th => {
        th.classList.remove('sort-asc', 'sort-desc');
    });
    
    // Add sort class to current header
    header.classList.add(isAscending ? 'sort-asc' : 'sort-desc');
    
    // Sort rows
    rows.sort((a, b) => {
        const aText = a.cells[columnIndex].textContent.trim();
        const bText = b.cells[columnIndex].textContent.trim();
        
        // Handle different data types
        if (columnIndex === 2) { // Date column
            const aDate = new Date(aText);
            const bDate = new Date(bText);
            return isAscending ? aDate - bDate : bDate - aDate;
        } else if (columnIndex === 0) { // Title column
            return isAscending ? aText.localeCompare(bText) : bText.localeCompare(aText);
        } else {
            return isAscending ? aText.localeCompare(bText) : bText.localeCompare(aText);
        }
    });
    
    // Re-append sorted rows
    rows.forEach(row => tbody.appendChild(row));
}

// Search functionality
function searchBlogs(searchTerm) {
    const tables = document.querySelectorAll('.blog-table');
    
    tables.forEach(table => {
        const tbody = table.querySelector('tbody');
        if (!tbody) return;
        
        const rows = tbody.querySelectorAll('tr');
        let visibleRows = 0;
        
        rows.forEach(row => {
            const title = row.querySelector('.blog-title')?.textContent.toLowerCase() || '';
            const author = row.querySelector('.blog-author')?.textContent.toLowerCase() || '';
            const searchLower = searchTerm.toLowerCase();
            
            if (title.includes(searchLower) || author.includes(searchLower)) {
                row.style.display = '';
                visibleRows++;
            } else {
                row.style.display = 'none';
            }
        });
        
        // Show/hide empty state
        updateEmptyState(table, visibleRows === 0);
    });
}

// Update empty state visibility
function updateEmptyState(table, show) {
    const section = table.closest('.content-section');
    if (!section) return;
    
    let emptyState = section.querySelector('.search-empty-state');
    
    if (show && !emptyState) {
        emptyState = document.createElement('div');
        emptyState.className = 'empty-state search-empty-state';
        emptyState.innerHTML = `
            <i class="fas fa-search"></i>
            <h3>No blogs found</h3>
            <p>Try adjusting your search terms</p>
        `;
        section.appendChild(emptyState);
    } else if (!show && emptyState) {
        emptyState.remove();
    }
}

// Filter functionality
function filterByStatus(status) {
    const tables = document.querySelectorAll('.blog-table');
    
    tables.forEach(table => {
        const tbody = table.querySelector('tbody');
        if (!tbody) return;
        
        const rows = tbody.querySelectorAll('tr');
        let visibleRows = 0;
        
        rows.forEach(row => {
            const statusBadge = row.querySelector('.status-badge');
            if (!statusBadge) return;
            
            const rowStatus = statusBadge.classList.contains('status-active') ? 'active' : 'inactive';
            
            if (status === 'all' || rowStatus === status) {
                row.style.display = '';
                visibleRows++;
            } else {
                row.style.display = 'none';
            }
        });
        
        updateEmptyState(table, visibleRows === 0);
    });
}

// Bulk actions functionality
function toggleBulkActions() {
    const checkboxes = document.querySelectorAll('.row-checkbox:checked');
    const bulkActions = document.getElementById('bulk-actions');
    
    if (bulkActions) {
        bulkActions.style.display = checkboxes.length > 0 ? 'block' : 'none';
    }
}

function selectAllRows(checkbox) {
    const rowCheckboxes = document.querySelectorAll('.row-checkbox');
    rowCheckboxes.forEach(cb => {
        cb.checked = checkbox.checked;
    });
    toggleBulkActions();
}

function performBulkAction(action) {
    const selectedIds = Array.from(document.querySelectorAll('.row-checkbox:checked'))
        .map(cb => cb.value);
    
    if (selectedIds.length === 0) {
        alert('Please select at least one blog to perform this action.');
        return;
    }
    
    let message = '';
    switch (action) {
        case 'activate':
            message = `Are you sure you want to activate ${selectedIds.length} blog(s)?`;
            break;
        case 'deactivate':
            message = `Are you sure you want to deactivate ${selectedIds.length} blog(s)?`;
            break;
        case 'delete':
            message = `Are you sure you want to delete ${selectedIds.length} blog(s)? This action cannot be undone.`;
            break;
    }
    
    if (confirm(message)) {
        // Create form and submit
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'blogs';
        
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'bulk_' + action;
        form.appendChild(actionInput);
        
        selectedIds.forEach(id => {
            const idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'blog_ids[]';
            idInput.value = id;
            form.appendChild(idInput);
        });
        
        document.body.appendChild(form);
        form.submit();
    }
}

// Statistics update functionality
function updateStatistics() {
    const activeCount = document.querySelectorAll('.status-active').length;
    const inactiveCount = document.querySelectorAll('.status-inactive').length;
    const totalCount = activeCount + inactiveCount;
    
    // Update stat cards if they exist
    const statCards = document.querySelectorAll('.stat-number');
    if (statCards.length >= 3) {
        statCards[0].textContent = totalCount;
        statCards[1].textContent = activeCount;
        statCards[2].textContent = inactiveCount;
    }
}

// Keyboard shortcuts
function handleKeyboardShortcuts(event) {
    // Ctrl/Cmd + F for search
    if ((event.ctrlKey || event.metaKey) && event.key === 'f') {
        event.preventDefault();
        const searchInput = document.getElementById('search-input');
        if (searchInput) {
            searchInput.focus();
        }
    }
    
    // Escape to clear search/filters
    if (event.key === 'Escape') {
        const searchInput = document.getElementById('search-input');
        if (searchInput && searchInput.value) {
            searchInput.value = '';
            searchBlogs('');
        }
    }
}

// Initialize page functionality
function initializeBlogManagement() {
    // Auto-hide alerts
    autoHideAlerts();
    
    // Add keyboard shortcuts
    document.addEventListener('keydown', handleKeyboardShortcuts);
    
    // Add click handlers for table headers (for sorting)
    const tableHeaders = document.querySelectorall('th[data-sortable]');
    tableHeaders.forEach((header, index) => {
        header.style.cursor = 'pointer';
        header.addEventListener('click', () => sortTable(index));
        
        // Add sort icons
        if (!header.querySelector('.sort-icon')) {
            const icon = document.createElement('i');
            icon.className = 'fas fa-sort sort-icon';
            icon.style.marginLeft = '0.5rem';
            header.appendChild(icon);
        }
    });
    
    // Add row selection handlers
    const rowCheckboxes = document.querySelectorAll('.row-checkbox');
    rowCheckboxes.forEach(checkbox => {
        checkbox.addEventListener('change', toggleBulkActions);
    });
    
    // Update statistics
    updateStatistics();
    
    // Add search input if it doesn't exist
    createSearchInterface();
}

// Create search interface
function createSearchInterface() {
    const container = document.querySelector('.container');
    if (!container || document.getElementById('search-input')) return;
    
    const searchContainer = document.createElement('div');
    searchContainer.className = 'search-container';
    searchContainer.style.cssText = `
        background: white;
        padding: 1rem 2rem;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        margin-bottom: 2rem;
        display: flex;
        gap: 1rem;
        align-items: center;
        flex-wrap: wrap;
    `;
    
    searchContainer.innerHTML = `
        <div style="flex: 1; min-width: 200px;">
            <input type="text" id="search-input" placeholder="Search blogs by title or author..." 
                   style="width: 100%; padding: 0.5rem; border: 1px solid #ddd; border-radius: 5px;">
        </div>
        <select id="status-filter" style="padding: 0.5rem; border: 1px solid #ddd; border-radius: 5px;">
            <option value="all">All Status</option>
            <option value="active">Active Only</option>
            <option value="inactive">Inactive Only</option>
        </select>
        <button onclick="searchBlogs(''); filterByStatus('all')" class="btn btn-secondary">
            <i class="fas fa-times"></i> Clear
        </button>
    `;
    
    // Insert after header
    const header = container.querySelector('.header');
    if (header) {
        header.insertAdjacentElement('afterend', searchContainer);
        
        // Add event listeners
        const searchInput = document.getElementById('search-input');
        const statusFilter = document.getElementById('status-filter');
        
        searchInput.addEventListener('input', (e) => searchBlogs(e.target.value));
        statusFilter.addEventListener('change', (e) => filterByStatus(e.target.value));
    }
}

// Export functions for global access
window.BlogManagement = {
    autoHideAlerts,
    confirmAction,
    sortTable,
    searchBlogs,
    filterByStatus,
    toggleBulkActions,
    selectAllRows,
    performBulkAction,
    updateStatistics,
    initializeBlogManagement
};

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', initializeBlogManagement);
document.addEventListener('DOMContentLoaded', function() {
    const selectAllCheckbox = document.getElementById('selectAll');
    const checkboxes = document.querySelectorAll('.feedback-checkbox');
    const deleteButton = document.getElementById('deleteSelectedBtn');
    const deleteForm = document.getElementById('deleteForm');

    // Select all functionality
    selectAllCheckbox.addEventListener('change', function() {
        checkboxes.forEach(checkbox => {
            checkbox.checked = this.checked;
        });
        updateDeleteButton();
    });

    // Individual checkbox change
    checkboxes.forEach(checkbox => {
        checkbox.addEventListener('change', updateDeleteButton);
    });

    // Delete button click
    deleteButton.addEventListener('click', function() {
        if (confirm('Are you sure you want to delete the selected feedback entries?')) {
            deleteForm.submit();
        }
    });

    // Update delete button state
    function updateDeleteButton() {
        const checkedCount = document.querySelectorAll('.feedback-checkbox:checked').length;
        deleteButton.disabled = checkedCount === 0;
    }
});

// Individual delete confirmation
function confirmDelete(id) {
    if (confirm('Are you sure you want to delete this feedback?')) {
        window.location.href = 'feedback/delete?id=' + id;
    }
}

// Add this to make the filter form work with the existing JavaScript
function showHideFields() {
    const feedbackType = document.getElementById('feedback_type').value;

    document.getElementById('coach_id_group').style.display =
        feedbackType === 'Coach' ? 'block' : 'none';

    document.getElementById('course_id_group').style.display =
        feedbackType === 'Course' ? 'block' : 'none';

    document.getElementById('general_feedback_type_group').style.display =
        feedbackType === 'General' ? 'block' : 'none';
}

// Initialize on page load
showHideFields();
function toggleOldPassword() {
    const oldPassword = document.getElementById('oldPass');
    const icon = document.getElementById('oldPasswordIcon');

    if (oldPassword.type === 'password') {
        oldPassword.type = 'text';
        icon.className = 'fas fa-eye';
    } else {
        oldPassword.type = 'password';
        icon.className = 'fas fa-eye-slash';
    }
}

function toggleNewPasswords() {
    const newPassword = document.getElementById('newPass');
    const confirmPassword = document.getElementById('confirmPass');
    const icon = document.getElementById('newPasswordIcon');

    if (newPassword.type === 'password') {
        newPassword.type = 'text';
        confirmPassword.type = 'text';
        icon.className = 'fas fa-eye';
    } else {
        newPassword.type = 'password';
        confirmPassword.type = 'password';
        icon.className = 'fas fa-eye-slash';
    }
}

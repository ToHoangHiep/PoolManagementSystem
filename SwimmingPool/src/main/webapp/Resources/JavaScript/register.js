// Password toggle functionality
function togglePassword() {
    const passwordField = document.getElementById('password');
    const eyeIcon = document.getElementById('eyeIcon');
    
    if (passwordField.type === 'password') {
        passwordField.type = 'text';
        eyeIcon.src = 'https://img.icons8.com/ios-glyphs/30/000000/visible.png';
    } else {
        passwordField.type = 'password';
        eyeIcon.src = 'https://img.icons8.com/ios-glyphs/30/000000/invisible.png';
    }
}

// Form validation
function validateForm() {
    const firstName = document.forms["registerForm"]["firstName"].value.trim();
    const lastName = document.forms["registerForm"]["lastName"].value.trim();
    const email = document.forms["registerForm"]["email"].value.trim();
    const phoneNumber = document.forms["registerForm"]["phoneNumber"].value.trim();
    const password = document.forms["registerForm"]["password"].value;
    const gender = document.forms["registerForm"]["gender"].value;
    
    // Check if all required fields are filled
    if (!firstName || !lastName || !email || !phoneNumber || !password || !gender) {
        alert("All fields are required!");
        return false;
    }
    
    // Validate first name and last name (only letters and spaces)
    const namePattern = /^[A-Za-z\s]+$/;
    if (!namePattern.test(firstName)) {
        alert("First name should contain only letters and spaces!");
        return false;
    }
    if (!namePattern.test(lastName)) {
        alert("Last name should contain only letters and spaces!");
        return false;
    }
    
    // Validate email format
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailPattern.test(email)) {
        alert("Please enter a valid email address!");
        return false;
    }
    
    // Validate phone number (10 digits)
    const phonePattern = /^\d{10}$/;
    if (!phonePattern.test(phoneNumber)) {
        alert("Phone number must be exactly 10 digits!");
        return false;
    }
    
    // Validate password strength
    if (password.length < 8) {
        alert("Password must be at least 8 characters long!");
        return false;
    }
    
    if (!/(?=.*[a-z])/.test(password)) {
        alert("Password must contain at least one lowercase letter!");
        return false;
    }
    
    if (!/(?=.*[A-Z])/.test(password)) {
        alert("Password must contain at least one uppercase letter!");
        return false;
    }
    
    if (!/(?=.*\d)/.test(password)) {
        alert("Password must contain at least one number!");
        return false;
    }
    
    if (!/(?=.*[@$!%*?&])/.test(password)) {
        alert("Password must contain at least one special character (@$!%*?&)!");
        return false;
    }
    
    return true;
}
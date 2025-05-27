<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.UserProfile" %>
<%
    UserProfile user = (UserProfile) request.getAttribute("user");
    if (user == null) {
%>
<h2 style="text-align:center; color:red;">User information not found</h2>
<p style="text-align:center;"><a href="home.jsp">Back to home</a></p>
<%
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>User Profile</title>
    <style>
        /* CSS giữ nguyên như bạn đã có */
        *, *::before, *::after {
            box-sizing: border-box;
        }
        html, body {
            margin: 0; padding: 0; height: 100%;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f2f7;
            overflow: hidden;
        }
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            background: white;
            width: 700px;
            max-width: 90vw;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            padding: 15px 25px 25px 25px;
            display: flex;
            flex-direction: column;
            height: 90vh;
        }
        .tabs {
            display: flex;
            border-bottom: 2px solid #ddd;
            margin-bottom: 15px;
        }
        .tabs button {
            flex: 1;
            padding: 10px 0;
            font-weight: 600;
            border: none;
            background: none;
            cursor: pointer;
            font-size: 16px;
            color: #666;
            border-bottom: 3px solid transparent;
            transition: color 0.3s ease, border-bottom-color 0.3s ease;
        }
        .tabs button.active {
            color: #007bff;
            border-bottom-color: #007bff;
        }
        .content {
            display: flex;
            gap: 25px;
            flex-wrap: nowrap;
            flex: 1 1 auto;
            max-height: 75vh;
            overflow-y: auto;
        }
        .avatar-section {
            flex: 0 0 140px;
            text-align: center;
            min-width: 140px;
        }
        .avatar-section img {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #007bff;
            box-shadow: 0 0 15px rgba(0,123,255,0.3);
        }
        .avatar-section input[type="file"] {
            margin-top: 12px;
            font-size: 14px;
            display: block;
            margin-left: auto;
            margin-right: auto;
            max-width: 140px;
        }
        form {
            flex: 1 1 auto;
            display: flex;
            flex-direction: column;
            min-width: 280px;
        }
        .form-group {
            margin-bottom: 10px;
        }
        label {
            font-weight: 600;
            margin-bottom: 4px;
            display: block;
            font-size: 13px;
            color: #333;
        }
        input[type="text"],
        input[type="email"],
        input[type="date"],
        input[type="tel"],
        select {
            width: 100%;
            padding: 8px 10px;
            font-size: 14px;
            border: 1.5px solid #ccc;
            border-radius: 5px;
            transition: border-color 0.3s ease;
        }
        input[type="text"]:focus,
        input[type="email"]:focus,
        input[type="date"]:focus,
        input[type="tel"]:focus,
        select:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 6px rgba(0,123,255,0.3);
        }
        input[disabled], select[disabled] {
            background-color: #eee;
            cursor: not-allowed;
        }
        .form-actions {
            margin-top: auto;
            text-align: right;
        }
        .form-actions button {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 24px;
            font-size: 15px;
            border-radius: 7px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-left: 8px;
        }
        .form-actions button:disabled {
            background-color: #a3c3f7;
            cursor: not-allowed;
        }
        .form-actions button:hover:not(:disabled) {
            background-color: #0056b3;
        }
        /* Scrollbar chrome */
        .content::-webkit-scrollbar {
            width: 8px;
        }
        .content::-webkit-scrollbar-thumb {
            background: rgba(0,123,255,0.3);
            border-radius: 4px;
        }
        .content::-webkit-scrollbar-track {
            background: #f0f2f7;
        }
        /* Responsive */
        @media (max-width: 720px) {
            .container {
                width: 90vw;
                padding: 10px 15px 20px 15px;
            }
            .content {
                flex-direction: column;
                overflow-y: visible;
            }
            .avatar-section {
                margin-bottom: 20px;
                flex: none;
                width: 100%;
                text-align: center;
            }
            .avatar-section img, .avatar-section input[type=file] {
                max-width: 140px;
                height: auto;
                margin: 0 auto;
                display: block;
            }
            form {
                min-width: auto;
                width: 100%;
            }
            .form-actions {
                text-align: center;
                margin-top: 15px;
            }
        }
    </style>
</head>
<body>

<div class="container">

    <%-- Display message --%>
    <% String message = (String) request.getAttribute("message"); %>
    <% if (message != null) { %>
    <div style="color: green; font-weight: bold; margin-bottom: 15px; text-align: center;">
        <%= message %>
    </div>
    <% } %>
        <a href="home.jsp" style="position: fixed; top: 10px; left: 10px; color: #007bff; font-weight: 600; text-decoration: none; user-select: none;">
            ← Back to Home
        </a>

    <div class="tabs">
        <button class="active" type="button">Profile</button>
        <button type="button">History</button>
    </div>
    <div class="content">


        <form id="profileForm" method="post" action="userProfile" enctype="multipart/form-data" novalidate onsubmit="return validateForm()">
            <div class="avatar-section">
                <img id="avatarPreview" src="<%= (user.getProfile_picture() != null && !user.getProfile_picture().isEmpty())
          ? user.getProfile_picture() : "https://via.placeholder.com/140" %>" alt="Avatar" />
                <input type="file" name="avatar" accept="image/*" onchange="previewImage(event)" disabled />
            </div>
            <input type="hidden" name="userId" value="<%= user.getUserId() %>" />

            <div class="form-group">
                <label for="fullName">Name</label>
                <input id="fullName" name="fullName" type="text" value="<%= user.getFullName() %>" disabled required minlength="2" />
            </div>

            <div class="form-group">
                <label for="dob">Date of Birth</label>
                <input id="dob" name="dob" type="date" value="<%= user.getDobString() %>" disabled required />
            </div>

            <div class="form-group">
                <label for="gender">Gender</label>
                <select id="gender" name="gender" disabled required>
                    <option value="" <%= (user.getGender() == null || user.getGender().isEmpty()) ? "selected" : "" %>>
                        -- Select Gender --
                    </option>
                    <option value="Male" <%= "Male".equalsIgnoreCase(user.getGender()) ? "selected" : "" %>>Male</option>
                    <option value="Female" <%= "Female".equalsIgnoreCase(user.getGender()) ? "selected" : "" %>>Female</option>
                    <option value="Other" <%= "Other".equalsIgnoreCase(user.getGender()) ? "selected" : "" %>>Other</option>
                </select>
            </div>

            <div class="form-group">
                <label for="phoneNumber">Phone</label>
                <input id="phoneNumber" name="phoneNumber" type="tel" pattern="[0-9+ \-]*" value="<%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "" %>"
                       disabled required minlength="7" />
            </div>

            <div class="form-group">
                <label for="email">Email</label>
                <input id="email" name="email" type="email" value="<%= user.getEmail() != null ? user.getEmail() : "" %>" disabled required />
            </div>

            <div class="form-group">
                <label for="address">Address</label>
                <input id="address" name="address" type="text" value="<%= user.getAddress() != null ? user.getAddress() : "" %>" disabled />
            </div>

            <div class="form-actions">
                <button type="button" id="btnEdit" onclick="toggleEdit()">Edit</button>
                <button type="submit" id="btnSave" disabled>Save</button>
            </div>
        </form>
    </div>
</div>

<script>
    function previewImage(event) {
        const reader = new FileReader();
        reader.onload = function () {
            document.getElementById("avatarPreview").src = reader.result;
        };
        reader.readAsDataURL(event.target.files[0]);
    }

    function toggleEdit() {
        const form = document.getElementById("profileForm");
        const inputs = form.querySelectorAll("input, select");
        const btnSave = document.getElementById("btnSave");
        const btnEdit = document.getElementById("btnEdit");

        // Lấy avatar gốc từ biến JSP để dùng khi reset
        const avatar = "<%= (user.getProfile_picture() != null && !user.getProfile_picture().isEmpty()) ? user.getProfile_picture() : "https://via.placeholder.com/140" %>";

        // Kiểm tra trạng thái hiện tại dựa vào text nút Edit/Cancel
        const isEditing = btnEdit.textContent === "Cancel";

        if (isEditing) {
            // Nếu đang ở chế độ edit, bấm Cancel thì disable tất cả input lại
            inputs.forEach(input => input.disabled = true);
            document.querySelector(".avatar-section input[type=file]").disabled = true;

            btnSave.disabled = true;
            btnEdit.textContent = "Edit";

            // Reset form về dữ liệu ban đầu
            form.reset();
            document.getElementById("avatarPreview").src = avatar;
        } else {
            // Nếu đang ở chế độ xem, bật edit (enable tất cả input)
            inputs.forEach(input => input.disabled = false);
            document.querySelector(".avatar-section input[type=file]").disabled = false;

            btnSave.disabled = false;
            btnEdit.textContent = "Cancel";
        }
    }

    function validateForm() {
        const fullName = document.getElementById("fullName").value.trim();
        const dob = document.getElementById("dob").value;
        const gender = document.getElementById("gender").value;
        const phone = document.getElementById("phoneNumber").value.trim();
        const email = document.getElementById("email").value.trim();
        const address = document.getElementById("address").value.trim();

        // Full name check
        if (fullName.length < 2) {
            alert("Full name must be at least 2 characters.");
            return false;
        }

        // DOB check - required and not in the future
        if (!dob) {
            alert("Please select your date of birth.");
            return false;
        }
        const dobDate = new Date(dob);
        const now = new Date();
        if (dobDate > now) {
            alert("Date of birth cannot be in the future.");
            return false;
        }

        // Gender check
        if (gender !== "Male" && gender !== "Female" && gender !== "Other") {
            alert("Please select your gender.");
            return false;
        }

        // Phone check - only digits, +, -, spaces allowed
        const phonePattern = /^[0-9+ \-]+$/;
        if (!phonePattern.test(phone)) {
            alert("Phone number is invalid. Only digits, +, -, and spaces are allowed.");
            return false;
        }
        // Count digits only length must be 10 or 11
        const digitsOnly = phone.replace(/\D/g, '');
        if (digitsOnly.length < 10 || digitsOnly.length > 11) {
            alert("Phone number must contain between 10 and 11 digits.");
            return false;
        }

        // Email check - simple regex
        const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailPattern.test(email)) {
            alert("Invalid email address.");
            return false;
        }

        // Address: optional, no validation here

        return true; // all checks passed
    }
</script>

</body>
</html>

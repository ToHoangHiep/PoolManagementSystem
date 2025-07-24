<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Customer" %>
<%
    Customer user = (Customer) request.getAttribute("user");
    if (user == null) {
%>
<h2 style="text-align:center; color:red;">User information not found</h2>
<p style="text-align:center;"><a href="home.jsp">Back to home</a></p>r
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
        * {
            box-sizing: border-box;
        }
        html, body {
            margin: 0; padding: 0;
            width: 100%;
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            background-color: #f0f2f7;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            overflow-y: auto;
        }
        .container {
            display: flex;
            max-width: 900px;
            width: 100%;
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            padding: 30px 0;
            overflow: visible;
        }

        .left-side {
            width: 200px;
            background-color: #ddd;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 20px;
            border-radius: 10px 0 0 10px;
        }
        .left-side img {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 15px;
            /* Bỏ viền, box-shadow */
            box-shadow: none !important;
            border: none !important;
        }
        .left-side input[type="file"] {
            cursor: pointer;
            width: 100%;
        }

        .right-side {
            flex-grow: 1;
            padding: 40px 40px;
            overflow-y: visible;
        }

        form {
            display: flex;
            flex-direction: column;
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

        .back-home {
            position: fixed;
            top: 20px;
            left: 20px;
            background-color: #007bff;
            color: white;
            padding: 8px 16px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
            transition: background-color 0.3s ease;
            z-index: 1000;
        }
        .back-home:hover {
            background-color: #0056b3;
        }
        @media (max-width: 768px) {
            html, body {
                display: block;
                overflow-y: auto;
                height: auto;
                padding: 10px;
            }
            .container {
                flex-direction: column;
                max-width: 100%;
                padding: 10px 0;
            }
            .left-side {
                width: 100%;
                border-radius: 10px 10px 0 0;
                padding: 10px;
                margin-bottom: 20px;
            }
            .right-side {
                width: 100%;
                padding: 20px 15px;
                border-radius: 0 0 10px 10px;
            }
        }
    </style>
</head>
<body>

<a href="home.jsp" class="back-home">&larr; Back to Home</a>

<div class="container">

    <form id="profileForm" method="post" action="userprofile" enctype="multipart/form-data" novalidate onsubmit="return validateForm()" style="display:flex; width:100%;">

        <div class="left-side">
            <img id="avatarPreview" src="<%= (user.getProfilePicture() != null && !user.getProfilePicture().isEmpty()) ? user.getProfilePicture() : "https://via.placeholder.com/160x160?text=No+Image" %>" alt="Avatar" />
            <input type="file" name="avatar" accept="image/*" onchange="previewImage(event)" disabled />
        </div>

        <div class="right-side">

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
                    <option value="" <%= (user.getGender() == null || user.getGender().isEmpty()) ? "selected" : "" %>>-- Select Gender --</option>
                    <option value="Male" <%= "Male".equalsIgnoreCase(user.getGender()) ? "selected" : "" %>>Male</option>
                    <option value="Female" <%= "Female".equalsIgnoreCase(user.getGender()) ? "selected" : "" %>>Female</option>
                    <option value="Other" <%= "Other".equalsIgnoreCase(user.getGender()) ? "selected" : "" %>>Other</option>
                </select>
            </div>

            <div class="form-group">
                <label for="phoneNumber">Phone</label>
                <input id="phoneNumber" name="phoneNumber" type="tel" pattern="[0-9+ \\-]*" value="<%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "" %>" disabled required minlength="7" />
            </div>

            <div class="form-group">
                <label for="email">Email</label>
                <input id="email" type="email" value="<%= user.getEmail() != null ? user.getEmail() : "" %>" readonly style="background-color:#eee; cursor:not-allowed;" />
                <input type="hidden" name="email" value="<%= user.getEmail() != null ? user.getEmail() : "" %>" />
            </div>

            <div class="form-group">
                <label for="address">Address</label>
                <input id="address" name="address" type="text" value="<%= user.getAddress() != null ? user.getAddress() : "" %>" disabled />
            </div>

            <div class="form-actions" style="margin-top:auto; text-align:right;">
                <button type="button" id="btnEdit" onclick="toggleEdit()">Edit</button>
                <button type="submit" id="btnSave" disabled>Save</button>
            </div>
        </div>

    </form>
</div>

<script>
    // Hiển thị popup alert khi có message từ server (thay thế thông báo dòng)
    <% String message = (String) request.getAttribute("message"); %>
    <% if (message != null && !message.isEmpty()) { %>
    alert("<%= message.replace("\"", "\\\"") %>");
    <% } %>

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
        const avatarInput = document.querySelector(".left-side input[type=file]");

        const isEditing = btnEdit.textContent === "Cancel";

        if (isEditing) {
            inputs.forEach(input => input.disabled = true);
            btnSave.disabled = true;
            btnEdit.textContent = "Edit";
            avatarInput.disabled = true;
        } else {
            inputs.forEach(input => {
                if (input.id !== 'email') input.disabled = false;
            });
            btnSave.disabled = false;
            btnEdit.textContent = "Cancel";
            avatarInput.disabled = false;
        }
    }

    function validateForm() {
        const fullName = document.getElementById("fullName").value.trim();
        const dob = document.getElementById("dob").value;
        const gender = document.getElementById("gender").value;
        const phone = document.getElementById("phoneNumber").value.trim();
        const email = document.getElementById("email").value.trim();

        if (fullName.length < 2) {
            alert("Full name must be at least 2 characters.");
            return false;
        }

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

        if (gender !== "Male" && gender !== "Female" && gender !== "Other") {
            alert("Please select your gender.");
            return false;
        }

        const phonePattern = /^[0-9+ \-]+$/;
        if (!phonePattern.test(phone)) {
            alert("Phone number is invalid. Only digits, +, -, and spaces are allowed.");
            return false;
        }
        const digitsOnly = phone.replace(/\D/g, '');
        if (digitsOnly.length < 10 || digitsOnly.length > 11) {
            alert("Phone number must contain between 10 and 11 digits.");
            return false;
        }

        const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailPattern.test(email)) {
            alert("Invalid email address.");
            return false;
        }

        return true;
    }
</script>
</body>
</html>

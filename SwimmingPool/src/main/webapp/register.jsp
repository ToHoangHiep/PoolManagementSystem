<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.UserProfile" %>
<%
    UserProfile user = (UserProfile) request.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Profile</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: #f4f6f8;
            padding: 40px;
            display: flex;
            justify-content: center;
        }

        .container {
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
            width: 600px;
            padding: 30px 40px;
        }

        .tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .tabs button {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            background-color: #e0e7ff;
            font-weight: 600;
            cursor: pointer;
        }

        .profile-header {
            display: flex;
            align-items: center;
            gap: 30px;
            margin-bottom: 20px;
        }

        .profile-image {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background-color: #d1d5db;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            color: #6b7280;
            position: relative;
            overflow: hidden;
        }

        .profile-image input {
            position: absolute;
            width: 100%;
            height: 100%;
            opacity: 0;
            cursor: pointer;
        }

        .profile-form .form-group {
            margin-bottom: 16px;
        }

        .form-group label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
            color: #374151;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            font-size: 14px;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }

        .form-actions button {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
        }

        .form-actions button:first-child {
            background-color: #e5e7eb;
        }

        .form-actions button:last-child {
            background-color: #4f46e5;
            color: white;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="tabs">
        <button>Profile</button>
        <button>History</button>
    </div>
    <div class="profile-header">
        <div class="profile-image">
            Upload
            <input type="file" accept="image/*">
        </div>
        <h2>User Profile</h2>
    </div>
    <form class="profile-form">
        <div class="form-group">
            <label for="name">Name</label>
            <input type="text" id="name" name="name" value="<%= user != null ? user.getFullName() : "" %>">
        </div>
        <div class="form-group">
            <label for="dob">Date of Birth</label>
            <input type="date" id="dob" name="dob" value="<%= user != null ? user.getDob() : "" %>">
        </div>
        <div class="form-group">
            <label for="gender">Gender</label>
            <select id="gender" name="gender">
                <option value="">Select Gender</option>
                <option value="male" <%= user != null && "male".equalsIgnoreCase(user.getGender()) ? "selected" : "" %>>Male</option>
                <option value="female" <%= user != null && "female".equalsIgnoreCase(user.getGender()) ? "selected" : "" %>>Female</option>
                <option value="other" <%= user != null && "other".equalsIgnoreCase(user.getGender()) ? "selected" : "" %>>Other</option>
            </select>
        </div>
        <div class="form-group">
            <label for="phone">Phone</label>
            <input type="tel" id="phone" name="phone" value="<%= user != null ? user.getPhoneNumber() : "" %>">
        </div>
        <div class="form-group">
            <label for="address">Address</label>
            <input type="text" id="address" name="address" value="<%= user != null ? user.getAddress() : "" %>">
        </div>
        <div class="form-actions">
            <button type="button">Edit</button>
            <button type="submit">Save</button>
        </div>
    </form>
</div>
</body>
</html>

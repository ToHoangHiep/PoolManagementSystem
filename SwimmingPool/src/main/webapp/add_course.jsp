<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.User" %>
<%-- Quyền truy cập đã được kiểm tra trong CoachCourseServlet --%>
<html>
<head>
    <title>Add New Course</title>
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 40px;
        }

        .form-container {
            background-color: #fff;
            max-width: 600px;
            margin: 0 auto;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }

        h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: #333;
        }

        input[type="text"],
        input[type="number"],
        textarea {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 15px;
        }

        textarea {
            resize: vertical;
        }

        button {
            width: 100%;
            padding: 12px;
            font-size: 16px;
            font-weight: bold;
            color: white;
            background-color: #007bff;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

<div class="form-container">
    <h2>Add New Course</h2>

    <form action="coachcourse" method="post" onsubmit="return validateCourseForm();">
        <input type="hidden" name="action" value="add" />

        <div class="form-group">
            <label for="name">Course Name</label>
            <input type="text" name="name" id="name" required>
        </div>

        <div class="form-group">
            <label for="description">Description</label>
            <textarea name="description" id="description" rows="4" required></textarea>
        </div>

        <div class="form-group">
            <label for="price">Price ($)</label>
            <input type="number" step="0.01" name="price" id="price" required>
        </div>

        <div class="form-group">
            <label for="duration">Duration (minutes)</label>
            <input type="number" name="duration" id="duration" required>
        </div>

        <button type="submit">Add Course</button>
    </form>
</div>

<script>
    function validateCourseForm() {
        const name = document.getElementById("name").value.trim();
        const description = document.getElementById("description").value.trim();
        const price = document.getElementById("price").value.trim();
        const duration = document.getElementById("duration").value.trim();

        if (!name || !description || isNaN(price) || price <= 0 || isNaN(duration) || duration <= 0) {
            alert("Please fill all fields correctly.");
            return false;
        }
        return true;
    }
</script>

</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.SwimCourse" %>
<%
  SwimCourse course = (SwimCourse) request.getAttribute("course");
%>
<html>
<head>
  <title>Edit Course</title>
  <style>
    body {
      font-family: 'Segoe UI', sans-serif;
      background-color: #f5f7fb;
      padding: 50px;
      margin: 0;
    }

    .form-container {
      max-width: 600px;
      margin: 0 auto;
      background: white;
      padding: 30px 40px;
      border-radius: 10px;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
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
      margin-bottom: 8px;
      font-weight: 600;
      color: #333;
    }

    input[type="text"],
    input[type="number"],
    textarea {
      width: 100%;
      padding: 10px;
      border: 1px solid #ccc;
      border-radius: 6px;
      font-size: 14px;
      box-sizing: border-box;
    }

    textarea {
      resize: vertical;
    }

    button {
      width: 100%;
      padding: 12px;
      background-color: #007bff;
      color: white;
      border: none;
      border-radius: 6px;
      font-size: 16px;
      font-weight: bold;
      cursor: pointer;
      transition: background-color 0.2s ease;
    }

    button:hover {
      background-color: #0056b3;
    }
  </style>
</head>
<body>

<div class="form-container">
  <h2>Edit Course</h2>

  <form action="coachcourse" method="post" onsubmit="return validateEditForm();">
    <input type="hidden" name="action" value="edit">
    <input type="hidden" name="id" value="<%= course.getId() %>">
    <input type="hidden" name="status" value="<%= course.getStatus() %>">

    <div class="form-group">
      <label for="name">Course Name</label>
      <input type="text" name="name" id="name" value="<%= course.getName() %>" required>
    </div>

    <div class="form-group">
      <label for="description">Description</label>
      <textarea name="description" id="description" rows="4" required><%= course.getDescription() %></textarea>
    </div>

    <div class="form-group">
      <label for="price">Price ($)</label>
      <input type="number" step="0.01" name="price" id="price" value="<%= course.getPrice() %>" required>
    </div>

    <div class="form-group">
      <label for="duration">Duration (minutes)</label>
      <input type="number" name="duration" id="duration" value="<%= course.getDuration() %>" required>
    </div>

    <button type="submit">Save Changes</button>
  </form>
</div>

<script>
  function validateEditForm() {
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

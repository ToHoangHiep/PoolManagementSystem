<%@ page import="model.User" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Maintenance Schedule</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" integrity="sha512-SnH5WK+bZxgPHs44uWIX+LLJAJ9/2PkPKZ5QiAj6Ta86w+fsb2TkcmfRyVX3pBnMFcV7oQPJkl9QevSCWr3W6A==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        body {
            background-color: #f8f9fa;
        }
        .container {
            margin-top: 30px;
        }
        .card {
            box-shadow: 0 0.25rem 0.5rem rgba(0, 0, 0, 0.05);
            border-radius: 0.75rem;
        }
        .card-header {
            background-color: #007bff;
            color: white;
            padding: 1rem 1.25rem;
            border-bottom: none;
            border-top-left-radius: 0.75rem;
            border-top-right-radius: 0.75rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .card-header h2 {
            margin: 0;
            font-size: 1.75rem;
            display: flex;
            align-items: center;
        }
        .card-header h2 i {
            margin-right: 0.5rem;
        }
        .card-body {
            padding: 1.25rem;
        }
        .form-label {
            font-weight: 500;
            margin-top: 0.5rem;
        }
        .form-control, .form-select {
            border-radius: 0.5rem;
        }
        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }
        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #0056b3;
        }
        .btn-secondary {
            background-color: #6c757d;
            border-color: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background-color: #5a6268;
            border-color: #545b62;
        }
    </style>
</head>
<body>

<% if (request.getAttribute("error") != null) { %>
<div class="alert alert-danger" role="alert">
    <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
</div>
<% } %>


<div class="container">
    <div class="card">
        <div class="card-header">
            <h2><i class="fas fa-plus-circle"></i> Add Maintenance Schedule</h2>
            <a href="maintenance" class="btn btn-secondary btn-sm"><i class="fas fa-arrow-left me-2"></i>Back to List</a>
        </div>
        <div class="card-body">
            <form action="maintenance?action=insert" method="post">
                <div class="mb-3">
                    <label for="title" class="form-label"><i class="fas fa-heading"></i> Title:</label>
                    <input type="text" class="form-control" id="title" name="title" required>
                </div>
                <div class="mb-3">
                    <label for="description" class="form-label"><i class="fas fa-file-alt"></i> Description:</label>
                    <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
                </div>
                <div class="mb-3">
                    <label for="frequency" class="form-label"><i class="fas fa-redo-alt"></i> Frequency:</label>
                    <select class="form-select" id="frequency" name="frequency" required>
                        <option value="Daily">Daily</option>
                        <option value="Weekly">Weekly</option>
                        <option value="Monthly">Monthly</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="assignedStaffId" class="form-label"><i class="fas fa-user-tie"></i> Assigned Staff:</label>
                    <select class="form-select" id="assignedStaffId" name="assignedStaffId" required>
                        <option value="">Select staff</option>
                        <%
                            List<User> staffList = (List<User>) request.getAttribute("staffList");
                            if (staffList != null) {
                                for (User staff : staffList) {
                        %>
                        <option value="<%= staff.getId() %>"><%= staff.getFullName() %></option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="scheduledTime" class="form-label"><i class="fas fa-clock"></i> Time:</label>
                    <input type="time" class="form-control" id="scheduledTime" name="scheduledTime" required>
                </div>
                <div class="mb-3">
                    <label for="status" class="form-label"><i class="fas fa-info-circle"></i> Status:</label>
                    <select class="form-select" id="status" name="status" required>
                        <option value="Scheduled">Scheduled</option>
                        <option value="Completed">Completed</option>
                        <option value="Missed">Missed</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Save</button>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>

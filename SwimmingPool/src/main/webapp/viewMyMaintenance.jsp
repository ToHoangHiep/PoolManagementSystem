<%@ page import="java.util.List" %>
<%@ page import="model.MaintenanceSchedule" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    List<MaintenanceSchedule> schedules = (List<MaintenanceSchedule>) request.getAttribute("schedules");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Maintenance Schedules</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            background-color: #eef2f6; /* Light gray-blue background */
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #333;
        }

        .container-fluid {
            padding: 40px 20px;
        }

        .card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
            overflow: hidden; /* Ensures border-radius applies to children */
        }

        .card-header {
            background-image: linear-gradient(to right, #6a11cb 0%, #2575fc 100%); /* Gradient header */
            color: white;
            padding: 20px 25px;
            font-size: 1.75rem;
            font-weight: 600;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: none;
        }

        .card-body {
            padding: 30px 25px;
        }

        .table-responsive {
            margin-top: 20px;
            border-radius: 10px;
            overflow: hidden; /* To keep the rounded corners for the table */
        }

        .table {
            --bs-table-bg: #ffffff; /* White background for table */
            --bs-table-hover-bg: #f5f5f5; /* Light hover effect */
            border-collapse: separate; /* Required for border-radius on cells in some browsers */
            border-spacing: 0; /* No space between cell borders */
        }

        .table thead th {
            background-color: #f0f3f7; /* Slightly darker header for table */
            color: #555;
            font-weight: 600;
            border-bottom: 2px solid #dee2e6;
            padding: 15px 12px;
            vertical-align: middle;
        }

        .table tbody tr:last-child td {
            border-bottom: none;
        }

        .table td {
            padding: 12px;
            vertical-align: middle;
            border-top: 1px solid #eee;
        }

        .status-badge {
            padding: .5em 1em;
            border-radius: .4rem;
            font-weight: bold;
            font-size: 0.85em;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .status-Scheduled {
            background-color: #0d6efd; /* Bootstrap primary */
            color: white;
        }

        .status-Completed {
            background-color: #198754; /* Bootstrap success */
            color: white;
        }

        .status-Missed {
            background-color: #dc3545; /* Bootstrap danger */
            color: white;
        }

        .form-select {
            border-radius: .4rem;
            padding: .4rem 1rem;
            font-size: 0.9em;
            cursor: pointer;
        }

        .action-link {
            color: #007bff; /* Bootstrap blue */
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s ease-in-out;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .action-link:hover {
            color: #0056b3;
            text-decoration: underline;
        }

        .alert-info {
            background-color: #e0f7fa; /* Light cyan */
            color: #007bb6; /* Darker blue for text */
            border-color: #b2ebf2;
            border-radius: 8px;
            padding: 20px;
            margin-top: 20px;
        }

        /* Style for the Back to Home button */
        .btn-back-home {
            background-color: #ffffff; /* White background */
            color: #6a11cb; /* Matches gradient start color */
            border: 1px solid #6a11cb; /* Border matching text */
            padding: 8px 15px;
            border-radius: .4rem;
            font-size: 1rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-back-home:hover {
            background-color: #6a11cb;
            color: white;
            border-color: #6a11cb;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="card">
        <div class="card-header">
            <span><i class="fas fa-clipboard-list me-2"></i>My Maintenance Schedules</span>
            <a href="home.jsp" class="btn btn-back-home">
                <i class="fas fa-home"></i> Back to Home
            </a>
        </div>
        <div class="card-body">
            <% if (schedules == null || schedules.isEmpty()) { %>
            <div class="alert alert-info text-center" role="alert">
                <p class="mb-0">
                    <i class="fas fa-info-circle me-2"></i>You have no assigned maintenance schedules at this time.
                </p>
            </div>
            <% } else { %>
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                    <tr>

                        <th>Title</th>
                        <th>Description</th>
                        <th>Frequency</th>
                        <th>Scheduled Time</th>
                        <th>Status</th>
                        <th class="text-center">Actions</th>
                        <th>Details</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (MaintenanceSchedule m : schedules) { %>
                    <tr>

                        <td><%= m.getTitle() %></td>
                        <td><%= m.getDescription() %></td>
                        <td><%= m.getFrequency() %></td>
                        <td><%= m.getScheduledTime() %></td>
                        <td>
                            <span class="status-badge status-<%= m.getStatus() %>">
                                <% if ("Scheduled".equals(m.getStatus())) { %>
                                    <i class="far fa-clock"></i>
                                <% } else if ("Completed".equals(m.getStatus())) { %>
                                    <i class="fas fa-check-circle"></i>
                                <% } else if ("Missed".equals(m.getStatus())) { %>
                                    <i class="fas fa-times-circle"></i>
                                <% } %>
                                <%= m.getStatus() %>
                            </span>
                        </td>
                        <td>
                            <form action="viewMyMaintenance" method="post" class="d-flex justify-content-center">
                                <input type="hidden" name="id" value="<%= m.getId() %>"/>
                                <select name="status" class="form-select form-select-sm" onchange="this.form.submit()">
                                    <option value="Scheduled" <%= "Scheduled".equals(m.getStatus()) ? "selected" : "" %>>
                                        Scheduled
                                    </option>
                                    <option value="Completed" <%= "Completed".equals(m.getStatus()) ? "selected" : "" %>>
                                        Completed
                                    </option>
                                    <option value="Missed" <%= "Missed".equals(m.getStatus()) ? "selected" : "" %>>
                                        Missed
                                    </option>
                                </select>
                            </form>
                        </td>
                        <td>
                            <a href="viewMyMaintenance?action=viewDetail&id=<%= m.getId() %>" class="action-link"
                               data-bs-toggle="tooltip" data-bs-placement="top" title="View details">
                                <i class="fas fa-info-circle"></i> View Details
                            </a>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
<script>
    // Initialize tooltips
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl)
    })
</script>
</body>
</html>
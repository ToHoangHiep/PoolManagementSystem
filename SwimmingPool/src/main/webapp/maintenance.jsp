<%@ page import="java.util.List" %>
<%@ page import="model.MaintenanceSchedule" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
  List<MaintenanceSchedule> schedules = (List<MaintenanceSchedule>) request.getAttribute("schedules");
  int totalPages = (Integer) request.getAttribute("totalPages");
  int currentPage = (Integer) request.getAttribute("currentPage");
  String searchStatus = (String) request.getAttribute("searchStatus");
  String searchTitle = (String) request.getAttribute("searchTitle");
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Maintenance Schedule Management</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" integrity="sha512-SnH5WK+bZxgPHs44uWIX+LLJAJ9/2PkPKZ5QiAj6Ta86w+fsb2TkcmfRyVX3pBnMFcV7oQPJkl9QevSCWr3W6A==" crossorigin="anonymous" referrerpolicy="no-referrer" />
  <style>
    body {
      background-color: #f8f9fa;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }
    .container-fluid {
      padding-top: 30px;
      padding-bottom: 30px;
    }
    .card {
      box-shadow: 0 4px 8px rgba(0,0,0,.05);
      border-radius: 10px;
      margin-bottom: 20px;
    }
    .card-header {
      background-color: #007bff;
      color: white;
      border-bottom: none;
      border-top-left-radius: 10px;
      border-top-right-radius: 10px;
      padding: 15px 20px;
      display: flex;
      align-items: center;
      justify-content: space-between; /* Ensures space between title and buttons */
    }
    .card-header h2 {
      margin: 0;
      color: white;
      font-size: 1.75rem;
      display: flex;
      align-items: center;
    }
    .card-header h2 i {
      margin-right: 10px;
    }
    .btn-primary {
      background-color: #007bff;
      border-color: #007bff;
    }
    .btn-primary:hover {
      background-color: #0056b3;
      border-color: #004085;
    }
    .form-control, .form-select {
      border-radius: .50rem;
    }
    .table-responsive {
      margin-top: 20px;
    }
    .table th {
      background-color: #e9ecef;
      color: #495057;
      vertical-align: middle;
      font-weight: 600;
    }
    .table td {
      vertical-align: middle;
    }
    .table tbody tr:hover {
      background-color: #f2f2f2;
    }
    .status-badge {
      padding: .4em .6em;
      border-radius: .3rem;
      font-weight: bold;
      font-size: 0.85em;
    }
    .status-Scheduled {
      background-color: #0d6efd;
      color: white;
    }
    .status-Completed {
      background-color: #198754;
      color: white;
    }
    .status-Missed {
      background-color: #dc3545;
      color: white;
    }
    .pagination .page-item .page-link {
      border-radius: .50rem;
      margin: 0 3px;
    }
    .pagination .page-item.active .page-link {
      background-color: #007bff;
      border-color: #007bff;
      color: white;
    }
    .pagination .page-item .page-link:focus {
      box-shadow: 0 0 0 .25rem rgba(0, 123, 255, .25);
    }
    .action-buttons a {
      margin-right: 8px;
      color: #007bff;
      text-decoration: none;
    }
    .action-buttons a:hover {
      text-decoration: underline;
    }
    .action-buttons a.text-danger {
      color: #dc3545 !important;
    }
    .action-buttons a.text-danger:hover {
      color: #bd2130 !important;
    }
    .no-records {
      text-align: center;
      padding: 40px;
      background-color: #fff;
      border-radius: 10px;
      box-shadow: 0 2px 4px rgba(0,0,0,.05);
      margin-top: 20px;
      font-size: 1.1rem;
      color: #6c757d;
    }
    /* New style for the Back to Home button */
    .btn-back-home {
      background-color: #ffffff; /* White background */
      color: #007bff; /* Primary blue color */
      border: 1px solid #007bff; /* Border matching text */
      padding: 8px 15px;
      border-radius: .4rem;
      font-size: 1rem;
      font-weight: 600;
      text-decoration: none;
      transition: all 0.3s ease;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      margin-left: 15px; /* Space between "Add New" and "Back to Home" */
    }

    .btn-back-home:hover {
      background-color: #007bff;
      color: white;
      border-color: #007bff;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
    }

    .header-buttons {
      display: flex;
      gap: 10px; /* Space between buttons in the header */
    }
  </style>
</head>
<body>
<div class="container-fluid">
  <div class="card">
    <div class="card-header">
      <h2><i class="fas fa-clipboard-list"></i> Maintenance Schedule List</h2>
      <div class="header-buttons">
        <a href="maintenance?action=new" class="btn btn-light"><i class="fas fa-plus-circle me-2"></i>Add New Maintenance Schedule</a>
        <a href="home.jsp" class="btn btn-back-home"><i class="fas fa-home"></i> Back to Home</a>
      </div>
    </div>
    <div class="card-body">
      <form class="row g-3 align-items-end mb-4" action="maintenance" method="get">
        <div class="col-md-4 col-lg-3">
          <label for="searchStatus" class="form-label"><i class="fas fa-filter me-2"></i>Search by status:</label>
          <select name="searchStatus" id="searchStatus" class="form-select">
            <option value="" <%= (searchStatus == null || searchStatus.isEmpty()) ? "selected" : "" %>>All</option>
            <option value="Scheduled" <%= "Scheduled".equals(searchStatus) ? "selected" : "" %>>Scheduled <i class="fas fa-clock"></i></option>
            <option value="Completed" <%= "Completed".equals(searchStatus) ? "selected" : "" %>>Completed <i class="fas fa-check-circle"></i></option>
            <option value="Missed" <%= "Missed".equals(searchStatus) ? "selected" : "" %>>Missed <i class="fas fa-times-circle"></i></option>
          </select>
        </div>
        <div class="col-md-5 col-lg-4">
          <label for="searchTitle" class="form-label"><i class="fas fa-search me-2"></i>Search by title:</label>
          <input type="text" name="searchTitle" id="searchTitle" class="form-control" placeholder="Enter title..." value="<%= searchTitle != null ? searchTitle : "" %>" />
        </div>
        <div class="col-md-3 col-lg-2">
          <button type="submit" class="btn btn-primary w-100"><i class="fas fa-search me-2"></i>Search</button>
        </div>
      </form>

      <% if (schedules == null || schedules.isEmpty()) { %>
      <div class="alert alert-info text-center no-records" role="alert">
        <i class="fas fa-info-circle fa-2x mb-3"></i>
        <p class="mb-0">No maintenance schedules found matching your search criteria.</p>
      </div>
      <% } else { %>
      <div class="table-responsive">
        <table class="table table-hover table-bordered align-middle">
          <thead class="table-light">
          <tr>
            <th><i class="fas fa-hashtag"></i> ID</th>
            <th><i class="fas fa-heading"></i> Title</th>
            <th><i class="fas fa-file-alt"></i> Description</th>
            <th><i class="fas fa-redo-alt"></i> Frequency</th>
            <th><i class="fas fa-clock"></i> Time</th>
            <th><i class="fas fa-info-circle"></i> Status</th>
            <th><i class="fas fa-user-tie"></i> Staff</th>
            <th><i class="fas fa-user-plus"></i> Created By</th>
            <th><i class="fas fa-calendar-alt"></i> Created At</th>
            <th class="text-center"><i class="fas fa-cogs"></i> Actions</th>
          </tr>
          </thead>
          <tbody>
          <% for (MaintenanceSchedule m : schedules) { %>
          <tr>
            <td><%= m.getId() %></td>
            <td><%= m.getTitle() %></td>
            <td><%= m.getDescription() %></td>
            <td><%= m.getFrequency() %></td>
            <td><%= m.getScheduledTime() %></td>
            <td><span class="status-badge status-<%= m.getStatus() %>"><%= m.getStatus() %></span></td>
            <td><%= m.getAssignedStaffName() %></td>
            <td><%= m.getCreatedByName() %></td>
            <td><%= m.getCreatedAt() %></td>
            <td class="text-center action-buttons">
              <a href="maintenance?action=edit&id=<%= m.getId() %>" class="text-primary" data-bs-toggle="tooltip" data-bs-placement="top" title="Chỉnh sửa"><i class="fas fa-edit"></i> Edit</a>
              <a href="maintenance?action=delete&id=<%= m.getId() %>" class="text-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa lịch bảo trì này?');" data-bs-toggle="tooltip" data-bs-placement="top" title="Xóa"><i class="fas fa-trash-alt"></i> Delete</a>
            </td>
          </tr>
          <% } %>
          </tbody>
        </table>
      </div>

      <nav aria-label="Maintenance Schedule Pagination">
        <ul class="pagination justify-content-center mt-4">
          <% if (currentPage > 1) { %>
          <li class="page-item">
            <a class="page-link" href="maintenance?pageNo=<%= currentPage - 1 %><%= (searchStatus != null && !searchStatus.isEmpty()) ? "&searchStatus=" + searchStatus : "" %><%= (searchTitle != null && !searchTitle.isEmpty()) ? "&searchTitle=" + searchTitle : "" %>" aria-label="Previous page">
              <span aria-hidden="true">&laquo;</span> Previous
            </a>
          </li>
          <% } %>

          <% for (int i = 1; i <= totalPages; i++) { %>
          <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
            <a class="page-link" href="maintenance?pageNo=<%= i %><%= (searchStatus != null && !searchStatus.isEmpty()) ? "&searchStatus=" + searchStatus : "" %><%= (searchTitle != null && !searchTitle.isEmpty()) ? "&searchTitle=" + searchTitle : "" %>"><%= i %></a>
          </li>
          <% } %>

          <% if (currentPage < totalPages) { %>
          <li class="page-item">
            <a class="page-link" href="maintenance?pageNo=<%= currentPage + 1 %><%= (searchStatus != null && !searchStatus.isEmpty()) ? "&searchStatus=" + searchStatus : "" %><%= (searchTitle != null && !searchTitle.isEmpty()) ? "&searchTitle=" + searchTitle : "" %>" aria-label="Next page">
              Next <span aria-hidden="true">&raquo;</span>
            </a>
          </li>
          <% } %>
        </ul>
      </nav>
      <% } %>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<script>
  var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
  var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl)
  })
</script>
</body>
</html>
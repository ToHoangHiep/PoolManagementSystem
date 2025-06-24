<%@ page import="model.MaintenanceSchedule" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    MaintenanceSchedule schedule = (MaintenanceSchedule) request.getAttribute("schedule");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Lịch Bảo Trì</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" integrity="sha512-SnH5WK+bZxgPHs44uWIX+LLJAJ9/2PkPKZ5QiAj6Ta86w+fsb2TkcmfRyVX3pBnMFcV7oQPJkl9QevSCWr3W6A==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .container {
            margin-top: 30px;
            margin-bottom: 30px;
        }
        .card {
            box-shadow: 0 0.25rem 0.5rem rgba(0, 0, 0, 0.05);
            border-radius: 0.75rem;
        }
        .card-header {
            background-color: #17a2b8; /* Info blue for details */
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
        .table-striped-details tbody tr:nth-of-type(odd) {
            background-color: rgba(0, 0, 0, .05);
        }
        .table-striped-details th {
            width: 30%; /* Adjust as needed for label width */
            font-weight: 600;
            vertical-align: top;
            padding: 0.75rem;
            color: #495057;
        }
        .table-striped-details td {
            vertical-align: top;
            padding: 0.75rem;
        }
        .status-badge {
            padding: .4em .6em;
            border-radius: .3rem;
            font-weight: bold;
            font-size: 0.9em;
        }
        .status-Scheduled {
            background-color: #0d6efd; /* Blue */
            color: white;
        }
        .status-Completed {
            background-color: #198754; /* Green */
            color: white;
        }
        .status-Missed {
            background-color: #dc3545; /* Red */
            color: white;
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
        .alert-info {
            text-align: center;
            padding: 40px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,.05);
            margin-top: 20px;
            font-size: 1.1rem;
            color: #6c757d;
        }
        .alert-info i {
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="card">
        <div class="card-header">
            <h2><i class="fas fa-info-circle"></i> Chi Tiết Lịch Bảo Trì</h2>
            <a href="viewMyMaintenance" class="btn btn-secondary btn-sm"><i class="fas fa-arrow-left me-2"></i>Quay lại</a>
        </div>
        <div class="card-body">
            <% if (schedule != null) { %>
            <div class="table-responsive">
                <table class="table table-striped-details table-bordered">
                    <tbody>

                    <tr>
                        <th><i class="fas fa-heading me-2"></i>Tiêu đề</th>
                        <td><%= schedule.getTitle() %></td>
                    </tr>
                    <tr>
                        <th><i class="fas fa-file-alt me-2"></i>Mô tả</th>
                        <td><%= schedule.getDescription() %></td>
                    </tr>
                    <tr>
                        <th><i class="fas fa-redo-alt me-2"></i>Tần suất</th>
                        <td><%= schedule.getFrequency() %></td>
                    </tr>
                    <tr>
                        <th><i class="fas fa-clock me-2"></i>Thời gian</th>
                        <td><%= schedule.getScheduledTime() %></td>
                    </tr>
                    <tr>
                        <th><i class="fas fa-check-circle me-2"></i>Trạng thái</th>
                        <td><span class="status-badge status-<%= schedule.getStatus() %>"><%= schedule.getStatus() %></span></td>
                    </tr>
                    <tr>
                        <th><i class="fas fa-user-tie me-2"></i>Nhân viên</th>
                        <td><%= schedule.getAssignedStaffName() %></td>
                    </tr>
                    <tr>
                        <th><i class="fas fa-user-plus me-2"></i>Người tạo</th>
                        <td><%= schedule.getCreatedByName() %></td>
                    </tr>
                    <tr>
                        <th><i class="fas fa-calendar-alt me-2"></i>Ngày tạo</th>
                        <td><%= schedule.getCreatedAt() %></td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <% } else { %>
            <div class="alert alert-info" role="alert">
                <i class="fas fa-exclamation-triangle fa-2x mb-3"></i>
                <p class="mb-0">Không tìm thấy lịch bảo trì này.</p>
            </div>
            <% } %>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>
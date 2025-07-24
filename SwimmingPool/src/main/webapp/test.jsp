<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <title>Maintenance Tracking</title>
    <!-- Bootstrap CSS -->
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
            rel="stylesheet"/>
</head>
<body>
<div class="container my-5">
    <h1 class="text-center mb-4">Maintenance Tracking</h1>

    <!-- Nav tabs (5 transactions) -->
    <ul class="nav nav-tabs" id="mtTab" role="tablist">
        <li class="nav-item">
            <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#new">
                1) New Request
            </button>
        </li>
        <li class="nav-item">
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#schedule">
                2) Schedule
            </button>
        </li>
        <li class="nav-item">
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#troubleshoot">
                3) Troubleshoot
            </button>
        </li>
        <li class="nav-item">
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#history">
                4) History
            </button>
        </li>
        <li class="nav-item">
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#reports">
                5) Analytics
            </button>
        </li>
    </ul>

    <div class="tab-content border p-4">
        <!-- 1) New Request (11 fields) -->
        <div class="tab-pane fade show active" id="new">
            <h4>New Maintenance Request</h4>
            <form action="submitMaintenance" method="post">
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Request ID</label>
                        <input type="text" class="form-control" name="requestId" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Equipment ID</label>
                        <input type="text" class="form-control" name="equipmentId" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Equipment Name</label>
                        <input type="text" class="form-control" name="equipmentName" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Location</label>
                        <input type="text" class="form-control" name="location" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Reported By</label>
                        <input type="text" class="form-control" name="reportedBy" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Reported Date</label>
                        <input type="date" class="form-control" name="reportedDate" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Priority</label>
                        <select class="form-select" name="priority" required>
                            <option value="">Select</option>
                            <option>Low</option>
                            <option>Medium</option>
                            <option>High</option>
                        </select>
                    </div>
                    <div class="col-md-8 mb-3">
                        <label class="form-label">Problem Description</label>
                        <textarea class="form-control" name="description" rows="2" required></textarea>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Suggested Action</label>
                        <textarea class="form-control" name="suggestedAction" rows="2" required></textarea>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Next Inspection Date</label>
                        <input type="date" class="form-control" name="nextInspection" required>
                    </div>
                </div>
                <button type="submit" class="btn btn-primary">Create Request</button>
            </form>
        </div>

        <!-- 2) Schedule Maintenance -->
        <div class="tab-pane fade" id="schedule">
            <h4>Schedule Maintenance</h4>
            <form action="submitSchedule" method="post">
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Schedule ID</label>
                        <input type="text" class="form-control" name="scheduleId" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Request ID</label>
                        <input type="text" class="form-control" name="requestId" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Scheduled Date</label>
                        <input type="date" class="form-control" name="scheduledDate" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Start Time</label>
                        <input type="time" class="form-control" name="startTime" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">End Time</label>
                        <input type="time" class="form-control" name="endTime" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Technician</label>
                        <input type="text" class="form-control" name="technician" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Location</label>
                        <input type="text" class="form-control" name="location" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Status</label>
                        <select class="form-select" name="status" required>
                            <option value="">Select</option>
                            <option>Pending</option>
                            <option>In Progress</option>
                            <option>Completed</option>
                        </select>
                    </div>
                    <div class="col-12 mb-3">
                        <label class="form-label">Comments</label>
                        <textarea class="form-control" name="comments" rows="2"></textarea>
                    </div>
                </div>
                <button type="submit" class="btn btn-success">Save Schedule</button>
            </form>
        </div>

        <!-- 3) Record Troubleshooting -->
        <div class="tab-pane fade" id="troubleshoot">
            <h4>Record Troubleshooting</h4>
            <form action="submitTroubleshoot" method="post">
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Troubleshoot ID</label>
                        <input type="text" class="form-control" name="troubleshootId" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Schedule ID</label>
                        <input type="text" class="form-control" name="scheduleId" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Issue Detected</label>
                        <input type="text" class="form-control" name="issueDetected" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Root Cause</label>
                        <textarea class="form-control" name="rootCause" rows="2" required></textarea>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Action Taken</label>
                        <textarea class="form-control" name="actionTaken" rows="2" required></textarea>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Parts Replaced</label>
                        <input type="text" class="form-control" name="partsReplaced">
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Time Spent (hrs)</label>
                        <input type="number" step="0.1" class="form-control" name="timeSpent" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Result Status</label>
                        <select class="form-select" name="resultStatus" required>
                            <option value="">Select</option>
                            <option>Successful</option>
                            <option>Unresolved</option>
                            <option>Escalated</option>
                        </select>
                    </div>
                    <div class="col-12 mb-3">
                        <label class="form-label">Additional Notes</label>
                        <textarea class="form-control" name="notes" rows="2"></textarea>
                    </div>
                </div>
                <button type="submit" class="btn btn-primary">Save Troubleshoot</button>
            </form>
        </div>

        <!-- 4) Maintenance History -->
        <div class="tab-pane fade" id="history">
            <h4>Maintenance History</h4>
            <table class="table table-striped">
                <thead>
                <tr>
                    <th>Req ID</th><th>Equip</th><th>Date</th><th>Status</th><th>Tech</th>
                </tr>
                </thead>
                <tbody>
                <tr><td>1001</td><td>EQ123</td><td>2025-05-20</td><td>Completed</td><td>John</td></tr>
                <tr><td>1002</td><td>EQ124</td><td>2025-05-18</td><td>Completed</td><td>Jane</td></tr>
                <tr><td>1003</td><td>EQ125</td><td>2025-05-15</td><td>In Progress</td><td>Bob</td></tr>
                <tr><td>1004</td><td>EQ126</td><td>2025-05-12</td><td>Cancelled</td><td>Alice</td></tr>
                <tr><td>1005</td><td>EQ127</td><td>2025-05-10</td><td>Pending</td><td>Mary</td></tr>
                </tbody>
            </table>
        </div>

        <!-- 5) Analytics / Reports -->
        <div class="tab-pane fade" id="reports">
            <h4>Analytics & Reports</h4>
            <ul>
                <li><strong>Total Requests:</strong> 25</li>
                <li><strong>Completed:</strong> 18</li>
                <li><strong>Pending:</strong> 5</li>
                <li><strong>Avg. Resolution Time:</strong> 2.3 days</li>
            </ul>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

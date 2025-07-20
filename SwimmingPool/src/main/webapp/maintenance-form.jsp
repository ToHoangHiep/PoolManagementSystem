<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>

<%@ page import="model.MaintenanceSchedule" %>

<%@ page import="model.PoolArea" %>

<%@ page import="model.User" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>



<%

  List<MaintenanceSchedule> templates = (List<MaintenanceSchedule>) request.getAttribute("templates");

  List<PoolArea> areas = (List<PoolArea>) request.getAttribute("areas");

  List<User> staffs = (List<User>) request.getAttribute("staffs");

%>

<!DOCTYPE html>

<html lang="vi">

<head>

  <meta charset="UTF-8">

  <title>Create Maintenance Task</title>

  <link rel="stylesheet" href="Resources/CSS/style.css">

</head>

<body>

<h2>Create Maintenance Task</h2>

<form action="MaintenanceServlet" method="post">

  <input type="hidden" name="action" value="create"/>



  <!-- Use template -->

  <label for="templateId">Use Template:</label>

  <select name="templateId" id="templateId">

    <option value="">-- None --</option>

    <c:forEach var="t" items="${templates}">

      <option value="${t.id}"

              data-title="${t.title}"

              data-description="${t.description}"

              data-frequency="${t.frequency}"

              data-time="${t.scheduledTime}">

          ${t.title} (${t.frequency} at ${t.scheduledTime})

      </option>

    </c:forEach>

  </select>

  <br/><br/>



  <!-- Title -->

  <label for="title">Title:</label>

  <input type="text" name="title" id="title" required />

  <br/><br/>



  <!-- Description -->

  <label for="description">Description:</label><br/>

  <textarea name="description" id="description" rows="4" cols="50" required></textarea>

  <br/><br/>



  <!-- Frequency -->

  <label for="frequency">Frequency:</label>

  <select name="frequency" id="frequency" required>

    <option value="Daily">Daily</option>

    <option value="Weekly">Weekly</option>

    <option value="Monthly">Monthly</option>

  </select>

  <br/><br/>



  <!-- Scheduled Time -->

  <label for="scheduledTime">Scheduled Time:</label>

  <input type="time" name="scheduledTime" id="scheduledTime" required />

  <br/><br/>



  <!-- Area -->

  <label for="areaId">Area:</label>

  <select name="areaId" id="areaId" required>

    <c:forEach var="a" items="${areas}">

      <option value="${a.id}">${a.name}</option>

    </c:forEach>

  </select>

  <br/><br/>



  <!-- Staff -->

  <label for="staffId">Assign to Staff:</label>

  <select name="staffId" id="staffId" required>

    <c:forEach var="u" items="${staffs}">

      <option value="${u.id}">${u.fullName}</option>

    </c:forEach>

  </select>

  <br/><br/>



  <button type="submit">Create Schedule</button>

</form>



<script>

  const templateSel = document.getElementById('templateId');

  const titleInput = document.getElementById('title');

  const descInput = document.getElementById('description');

  const freqSel = document.getElementById('frequency');

  const timeInput = document.getElementById('scheduledTime');



  templateSel.addEventListener('change', function() {

    const opt = this.options[this.selectedIndex];

    const hasTpl = opt.value !== '';

    if (hasTpl) {

// fill and lock

      titleInput.value = opt.getAttribute('data-title') || '';

      descInput.value = opt.getAttribute('data-description') || '';

      freqSel.value = opt.getAttribute('data-frequency') || 'Daily';

      timeInput.value = opt.getAttribute('data-time') || '';



      titleInput.readOnly = true;

      descInput.readOnly = true;

    } else {

// clear and unlock

      titleInput.value = '';

      descInput.value = '';

      freqSel.value = 'Daily';

      timeInput.value = '';



      titleInput.readOnly = false;

      descInput.readOnly = false;

    }

  });

</script>

</body>

</html>
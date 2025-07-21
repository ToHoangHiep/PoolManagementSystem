
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Course Sign Up</title>
    <script>
        function showCourseInfo() {
            var select = document.getElementById("courseId");
            var selectedOption = select.options[select.selectedIndex];
            var description = selectedOption.getAttribute("data-description");
            var price = selectedOption.getAttribute("data-price");
            document.getElementById("courseInfo").innerHTML = "Description: " + description + "<br>Price: " + price;
        }

        function showCoachInfo() {
            var select = document.getElementById("coachId");
            var selectedOption = select.options[select.selectedIndex];
            var specialty = selectedOption.getAttribute("data-specialty");
            document.getElementById("coachInfo").innerHTML = "Specialty: " + specialty;
        }
    </script>
</head>
<body>
    <h1>Course Sign Up</h1>
    <form action="course-signup" method="post">
        <c:if test="${sessionScope.user == null}">
            <h2>Personal Information</h2>
            <label for="name">Name:</label>
            <input type="text" id="name" name="name" required><br>
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required><br>
            <label for="phone">Phone:</label>
            <input type="text" id="phone" name="phone" required><br>
        </c:if>

        <h2>Course and Coach Selection</h2>
        <label for="courseId">Course:</label>
        <select id="courseId" name="courseId" onchange="showCourseInfo()" <c:if test="${not empty param.courseId}">disabled</c:if>>
            <c:forEach var="course" items="${courses}">
                <option value="${course.courseId}" data-description="${course.description}" data-price="${course.price}" <c:if test="${course.courseId == param.courseId}">selected</c:if>>
                    ${course.courseName}
                </option>
            </c:forEach>
        </select>
        <div id="courseInfo"></div>

        <label for="coachId">Coach:</label>
        <select id="coachId" name="coachId" onchange="showCoachInfo()" <c:if test="${not empty param.coachId}">disabled</c:if>>
            <c:forEach var="coach" items="${coaches}">
                <option value="${coach.coachId}" data-specialty="${coach.specialty}" <c:if test="${coach.coachId == param.coachId}">selected</c:if>>
                    ${coach.name}
                </option>
            </c:forEach>
        </select>
        <div id="coachInfo"></div>

        <input type="submit" value="Sign Up">
    </form>
</body>
</html>

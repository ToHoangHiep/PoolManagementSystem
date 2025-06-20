<%-- 
  Created by IntelliJ IDEA.
  User: LAPTOP
  Date: 30-May-25
  Time: 11:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Error Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            margin-top: 50px;
        }
        .error-message {
            font-size: 20px;
            color: #ff0000;
        }
        .back-button {
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #007bff;
            color: #ffffff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
        }
        .back-button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="error-message">
        <p>Oops! Something went wrong.</p>
        <p>Let's go back to the main page, maybe you'll find something there?</p>
    </div>

    <!-- TODO: Add a link to the home page -->
    <a href="home.jsp" class="back-button">Go Back to Home</a>
</body>
</html>
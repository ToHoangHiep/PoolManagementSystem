<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Registration</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .register-box {
            background: #fff;
            padding: 30px;
            width: 320px;
            border-radius: 30px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        h2 { margin-bottom: 25px; }
        input[type="text"],
        input[type="email"],
        input[type="tel"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
            box-sizing: border-box;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        .btn {
            background-color: #7a73ff;
            color: white;
            padding: 10px;
            margin-top: 15px;
            width: 100%;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
        }
        .btn:hover {
            background-color: #5d53d4;
        }
        .login-link {
            margin-top: 20px;
            display: block;
            color: black;
            text-decoration: none;
            font-weight: bold;
        }
        .login-link:hover {
            text-decoration: underline;
        }
        .error {
            color: red;
            margin-top: 10px;
            font-size: 14px;
        }
    </style>

    <script>
        function validateForm() {
            const email = document.forms["regForm"]["email"].value;
            const phone = document.forms["regForm"]["phone"].value;
            const password = document.forms["regForm"]["password"].value;
            const confirm = document.forms["regForm"]["confirmPassword"].value;

            const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
            const phoneRegex = /^[0-9]{10,11}$/;
            const passMinLength = 6;

            if (!emailRegex.test(email)) {
                alert("Email không hợp lệ!");
                return false;
            }

            if (!phoneRegex.test(phone)) {
                alert("Số điện thoại phải gồm 10 hoặc 11 chữ số!");
                return false;
            }

            if (password.length < passMinLength) {
                alert("Mật khẩu phải dài tối thiểu " + passMinLength + " ký tự.");
                return false;
            }

            if (password !== confirm) {
                alert("Mật khẩu xác nhận không khớp.");
                return false;
            }

            return true;
        }
    </script>

</head>
<body>
<div class="register-box">
    <h2>User Registration</h2>
    <form name="regForm" action="register" method="post" onsubmit="return validateForm();">
        <input type="text" name="fullname" placeholder="Full Name" required />
        <input type="email" name="email" placeholder="Email" required />
        <input type="tel" name="phone" placeholder="Phone Number" required />
        <input type="password" name="password" placeholder="Password" required />
        <input type="password" name="confirmPassword" placeholder="Confirm Password" required />
        <input type="submit" value="Sign in" class="btn" />
    </form>
    <a href="login.jsp" class="login-link">Login</a>

    <div class="error">
        <%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %>
    </div>
</div>
</body>
</html>

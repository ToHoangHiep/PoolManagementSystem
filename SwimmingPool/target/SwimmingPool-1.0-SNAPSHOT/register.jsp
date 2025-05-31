<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Registration</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }

        body {
            background: url('https://images.pexels.com/photos/261102/pexels-photo-261102.jpeg') center/cover no-repeat;
            height: 100vh;
            color: white;
        }

        .overlay {
            position: absolute;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background-color: rgba(0, 0, 0, 0.6);
            z-index: 0;
        }

        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(0, 92, 170, 0.95);
            padding: 15px 30px;
            position: fixed;
            top: 0; left: 0;
            width: 100%;
            z-index: 2;
        }

        .navbar .logo {
            font-size: 24px;
            font-weight: bold;
            color: white;
        }

        .navbar .nav-links a {
            color: white;
            text-decoration: none;
            margin: 0 12px;
            font-weight: 500;
        }

        .form-container {
            position: relative;
            z-index: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding-top: 100px;
        }

        .register-box {
            background: white;
            color: #333;
            padding: 40px;
            width: 100%;
            max-width: 420px;
            border-radius: 12px;
            box-shadow: 0 0 20px rgba(0,0,0,0.2);
        }

        .register-box h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #005caa;
        }

        input, select {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        .password-toggle {
            position: relative;
        }

        .password-toggle input {
            padding-right: 40px;
        }

        .eye-icon {
            position: absolute;
            top: 50%;
            right: 10px;
            width: 20px;
            height: 20px;
            transform: translateY(-50%);
            cursor: pointer;
            opacity: 0.5;
        }

        .eye-icon:hover {
            opacity: 1;
        }

        .btn {
            background-color: #005caa;
            color: white;
            border: none;
            padding: 12px;
            font-size: 16px;
            cursor: pointer;
            width: 100%;
            margin-top: 15px;
            border-radius: 6px;
        }

        .btn:hover {
            background-color: #004b91;
        }

        .back-home {
            margin-top: 15px;
            text-align: center;
        }

        .back-home a {
            color: #005caa;
            font-weight: bold;
            text-decoration: underline;
        }

        .error {
            color: red;
            text-align: center;
            margin-top: 10px;
        }

        @media screen and (max-width: 480px) {
            .register-box {
                padding: 30px 20px;
            }
        }
    </style>

    <script>
        function togglePassword(id, icon) {
            const input = document.getElementById(id);
            const isHidden = input.type === "password";
            input.type = isHidden ? "text" : "password";
            icon.src = isHidden
                ? "https://cdn-icons-png.flaticon.com/512/709/709612.png"
                : "https://cdn-icons-png.flaticon.com/512/159/159604.png";
        }

        function validateForm() {
            const email = document.forms["regForm"]["email"].value;
            const phone = document.forms["regForm"]["phone"].value;
            const password = document.forms["regForm"]["password"].value;
            const confirm = document.forms["regForm"]["confirmPassword"].value;
            const dobInput = document.forms["regForm"]["dob"].value;

            const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
            const phoneRegex = /^[0-9]{10,11}$/;

            if (!emailRegex.test(email)) {
                alert("Email không hợp lệ!");
                return false;
            }

            if (!phoneRegex.test(phone)) {
                alert("Số điện thoại phải gồm 10 hoặc 11 chữ số!");
                return false;
            }

            if (password.length < 6) {
                alert("Mật khẩu phải dài tối thiểu 6 ký tự.");
                return false;
            }

            if (password !== confirm) {
                alert("Mật khẩu xác nhận không khớp.");
                return false;
            }

            const dob = new Date(dobInput);
            const today = new Date();
            if (dob > today) {
                alert("Ngày sinh không được vượt quá ngày hiện tại!");
                return false;
            }

            return true;
        }
    </script>
</head>

<body>
<div class="overlay"></div>

<div class="navbar">
    <div class="logo">SwimmingPool</div>
    <div class="nav-links">
        <a href="home.jsp">Home</a>
        <a href="login.jsp">Login</a>
    </div>
</div>

<div class="form-container">
    <div class="register-box">
        <h2>User Registration</h2>
        <form name="regForm" action="register" method="post" onsubmit="return validateForm();">
            <input type="text" name="fullname" placeholder="Full Name" required />
            <input type="email" name="email" placeholder="Email" required />
            <input type="text" name="phone" placeholder="Phone Number (10-11 digits)" required />

            <div class="password-toggle">
                <input type="password" name="password" id="password" placeholder="Password" required />
                <img src="https://cdn-icons-png.flaticon.com/512/159/159604.png" class="eye-icon" onclick="togglePassword('password', this)">
            </div>

            <div class="password-toggle">
                <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Confirm Password" required />
                <img src="https://cdn-icons-png.flaticon.com/512/159/159604.png" class="eye-icon" onclick="togglePassword('confirmPassword', this)">
            </div>

            <input type="text" name="address" placeholder="Address" required />
            <input type="date" name="dob" required />
            <select name="gender" required>
                <option value="">Select Gender</option>
                <option value="Male">Male</option>
                <option value="Female">Female</option>
                <option value="Other">Other</option>
            </select>

            <input type="submit" value="Register" class="btn" />
        </form>


        <div class="error">
            <%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %>
        </div>
    </div>
</div>
</body>
</html>

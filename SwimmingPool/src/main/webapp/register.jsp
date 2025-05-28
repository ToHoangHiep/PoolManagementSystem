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
        }
        .register-box {
            background: white;
            padding: 30px;
            width: 400px;
            border-radius: 10px;
            box-shadow: 0 0 10px gray;
        }
        input, select {
            width: 100%;
            padding: 8px;
            margin: 6px 0;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .btn {
            background-color: #5c6bc0;
            color: white;
            border: none;
            padding: 10px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 10px;
            width: 100%;
            border-radius: 4px;
        }
        .btn:hover {
            background-color: #3f51b5;
        }
    </style>
    <script>
        function validateForm() {
            const email = document.forms["regForm"]["email"].value;
            const phone = document.forms["regForm"]["phone"].value;
            const password = document.forms["regForm"]["password"].value;
            const confirm = document.forms["regForm"]["confirmPassword"].value;
            const dobInput = document.forms["regForm"]["dob"].value;

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
<div class="register-box">
    <h2>User Registration</h2>
    <form name="regForm" action="register" method="post" onsubmit="return validateForm();">
        <input type="text" name="fullname" placeholder="Full Name" required />
        <input type="email" name="email" placeholder="Email" required />
        <input type="text" name="phone" placeholder="Phone Number (10-11 digits)" required />
        <input type="password" name="password" placeholder="Password" required />
        <input type="password" name="confirmPassword" placeholder="Confirm Password" required />
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
    <div style="color: red;">
        <%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %>
    </div>
</div>
</body>
</html>

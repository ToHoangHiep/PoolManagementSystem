<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Yêu cầu nhập thiết bị</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f8f9fc;
            padding: 40px;
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
        }

        form {
            max-width: 500px;
            margin: 0 auto;
            background-color: #ffffff;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        }

        label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            margin-top: 20px;
        }

        input[type="number"],
        textarea {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.2s ease-in-out;
        }

        input[type="number"]:focus,
        textarea:focus {
            border-color: #4a90e2;
            outline: none;
        }

        textarea {
            resize: vertical;
            min-height: 100px;
        }

        button[type="submit"] {
            display: block;
            margin-top: 25px;
            width: 100%;
            background-color: #4a90e2;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button[type="submit"]:hover {
            background-color: #357ac9;
        }

        .device-name {
            font-weight: bold;
            font-size: 16px;
            color: #333;
            margin-bottom: 10px;
        }

        a.back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            text-decoration: none;
            color: #4a90e2;
            font-weight: bold;
        }

        a.back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<h2>Yêu cầu nhập thiết bị</h2>

<form action="inventory" method="post">
    <input type="hidden" name="action" value="insertRequest"/>
    <input type="hidden" name="inventory_id" value="${inventory.inventoryId}"/>

    <label>Tên thiết bị:</label>
    <c:if test="${empty inventory}">
        <div style="color: red;">Không tìm thấy thiết bị! (inventory null)</div>
    </c:if>

    <c:if test="${not empty inventory}">
        <div class="device-name">${inventory.itemName} (SL: ${inventory.quantity})</div>
    </c:if>



    <label>Số lượng cần nhập:</label>
    <input type="number" name="requested_quantity" min="1" required/>

    <label>Lý do:</label>
    <textarea name="reason" required></textarea>

    <button type="submit">Gửi yêu cầu</button>
</form>

<a href="inventory?action=lowstock" class="back-link">← Quay lại danh sách thiết bị sắp hết</a>

</body>
</html>

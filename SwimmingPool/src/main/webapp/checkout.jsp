<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Checkout</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: 'Inter', sans-serif;
            margin: 0;
            background-color: #ffffff;
        }
        .header {
            background: #002B5B;
            color: white;
            padding: 10px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 14px;
        }
        .container {
            max-width: 1140px;
            margin: 40px auto;
            padding: 0 20px;
        }
        h2 {
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .checkout-box {
            display: flex;
            justify-content: space-between;
            gap: 40px;
        }
        .order-summary {
            flex: 0 0 65%;
        }
        .order-summary table {
            width: 100%;
            border-collapse: collapse;
        }
        .order-summary th, .order-summary td {
            padding: 12px;
            border: 1px solid #ccc;
            text-align: left;
        }
        .order-summary th {
            background-color: #007bff;
            color: white;
        }
        .order-summary img {
            width: 60px;
            height: auto;
        }
        .payment-methods {
            flex: 0 0 35%;
        }
        .summary-total {
            margin-top: 20px;
            font-size: 18px;
            font-weight: bold;
        }
        .payment-methods label {
            display: block;
            margin: 10px 0;
            font-weight: 500;
        }
        input[type="radio"] {
            margin-right: 10px;
        }
        .btn-submit {
            background-color: #007bff;
            color: white;
            padding: 12px 24px;
            font-size: 16px;
            border: none;
            border-radius: 4px;
            margin-top: 20px;
            cursor: pointer;
        }
        .footer {
            background: #0b1c39;
            color: white;
            padding: 40px;
            display: flex;
            justify-content: space-between;
            font-size: 14px;
        }
        .footer-column {
            flex: 1;
            margin: 0 10px;
        }
        .footer a {
            color: #aad4ff;
            text-decoration: none;
        }
    </style>
</head>
<body>
<div class="header">
    <strong>Poolax</strong>
    <div>support@poolax.com</div>
</div>

<div class="container">
    <h2>Your Order</h2>
    <div class="checkout-box">
        <div class="order-summary">
            <table>
                <tr>
                    <th>Image</th>
                    <th>Product Name</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Total</th>
                </tr>
                <tr>
                    <td><img src="https://www.bing.com/images/blob?bcid=S0WAaaJZJYUIJ0qvdQ0hatgQx7pRDEdrsis" alt="Ticket"></td>
                    <td>${ticket.ticketTypeName}</td>
                    <td>${ticket.price}đ</td>
                    <td>${ticket.quantity}</td>
                    <td>${ticket.total}đ</td>
                </tr>
            </table>
            <div class="summary-total">
                <p>Subtotal: ${ticket.total}đ</p>
                <p>Shipping: Free</p>
                <p><strong>Total: ${ticket.total}đ</strong></p>
            </div>
        </div>
        <div class="payment-methods">
            <form action="checkout" method="post">
                <label><input type="radio" name="paymentMethod" value="bank" required> Direct Bank Transfer</label>
                <label><input type="radio" name="paymentMethod" value="cheque"> Cheque Payment</label>
                <label><input type="radio" name="paymentMethod" value="card"> Credit Card</label>
                <label><input type="radio" name="paymentMethod" value="paypal"> Paypal</label>
                <input type="hidden" name="action" value="confirm">
                <button type="submit" class="btn-submit">PLACE ORDER</button>
            </form>
            <form action="checkout" method="post" style="margin-top: 10px;">
                <input type="hidden" name="action" value="cancel">
                <button type="submit" class="btn btn-cancel">✖ CANCEL ORDER</button>
            </form>
        </div>
    </div>
</div>

<div class="footer">
    <div class="footer-column">
        <strong>About Company</strong>
        <p>We provide specialized pool services for your seasonal needs.</p>
    </div>
    <div class="footer-column">
        <strong>Contact</strong>
        <p>📞 +468 254 76243</p>
        <p>📧 info@poolax.com</p>
    </div>
    <div class="footer-column">
        <strong>Working Hours</strong>
        <p>Mon - Fri: 9AM - 6PM</p>
    </div>
</div>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Checkout - Ticket Purchase</title>
  <link rel="stylesheet" href="styles.css">
  <style>
    body { font-family: Arial, sans-serif; margin: 0; padding: 0; background: #f5f5f5; }
    .container { max-width: 800px; margin: 40px auto; background: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
    h2, h3 { color: #007bff; }
    .section { margin-bottom: 30px; }
    .summary, .payment { border-top: 2px dashed #ccc; padding-top: 20px; }
    .label { font-weight: bold; display: block; margin-top: 10px; }
    .total { font-size: 18px; color: #000; font-weight: bold; margin-top: 20px; }
    input[type="radio"] { margin-right: 10px; }
    .confirm-btn { background-color: #28a745; color: white; border: none; padding: 10px 20px; cursor: pointer; margin-top: 20px; font-weight: bold; }
    .cancel-btn { background-color: #dc3545; color: white; border: none; padding: 10px 20px; cursor: pointer; margin-left: 10px; font-weight: bold; }
    .confirm-btn:hover { background-color: #218838; }
    .cancel-btn:hover { background-color: #c82333; }
  </style>
</head>
<body>
<div class="container">
  <h2>Order Summary</h2>
  <div class="section summary">
    <p>- <strong>Ticket Type:</strong> ${ticket.ticketTypeName}</p>
    <p>- <strong>Quantity:</strong> ${ticket.quantity}</p>
    <p>- <strong>Usage Period:</strong> ${ticket.startDate} - ${ticket.endDate}</p>
    <p>- <strong>Price per Ticket:</strong> ${ticket.price}đ</p>
    <p class="total">=> Total: ${ticket.total}đ</p>
  </div>

  <div class="section payment">
    <h3>Payment Method</h3>

    <form action="checkout" method="post">
      <label><input type="radio" name="paymentMethod" value="ewallet" required> E-Wallet</label><br>
      <label><input type="radio" name="paymentMethod" value="bank"> Bank Transfer</label><br>
      <label><input type="radio" name="paymentMethod" value="counter"> Pay at Counter</label><br>

      <!-- Gửi action để servlet biết là confirm hay cancel -->
      <input type="hidden" name="action" value="confirm">

      <button type="submit" class="confirm-btn">☑ Confirm Purchase</button>
    </form>

    <form action="checkout" method="post" style="display:inline;">
      <input type="hidden" name="action" value="cancel">
      <button type="submit" class="cancel-btn">✖ Cancel Payment</button>
    </form>


  </div>
</div>
</body>
</html>

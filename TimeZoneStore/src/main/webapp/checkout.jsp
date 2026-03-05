<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.timezone.model.Watch"%>
<!DOCTYPE html>
<html>
<head>
    <title>Checkout - TimeZone</title>
    <!-- Your existing styles -->
</head>
<body>
    <form action="checkout" method="post">
        <!-- Payment and shipping details -->
        <input type="text" name="paymentMethod" value="Credit Card" hidden>
        <input type="text" name="address" value="Default Address" hidden>
        <button type="submit">Place Order</button>
    </form>
</body>
</html>
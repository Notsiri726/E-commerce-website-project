<%@ page session="true" %>
<%
    Integer customerId = (Integer) session.getAttribute("customerId");
    if (customerId == null) {
        response.sendRedirect("login_customer.jsp");
        return;
    }

    String total = request.getParameter("total");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Checkout</title>
</head>
<body>
    <h1>Checkout</h1>
    <p>Total Amount: Rs.<%= total %></p>
    
    <form action="PlaceOrderServlet" method="post">
        <input type="hidden" name="total" value="<%= total %>">
        <input type="text" name="address" placeholder="Enter your address" required><br><br>
        <input type="text" name="paymentMethod" placeholder="Payment method (COD, UPI, etc)" required><br><br>
        <button type="submit">Place Order</button>
    </form>
</body>
</html>

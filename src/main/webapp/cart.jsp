<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.text.DecimalFormat" %>
<%@ page session="true" %>
<%
    Integer customerId = (Integer) session.getAttribute("customerId");
    if (customerId == null) {
        response.sendRedirect("login_customer.jsp");
        return;
    }

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce_platform", "root", "your_pass");

    PreparedStatement stmt = conn.prepareStatement(
        "SELECT p.id, p.name, p.price, p.image_url FROM cart c JOIN products p ON c.product_id = p.id WHERE c.customer_id = ?");
    stmt.setInt(1, customerId);
    ResultSet rs = stmt.executeQuery();

    double totalPrice = 0.0;
    boolean hasItems = false;
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Cart 🛒</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 20px;
        }
        .cart-container {
            max-width: 1000px;
            margin: auto;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        .cart-item {
            display: flex;
            align-items: center;
            background: white;
            margin: 15px 0;
            padding: 15px;
            border-radius: 12px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }
        .cart-item img {
            width: 140px;
            height: 140px;
            object-fit: contain;
            border-radius: 10px;
            margin-right: 20px;
        }
        .cart-details {
            flex: 1;
        }
        .cart-details h3 {
            margin: 0 0 10px;
        }
        .cart-details p {
            color: #555;
            margin-bottom: 10px;
        }
        .remove-btn {
            background-color: #e74c3c;
            color: white;
            padding: 10px 14px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }
        .total-section {
            text-align: right;
            font-size: 20px;
            margin-top: 20px;
            font-weight: bold;
            color: #2c3e50;
        }
        .checkout-form {
            text-align: right;
            margin-top: 20px;
        }
        .checkout-btn {
            background-color: #27ae60;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
        }
        .empty-cart {
            text-align: center;
            padding: 60px;
            font-size: 22px;
            color: #777;
        }
        .empty-cart a {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            font-weight: bold;
            color: #2980b9;
        }

        /* Toast styles */
        .toast {
            position: fixed;
            bottom: 20px;
            right: 30px;
            background-color: #333;
            color: white;
            padding: 14px 20px;
            border-radius: 8px;
            z-index: 1000;
            font-size: 16px;
            opacity: 1;
            transition: opacity 0.5s ease;
        }
        .toast.fadeout {
            opacity: 0;
        }
    </style>
</head>
<body>
<div class="cart-container">
    <h2>Your Shopping Cart</h2>

<%
    while (rs.next()) {
        hasItems = true;
        int productId = rs.getInt("id");
        String name = rs.getString("name");
        String image = rs.getString("image_url");
        double price = rs.getDouble("price");
        totalPrice += price;
%>

    <div class="cart-item" data-product-id="<%= productId %>">
        <img src="<%= request.getContextPath() + "/" + image %>" alt="<%= name %>">
        <div class="cart-details">
            <h3><%= name %></h3>
            <p>Price: ₹<%= new DecimalFormat("0.00").format(price) %></p>
            <button class="remove-btn" onclick="removeFromCart(<%= productId %>, this)">Remove</button>
        </div>
    </div>

<% } %>

<% if (!hasItems) { %>
    <div class="empty-cart">
        Your cart is empty!<br><br>
        <a href="customer_dashboard.jsp">Continue Shopping</a>
    </div>
<% } else { %>
    <div class="total-section">
        Total: ₹<%= new DecimalFormat("0.00").format(totalPrice) %>
    </div>

    <div class="checkout-form">
        <form action="CartCheckoutServlet" method="post">
            <input type="hidden" name="total" value="<%= totalPrice %>">
            <button type="submit" class="checkout-btn">Proceed to Buy</button>
        </form>
    </div>
<% } %>

</div>

<!-- JS Toast & Remove Logic -->
<script>
function removeFromCart(productId, button) {
    fetch('RemoveFromCartServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: 'productId=' + encodeURIComponent(productId)
    })
    .then(response => response.text())
    .then(data => {
        const trimmed = data.trim();
        if (trimmed === 'removed') {
            showToast("🗑️ Removed from Cart");
            const cartItem = button.closest(".cart-item");
            if (cartItem) cartItem.remove();

            // If no items left, reload to show empty message
            if (document.querySelectorAll('.cart-item').length === 0) {
                setTimeout(() => location.reload(), 1000);
            }
        } else {
            showToast("⚠️ Could not remove item");
        }
    })
    .catch(() => {
        showToast("❌ Error removing item");
    });
}

function showToast(message) {
    const existing = document.querySelector('.toast');
    if (existing) existing.remove();

    const toast = document.createElement('div');
    toast.className = 'toast';
    toast.innerText = message;
    document.body.appendChild(toast);

    setTimeout(() => toast.classList.add('fadeout'), 1800);
    setTimeout(() => toast.remove(), 2300);
}
</script>

</body>
</html>

<%
    conn.close();
%>


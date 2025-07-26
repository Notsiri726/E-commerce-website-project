<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*, java.text.*, java.util.Date" %>
<%@ page session="true" %>

<%
    Integer customerId = (Integer) session.getAttribute("customerId");
    String customerName = (String) session.getAttribute("customerName");

    if (customerId == null) {
        response.sendRedirect("login_customer.jsp");
        return;
    }

    if (customerName == null || customerName.trim().isEmpty()) {
        customerName = "Customer";
    }

    List<Map<String, String>> orders = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/ecommerce_platform", "root", "your_pass");

        PreparedStatement stmt = conn.prepareStatement(
            "SELECT * FROM orders WHERE customer_id = ? ORDER BY order_date DESC");
        stmt.setInt(1, customerId);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            Map<String, String> order = new HashMap<>();
            Timestamp orderDateTs = rs.getTimestamp("order_date");
            String status = rs.getString("status");
            String totalAmount = rs.getString("total_amount");

            // Calculate delivery date (1–5 days after order date)
            Calendar cal = Calendar.getInstance();
            cal.setTime(orderDateTs);
            cal.add(Calendar.DATE, new Random().nextInt(5) + 1);
            Date deliveryDate = cal.getTime();

            // Check if current date is after delivery date
            Date now = new Date();
            if (now.after(deliveryDate)) {
                status = "Delivered";
            }

            SimpleDateFormat orderFormat = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
            SimpleDateFormat deliveryFormat = new SimpleDateFormat("dd MMM yyyy");

            order.put("orderDate", orderFormat.format(orderDateTs));
            order.put("deliveryDate", deliveryFormat.format(deliveryDate));
            order.put("status", status);
            order.put("totalAmount", totalAmount);

            orders.add(order);
        }

        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Order Tracking</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #e3f2fd, #ffffff);
            margin: 0;
            padding: 50px 20px;
        }

        .container {
            max-width: 900px;
            margin: auto;
            background: #ffffff;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            animation: fadeIn 0.6s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        h1 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
        }

        .order {
            background: #f7faff;
            border-left: 5px solid #3498db;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }

        .order:hover {
            box-shadow: 0 4px 14px rgba(0,0,0,0.08);
            transform: translateY(-2px);
        }

        .order p {
            margin: 8px 0;
            font-size: 16px;
            color: #333;
        }

        .order strong {
            color: #2c3e50;
        }

        .no-orders {
            text-align: center;
            font-size: 18px;
            color: #999;
            padding: 50px 20px;
        }

        .close-btn {
            text-align: center;
            margin-top: 40px;
        }

        .close-btn a {
            padding: 12px 30px;
            background-color: #3498db;
            color: white;
            text-decoration: none;
            border-radius: 30px;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }

        .close-btn a:hover {
            background-color: #2980b9;
        }

        .customer-name {
            font-size: 18px;
            margin-bottom: 10px;
            color: #555;
            text-align: right;
        }

        @media screen and (max-width: 600px) {
            .order p {
                font-size: 15px;
            }
            .close-btn a {
                width: 100%;
                display: inline-block;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="customer-name">👤 Welcome, <strong><%= customerName %></strong></div>
    <h1>🧾 Your Orders</h1>

    <% if (orders.isEmpty()) { %>
        <div class="no-orders">You haven’t placed any orders yet.</div>
    <% } else { %>
        <% for (Map<String, String> order : orders) { %>
            <div class="order">
                <p><strong>🛒 Order Placed:</strong> <%= order.get("orderDate") %></p>
                <p><strong>📦 Estimated Delivery:</strong> <%= order.get("deliveryDate") %></p>
                <p><strong>💰 Total Amount:</strong> ₹<%= order.get("totalAmount") %></p>
                <p><strong>📍 Status:</strong> <%= order.get("status") %></p>
            </div>
        <% } %>
    <% } %>

    <div class="close-btn">
        <a href="customer_dashboard.jsp">⬅ Back to Dashboard</a>
    </div>
</div>

</body>
</html>

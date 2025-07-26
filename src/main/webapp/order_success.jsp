<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page session="true" %>
<%
String name = (String) session.getAttribute("purchasedProduct");
Double price = (Double) session.getAttribute("purchasedAmount");

    if (name == null || price == null) {
        response.sendRedirect("customer_dashboard.jsp");
        return;
    }

    session.removeAttribute("purchasedProduct");
    session.removeAttribute("purchasedAmount");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Order Confirmed</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #f0f9ff, #e0f7fa);
            margin: 0;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .success-card {
            background: white;
            padding: 40px 50px;
            border-radius: 20px;
            box-shadow: 0 12px 30px rgba(0,0,0,0.1);
            text-align: center;
            animation: fadeSlideIn 0.8s ease-out forwards;
            opacity: 0;
            transform: translateY(40px);
            max-width: 400px;
            width: 90%;
        }

        @keyframes fadeSlideIn {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .checkmark {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: #2ecc71;
            display: inline-block;
            position: relative;
            margin-bottom: 20px;
            animation: popIn 0.6s ease;
        }

        @keyframes popIn {
            0% {
                transform: scale(0.2);
                opacity: 0;
            }
            100% {
                transform: scale(1);
                opacity: 1;
            }
        }

        .checkmark::after {
            content: '';
            position: absolute;
            left: 22px;
            top: 38px;
            width: 20px;
            height: 40px;
            border: solid white;
            border-width: 0 6px 6px 0;
            transform: rotate(45deg);
        }

        h2 {
            color: #27ae60;
            margin-top: 10px;
            margin-bottom: 20px;
        }

        .details {
            font-size: 18px;
            color: #555;
            margin-bottom: 25px;
        }

        .details p {
            margin: 10px 0;
        }

        .btn {
            display: inline-block;
            padding: 12px 25px;
            background: #3498db;
            color: white;
            text-decoration: none;
            font-weight: bold;
            border-radius: 30px;
            transition: background 0.3s ease;
        }

        .btn:hover {
            background: #2980b9;
        }
    </style>
</head>
<body>
    <div class="success-card">
        <div class="checkmark"></div>
        <h2>Order Placed Successfully!</h2>
        <div class="details">
            <p><strong>Products:</strong> <%= name %></p>
            <p><strong>Grand Total:</strong> Rs.<%= String.format("%.2f", price) %></p>
        </div>
        <a href="customer_dashboard.jsp" class="btn">Back to Shopping</a>
    </div>
</body>
</html>

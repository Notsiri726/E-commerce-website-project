<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register Choice</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            background: url("images/ecombg.jpg") no-repeat center center fixed;
            background-size: cover;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            text-align: center;
            padding-top: 100px;
        }

        h2 {
            font-size: 36px;
            color: white;
            text-transform: uppercase;
            letter-spacing: 2px;
            animation: glow 3s infinite alternate;
        }

        @keyframes glow {
            0% {
                text-shadow: 0 0 5px #00ffff, 0 0 10px #00ffff, 0 0 15px #00ffff;
            }
            33% {
                text-shadow: 0 0 5px #ff00ff, 0 0 10px #ff00ff, 0 0 15px #ff00ff;
            }
            66% {
                text-shadow: 0 0 5px #ffff00, 0 0 10px #ffff00, 0 0 15px #ffff00;
            }
            100% {
                text-shadow: 0 0 5px #00ff00, 0 0 10px #00ff00, 0 0 15px #00ff00;
            }
        }

        .button-container {
            margin-top: 50px;
        }

        .btn {
            padding: 15px 35px;
            margin: 20px;
            font-size: 18px;
            border: none;
            border-radius: 8px;
            background-color: #17a2b8;
            color: white;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.4);
        }

        .btn:hover {
            background-color: #138496;
            transform: scale(1.05);
        }
    </style>
</head>
<body>

<h2>Register as:</h2>

<div class="button-container">
    <form action="registerCustomer.jsp" method="get" style="display:inline;">
        <button class="btn">Customer</button>
    </form>

    <form action="registerSeller.jsp" method="get" style="display:inline;">
        <button class="btn">Seller</button>
    </form>
</div>

</body>
</html>

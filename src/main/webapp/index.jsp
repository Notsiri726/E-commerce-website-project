<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>E-Commerce Platform</title>
    <style>
        body {
            background: url("images/ecombg.jpg") no-repeat center center fixed;
            background-size: cover;
            font-family: Arial, sans-serif;
            text-align: center;
            padding-top: 100px;
            margin: 0;
        }

        h1 {
            font-size: 40px;
            color: white;
            letter-spacing: 2px;
            text-shadow: 0 0 5px #00ffff, 0 0 10px #00ffff;
            animation: glow 4s infinite alternate;
        }

        @keyframes glow {
            0% {
                text-shadow: 0 0 5px #00ffff, 0 0 10px #00ffff;
            }
            33% {
                text-shadow: 0 0 5px #ff00ff, 0 0 10px #ff00ff;
            }
            66% {
                text-shadow: 0 0 5px #ffff00, 0 0 10px #ffff00;
            }
            100% {
                text-shadow: 0 0 5px #00ff00, 0 0 10px #00ff00;
            }
        }

        .button-container {
            margin-top: 40px;
        }

        .btn {
            padding: 15px 30px;
            margin: 10px;
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

<h1>Welcome to Our E-Commerce Platform</h1>

<div class="button-container">
    <form action="login.jsp" method="get" style="display:inline;">
        <button class="btn">Login</button>
    </form>

    <form action="registerChoice.jsp" method="get" style="display:inline;">
        <button class="btn">Register</button>
    </form>
</div>

</body>
</html>



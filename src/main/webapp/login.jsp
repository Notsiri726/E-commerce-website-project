<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String loginStatus = (String) request.getAttribute("loginStatus");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login Portal</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            background: url('images/ecombg.jpg') no-repeat center center fixed;
            background-size: cover;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .login-container {
            background-color: rgba(255, 255, 255, 0.95);
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.2);
            width: 380px;
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin: 12px 0 6px;
            font-weight: bold;
        }

        select, input[type="text"], input[type="password"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }

        .btn-login {
            width: 100%;
            padding: 12px;
            margin-top: 20px;
            background: linear-gradient(90deg, #007bff, #00bfff);
            color: white;
            font-size: 16px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .btn-login:hover {
            background: linear-gradient(90deg, #0056b3, #008cba);
        }

        .toast {
            visibility: hidden;
            min-width: 250px;
            margin-left: -125px;
            background-color: #333;
            color: white;
            text-align: center;
            border-radius: 6px;
            padding: 16px;
            position: fixed;
            z-index: 1;
            left: 50%;
            bottom: 30px;
            font-size: 17px;
            opacity: 0;
            transition: opacity 0.5s ease, visibility 0.5s ease;
        }

        .toast.show {
            visibility: visible;
            opacity: 1;
        }
    </style>
</head>
<body>

<div class="login-container">
    <h2>Login Portal</h2>
    <form action="LoginServlet" method="post">
        <label for="role">Login as:</label>
        <select name="role" required>
            <option value="">-- Select Role --</option>
            <option value="customer">Customer</option>
            <option value="seller">Seller</option>
        </select>

        <label for="username">Username:</label>
        <input type="text" name="username" required>

        <label for="password">Password:</label>
        <input type="password" name="password" required>

        <button type="submit" class="btn-login">Login</button>
    </form>
</div>

<% if ("fail".equals(loginStatus)) { %>
    <div id="toast" class="toast show">Invalid username or password</div>
<% } else if ("success".equals(loginStatus)) { %>
    <div id="toast" class="toast show">Login successful!</div>
<% } %>

<script>
    // Hide toast after 3 seconds
    setTimeout(() => {
        const toast = document.querySelector('.toast');
        if (toast) toast.classList.remove('show');
    }, 3000);
</script>

</body>
</html>


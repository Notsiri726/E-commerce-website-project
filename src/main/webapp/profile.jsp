<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    Integer customerId = (Integer) session.getAttribute("customerId");
    if (customerId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String name = "", email = "", username = "", password = "", phone = "", address = "";
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce_platform", "root", "your_pass");
        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM customers WHERE id = ?");
        stmt.setInt(1, customerId);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            email = rs.getString("email");
            username = rs.getString("username");
            password = rs.getString("password");
            phone = rs.getString("phone");
            address = rs.getString("address");
        }
        conn.close();
    } catch (Exception e) {
        out.println("Error fetching profile: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Profile</title>
    <style>
        :root {
            --bg-color: #f4f4f4;
            --text-color: #000000;
            --container-bg: #ffffff;
            --input-bg: #ffffff;
        }

        body.dark-mode {
            --bg-color: #121212;
            --text-color: #f0f0f0;
            --container-bg: #1e1e1e;
            --input-bg: #2a2a2a;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            padding: 40px;
            transition: background-color 0.3s, color 0.3s;
        }

        .profile-container {
            background: var(--container-bg);
            max-width: 500px;
            margin: auto;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            position: relative;
            transition: background-color 0.3s;
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin-top: 12px;
            font-weight: 500;
        }

        input, textarea {
            width: 100%;
            padding: 10px;
            border-radius: 6px;
            background-color: var(--input-bg);
            color: var(--text-color);
            border: 1px solid #ccc;
            margin-top: 5px;
        }

        .button-group {
            margin-top: 25px;
            display: flex;
            justify-content: space-between;
        }

        .button-group button {
            padding: 10px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
        }

        .update-btn { background-color: #2980b9; color: white; }
        .close-btn { background-color: #e74c3c; color: white; }

        .toast {
            position: fixed;
            top: 80px;
            right: 30px;
            background-color: #2ecc71;
            color: white;
            padding: 12px 24px;
            border-radius: 6px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
            animation: fadeout 3s forwards;
        }

        @keyframes fadeout {
            0% { opacity: 1; }
            70% { opacity: 1; }
            100% { opacity: 0; display: none; }
        }
    </style>
</head>
<body>
<script>
    function toggleDarkMode() {
        const body = document.body;
        const modeIcon = document.getElementById("modeIcon");
        body.classList.toggle("dark-mode");

        const darkModeEnabled = body.classList.contains("dark-mode");
        modeIcon.textContent = darkModeEnabled ? "☀️" : "🌙";

        // Save preference in cookie
        document.cookie = "darkMode=" + (darkModeEnabled ? "true" : "false") + "; path=/";
    }

    // Apply dark mode on page load if cookie is set
    window.onload = function () {
        if (document.cookie.includes("darkMode=true")) {
            document.body.classList.add("dark-mode");
            const modeIcon = document.getElementById("modeIcon");
            if (modeIcon) modeIcon.textContent = "☀️";
        }
    };
</script>


<% if (request.getParameter("success") != null && request.getParameter("success").equals("true")) { %>
    <div class="toast">✅ Profile updated successfully!</div>
<% } %>

<div class="profile-container">
    <form action="UpdateProfileServlet" method="post">
        <h2>My Profile</h2>
        <label>Name:</label>
        <input type="text" name="name" value="<%= name %>" required>

        <label>Email:</label>
        <input type="email" name="email" value="<%= email %>" required>

        <label>Username:</label>
        <input type="text" name="username" value="<%= username %>" required>

        <label>Password:</label>
        <input type="password" name="password" value="<%= password %>" required>

        <label>Phone:</label>
        <input type="text" name="phone" value="<%= phone %>" required>

        <label>Address:</label>
        <textarea name="address" rows="3"><%= address %></textarea>

        <div class="button-group">
            <button type="submit" class="update-btn">🔄 Update</button>
            <button type="button" class="close-btn" onclick="window.location.href='customer_dashboard.jsp'">✖ Close</button>
        </div>
    </form>
</div>

</body>
</html>


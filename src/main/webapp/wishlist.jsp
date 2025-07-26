
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*, javax.sql.*" %>

<%
    Integer customerId = (Integer) session.getAttribute("customerId");
    if (customerId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Boolean wishlistRemoved = (Boolean) session.getAttribute("wishlistRemoved");
    if (wishlistRemoved != null && wishlistRemoved) {
%>
    <div id="toast" style="position: fixed; top: 20px; right: 20px; background: #e74c3c; color: white; padding: 12px 20px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.3); z-index: 999; transition: opacity 0.3s ease;">
        ❌ Removed from your Wishlist!
    </div>
    <script>
        setTimeout(() => {
            const toast = document.getElementById("toast");
            toast.style.opacity = "0";
            setTimeout(() => toast.remove(), 500);
        }, 3000);
    </script>
<%
        session.removeAttribute("wishlistRemoved");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Wishlist</title>
    <style>
        :root {
            --bg: #f4f4f4;
            --text: #2c3e50;
            --card: white;
            --button-bg: #e74c3c;
            --button-hover: #c0392b;
            --back-btn: #3498db;
            --back-hover: #2980b9;
        }

        body.dark-mode {
            --bg: #1e1e1e;
            --text: #ecf0f1;
            --card: #2c2c2c;
            --button-bg: #e74c3c;
            --button-hover: #c0392b;
            --back-btn: #2980b9;
            --back-hover: #3498db;
        }

        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: var(--bg);
            color: var(--text);
            padding: 30px;
            transition: all 0.3s ease;
        }

        h1 {
            text-align: center;
            margin-bottom: 30px;
        }

        .theme-toggle {
            position: absolute;
            top: 20px;
            left: 20px;
            font-size: 24px;
            cursor: pointer;
        }

        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
        }

        .card {
            background-color: var(--card);
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            text-align: center;
            transition: background 0.3s;
        }

        .card img {
            width: 100%;
            height: 180px;
            object-fit: contain;
            border-radius: 8px;
        }

        .desc {
            font-size: 18px;
            font-weight: bold;
            margin: 10px 0;
        }

        .price {
            color: #27ae60;
            margin-bottom: 10px;
        }

        form button {
            padding: 10px 16px;
            background-color: var(--button-bg);
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        form button:hover {
            background-color: var(--button-hover);
        }

        .back-btn {
            display: block;
            margin: 30px auto 0;
            padding: 12px 24px;
            background-color: var(--back-btn);
            color: white;
            border: none;
            border-radius: 8px;
            text-align: center;
            font-size: 16px;
            text-decoration: none;
            cursor: pointer;
        }

        .back-btn:hover {
            background-color: var(--back-hover);
        }
    </style>
</head>
<body>



<h1>❤️ Your Wishlist</h1>

<div class="product-grid">
<%
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce_platform", "root", "your_pass");

        PreparedStatement stmt = conn.prepareStatement(
            "SELECT p.id, p.name, p.image_url, p.price FROM wishlist w JOIN products p ON w.product_id = p.id WHERE w.customer_id = ?");
        stmt.setInt(1, customerId);

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
%>
        <div class="card">
            <img src="<%= rs.getString("image_url") %>" alt="Product">
            <div class="desc"><%= rs.getString("name") %></div>
            <div class="price">₹<%= rs.getString("price") %></div>
            <form action="RemoveFromWishlistServlet" method="post">
                <input type="hidden" name="productId" value="<%= rs.getString("id") %>">
                <button>❌ Remove</button>
            </form>
        </div>
<%
        }
        conn.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
</div>

<a class="back-btn" href="customer_dashboard.jsp">⬅ Back to Dashboard</a>

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


</body>
</html>


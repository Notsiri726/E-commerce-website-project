<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    Integer sellerId = (Integer) session.getAttribute("sellerId");
    String sellerUsername = (String) session.getAttribute("username");
    if (sellerId == null || sellerUsername == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<style>
/* Global Dark Theme */
body.dark {
    background: linear-gradient(to right, #1c1c1c, #2a2a2a);
    color: #1a1a1a;
}

/* Heading & Label Styles */
body.dark h1,
body.dark h2,
body.dark label,
body.dark .form-label {
    color: #ffffff !important;
    font-weight: bold;
}

/* Make input fields light in dark mode */
body.dark input,
body.dark textarea,
body.dark select {
    background-color: #ffffff !important;
    color: #000000 !important;
    border: 1px solid #999;
}

/* Placeholder styling in dark mode */
body.dark input::placeholder,
body.dark textarea::placeholder {
    color: #555;
}
</style>

<script>
// Apply saved theme on page load
window.onload = function () {
    const savedTheme = localStorage.getItem("theme") || "light";
    document.body.classList.add(savedTheme);
};
</script>
<style>
/* Force black color on all label-related elements in dark mode */
body.dark label,
body.dark .form-label,
body.dark h2,
body.dark h3,
body.dark span,
body.dark legend,
body.dark p {
    color: #000 !important;
    font-weight: bold !important;
}

/* Keep input, textarea, and select fields white with dark text */
body.dark input,
body.dark textarea,
body.dark select {
    background-color: #fff !important;
    color: #000 !important;
    border: 1px solid #999 !important;
}

/* Optional: Placeholder styling */
body.dark input::placeholder,
body.dark textarea::placeholder {
    color: #555 !important;
}
</style>

<script>
// Apply saved theme on page load
window.onload = function () {
    const savedTheme = localStorage.getItem("theme") || "light";
    document.body.classList.add(savedTheme);
};
</script>

    <meta charset="UTF-8">
    <title>Manage Products</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f6f7;
        }

        .header {
            background-color: #d2f7e9 ;
            color: white;
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h2 {
            margin: 0;
        }

        .container {
            max-width: 1100px;
            margin: 40px auto;
            padding: 20px;
        }

        .product-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 6px 18px rgba(0,0,0,0.08);
        }

        .product-card img {
            height: 100px;
            width: auto;
            margin-right: 25px;
        }

        .product-details {
            flex: 1;
        }

        .product-details h3 {
            margin: 0 0 10px;
        }

        .product-details p {
            margin: 4px 0;
        }

        .product-actions {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .product-actions form {
            display: inline;
        }

        .product-actions button {
            padding: 8px 14px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
        }

        .edit-btn {
            background-color: #3498db;
            color: white;
        }

        .delete-btn {
            background-color: #e74c3c;
            color: white;
        }

        .back-btn {
            background-color: #95a5a6;
            color: white;
            padding: 10px 18px;
            border: none;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
        }

        .no-products {
            text-align: center;
            font-size: 18px;
            margin-top: 60px;
            color: #888;
        }
    </style>
</head>
<body>


<div class="header">
    <h2>📦 Manage Your Products</h2>
    <button onclick="location.href='seller_dashboard.jsp'" class="back-btn">⏪ Back to Dashboard</button>
</div>

<div class="container">
<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce_platform", "root", "your_pass");
        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM products WHERE seller_id = ?");
        stmt.setInt(1, sellerId);

        ResultSet rs = stmt.executeQuery();

        boolean hasProducts = false;

        while (rs.next()) {
            hasProducts = true;
%>
    <div class="product-card">
        <img src="<%= request.getContextPath() + "/" + rs.getString("image_url") %>" alt="Product Image">
        <div class="product-details">
            <h3><%= rs.getString("name") %></h3>
            <p>Price: ₹<%= rs.getString("price") %></p>
            <p>Category: <%= rs.getString("category") %></p>
            <p>Hot Deal: <%= rs.getInt("is_hot") == 1 ? "Yes" : "No" %></p>
        </div>
        <div class="product-actions">
            <form action="edit_product.jsp" method="get">

                <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                <button type="submit" class="edit-btn">✏️ Edit</button>
            </form>
            <form action="DeleteProductServlet" method="post" onsubmit="return confirm('Are you sure you want to delete this product?');">
                <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                <button type="submit" class="delete-btn">🗑️ Delete</button>
            </form>
        </div>
    </div>
<%
        }

        if (!hasProducts) {
%>
    <div class="no-products">You haven't added any products yet.</div>
<%
        }

        conn.close();
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error loading products: " + e.getMessage() + "</p>");
    }
%>
</div>
<script>
    // Apply saved theme on page load
    window.onload = function () {
        const savedTheme = localStorage.getItem("theme") || "light";
        document.body.classList.add(savedTheme);
    };
</script>
<style>
/* Fix: Make labels & headings pure black in dark theme */
body.dark label,
body.dark h1,
body.dark h2,
body.dark h3,
body.dark h4,
body.dark h5,
body.dark h6,
body.dark span.title,
body.dark .form-label {
    color: #000000 !important;
    font-weight: bold;
}

/* Keep general text readable */
body.dark,
body.dark p,
body.dark td,
body.dark th {
    color: #1a1a1a !important;
}

/* Optional: Brighter placeholders */
body.dark input::placeholder,
body.dark textarea::placeholder {
    color: #555555 !important;
}
</style>


</body>
</html>


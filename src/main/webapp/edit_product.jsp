<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    Integer sellerId = (Integer) session.getAttribute("sellerId");
    String updated = request.getParameter("updated");
    if (sellerId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String productIdStr = request.getParameter("id");
    if (productIdStr == null || productIdStr.isEmpty()) {
        out.println("<h3>Product ID missing</h3>");
        return;
    }

    int productId = Integer.parseInt(productIdStr);

    String name = "", description = "", fullDescription = "", price = "", category = "", image1 = "", image2 = "";
    int isHot = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce_platform", "root", "your_pass");
        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM products WHERE id = ? AND seller_id = ?");
        stmt.setInt(1, productId);
        stmt.setInt(2, sellerId);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            name = rs.getString("name");
            description = rs.getString("description");
            fullDescription = rs.getString("full_description");
            price = rs.getString("price");
            category = rs.getString("category");
            image1 = rs.getString("image_url");
            image2 = rs.getString("image_url_2");
            isHot = rs.getInt("is_hot");
        } else {
            out.println("<h3>Product not found or unauthorized access</h3>");
            return;
        }
        conn.close();
    } catch (Exception e) {
        out.println("<h3>Error: " + e.getMessage() + "</h3>");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Product</title>
    <style>
    
    
    .toast {
    position: fixed;
    top: 30px;
    right: 30px;
    background-color: #2ecc71;
    color: white;
    padding: 15px 25px;
    border-radius: 8px;
    font-weight: bold;
    box-shadow: 0 4px 12px rgba(0,0,0,0.2);
    animation: fadeout 3s forwards;
}
@keyframes fadeout {
    0% { opacity: 1; }
    70% { opacity: 1; }
    100% { opacity: 0; display: none; }
}
    
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f1f1f1;
            padding: 30px;
        }

        .form-container {
            max-width: 700px;
            margin: auto;
            background: #fff;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            position: relative;
        }

        .form-container h2 {
            text-align: center;
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
        }

        input, textarea, select {
            width: 100%;
            padding: 12px;
            margin-top: 8px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
        }

        button {
            margin-top: 25px;
            width: 100%;
            padding: 14px;
            background: #3498db;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background: #2980b9;
        }

        img.preview {
            max-height: 120px;
            margin-top: 10px;
            border-radius: 8px;
        }

        .toast {
            position: fixed;
            top: 30px;
            right: 30px;
            background-color: #2ecc71;
            color: white;
            padding: 15px 25px;
            border-radius: 8px;
            font-weight: bold;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            animation: fadeout 3s forwards;
        }

        @keyframes fadeout {
            0% { opacity: 1; }
            70% { opacity: 1; }
            100% { opacity: 0; display: none; }
        }
        .close-btn {
    position: absolute;
    top: 16px;
    right: 20px;
    font-size: 24px;
    color: #888;
    text-decoration: none;
    font-weight: bold;
    transition: color 0.3s ease;
}

.close-btn:hover {
    color: #e74c3c;
}
        
    </style>
</head>
<body>

<% if (request.getParameter("updated") != null && request.getParameter("updated").equals("true")) { %>
    <div class="toast">Product Updated Successfully!</div>
<% } %>

<% if (updated != null && updated.equals("true")) { %>
    <div class="toast">Product Updated Successfully!</div>
<% } %>

<div class="form-container">
<a href="seller_dashboard.jsp" class="close-btn" title="Close">×</a>

    <h2>✏️ Edit Product</h2>
    <form action="EditProductServlet" method="post" enctype="multipart/form-data">
        <input type="hidden" name="id" value="<%= productId %>">


        <label>Product Name</label>
        <input type="text" name="name" value="<%= name %>" required>

        <label>Price (₹)</label>
        <input type="number" name="price" step="0.01" value="<%= price %>" required>

        <label>Short Description</label>
        <textarea name="description" rows="3" required><%= description %></textarea>

        <label>Full Description</label>
        <textarea name="full_description" rows="4"><%= fullDescription %></textarea>

        <label>Category</label>
        <select name="category" required>
            <option value="electronics" <%= category.equals("electronics") ? "selected" : "" %>>Electronics</option>
            <option value="fashion" <%= category.equals("fashion") ? "selected" : "" %>>Fashion</option>
            <option value="jewellery" <%= category.equals("jewellery") ? "selected" : "" %>>Jewellery</option>
            <option value="general" <%= category.equals("general") ? "selected" : "" %>>General</option>
        </select>

        <label>Hot Deal?</label>
        <select name="is_hot">
            <option value="0" <%= isHot == 0 ? "selected" : "" %>>No</option>
            <option value="1" <%= isHot == 1 ? "selected" : "" %>>Yes</option>
        </select>

        <label>Image 1 (Primary)</label>
        <input type="file" name="image1" accept="image/*">
        <% if (image1 != null && !image1.isEmpty()) { %>
            <img class="preview" src="<%= request.getContextPath() + "/" + image1 %>" alt="Current Image">
        <% } %>

        <label>Image 2 (Optional)</label>
        <input type="file" name="image2" accept="image/*">
        <% if (image2 != null && !image2.isEmpty()) { %>
            <img class="preview" src="<%= request.getContextPath() + "/" + image2 %>" alt="Current Image">
        <% } %>

        <button type="submit">💾 Update Product</button>
        
    </form>
</div>
</body>
</html>

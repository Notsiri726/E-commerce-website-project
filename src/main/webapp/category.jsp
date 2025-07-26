<%@ page import="java.sql.*" %>
<%
    String category = request.getParameter("category");
%>

<html>
<head>
    <title><%= category %> Products</title>
</head>
<body>
    <h2 style="text-align:center;"><%= category %> Products</h2>

<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce_platform", "root", "your_pass");

        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM products WHERE category = ?");
        stmt.setString(1, category);
        ResultSet rs = stmt.executeQuery();

        boolean hasItems = false;
        while (rs.next()) {
            hasItems = true;
            int pid = rs.getInt("id");
            String name = rs.getString("name");
            String img = rs.getString("image_url");
            String price = rs.getString("price");
%>
        <div style="margin:20px; display:inline-block;">
            <a href="product.jsp?id=<%= pid %>">
                <img src="<%= img %>" width="150" height="150"><br>
                <strong><%= name %></strong><br>
                ₹<%= price %>
            </a>
        </div>
<%
        }
        if (!hasItems) {
%>
    <p style="text-align:center;">❌ No products found in this category.</p>
<%
        }
        conn.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>

</body>
</html>

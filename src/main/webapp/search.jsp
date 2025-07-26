<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String query = request.getParameter("query");
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
%>

<html>
<head>
    <title>Search Results</title>
</head>
<body>
    <h2 style="text-align:center;">🔍 Results for "<%= query %>"</h2>

<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce_platform", "root", "your_pass");

        stmt = conn.prepareStatement("SELECT * FROM products WHERE name LIKE ?");
        stmt.setString(1, "%" + query + "%");
        rs = stmt.executeQuery();

        boolean found = false;
        while (rs.next()) {
            found = true;
            int pid = rs.getInt("id");
            String name = rs.getString("name");
            String price = rs.getString("price");
            String img = rs.getString("image_url");
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
        if (!found) {
%>
    <p style="text-align:center;">❌ No products found.</p>
<%
        }
        conn.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
</body>
</html>

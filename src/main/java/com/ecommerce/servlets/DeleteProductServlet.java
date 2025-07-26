package com.ecommerce.servlets;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/DeleteProductServlet")
public class DeleteProductServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        Integer sellerId = (Integer) session.getAttribute("sellerId");

        if (sellerId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String productIdStr = request.getParameter("id");

        if (productIdStr == null || productIdStr.trim().isEmpty()) {
            response.sendRedirect("manage_products.jsp");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdStr);

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/ecommerce_platform", "root", "your_pass");

            // ✅ Only allow deletion of products owned by this seller
            PreparedStatement stmt = conn.prepareStatement(
                    "DELETE FROM products WHERE id = ? AND seller_id = ?");
            stmt.setInt(1, productId);
            stmt.setInt(2, sellerId);
            stmt.executeUpdate();

            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("manage_products.jsp");
    }
}

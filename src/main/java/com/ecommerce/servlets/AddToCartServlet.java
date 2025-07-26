package com.ecommerce.servlets;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/AddToCartServlet")
public class AddToCartServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        Connection conn = null;

        try {
            HttpSession session = request.getSession(false);
            Integer customerId = (Integer) session.getAttribute("customerId");

            if (customerId == null) {
                out.print("{\"success\": false, \"message\": \"User not logged in.\"}");
                return;
            }

            String productIdStr = request.getParameter("productId");
            System.out.println("🛒 Received productId: " + productIdStr);

            if (productIdStr == null || productIdStr.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"Product ID missing.\"}");
                return;
            }

            int productId = Integer.parseInt(productIdStr);

            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/ecommerce_platform?useSSL=false&serverTimezone=UTC",
                "root", "your_pass");

            PreparedStatement checkStmt = conn.prepareStatement(
                "SELECT id FROM cart WHERE customer_id = ? AND product_id = ?");
            checkStmt.setInt(1, customerId);
            checkStmt.setInt(2, productId);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                out.print("{\"success\": false, \"message\": \"Already in cart.\"}");
                return;
            }

            PreparedStatement insertStmt = conn.prepareStatement(
                "INSERT INTO cart (customer_id, product_id) VALUES (?, ?)");
            insertStmt.setInt(1, customerId);
            insertStmt.setInt(2, productId);
            insertStmt.executeUpdate();

            out.print("{\"success\": true}");

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Error: " + e.getMessage().replace("\"", "\\\"") + "\"}");
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
            out.close();
        }
    }
}


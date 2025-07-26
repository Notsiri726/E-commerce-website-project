package com.ecommerce.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/submitReview")
public class ReviewServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        PrintWriter out = response.getWriter();
        Connection conn = null;

        try {
            HttpSession session = request.getSession(false);
            Integer customerId = (Integer) session.getAttribute("customerId");

            if (customerId == null) {
                out.print("{\"error\": \"You must be logged in to submit a review.\"}");
                return;
            }

            // Read input values
            String productIdStr = request.getParameter("productId");
            String name = request.getParameter("name");
            String ratingStr = request.getParameter("rating");
            String review = request.getParameter("review");

            System.out.println("productId = " + productIdStr);
            System.out.println("name = " + name);
            System.out.println("rating = " + ratingStr);
            System.out.println("review = " + review);

            if (productIdStr == null || ratingStr == null || name == null || review == null ||
                productIdStr.trim().isEmpty() || ratingStr.trim().isEmpty() || name.trim().isEmpty() || review.trim().isEmpty()) {
                out.print("{\"error\": \"Missing or empty fields in request.\"}");
                return;
            }

            int productId = Integer.parseInt(productIdStr);
            int rating = Integer.parseInt(ratingStr);

            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/ecommerce_platform?useSSL=false&serverTimezone=UTC",
                "root", "your_pass");

            // 🔒 Duplicate check
            PreparedStatement checkStmt = conn.prepareStatement(
                "SELECT id FROM reviews WHERE product_id = ? AND customer_id = ?");
            checkStmt.setInt(1, productId);
            checkStmt.setInt(2, customerId);
            ResultSet checkRs = checkStmt.executeQuery();

            if (checkRs.next()) {
                out.print("{\"error\": \"You've already submitted a review for this product.\"}");
                return;
            }

            // ✅ Insert new review
            PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO reviews (product_id, customer_id, customer_name, rating, review_text) VALUES (?, ?, ?, ?, ?)");
            stmt.setInt(1, productId);
            stmt.setInt(2, customerId);
            stmt.setString(3, name);
            stmt.setInt(4, rating);
            stmt.setString(5, review);
            stmt.executeUpdate();

            // ✅ JSON success response
            String jsonResponse = "{"
                    + "\"success\": true,"
                    + "\"name\": \"" + escapeJson(name) + "\","
                    + "\"rating\": " + rating + ","
                    + "\"review\": \"" + escapeJson(review) + "\""
                    + "}";

            out.print(jsonResponse);

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\": \"Internal Server Error: " + escapeJson(e.getMessage()) + "\"}");
        } finally {
            try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
            out.close();
        }
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r");
    }
}

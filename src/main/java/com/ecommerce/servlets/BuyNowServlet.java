package com.ecommerce.servlets;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/BuyNowServlet")
public class BuyNowServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        Integer customerId = (Integer) session.getAttribute("customerId");

        if (customerId == null) {
            response.sendRedirect("login_customer.jsp");
            return;
        }

        String productIdStr = request.getParameter("productId");

        if (productIdStr == null || productIdStr.trim().isEmpty()) {
            response.sendRedirect("product.jsp");
            return;
        }

        int productId = Integer.parseInt(productIdStr);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/ecommerce_platform?useSSL=false&serverTimezone=UTC",
                "root", "you_pass");

            // 1. Fetch product details
            PreparedStatement ps = conn.prepareStatement(
                "SELECT name, price FROM products WHERE id = ?");
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String name = rs.getString("name");
                double price = rs.getDouble("price");

                // 2. Get customer's current wallet balance
                PreparedStatement balCheck = conn.prepareStatement(
                    "SELECT wallet_balance FROM customers WHERE id = ?");
                balCheck.setInt(1, customerId);
                ResultSet balRs = balCheck.executeQuery();

                if (balRs.next()) {
                    double currentBalance = balRs.getDouble("wallet_balance");

                    if (currentBalance >= price) {
                        // 3. Deduct from wallet
                        double newBalance = currentBalance - price;
                        PreparedStatement updateBal = conn.prepareStatement(
                            "UPDATE customers SET wallet_balance = ? WHERE id = ?");
                        updateBal.setDouble(1, newBalance);
                        updateBal.setInt(2, customerId);
                        updateBal.executeUpdate();

                        // 4. Insert order
                        PreparedStatement insertOrder = conn.prepareStatement(
                            "INSERT INTO orders (customer_id, total_amount, status) VALUES (?, ?, ?)");
                        insertOrder.setInt(1, customerId);
                        insertOrder.setDouble(2, price);
                        insertOrder.setString(3, "Processing");
                        insertOrder.executeUpdate();

                        session.setAttribute("purchasedProduct", name);
                        session.setAttribute("purchasedAmount", price);

                        conn.close();
                        response.sendRedirect("buy_now_success.jsp");
                        return;

                    } else {
                        // ❌ Insufficient balance
                        session.setAttribute("buyNowError", "❌ Insufficient balance. Please add funds.");
                        conn.close();
                        response.sendRedirect("product.jsp?id=" + productId);
                        return;
                    }
                }
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("product.jsp?id=" + productId);
    }
}

package com.ecommerce.servlets;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.*;
@WebServlet("/CartCheckoutServlet")
public class CartCheckoutServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer customerId = (Integer) session.getAttribute("customerId");

        if (customerId == null) {
            response.sendRedirect("login_customer.jsp");
            return;
        }

        double totalAmount = 0;
        List<Integer> cartProductIds = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/ecommerce_platform", "root", "your_pass");

            // 1. Get all product IDs from the cart
            PreparedStatement cartStmt = conn.prepareStatement("SELECT product_id FROM cart WHERE customer_id = ?");
            cartStmt.setInt(1, customerId);
            ResultSet cartRs = cartStmt.executeQuery();

            while (cartRs.next()) {
                cartProductIds.add(cartRs.getInt("product_id"));
            }

            if (cartProductIds.isEmpty()) {
                response.sendRedirect("cart.jsp"); // Nothing to checkout
                return;
            }

            // 2. Calculate total price
            StringBuilder ids = new StringBuilder();
            for (int i = 0; i < cartProductIds.size(); i++) {
                ids.append("?");
                if (i < cartProductIds.size() - 1) ids.append(",");
            }

            PreparedStatement productStmt = conn.prepareStatement(
                "SELECT price FROM products WHERE id IN (" + ids + ")");
            for (int i = 0; i < cartProductIds.size(); i++) {
                productStmt.setInt(i + 1, cartProductIds.get(i));
            }

            ResultSet priceRs = productStmt.executeQuery();
            while (priceRs.next()) {
                totalAmount += priceRs.getDouble("price");
            }

            // 3. Get customer wallet
            PreparedStatement walletStmt = conn.prepareStatement("SELECT wallet_balance FROM customers WHERE id = ?");
            walletStmt.setInt(1, customerId);
            ResultSet walletRs = walletStmt.executeQuery();
            double wallet = 0;
            if (walletRs.next()) {
                wallet = walletRs.getDouble("wallet_balance");
            }

            if (wallet < totalAmount) {
                // Not enough balance
                session.setAttribute("error", "Insufficient wallet balance");
                response.sendRedirect("cart.jsp");
                return;
            }

            // 4. Deduct wallet
            PreparedStatement updateWallet = conn.prepareStatement(
                    "UPDATE customers SET wallet_balance = wallet_balance - ? WHERE id = ?");
            updateWallet.setDouble(1, totalAmount);
            updateWallet.setInt(2, customerId);
            updateWallet.executeUpdate();

            // 5. Insert into orders table
            PreparedStatement orderStmt = conn.prepareStatement(
                    "INSERT INTO orders (customer_id, total_amount, status) VALUES (?, ?, ?)");
            orderStmt.setInt(1, customerId);
            orderStmt.setDouble(2, totalAmount);
            orderStmt.setString(3, "Placed");
            orderStmt.executeUpdate();

            // 6. Clear cart
            PreparedStatement clearCart = conn.prepareStatement("DELETE FROM cart WHERE customer_id = ?");
            clearCart.setInt(1, customerId);
            clearCart.executeUpdate();

            conn.close();

            // ✅ Redirect to dedicated success page
            session.setAttribute("purchasedProduct", "Items in Cart");
            session.setAttribute("purchasedAmount", totalAmount);
            response.sendRedirect("order_success.jsp");


        } catch (Exception e) {
        	e.printStackTrace();
        	response.getWriter().println("<h2 style='color:red;'>Something went wrong: " + e.getMessage() + "</h2>");

        }
    }
}

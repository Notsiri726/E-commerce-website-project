package com.ecommerce.servlets;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Integer customerId = (Integer) session.getAttribute("customerId");

        if (customerId == null) {
            response.sendRedirect("login_customer.jsp");
            return;
        }

        String totalStr = request.getParameter("total");
        double totalAmount = 0.0;

        try {
            totalAmount = Double.parseDouble(totalStr);
        } catch (Exception e) {
            response.sendRedirect("cart.jsp");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/ecommerce_platform", "root", "your_pass");

            // Insert into orders table
            PreparedStatement insertOrder = conn.prepareStatement(
                "INSERT INTO orders (customer_id, total_amount, status) VALUES (?, ?, ?)");
            insertOrder.setInt(1, customerId);
            insertOrder.setDouble(2, totalAmount);
            insertOrder.setString(3, "Processing"); // default status
            insertOrder.executeUpdate();

            // Clear the cart
            PreparedStatement clearCart = conn.prepareStatement("DELETE FROM cart WHERE customer_id = ?");
            clearCart.setInt(1, customerId);
            clearCart.executeUpdate();

            conn.close();

            response.sendRedirect("order_success.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("cart.jsp");
        }
    }
}



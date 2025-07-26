package com.ecommerce.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/AddToWishlistServlet")
public class AddToWishlistServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        if (session == null || session.getAttribute("customerId") == null) {
            out.print("unauthorized");
            return;
        }

        int customerId = (int) session.getAttribute("customerId");
        int productId = Integer.parseInt(request.getParameter("productId"));

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/ecommerce_platform", "root", "your_pass");

            // Check if the product is already in wishlist
            PreparedStatement check = conn.prepareStatement(
                    "SELECT * FROM wishlist WHERE customer_id = ? AND product_id = ?");
            check.setInt(1, customerId);
            check.setInt(2, productId);
            ResultSet rs = check.executeQuery();

            if (!rs.next()) {
                // Insert into wishlist
                PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO wishlist (customer_id, product_id) VALUES (?, ?)");
                ps.setInt(1, customerId);
                ps.setInt(2, productId);
                ps.executeUpdate();
                ps.close();
                out.print("added");
            } else {
                out.print("exists");
            }

            rs.close();
            check.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            out.print("error");
        }
    }
}


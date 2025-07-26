package com.ecommerce.servlets;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/RemoveFromCartServlet")
public class RemoveFromCartServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        Integer customerId = (Integer) session.getAttribute("customerId");

        if (customerId == null) {
            out.print("unauthorized");
            return;
        }

        String productIdStr = request.getParameter("productId");
        if (productIdStr == null || productIdStr.trim().isEmpty()) {
            out.print("invalid");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdStr);
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/ecommerce_platform",
                "root", "your_pass"
            );

            PreparedStatement stmt = conn.prepareStatement(
                "DELETE FROM cart WHERE product_id = ? AND customer_id = ?"
            );
            stmt.setInt(1, productId);
            stmt.setInt(2, customerId);

            int rows = stmt.executeUpdate();
            conn.close();

            if (rows > 0) {
                out.print("removed");
            } else {
                out.print("not_found");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.print("error");
        }
    }
}


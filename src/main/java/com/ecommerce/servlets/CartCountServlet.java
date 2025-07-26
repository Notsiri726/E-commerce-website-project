package com.ecommerce.servlets;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/CartCountServlet")
public class CartCountServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        Integer customerId = (Integer) session.getAttribute("customerId");

        if (customerId == null) {
            out.print("{\"count\": 0}");
            return;
        }

        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/ecommerce_platform?useSSL=false&serverTimezone=UTC",
                "root", "your_pass"
            );

            PreparedStatement stmt = conn.prepareStatement(
                "SELECT COUNT(*) FROM cart WHERE customer_id = ?");
            stmt.setInt(1, customerId);

            ResultSet rs = stmt.executeQuery();
            int count = 0;
            if (rs.next()) {
                count = rs.getInt(1);
            }

            out.print("{\"count\": " + count + "}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"count\": 0}");
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
            out.close();
        }
    }
}

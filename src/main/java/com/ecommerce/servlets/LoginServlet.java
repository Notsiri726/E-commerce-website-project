package com.ecommerce.servlets;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = request.getParameter("role"); // "customer" or "seller"
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        String table = role.equals("customer") ? "customers" : "sellers";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/ecommerce_platform", "root", "your_pass");

            String sql = "SELECT * FROM " + table + " WHERE username = ? AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                int userId = rs.getInt("id");
                String dbName = rs.getString("name"); // ✅ this must match column name exactly

                HttpSession session = request.getSession(true);
                session.setAttribute("username", username);
                session.setAttribute("role", role);

                if (role.equals("customer")) {
                    session.setAttribute("customerId", userId);
                    session.setAttribute("customerName", rs.getString("name"));
                    response.sendRedirect("customer_dashboard.jsp");
                } else if (role.equals("seller")) {
                    session.setAttribute("sellerId", userId);
                    session.setAttribute("username", rs.getString("username"));  // ✅ This helps in manage_product.jsp
                    response.sendRedirect("seller_dashboard.jsp");
                }

            }



            rs.close();
            stmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("loginStatus", "fail");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}


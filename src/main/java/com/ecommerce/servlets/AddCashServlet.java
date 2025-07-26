package com.ecommerce.servlets;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/AddCashServlet")
public class AddCashServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer customerId = (Integer) request.getSession().getAttribute("customerId");
        String amountStr = request.getParameter("amount");

        if (customerId == null || amountStr == null || amountStr.isEmpty()) {
            response.sendRedirect("customer_dashboard.jsp");
            return;
        }

        double amount = Double.parseDouble(amountStr);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/ecommerce_platform?useSSL=false&serverTimezone=UTC",
                "root", "your_pass");

            PreparedStatement ps = conn.prepareStatement(
                "UPDATE customers SET wallet_balance = wallet_balance + ? WHERE id = ?");
            ps.setDouble(1, amount);
            ps.setInt(2, customerId);
            ps.executeUpdate();

            conn.close();
            response.sendRedirect("customer_dashboard.jsp?cashAdded=true");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("customer_dashboard.jsp?cashAdded=true");

        }
    }
}


package com.ecommerce.servlets;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/RemoveFromWishlistServlet")
public class RemoveFromWishlistServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("customerId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int customerId = (int) session.getAttribute("customerId");
        int productId = Integer.parseInt(request.getParameter("productId"));

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/ecommerce_platform", "root", "JaiJagannath7");

            PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM wishlist WHERE customer_id = ? AND product_id = ?");
            ps.setInt(1, customerId);
            ps.setInt(2, productId);
            ps.executeUpdate();

            ps.close();
            conn.close();

            session.setAttribute("wishlistRemoved", true);
            response.sendRedirect("wishlist.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}

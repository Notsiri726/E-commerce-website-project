package com.ecommerce.servlets;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/SellerRegisterServlet")
public class SellerRegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String shopName = request.getParameter("shopname");
        String gst = request.getParameter("gst");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/ecommerce_platform", "root", "your_pass");

            String sql = "INSERT INTO sellers (name, email, shopName, gst, username, password, phone, address) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, shopName);
            ps.setString(4, gst);
            ps.setString(5, username);
            ps.setString(6, password);
            ps.setString(7, phone);
            ps.setString(8, address);

            int rowInserted = ps.executeUpdate();

            if (rowInserted > 0) {
                RequestDispatcher dispatcher = request.getRequestDispatcher("registration_success.jsp");
                dispatcher.forward(request, response);
            } else {
                response.getWriter().println("Seller registration failed.");
            }

            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error occurred: " + e.getMessage());
        }
    }
}


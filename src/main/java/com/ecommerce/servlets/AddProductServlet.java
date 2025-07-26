package com.ecommerce.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.Paths;
import java.sql.*;

@WebServlet("/AddProductServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
                 maxFileSize = 1024 * 1024 * 10,       // 10MB
                 maxRequestSize = 1024 * 1024 * 50)    // 50MB
public class AddProductServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Integer sellerId = (Integer) session.getAttribute("sellerId");

        if (sellerId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // ✅ Retrieve form parameters
        String name = request.getParameter("name");
        String priceStr = request.getParameter("price");
        String description = request.getParameter("description");
        String fullDescription = request.getParameter("full_description");
        String category = request.getParameter("category");
        String isHotStr = request.getParameter("is_hot");

        java.math.BigDecimal price = new java.math.BigDecimal(
                (priceStr != null && !priceStr.isBlank()) ? priceStr : "0.00");

        int isHot = (isHotStr != null && !isHotStr.trim().isEmpty()) ? Integer.parseInt(isHotStr) : 0;

        // ✅ File uploads
        Part image1Part = request.getPart("image1");
        Part image2Part = request.getPart("image2");

        String uploadPath = getServletContext().getRealPath("/images");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String image1FileName = Paths.get(image1Part.getSubmittedFileName()).getFileName().toString();
        String image2FileName = (image2Part != null) ?
                Paths.get(image2Part.getSubmittedFileName()).getFileName().toString() : "";

        image1Part.write(uploadPath + File.separator + image1FileName);
        if (image2Part != null && !image2FileName.isEmpty()) {
            image2Part.write(uploadPath + File.separator + image2FileName);
        }

        // ✅ Store in DB including seller_id
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/ecommerce_platform",
                    "root", "your_pass");

            PreparedStatement stmt = conn.prepareStatement(
            	    "INSERT INTO products (name, description, price, image_url, image_url_2, category, is_hot, full_description, seller_id) " +
            	    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
            	);

            	stmt.setString(1, name);
            	stmt.setString(2, description);
            	stmt.setBigDecimal(3, price);
            	stmt.setString(4, "images/" + image1FileName);
            	stmt.setString(5, image2FileName.isEmpty() ? null : "images/" + image2FileName);
            	stmt.setString(6, category);
            	stmt.setInt(7, isHot);
            	stmt.setString(8, fullDescription);
            	stmt.setInt(9, sellerId); // ✅ This line MUST exist and be at correct position

            	stmt.executeUpdate();

            stmt.close();
            conn.close();

            response.sendRedirect("seller_dashboard.jsp?added=true");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("<h3 style='color:red;'>Error: " + e.getMessage() + "</h3>");
        }
    }
}


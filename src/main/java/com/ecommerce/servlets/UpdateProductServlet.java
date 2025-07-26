package com.ecommerce.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.sql.*;

@WebServlet("/UpdateProductServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
                 maxFileSize = 1024 * 1024 * 10,       // 10MB
                 maxRequestSize = 1024 * 1024 * 50)    // 50MB
public class UpdateProductServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer sellerId = (Integer) session.getAttribute("sellerId");

        if (sellerId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        int productId = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String priceStr = request.getParameter("price");
        String description = request.getParameter("description");
        String fullDescription = request.getParameter("full_description");
        String category = request.getParameter("category");
        int isHot = Integer.parseInt(request.getParameter("is_hot"));

        BigDecimal price = new BigDecimal(priceStr);

        Part image1Part = request.getPart("image1");
        Part image2Part = request.getPart("image2");

        String uploadPath = getServletContext().getRealPath("/images");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String image1Path = null;
        String image2Path = null;

        if (image1Part != null && image1Part.getSize() > 0) {
            String fileName1 = Paths.get(image1Part.getSubmittedFileName()).getFileName().toString();
            image1Part.write(uploadPath + File.separator + fileName1);
            image1Path = "images/" + fileName1;
        }

        if (image2Part != null && image2Part.getSize() > 0) {
            String fileName2 = Paths.get(image2Part.getSubmittedFileName()).getFileName().toString();
            image2Part.write(uploadPath + File.separator + fileName2);
            image2Path = "images/" + fileName2;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/ecommerce_platform", "root", "your_pass");

            StringBuilder sql = new StringBuilder("""
                UPDATE products
                SET name = ?, description = ?, price = ?, category = ?, is_hot = ?, full_description = ?
            """);

            if (image1Path != null) sql.append(", image_url = ?");
            if (image2Path != null) sql.append(", image_url_2 = ?");
            sql.append(" WHERE id = ? AND seller_id = ?");

            PreparedStatement stmt = conn.prepareStatement(sql.toString());

            int idx = 1;
            stmt.setString(idx++, name);
            stmt.setString(idx++, description);
            stmt.setBigDecimal(idx++, price);
            stmt.setString(idx++, category);
            stmt.setInt(idx++, isHot);
            stmt.setString(idx++, fullDescription);

            if (image1Path != null) stmt.setString(idx++, image1Path);
            if (image2Path != null) stmt.setString(idx++, image2Path);

            stmt.setInt(idx++, productId);
            stmt.setInt(idx, sellerId);

            stmt.executeUpdate();
            stmt.close();
            conn.close();

            response.sendRedirect("manage_products.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3 style='color:red;'>Error: " + e.getMessage() + "</h3>");
        }
    }
}

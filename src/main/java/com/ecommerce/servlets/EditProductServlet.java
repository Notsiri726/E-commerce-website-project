package com.ecommerce.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.Paths;
import java.sql.*;

@WebServlet("/EditProductServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
                 maxFileSize = 1024 * 1024 * 10,       // 10MB
                 maxRequestSize = 1024 * 1024 * 50)    // 50MB
public class EditProductServlet extends HttpServlet {

    // ✅ Show Edit Form (GET)
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer sellerId = (Integer) session.getAttribute("sellerId");

        if (sellerId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String productIdStr = request.getParameter("id");
        if (productIdStr == null || productIdStr.isEmpty()) {
            response.getWriter().println("<h3>Product ID missing</h3>");
            return;
        }

        int productId = Integer.parseInt(productIdStr);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce_platform", "root", "your_pass");

            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM products WHERE id = ? AND seller_id = ?");
            stmt.setInt(1, productId);
            stmt.setInt(2, sellerId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                request.setAttribute("product", rs);
                request.getRequestDispatcher("edit_product.jsp").forward(request, response);
            } else {
                response.getWriter().println("<h3>Product not found or unauthorized</h3>");
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Error: " + e.getMessage() + "</h3>");
        }
    }

    // ✅ Handle Form Submission (POST)
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Integer sellerId = (Integer) session.getAttribute("sellerId");

        if (sellerId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String price = request.getParameter("price");
        String description = request.getParameter("description");
        String fullDescription = request.getParameter("full_description");
        String category = request.getParameter("category");
        String isHot = request.getParameter("is_hot");

        Part image1Part = request.getPart("image1");
        Part image2Part = request.getPart("image2");

        String uploadPath = getServletContext().getRealPath("/images");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String image1FileName = image1Part.getSubmittedFileName();
        String image2FileName = image2Part.getSubmittedFileName();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/ecommerce_platform", "root", "JaiJagannath7");

            // Build dynamic SQL
            StringBuilder sql = new StringBuilder("UPDATE products SET name=?, description=?, price=?, full_description=?, category=?, is_hot=?");

            if (image1FileName != null && !image1FileName.isEmpty()) {
                sql.append(", image_url=?");
            }

            if (image2FileName != null && !image2FileName.isEmpty()) {
                sql.append(", image_url_2=?");
            }

            sql.append(" WHERE id=? AND seller_id=?");

            PreparedStatement stmt = conn.prepareStatement(sql.toString());

            stmt.setString(1, name);
            stmt.setString(2, description);
            stmt.setBigDecimal(3, new java.math.BigDecimal(price));
            stmt.setString(4, fullDescription);
            stmt.setString(5, category);
            stmt.setInt(6, Integer.parseInt(isHot));

            int paramIndex = 7;

            if (image1FileName != null && !image1FileName.isEmpty()) {
                image1Part.write(uploadPath + File.separator + image1FileName);
                stmt.setString(paramIndex++, "images/" + image1FileName);
            }

            if (image2FileName != null && !image2FileName.isEmpty()) {
                image2Part.write(uploadPath + File.separator + image2FileName);
                stmt.setString(paramIndex++, "images/" + image2FileName);
            }

            stmt.setInt(paramIndex++, Integer.parseInt(id));
            stmt.setInt(paramIndex, sellerId);

            stmt.executeUpdate();
            conn.close();

            response.sendRedirect("edit_product.jsp?id=" + id + "&updated=true");


        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}

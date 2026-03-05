package com.timezone.controller.admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.timezone.model.Watch;
import com.timezone.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/admin/products")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class AdminProductServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if admin is logged in
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        String id = request.getParameter("id");
        
        try {
            Connection con = DBConnection.getConnection();
            
            // Handle delete action
            if ("delete".equals(action) && id != null) {
                String deleteQuery = "DELETE FROM watches WHERE id = ?";
                PreparedStatement deletePs = con.prepareStatement(deleteQuery);
                deletePs.setInt(1, Integer.parseInt(id));
                deletePs.executeUpdate();
                response.sendRedirect("products?deleted=true");
                return;
            }
            
            // Handle edit action - fetch product data
            if ("edit".equals(action) && id != null) {
                String query = "SELECT * FROM watches WHERE id = ?";
                PreparedStatement ps = con.prepareStatement(query);
                ps.setInt(1, Integer.parseInt(id));
                ResultSet rs = ps.executeQuery();
                
                if (rs.next()) {
                    Watch watch = new Watch();
                    watch.setId(rs.getInt("id"));
                    watch.setName(rs.getString("name"));
                    watch.setBrand(rs.getString("brand"));
                    watch.setPrice(rs.getDouble("price"));
                    watch.setImage(rs.getString("image"));
                    watch.setDescription(rs.getString("description"));
                    watch.setCategory(rs.getString("category"));
                    
                    request.setAttribute("watch", watch);
                    request.setAttribute("editMode", true);
                    
                    // Forward to product-form.jsp with the data
                    con.close();
                    request.getRequestDispatcher("/admin/product-form.jsp").forward(request, response);
                    return;
                }
            }
            
            // Get all products for listing
            List<Watch> products = new ArrayList<>();
            String query = "SELECT * FROM watches ORDER BY id DESC";
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Watch watch = new Watch();
                watch.setId(rs.getInt("id"));
                watch.setName(rs.getString("name"));
                watch.setBrand(rs.getString("brand"));
                watch.setPrice(rs.getDouble("price"));
                watch.setImage(rs.getString("image"));
                watch.setDescription(rs.getString("description"));
                watch.setCategory(rs.getString("category"));
                products.add(watch);
            }
            
            request.setAttribute("products", products);
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        String id = request.getParameter("id");
        
        String name = request.getParameter("name");
        String brand = request.getParameter("brand");
        double price = Double.parseDouble(request.getParameter("price"));
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        
        Part filePart = request.getPart("image");
        String fileName = null;
        
        try {
            Connection con = DBConnection.getConnection();
            
            if ("add".equals(action)) {
                // Handle image upload
                if (filePart != null && filePart.getSize() > 0) {
                    fileName = getFileName(filePart);
                    String uploadPath = getServletContext().getRealPath("/images/") + fileName;
                    filePart.write(uploadPath);
                } else {
                    fileName = "placeholder.jpg";
                }
                
                // Insert new product
                String insertQuery = "INSERT INTO watches (name, brand, price, image, description, category) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement ps = con.prepareStatement(insertQuery);
                ps.setString(1, name);
                ps.setString(2, brand);
                ps.setDouble(3, price);
                ps.setString(4, fileName);
                ps.setString(5, description);
                ps.setString(6, category);
                ps.executeUpdate();
                
                response.sendRedirect("products?added=true");
                
            } else if ("edit".equals(action) && id != null) {
                // Check if new image uploaded
                if (filePart != null && filePart.getSize() > 0) {
                    fileName = getFileName(filePart);
                    String uploadPath = getServletContext().getRealPath("/images/") + fileName;
                    filePart.write(uploadPath);
                    
                    // Update with new image
                    String updateQuery = "UPDATE watches SET name=?, brand=?, price=?, image=?, description=?, category=? WHERE id=?";
                    PreparedStatement ps = con.prepareStatement(updateQuery);
                    ps.setString(1, name);
                    ps.setString(2, brand);
                    ps.setDouble(3, price);
                    ps.setString(4, fileName);
                    ps.setString(5, description);
                    ps.setString(6, category);
                    ps.setInt(7, Integer.parseInt(id));
                    ps.executeUpdate();
                } else {
                    // Update without changing image
                    String updateQuery = "UPDATE watches SET name=?, brand=?, price=?, description=?, category=? WHERE id=?";
                    PreparedStatement ps = con.prepareStatement(updateQuery);
                    ps.setString(1, name);
                    ps.setString(2, brand);
                    ps.setDouble(3, price);
                    ps.setString(4, description);
                    ps.setString(5, category);
                    ps.setInt(6, Integer.parseInt(id));
                    ps.executeUpdate();
                }
                
                response.sendRedirect("products?updated=true");
            }
            
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("products?error=true");
        }
    }
    
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] tokens = contentDisposition.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "placeholder.jpg";
    }
}
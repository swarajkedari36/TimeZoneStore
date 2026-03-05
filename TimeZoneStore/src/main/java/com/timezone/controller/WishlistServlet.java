package com.timezone.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.timezone.model.Watch;
import com.timezone.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/wishlist")
public class WishlistServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("login.html");
            return;
        }
        
        String email = (String) session.getAttribute("userEmail");
        String action = request.getParameter("action");
        
        try {
            Connection con = DBConnection.getConnection();
            int userId = getUserId(con, email);
            
            if ("add".equals(action)) {
                int watchId = Integer.parseInt(request.getParameter("watchId"));
                addToWishlist(con, userId, watchId);
                response.sendRedirect("wishlist?added=true");
                return;
            } else if ("remove".equals(action)) {
                int wishlistId = Integer.parseInt(request.getParameter("id"));
                removeFromWishlist(con, wishlistId);
                response.sendRedirect("wishlist?removed=true");
                return;
            } else if ("clear".equals(action)) {
                clearWishlist(con, userId);
                response.sendRedirect("wishlist?cleared=true");
                return;
            }
            
            // Get wishlist items
            List<Watch> wishlist = getWishlist(con, userId);
            request.setAttribute("wishlist", wishlist);
            
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("wishlist.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    private int getUserId(Connection con, String email) throws Exception {
        String query = "SELECT id FROM users WHERE email = ?";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setString(1, email);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            return rs.getInt("id");
        }
        return 0;
    }
    
    private List<Watch> getWishlist(Connection con, int userId) throws Exception {
        List<Watch> wishlist = new ArrayList<>();
        
        String query = "SELECT w.*, wi.id as wishlist_id, wi.added_date " +
                      "FROM wishlist wi " +
                      "JOIN watches w ON wi.watch_id = w.id " +
                      "WHERE wi.user_id = ? " +
                      "ORDER BY wi.added_date DESC";
        
        PreparedStatement ps = con.prepareStatement(query);
        ps.setInt(1, userId);
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
            
            // Store wishlist item ID separately (for removal)
            watch.setQuantity(rs.getInt("wishlist_id")); // Using quantity field temporarily
            
            wishlist.add(watch);
        }
        
        return wishlist;
    }
    
    private void addToWishlist(Connection con, int userId, int watchId) throws Exception {
        // Check if already in wishlist
        String checkQuery = "SELECT id FROM wishlist WHERE user_id = ? AND watch_id = ?";
        PreparedStatement checkPs = con.prepareStatement(checkQuery);
        checkPs.setInt(1, userId);
        checkPs.setInt(2, watchId);
        ResultSet rs = checkPs.executeQuery();
        
        if (!rs.next()) {
            // Not in wishlist, add it
            String insertQuery = "INSERT INTO wishlist (user_id, watch_id) VALUES (?, ?)";
            PreparedStatement insertPs = con.prepareStatement(insertQuery);
            insertPs.setInt(1, userId);
            insertPs.setInt(2, watchId);
            insertPs.executeUpdate();
        }
    }
    
    private void removeFromWishlist(Connection con, int wishlistId) throws Exception {
        String query = "DELETE FROM wishlist WHERE id = ?";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setInt(1, wishlistId);
        ps.executeUpdate();
    }
    
    private void clearWishlist(Connection con, int userId) throws Exception {
        String query = "DELETE FROM wishlist WHERE user_id = ?";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setInt(1, userId);
        ps.executeUpdate();
    }
}
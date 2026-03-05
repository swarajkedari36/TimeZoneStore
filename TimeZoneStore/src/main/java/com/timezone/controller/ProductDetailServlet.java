package com.timezone.controller;

import java.io.IOException;
import java.util.List;

import com.timezone.dao.ReviewDAO;
import com.timezone.dao.WatchDAO;
import com.timezone.model.Review;
import com.timezone.model.Watch;
import com.timezone.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/product")
public class ProductDetailServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("login.html");
            return;
        }
        
        int watchId = Integer.parseInt(request.getParameter("id"));
        String email = (String) session.getAttribute("userEmail");
        
        try {
            // Get watch details
            WatchDAO watchDAO = new WatchDAO();
            Watch watch = watchDAO.getWatchById(watchId);
            
            // Get user ID
            int userId = getUserId(email);
            
            // Get reviews
            ReviewDAO reviewDAO = new ReviewDAO();
            List<Review> reviews = reviewDAO.getReviewsByWatchId(watchId, userId);
            double avgRating = reviewDAO.getAverageRating(watchId);
            int[] ratingSummary = reviewDAO.getRatingSummary(watchId);
            boolean hasReviewed = reviewDAO.hasUserReviewed(userId, watchId);
            
            request.setAttribute("watch", watch);
            request.setAttribute("reviews", reviews);
            request.setAttribute("avgRating", avgRating);
            request.setAttribute("ratingSummary", ratingSummary);
            request.setAttribute("totalReviews", reviews.size());
            request.setAttribute("hasReviewed", hasReviewed);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("product-detail.jsp").forward(request, response);
    }
    
    private int getUserId(String email) throws Exception {
        java.sql.Connection con = DBConnection.getConnection();
        String query = "SELECT id FROM users WHERE email = ?";
        java.sql.PreparedStatement ps = con.prepareStatement(query);
        ps.setString(1, email);
        java.sql.ResultSet rs = ps.executeQuery();
        
        int userId = 0;
        if (rs.next()) {
            userId = rs.getInt("id");
        }
        
        con.close();
        return userId;
    }
}
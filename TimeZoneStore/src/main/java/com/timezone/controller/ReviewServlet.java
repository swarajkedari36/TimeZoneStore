package com.timezone.controller;

import java.io.IOException;

import com.timezone.dao.ReviewDAO;
import com.timezone.model.Review;
import com.timezone.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("login.html");
            return;
        }
        
        String action = request.getParameter("action");
        String email = (String) session.getAttribute("userEmail");
        
        try {
            int userId = getUserId(email);
            
            if ("add".equals(action)) {
                int watchId = Integer.parseInt(request.getParameter("watchId"));
                int rating = Integer.parseInt(request.getParameter("rating"));
                String reviewText = request.getParameter("reviewText");
                
                Review review = new Review();
                review.setUserId(userId);
                review.setWatchId(watchId);
                review.setRating(rating);
                review.setReviewText(reviewText);
                
                ReviewDAO dao = new ReviewDAO();
                boolean success = dao.addReview(review);
                
                if (success) {
                    response.sendRedirect("product?id=" + watchId + "&review=added");
                } else {
                    response.sendRedirect("product?id=" + watchId + "&review=error");
                }
                
            } else if ("helpful".equals(action)) {
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                int watchId = Integer.parseInt(request.getParameter("watchId"));
                boolean helpful = Boolean.parseBoolean(request.getParameter("helpful"));
                
                ReviewDAO dao = new ReviewDAO();
                dao.markHelpful(reviewId, userId, helpful);
                
                response.sendRedirect("product?id=" + watchId);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
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
package com.timezone.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.timezone.model.Review;
import com.timezone.util.DBConnection;

public class ReviewDAO {
    
    // Add a review
    public boolean addReview(Review review) {
        boolean success = false;
        
        try {
            Connection con = DBConnection.getConnection();
            
            String query = "INSERT INTO reviews (user_id, watch_id, rating, review_text) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, review.getUserId());
            ps.setInt(2, review.getWatchId());
            ps.setInt(3, review.getRating());
            ps.setString(4, review.getReviewText());
            
            int result = ps.executeUpdate();
            success = (result > 0);
            
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return success;
    }
    
    // Get reviews for a watch
    public List<Review> getReviewsByWatchId(int watchId, int currentUserId) {
        List<Review> reviews = new ArrayList<>();
        
        try {
            Connection con = DBConnection.getConnection();
            
            String query = "SELECT r.*, u.name as user_name, " +
                          "(SELECT COUNT(*) FROM review_helpful WHERE review_id = r.id AND is_helpful = 1) as helpful_count, " +
                          "(SELECT COUNT(*) FROM review_helpful WHERE review_id = r.id AND user_id = ?) as user_helpful " +
                          "FROM reviews r " +
                          "JOIN users u ON r.user_id = u.id " +
                          "WHERE r.watch_id = ? " +
                          "ORDER BY r.created_at DESC";
            
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, currentUserId);
            ps.setInt(2, watchId);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Review review = new Review();
                review.setId(rs.getInt("id"));
                review.setUserId(rs.getInt("user_id"));
                review.setWatchId(rs.getInt("watch_id"));
                review.setRating(rs.getInt("rating"));
                review.setReviewText(rs.getString("review_text"));
                review.setCreatedAt(rs.getTimestamp("created_at"));
                review.setUserName(rs.getString("user_name"));
                review.setHelpfulCount(rs.getInt("helpful_count"));
                review.setUserHelpful(rs.getInt("user_helpful") > 0);
                
                reviews.add(review);
            }
            
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return reviews;
    }
    
    // Get average rating for a watch
    public double getAverageRating(int watchId) {
        double avgRating = 0;
        
        try {
            Connection con = DBConnection.getConnection();
            
            String query = "SELECT AVG(rating) as avg_rating, COUNT(*) as total FROM reviews WHERE watch_id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, watchId);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                avgRating = rs.getDouble("avg_rating");
            }
            
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return avgRating;
    }
    
    // Get rating summary (count of each star)
    public int[] getRatingSummary(int watchId) {
        int[] summary = new int[6]; // index 1-5 for stars
        
        try {
            Connection con = DBConnection.getConnection();
            
            String query = "SELECT rating, COUNT(*) as count FROM reviews WHERE watch_id = ? GROUP BY rating";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, watchId);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                int rating = rs.getInt("rating");
                int count = rs.getInt("count");
                if (rating >= 1 && rating <= 5) {
                    summary[rating] = count;
                }
            }
            
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return summary;
    }
    
    // Check if user has already reviewed this watch
    public boolean hasUserReviewed(int userId, int watchId) {
        boolean reviewed = false;
        
        try {
            Connection con = DBConnection.getConnection();
            
            String query = "SELECT id FROM reviews WHERE user_id = ? AND watch_id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, userId);
            ps.setInt(2, watchId);
            
            ResultSet rs = ps.executeQuery();
            reviewed = rs.next();
            
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return reviewed;
    }
    
    // Mark review as helpful
    public boolean markHelpful(int reviewId, int userId, boolean helpful) {
        boolean success = false;
        
        try {
            Connection con = DBConnection.getConnection();
            
            // Check if already exists
            String checkQuery = "SELECT id FROM review_helpful WHERE review_id = ? AND user_id = ?";
            PreparedStatement checkPs = con.prepareStatement(checkQuery);
            checkPs.setInt(1, reviewId);
            checkPs.setInt(2, userId);
            ResultSet rs = checkPs.executeQuery();
            
            if (rs.next()) {
                // Update existing
                String updateQuery = "UPDATE review_helpful SET is_helpful = ? WHERE review_id = ? AND user_id = ?";
                PreparedStatement updatePs = con.prepareStatement(updateQuery);
                updatePs.setBoolean(1, helpful);
                updatePs.setInt(2, reviewId);
                updatePs.setInt(3, userId);
                success = updatePs.executeUpdate() > 0;
            } else {
                // Insert new
                String insertQuery = "INSERT INTO review_helpful (review_id, user_id, is_helpful) VALUES (?, ?, ?)";
                PreparedStatement insertPs = con.prepareStatement(insertQuery);
                insertPs.setInt(1, reviewId);
                insertPs.setInt(2, userId);
                insertPs.setBoolean(3, helpful);
                success = insertPs.executeUpdate() > 0;
            }
            
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return success;
    }
}
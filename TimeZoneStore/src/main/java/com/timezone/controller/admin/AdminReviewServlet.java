package com.timezone.controller.admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.timezone.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/reviews")
public class AdminReviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
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
            
            // Approve review
            if ("approve".equals(action) && id != null) {
                updateReviewStatus(con, Integer.parseInt(id), "approved");
                response.sendRedirect("reviews?approved=true");
                return;
            }
            
            // Reject review
            if ("reject".equals(action) && id != null) {
                updateReviewStatus(con, Integer.parseInt(id), "rejected");
                response.sendRedirect("reviews?rejected=true");
                return;
            }
            
            // Delete review
            if ("delete".equals(action) && id != null) {
                deleteReview(con, Integer.parseInt(id));
                response.sendRedirect("reviews?deleted=true");
                return;
            }
            
            // Get filter parameters
            String status = request.getParameter("status");
            String watchId = request.getParameter("watchId");
            String rating = request.getParameter("rating");
            
            // Get all reviews
            List<Map<String, Object>> reviews = getReviews(con, status, watchId, rating);
            
            // Get review statistics
            int pendingReviews = getReviewCountByStatus(con, "pending");
            int approvedReviews = getReviewCountByStatus(con, "approved");
            int rejectedReviews = getReviewCountByStatus(con, "rejected");
            
            // Get watches for filter dropdown
            List<Map<String, Object>> watches = getWatches(con);
            
            request.setAttribute("reviews", reviews);
            request.setAttribute("pendingReviews", pendingReviews);
            request.setAttribute("approvedReviews", approvedReviews);
            request.setAttribute("rejectedReviews", rejectedReviews);
            request.setAttribute("watches", watches);
            request.setAttribute("selectedStatus", status);
            request.setAttribute("selectedWatchId", watchId);
            request.setAttribute("selectedRating", rating);
            
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("/admin/reviews.jsp").forward(request, response);
    }
    
    private List<Map<String, Object>> getReviews(Connection con, String status, String watchId, String rating) throws Exception {
        List<Map<String, Object>> reviews = new ArrayList<>();
        
        StringBuilder query = new StringBuilder(
            "SELECT r.*, u.name as user_name, u.email as user_email, " +
            "w.name as watch_name, w.image as watch_image " +
            "FROM reviews r " +
            "JOIN users u ON r.user_id = u.id " +
            "JOIN watches w ON r.watch_id = w.id " +
            "WHERE 1=1"
        );
        
        List<Object> params = new ArrayList<>();
        
        if (status != null && !status.isEmpty() && !"all".equals(status)) {
            query.append(" AND r.status = ?");
            params.add(status);
        }
        
        if (watchId != null && !watchId.isEmpty() && !"all".equals(watchId)) {
            query.append(" AND r.watch_id = ?");
            params.add(Integer.parseInt(watchId));
        }
        
        if (rating != null && !rating.isEmpty() && !"all".equals(rating)) {
            query.append(" AND r.rating = ?");
            params.add(Integer.parseInt(rating));
        }
        
        query.append(" ORDER BY r.created_at DESC");
        
        PreparedStatement ps = con.prepareStatement(query.toString());
        
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
        
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            Map<String, Object> review = new HashMap<>();
            review.put("id", rs.getInt("id"));
            review.put("userId", rs.getInt("user_id"));
            review.put("watchId", rs.getInt("watch_id"));
            review.put("rating", rs.getInt("rating"));
            review.put("reviewText", rs.getString("review_text"));
            review.put("status", rs.getString("status"));
            review.put("createdAt", rs.getTimestamp("created_at"));
            review.put("userName", rs.getString("user_name"));
            review.put("userEmail", rs.getString("user_email"));
            review.put("watchName", rs.getString("watch_name"));
            review.put("watchImage", rs.getString("watch_image"));
            reviews.add(review);
        }
        
        return reviews;
    }
    
    private void updateReviewStatus(Connection con, int reviewId, String status) throws Exception {
        String query = "UPDATE reviews SET status = ? WHERE id = ?";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setString(1, status);
        ps.setInt(2, reviewId);
        ps.executeUpdate();
    }
    
    private void deleteReview(Connection con, int reviewId) throws Exception {
        String query = "DELETE FROM reviews WHERE id = ?";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setInt(1, reviewId);
        ps.executeUpdate();
    }
    
    private int getReviewCountByStatus(Connection con, String status) throws Exception {
        String query = "SELECT COUNT(*) as count FROM reviews WHERE status = ?";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setString(1, status);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            return rs.getInt("count");
        }
        return 0;
    }
    
    private List<Map<String, Object>> getWatches(Connection con) throws Exception {
        List<Map<String, Object>> watches = new ArrayList<>();
        
        String query = "SELECT id, name FROM watches ORDER BY name";
        PreparedStatement ps = con.prepareStatement(query);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            Map<String, Object> watch = new HashMap<>();
            watch.put("id", rs.getInt("id"));
            watch.put("name", rs.getString("name"));
            watches.add(watch);
        }
        
        return watches;
    }
}
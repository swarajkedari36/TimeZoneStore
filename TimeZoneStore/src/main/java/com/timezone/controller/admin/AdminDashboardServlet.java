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

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if admin is logged in
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect("login");
            return;
        }
        
        try {
            Connection con = DBConnection.getConnection();
            
            // Get dashboard statistics
            Map<String, Object> stats = new HashMap<>();
            
            // Total products
            String productQuery = "SELECT COUNT(*) as count FROM watches";
            PreparedStatement productPs = con.prepareStatement(productQuery);
            ResultSet productRs = productPs.executeQuery();
            if (productRs.next()) {
                stats.put("totalProducts", productRs.getInt("count"));
            }
            
            // Total orders
            String orderQuery = "SELECT COUNT(*) as count FROM orders";
            PreparedStatement orderPs = con.prepareStatement(orderQuery);
            ResultSet orderRs = orderPs.executeQuery();
            if (orderRs.next()) {
                stats.put("totalOrders", orderRs.getInt("count"));
            }
            
            // Total users
            String userQuery = "SELECT COUNT(*) as count FROM users";
            PreparedStatement userPs = con.prepareStatement(userQuery);
            ResultSet userRs = userPs.executeQuery();
            if (userRs.next()) {
                stats.put("totalUsers", userRs.getInt("count"));
            }
            
            // Total revenue
            String revenueQuery = "SELECT SUM(total_amount) as total FROM orders WHERE status != 'Cancelled'";
            PreparedStatement revenuePs = con.prepareStatement(revenueQuery);
            ResultSet revenueRs = revenuePs.executeQuery();
            if (revenueRs.next()) {
                stats.put("totalRevenue", revenueRs.getDouble("total"));
            }
            
            // Recent orders
            String recentQuery = "SELECT o.*, u.email FROM orders o " +
                               "JOIN users u ON o.user_id = u.id " +
                               "ORDER BY o.order_date DESC LIMIT 5";
            PreparedStatement recentPs = con.prepareStatement(recentQuery);
            ResultSet recentRs = recentPs.executeQuery();
            
            List<Map<String, Object>> recentOrders = new ArrayList<>();
            while (recentRs.next()) {
                Map<String, Object> order = new HashMap<>();
                order.put("id", recentRs.getInt("id"));
                order.put("orderNumber", recentRs.getString("order_number"));
                order.put("email", recentRs.getString("email"));
                order.put("totalAmount", recentRs.getDouble("total_amount"));
                order.put("status", recentRs.getString("status"));
                order.put("orderDate", recentRs.getTimestamp("order_date"));
                recentOrders.add(order);
            }
            
            // Orders by status
            String statusQuery = "SELECT status, COUNT(*) as count FROM orders GROUP BY status";
            PreparedStatement statusPs = con.prepareStatement(statusQuery);
            ResultSet statusRs = statusPs.executeQuery();
            
            Map<String, Integer> ordersByStatus = new HashMap<>();
            while (statusRs.next()) {
                ordersByStatus.put(statusRs.getString("status"), statusRs.getInt("count"));
            }
            
            con.close();
            
            request.setAttribute("stats", stats);
            request.setAttribute("recentOrders", recentOrders);
            request.setAttribute("ordersByStatus", ordersByStatus);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}
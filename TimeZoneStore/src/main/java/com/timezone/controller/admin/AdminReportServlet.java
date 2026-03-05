package com.timezone.controller.admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
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

@WebServlet("/admin/reports")
public class AdminReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if admin is logged in
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect("login");
            return;
        }
        
        String period = request.getParameter("period");
        if (period == null || period.isEmpty()) {
            period = "month"; // Default to monthly report
        }
        
        try {
            Connection con = DBConnection.getConnection();
            
            // Get sales data based on period
            Map<String, Object> salesData = getSalesData(con, period);
            
            // Get top selling products
            List<Map<String, Object>> topProducts = getTopSellingProducts(con);
            
            // Get sales by category
            List<Map<String, Object>> salesByCategory = getSalesByCategory(con);
            
            // Get order status distribution
            List<Map<String, Object>> orderStatusDistribution = getOrderStatusDistribution(con);
            
            // Get summary statistics
            Map<String, Object> summaryStats = getSummaryStats(con);
            
            request.setAttribute("period", period);
            request.setAttribute("salesData", salesData);
            request.setAttribute("topProducts", topProducts);
            request.setAttribute("salesByCategory", salesByCategory);
            request.setAttribute("orderStatusDistribution", orderStatusDistribution);
            request.setAttribute("summaryStats", summaryStats);
            
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
    }
    
    private Map<String, Object> getSalesData(Connection con, String period) throws Exception {
        Map<String, Object> result = new HashMap<>();
        List<String> labels = new ArrayList<>();
        List<Double> salesData = new ArrayList<>();
        List<Integer> orderCounts = new ArrayList<>();
        
        SimpleDateFormat labelFormat = new SimpleDateFormat();
        Calendar cal = Calendar.getInstance();
        
        String query = "";
        
        switch (period) {
            case "week":
                labelFormat = new SimpleDateFormat("EEE");
                query = "SELECT DATE(order_date) as date, COUNT(*) as order_count, SUM(total_amount) as total " +
                        "FROM orders WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) " +
                        "GROUP BY DATE(order_date) ORDER BY date";
                break;
                
            case "month":
                labelFormat = new SimpleDateFormat("dd MMM");
                query = "SELECT DATE(order_date) as date, COUNT(*) as order_count, SUM(total_amount) as total " +
                        "FROM orders WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) " +
                        "GROUP BY DATE(order_date) ORDER BY date";
                break;
                
            case "year":
                labelFormat = new SimpleDateFormat("MMM yyyy");
                query = "SELECT DATE_FORMAT(order_date, '%Y-%m') as month, COUNT(*) as order_count, SUM(total_amount) as total " +
                        "FROM orders WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH) " +
                        "GROUP BY DATE_FORMAT(order_date, '%Y-%m') ORDER BY month";
                break;
                
            case "all":
            default:
                labelFormat = new SimpleDateFormat("MMM yyyy");
                query = "SELECT DATE_FORMAT(order_date, '%Y-%m') as month, COUNT(*) as order_count, SUM(total_amount) as total " +
                        "FROM orders GROUP BY DATE_FORMAT(order_date, '%Y-%m') ORDER BY month";
                break;
        }
        
        PreparedStatement ps = con.prepareStatement(query);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            String label = "";
            if (period.equals("year") || period.equals("all")) {
                label = rs.getString("month");
            } else {
                Date date = rs.getDate("date");
                label = labelFormat.format(date);
            }
            
            labels.add(label);
            salesData.add(rs.getDouble("total"));
            orderCounts.add(rs.getInt("order_count"));
        }
        
        result.put("labels", labels);
        result.put("salesData", salesData);
        result.put("orderCounts", orderCounts);
        
        return result;
    }
    
    private List<Map<String, Object>> getTopSellingProducts(Connection con) throws Exception {
        List<Map<String, Object>> products = new ArrayList<>();
        
        String query = "SELECT w.id, w.name, w.image, w.price, " +
                      "SUM(oi.quantity) as total_sold, " +
                      "SUM(oi.quantity * oi.price) as total_revenue " +
                      "FROM order_items oi " +
                      "JOIN watches w ON oi.watch_id = w.id " +
                      "JOIN orders o ON oi.order_id = o.id " +
                      "WHERE o.status != 'Cancelled' " +
                      "GROUP BY w.id, w.name, w.image, w.price " +
                      "ORDER BY total_sold DESC LIMIT 10";
        
        PreparedStatement ps = con.prepareStatement(query);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            Map<String, Object> product = new HashMap<>();
            product.put("id", rs.getInt("id"));
            product.put("name", rs.getString("name"));
            product.put("image", rs.getString("image"));
            product.put("price", rs.getDouble("price"));
            product.put("totalSold", rs.getInt("total_sold"));
            product.put("totalRevenue", rs.getDouble("total_revenue"));
            products.add(product);
        }
        
        return products;
    }
    
    private List<Map<String, Object>> getSalesByCategory(Connection con) throws Exception {
        List<Map<String, Object>> categories = new ArrayList<>();
        
        String query = "SELECT w.category, " +
                      "COUNT(DISTINCT oi.order_id) as order_count, " +
                      "SUM(oi.quantity) as total_sold, " +
                      "SUM(oi.quantity * oi.price) as total_revenue " +
                      "FROM order_items oi " +
                      "JOIN watches w ON oi.watch_id = w.id " +
                      "JOIN orders o ON oi.order_id = o.id " +
                      "WHERE o.status != 'Cancelled' " +
                      "GROUP BY w.category " +
                      "ORDER BY total_revenue DESC";
        
        PreparedStatement ps = con.prepareStatement(query);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            Map<String, Object> category = new HashMap<>();
            category.put("name", rs.getString("category"));
            category.put("orderCount", rs.getInt("order_count"));
            category.put("totalSold", rs.getInt("total_sold"));
            category.put("totalRevenue", rs.getDouble("total_revenue"));
            categories.add(category);
        }
        
        return categories;
    }
    
    private List<Map<String, Object>> getOrderStatusDistribution(Connection con) throws Exception {
        List<Map<String, Object>> statuses = new ArrayList<>();
        
        String query = "SELECT status, COUNT(*) as count, SUM(total_amount) as total " +
                      "FROM orders GROUP BY status";
        
        PreparedStatement ps = con.prepareStatement(query);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            Map<String, Object> status = new HashMap<>();
            status.put("status", rs.getString("status"));
            status.put("count", rs.getInt("count"));
            status.put("total", rs.getDouble("total"));
            statuses.add(status);
        }
        
        return statuses;
    }
    
    private Map<String, Object> getSummaryStats(Connection con) throws Exception {
        Map<String, Object> stats = new HashMap<>();
        
        // Total revenue
        String revenueQuery = "SELECT SUM(total_amount) as total FROM orders WHERE status != 'Cancelled'";
        PreparedStatement ps = con.prepareStatement(revenueQuery);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            stats.put("totalRevenue", rs.getDouble("total"));
        }
        
        // Total orders
        String ordersQuery = "SELECT COUNT(*) as count FROM orders";
        ps = con.prepareStatement(ordersQuery);
        rs = ps.executeQuery();
        if (rs.next()) {
            stats.put("totalOrders", rs.getInt("count"));
        }
        
        // Average order value
        String avgQuery = "SELECT AVG(total_amount) as avg FROM orders WHERE status != 'Cancelled'";
        ps = con.prepareStatement(avgQuery);
        rs = ps.executeQuery();
        if (rs.next()) {
            stats.put("averageOrderValue", rs.getDouble("avg"));
        }
        
        // Today's revenue
        String todayQuery = "SELECT SUM(total_amount) as total FROM orders WHERE DATE(order_date) = CURDATE() AND status != 'Cancelled'";
        ps = con.prepareStatement(todayQuery);
        rs = ps.executeQuery();
        if (rs.next()) {
            stats.put("todayRevenue", rs.getDouble("total"));
        }
        
        // This month's revenue
        String monthQuery = "SELECT SUM(total_amount) as total FROM orders WHERE MONTH(order_date) = MONTH(CURDATE()) AND YEAR(order_date) = YEAR(CURDATE()) AND status != 'Cancelled'";
        ps = con.prepareStatement(monthQuery);
        rs = ps.executeQuery();
        if (rs.next()) {
            stats.put("monthRevenue", rs.getDouble("total"));
        }
        
        return stats;
    }
}
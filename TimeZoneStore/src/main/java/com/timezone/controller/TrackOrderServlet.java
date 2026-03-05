package com.timezone.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.timezone.model.Order;
import com.timezone.model.TrackingHistory;
import com.timezone.model.Watch;
import com.timezone.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/track-order")
public class TrackOrderServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("login.html");
            return;
        }
        
        String orderNumber = request.getParameter("orderNumber");
        String email = (String) session.getAttribute("userEmail");
        
        if (orderNumber == null || orderNumber.trim().isEmpty()) {
            request.setAttribute("error", "Please enter an order number");
            request.getRequestDispatcher("track-order.jsp").forward(request, response);
            return;
        }
        
        try {
            Connection con = DBConnection.getConnection();
            
            // Get order details with user verification
            String query = "SELECT o.*, u.email FROM orders o " +
                          "JOIN users u ON o.user_id = u.id " +
                          "WHERE o.order_number = ? AND u.email = ?";
            
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, orderNumber);
            ps.setString(2, email);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setOrderNumber(rs.getString("order_number"));
                order.setOrderDate(rs.getTimestamp("order_date"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setShippingAddress(rs.getString("shipping_address"));
                order.setTrackingNumber(rs.getString("tracking_number"));
                order.setEstimatedDelivery(rs.getDate("estimated_delivery"));
                order.setDeliveredDate(rs.getTimestamp("delivered_date"));
                order.setShippingCarrier(rs.getString("shipping_carrier"));
                order.setTrackingStatus(rs.getString("tracking_status"));
                
                // Get order items
                List<Watch> items = getOrderItems(con, order.getId());
                order.setItems(items);
                
             // Get tracking history
                List<Order.TrackingHistory> history = getTrackingHistory(con, order.getId());
                order.setTrackingHistory(history);
                
                request.setAttribute("order", order);
                
                // Calculate progress percentage for tracking bar
                int progress = getTrackingProgress(order.getTrackingStatus());
                request.setAttribute("progress", progress);
                
            } else {
                request.setAttribute("error", "Order not found or you don't have permission to view it");
            }
            
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while tracking your order");
        }
        
        request.getRequestDispatcher("track-order.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    private List<Watch> getOrderItems(Connection con, int orderId) throws Exception {
        List<Watch> items = new ArrayList<>();
        
        String query = "SELECT w.*, oi.quantity FROM order_items oi " +
                      "JOIN watches w ON oi.watch_id = w.id " +
                      "WHERE oi.order_id = ?";
        
        PreparedStatement ps = con.prepareStatement(query);
        ps.setInt(1, orderId);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            Watch watch = new Watch();
            watch.setId(rs.getInt("id"));
            watch.setName(rs.getString("name"));
            watch.setBrand(rs.getString("brand"));
            watch.setPrice(rs.getDouble("price"));
            watch.setImage(rs.getString("image"));
            watch.setQuantity(rs.getInt("quantity"));
            items.add(watch);
        }
        
        return items;
    }
    
    private List<Order.TrackingHistory> getTrackingHistory(Connection con, int orderId) throws Exception {
        List<Order.TrackingHistory> history = new ArrayList<>();
        
        String query = "SELECT * FROM order_tracking WHERE order_id = ? ORDER BY created_at DESC";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setInt(1, orderId);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            Order.TrackingHistory th = new Order.TrackingHistory();
            th.setStatus(rs.getString("status"));
            th.setLocation(rs.getString("location"));
            th.setDescription(rs.getString("description"));
            th.setCreatedAt(rs.getTimestamp("created_at"));
            history.add(th);
        }
        
        return history;
    
    }
    
    private int getTrackingProgress(String status) {
        if (status == null) return 0;
        
        switch(status) {
            case "Processing": return 20;
            case "Confirmed": return 40;
            case "Shipped": return 60;
            case "Out for Delivery": return 80;
            case "Delivered": return 100;
            default: return 0;
        }
    }
}
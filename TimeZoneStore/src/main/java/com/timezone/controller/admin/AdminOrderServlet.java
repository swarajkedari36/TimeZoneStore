package com.timezone.controller.admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.timezone.model.Order;
import com.timezone.model.Watch;
import com.timezone.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {
    
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
            
            // View single order details
            if ("view".equals(action) && id != null) {
                Order order = getOrderById(con, Integer.parseInt(id));
                request.setAttribute("order", order);
                con.close();
                request.getRequestDispatcher("/admin/order-detail.jsp").forward(request, response);
                return;
            }
            
            // Get filter parameters
            String status = request.getParameter("status");
            String fromDate = request.getParameter("fromDate");
            String toDate = request.getParameter("toDate");
            
            // Get all orders with optional filters
            List<Order> orders = getOrders(con, status, fromDate, toDate);
            
            // Get order statistics
            int totalOrders = getOrderCount(con, null, null, null);
            int pendingOrders = getOrderCount(con, "Processing", null, null);
            int shippedOrders = getOrderCount(con, "Shipped", null, null);
            int deliveredOrders = getOrderCount(con, "Delivered", null, null);
            
            request.setAttribute("orders", orders);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("pendingOrders", pendingOrders);
            request.setAttribute("shippedOrders", shippedOrders);
            request.setAttribute("deliveredOrders", deliveredOrders);
            request.setAttribute("selectedStatus", status);
            request.setAttribute("fromDate", fromDate);
            request.setAttribute("toDate", toDate);
            
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        String orderId = request.getParameter("orderId");
        
        try {
            Connection con = DBConnection.getConnection();
            
            if ("updateStatus".equals(action)) {
                String status = request.getParameter("status");
                String trackingNumber = request.getParameter("trackingNumber");
                String carrier = request.getParameter("carrier");
                String estimatedDelivery = request.getParameter("estimatedDelivery");
                String location = request.getParameter("location");
                String description = request.getParameter("description");
                
                // Update order status and tracking
                updateOrderStatus(con, Integer.parseInt(orderId), status, trackingNumber, carrier, estimatedDelivery);
                
                // Add tracking history entry
                addTrackingHistory(con, Integer.parseInt(orderId), status, location, description);
                
                response.sendRedirect("orders?action=view&id=" + orderId + "&updated=true");
            }
            
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("orders?error=true");
        }
    }
    
    private List<Order> getOrders(Connection con, String status, String fromDate, String toDate) throws Exception {
        List<Order> orders = new ArrayList<>();
        
        StringBuilder query = new StringBuilder(
            "SELECT o.*, u.email, u.name as customer_name FROM orders o " +
            "JOIN users u ON o.user_id = u.id WHERE 1=1"
        );
        
        List<Object> params = new ArrayList<>();
        
        if (status != null && !status.isEmpty() && !"All".equals(status)) {
            query.append(" AND o.status = ?");
            params.add(status);
        }
        
        if (fromDate != null && !fromDate.isEmpty()) {
            query.append(" AND DATE(o.order_date) >= ?");
            params.add(fromDate);
        }
        
        if (toDate != null && !toDate.isEmpty()) {
            query.append(" AND DATE(o.order_date) <= ?");
            params.add(toDate);
        }
        
        query.append(" ORDER BY o.order_date DESC");
        
        PreparedStatement ps = con.prepareStatement(query.toString());
        
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
        
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
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
            
            // Add customer info
            order.setCustomerName(rs.getString("customer_name"));
            order.setCustomerEmail(rs.getString("email"));
            
            orders.add(order);
        }
        
        return orders;
    }
    
    private Order getOrderById(Connection con, int orderId) throws Exception {
        String query = "SELECT o.*, u.email, u.name as customer_name, u.phone as customer_phone " +
                      "FROM orders o JOIN users u ON o.user_id = u.id WHERE o.id = ?";
        
        PreparedStatement ps = con.prepareStatement(query);
        ps.setInt(1, orderId);
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
            
            // Customer info
            order.setCustomerName(rs.getString("customer_name"));
            order.setCustomerEmail(rs.getString("email"));
            order.setCustomerPhone(rs.getString("customer_phone"));
            
            // Get order items
            List<Watch> items = getOrderItems(con, orderId);
            order.setItems(items);
            
            // Get tracking history
            order.setTrackingHistory(getTrackingHistory(con, orderId));
            
            return order;
        }
        
        return null;
    }
    
    private List<Watch> getOrderItems(Connection con, int orderId) throws Exception {
        List<Watch> items = new ArrayList<>();
        
        String query = "SELECT w.*, oi.quantity FROM order_items oi " +
                      "JOIN watches w ON oi.watch_id = w.id WHERE oi.order_id = ?";
        
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
    
    private void updateOrderStatus(Connection con, int orderId, String status, 
                                   String trackingNumber, String carrier, String estimatedDelivery) throws Exception {
        
        StringBuilder query = new StringBuilder("UPDATE orders SET status = ?");
        
        if (trackingNumber != null && !trackingNumber.isEmpty()) {
            query.append(", tracking_number = ?");
        }
        if (carrier != null && !carrier.isEmpty()) {
            query.append(", shipping_carrier = ?");
        }
        if (estimatedDelivery != null && !estimatedDelivery.isEmpty()) {
            query.append(", estimated_delivery = ?");
        }
        if ("Delivered".equals(status)) {
            query.append(", delivered_date = ?");
        }
        
        query.append(" WHERE id = ?");
        
        PreparedStatement ps = con.prepareStatement(query.toString());
        
        int paramIndex = 1;
        ps.setString(paramIndex++, status);
        
        if (trackingNumber != null && !trackingNumber.isEmpty()) {
            ps.setString(paramIndex++, trackingNumber);
        }
        if (carrier != null && !carrier.isEmpty()) {
            ps.setString(paramIndex++, carrier);
        }
        if (estimatedDelivery != null && !estimatedDelivery.isEmpty()) {
            ps.setDate(paramIndex++, java.sql.Date.valueOf(estimatedDelivery));
        }
        if ("Delivered".equals(status)) {
            ps.setTimestamp(paramIndex++, new Timestamp(System.currentTimeMillis()));
        }
        
        ps.setInt(paramIndex++, orderId);
        ps.executeUpdate();
    }
    
    private void addTrackingHistory(Connection con, int orderId, String status, 
                                    String location, String description) throws Exception {
        
        String query = "INSERT INTO order_tracking (order_id, status, location, description) VALUES (?, ?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setInt(1, orderId);
        ps.setString(2, status);
        ps.setString(3, location);
        ps.setString(4, description);
        ps.executeUpdate();
    }
    
    private int getOrderCount(Connection con, String status, String fromDate, String toDate) throws Exception {
        StringBuilder query = new StringBuilder("SELECT COUNT(*) as count FROM orders WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (status != null) {
            query.append(" AND status = ?");
            params.add(status);
        }
        
        if (fromDate != null) {
            query.append(" AND DATE(order_date) >= ?");
            params.add(fromDate);
        }
        
        if (toDate != null) {
            query.append(" AND DATE(order_date) <= ?");
            params.add(toDate);
        }
        
        PreparedStatement ps = con.prepareStatement(query.toString());
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
        
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            return rs.getInt("count");
        }
        
        return 0;
    }
// // Add this method to get tracking history
//    private List<Order.TrackingHistory> getTrackingHistory(Connection con, int orderId) throws Exception {
//        List<Order.TrackingHistory> history = new ArrayList<>();
//        
//        String query = "SELECT * FROM order_tracking WHERE order_id = ? ORDER BY created_at DESC";
//        PreparedStatement ps = con.prepareStatement(query);
//        ps.setInt(1, orderId);
//        ResultSet rs = ps.executeQuery();
//        
//        while (rs.next()) {
//            Order.TrackingHistory th = new Order.TrackingHistory();
//            th.setStatus(rs.getString("status"));
//            th.setLocation(rs.getString("location"));
//            th.setDescription(rs.getString("description"));
//            th.setCreatedAt(rs.getTimestamp("created_at"));
//            history.add(th);
//        }
//        
//        return history;
//    }
}
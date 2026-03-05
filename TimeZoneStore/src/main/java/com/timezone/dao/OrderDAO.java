package com.timezone.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.timezone.model.Order;
import com.timezone.model.Watch;
import com.timezone.util.DBConnection;

public class OrderDAO {
    
    // Get orders by user email
    public List<Order> getOrdersByUser(String email) {
        List<Order> orders = new ArrayList<>();
        
        try {
            Connection con = DBConnection.getConnection();
            
            String query = "SELECT o.* FROM orders o " +
                          "JOIN users u ON o.user_id = u.id " +
                          "WHERE u.email = ? " +
                          "ORDER BY o.order_date DESC";
            
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, email);
            
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
                
                // Get items for this order
                order.setItems(getOrderItems(order.getId()));
                
                orders.add(order);
            }
            
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return orders;
    }
    
    // Get items for a specific order
    private List<Watch> getOrderItems(int orderId) {
        List<Watch> items = new ArrayList<>();
        
        try {
            Connection con = DBConnection.getConnection();
            
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
            
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return items;
    }
}
package com.timezone.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
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

@WebServlet("/orders")
public class OrderServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("========== ORDER SERVLET CALLED ==========");
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("userEmail") == null) {
            System.out.println("User not logged in, redirecting to login");
            response.sendRedirect("login.html");
            return;
        }
        
        String email = (String) session.getAttribute("userEmail");
        System.out.println("User email: " + email);
        
        List<Order> orders = new ArrayList<>();
        
        try {
            Connection con = DBConnection.getConnection();
            
            // Get user_id from email
            String userQuery = "SELECT id FROM users WHERE email = ?";
            PreparedStatement userPs = con.prepareStatement(userQuery);
            userPs.setString(1, email);
            ResultSet userRs = userPs.executeQuery();
            
            int userId = 0;
            if (userRs.next()) {
                userId = userRs.getInt("id");
                System.out.println("User ID found: " + userId);
            } else {
                System.out.println("User not found in database!");
            }
            userRs.close();
            userPs.close();
            
            if (userId > 0) {
                // Get all orders for this user
                String orderQuery = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";
                PreparedStatement orderPs = con.prepareStatement(orderQuery);
                orderPs.setInt(1, userId);
                ResultSet orderRs = orderPs.executeQuery();
                
                while (orderRs.next()) {
                    Order order = new Order();
                    order.setId(orderRs.getInt("id"));
                    order.setOrderNumber(orderRs.getString("order_number"));
                    order.setOrderDate(orderRs.getTimestamp("order_date"));
                    order.setTotalAmount(orderRs.getDouble("total_amount"));
                    order.setStatus(orderRs.getString("status"));
                    order.setPaymentMethod(orderRs.getString("payment_method"));
                    order.setShippingAddress(orderRs.getString("shipping_address"));
                    
                    System.out.println("Found order: " + order.getOrderNumber());
                    
                    // Get items for this order
                    List<Watch> items = new ArrayList<>();
                    String itemsQuery = "SELECT w.*, oi.quantity FROM order_items oi " +
                                       "JOIN watches w ON oi.watch_id = w.id " +
                                       "WHERE oi.order_id = ?";
                    PreparedStatement itemsPs = con.prepareStatement(itemsQuery);
                    itemsPs.setInt(1, order.getId());
                    ResultSet itemsRs = itemsPs.executeQuery();
                    
                    while (itemsRs.next()) {
                        Watch watch = new Watch();
                        watch.setId(itemsRs.getInt("id"));
                        watch.setName(itemsRs.getString("name"));
                        watch.setBrand(itemsRs.getString("brand"));
                        watch.setPrice(itemsRs.getDouble("price"));
                        watch.setImage(itemsRs.getString("image"));
                        watch.setDescription(itemsRs.getString("description"));
                        watch.setCategory(itemsRs.getString("category"));
                        watch.setQuantity(itemsRs.getInt("quantity"));
                        
                        items.add(watch);
                        System.out.println("  - Item: " + watch.getName() + " x" + watch.getQuantity());
                    }
                    
                    order.setItems(items);
                    orders.add(order);
                    
                    itemsRs.close();
                    itemsPs.close();
                }
                
                orderRs.close();
                orderPs.close();
            }
            
            con.close();
            
        } catch (Exception e) {
            System.out.println("ERROR in OrderServlet:");
            e.printStackTrace();
        }
        
        System.out.println("Total orders found: " + orders.size());
        
        // IMPORTANT: Set the attribute and forward
        request.setAttribute("orders", orders);
        System.out.println("Orders attribute set with " + orders.size() + " orders");
        
        request.getRequestDispatcher("orders.jsp").forward(request, response);
        System.out.println("Forwarded to orders.jsp");
    }
}
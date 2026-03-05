package com.timezone.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import java.util.UUID;

import com.timezone.model.Watch;
import com.timezone.util.DBConnection;
import com.timezone.util.EmailUtility;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("login.html");
            return;
        }
        
        String userEmail = (String) session.getAttribute("userEmail"); // Renamed to userEmail
        List<Watch> cart = (List<Watch>) session.getAttribute("cart");
        
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart.jsp");
            return;
        }
        
        Connection con = null;
        
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false); // Start transaction
            
            // Get user_id
            int userId = 0;
            String userQuery = "SELECT id, name FROM users WHERE email = ?"; // Also get name
            PreparedStatement userPs = con.prepareStatement(userQuery);
            userPs.setString(1, userEmail);
            ResultSet userRs = userPs.executeQuery();
            
            String userName = null;
            if (userRs.next()) {
                userId = userRs.getInt("id");
                userName = userRs.getString("name"); // Get user name
            }
            userRs.close();
            userPs.close();
            
            if (userId == 0) {
                throw new Exception("User not found");
            }
            
            // Calculate total
            double total = 0;
            for (Watch w : cart) {
                total += w.getPrice() * w.getQuantity();
            }
            
            // Generate order number
            String orderNumber = "TZ-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            
            // Insert into orders table
            String orderQuery = "INSERT INTO orders (order_number, user_id, total_amount, status, payment_method, shipping_address) " +
                               "VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement orderPs = con.prepareStatement(orderQuery, PreparedStatement.RETURN_GENERATED_KEYS);
            orderPs.setString(1, orderNumber);
            orderPs.setInt(2, userId);
            orderPs.setDouble(3, total);
            orderPs.setString(4, "Processing");
            orderPs.setString(5, request.getParameter("paymentMethod") != null ? request.getParameter("paymentMethod") : "Credit Card");
            orderPs.setString(6, request.getParameter("address") != null ? request.getParameter("address") : "Standard Shipping");
            
            orderPs.executeUpdate();
            
            // Get generated order ID
            ResultSet generatedKeys = orderPs.getGeneratedKeys();
            int orderId = 0;
            if (generatedKeys.next()) {
                orderId = generatedKeys.getInt(1);
            }
            generatedKeys.close();
            orderPs.close();
            
            // Insert into order_items table
            String itemsQuery = "INSERT INTO order_items (order_id, watch_id, quantity, price) VALUES (?, ?, ?, ?)";
            PreparedStatement itemsPs = con.prepareStatement(itemsQuery);
            
            for (Watch w : cart) {
                itemsPs.setInt(1, orderId);
                itemsPs.setInt(2, w.getId());
                itemsPs.setInt(3, w.getQuantity());
                itemsPs.setDouble(4, w.getPrice());
                itemsPs.addBatch();
            }
            
            itemsPs.executeBatch();
            itemsPs.close();
            
            // After order is saved to database - Send email
            try {
                // Send order confirmation email
                String subject = "Order Confirmed - TimeZone Watches";
                String estimatedDelivery = "3-5 business days"; // Calculate based on your logic
                String htmlContent = EmailUtility.getOrderConfirmationEmailTemplate(
                    userName != null ? userName : "Customer", 
                    orderNumber, 
                    total, 
                    estimatedDelivery
                );
                
                EmailUtility.sendEmail(userEmail, subject, htmlContent); // Use userEmail here
                System.out.println("Order confirmation email sent to: " + userEmail);
                
            } catch (Exception e) {
                System.out.println("Failed to send order confirmation: " + e.getMessage());
                e.printStackTrace();
                // Don't rollback transaction for email failure
            }
            
            // Clear cart from database (if you have cart table)
            String clearCartQuery = "DELETE FROM cart WHERE user_id = ?";
            PreparedStatement clearPs = con.prepareStatement(clearCartQuery);
            clearPs.setInt(1, userId);
            clearPs.executeUpdate();
            clearPs.close();
            
            con.commit(); // Commit transaction
            
            // Clear session cart
            session.removeAttribute("cart");
            session.setAttribute("lastOrderNumber", orderNumber);
            
            response.sendRedirect("orderSuccess.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (con != null) {
                    con.rollback(); // Rollback on error
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            response.sendRedirect("checkout.jsp?error=true");
        } finally {
            try {
                if (con != null) {
                    con.setAutoCommit(true);
                    con.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
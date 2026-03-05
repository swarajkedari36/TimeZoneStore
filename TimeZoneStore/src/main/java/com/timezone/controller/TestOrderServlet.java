package com.timezone.controller;

import java.io.IOException;
import java.io.PrintWriter;
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

@WebServlet("/test-orders-simple")
public class TestOrderServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession(false);
        
        out.println("<html><body>");
        out.println("<h1>Order Debug Test</h1>");
        
        if (session == null || session.getAttribute("userEmail") == null) {
            out.println("<p style='color:red'>❌ No user logged in!</p>");
            out.println("</body></html>");
            return;
        }
        
        String email = (String) session.getAttribute("userEmail");
        out.println("<p>✅ Logged in as: " + email + "</p>");
        
        try {
            Connection con = DBConnection.getConnection();
            out.println("<p>✅ Database connected</p>");
            
            // Get user_id
            String userQuery = "SELECT id FROM users WHERE email = ?";
            PreparedStatement userPs = con.prepareStatement(userQuery);
            userPs.setString(1, email);
            ResultSet userRs = userPs.executeQuery();
            
            int userId = 0;
            if (userRs.next()) {
                userId = userRs.getInt("id");
                out.println("<p>✅ User ID: " + userId + "</p>");
            } else {
                out.println("<p style='color:red'>❌ User not found in database!</p>");
            }
            
            if (userId > 0) {
                // Check orders
                String orderQuery = "SELECT * FROM orders WHERE user_id = ?";
                PreparedStatement orderPs = con.prepareStatement(orderQuery);
                orderPs.setInt(1, userId);
                ResultSet orderRs = orderPs.executeQuery();
                
                int orderCount = 0;
                while (orderRs.next()) {
                    orderCount++;
                    out.println("<h3>Order " + orderCount + ": " + orderRs.getString("order_number") + "</h3>");
                    out.println("<ul>");
                    out.println("<li>Status: " + orderRs.getString("status") + "</li>");
                    out.println("<li>Total: ₹" + orderRs.getDouble("total_amount") + "</li>");
                    
                    // Get items
                    String itemQuery = "SELECT w.*, oi.quantity FROM order_items oi " +
                                      "JOIN watches w ON oi.watch_id = w.id " +
                                      "WHERE oi.order_id = ?";
                    PreparedStatement itemPs = con.prepareStatement(itemQuery);
                    itemPs.setInt(1, orderRs.getInt("id"));
                    ResultSet itemRs = itemPs.executeQuery();
                    
                    int itemCount = 0;
                    while (itemRs.next()) {
                        itemCount++;
                        out.println("<li>Item: " + itemRs.getString("name") + 
                                   " x" + itemRs.getInt("quantity") + 
                                   " = ₹" + (itemRs.getDouble("price") * itemRs.getInt("quantity")) + "</li>");
                    }
                    
                    if (itemCount == 0) {
                        out.println("<li style='color:red'>❌ No items in this order!</li>");
                    }
                    
                    out.println("</ul>");
                }
                
                if (orderCount == 0) {
                    out.println("<p style='color:red'>❌ No orders found for user ID: " + userId + "</p>");
                } else {
                    out.println("<p>✅ Found " + orderCount + " order(s)</p>");
                }
            }
            
            con.close();
            
        } catch (Exception e) {
            out.println("<p style='color:red'>❌ Error: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        }
        
        out.println("</body></html>");
    }
}
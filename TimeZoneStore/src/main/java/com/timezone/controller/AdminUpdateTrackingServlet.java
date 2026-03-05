package com.timezone.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.timezone.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/update-tracking")
public class AdminUpdateTrackingServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String status = request.getParameter("status");
        String trackingNumber = request.getParameter("trackingNumber");
        String carrier = request.getParameter("carrier");
        String estimatedDelivery = request.getParameter("estimatedDelivery");
        String location = request.getParameter("location");
        String description = request.getParameter("description");
        
        try {
            Connection con = DBConnection.getConnection();
            
            // Update order
            String updateOrder = "UPDATE orders SET tracking_status = ?, tracking_number = ?, " +
                               "shipping_carrier = ?, estimated_delivery = ? WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(updateOrder);
            ps.setString(1, status);
            ps.setString(2, trackingNumber);
            ps.setString(3, carrier);
            
            if (estimatedDelivery != null && !estimatedDelivery.isEmpty()) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date date = sdf.parse(estimatedDelivery);
                ps.setDate(4, new java.sql.Date(date.getTime()));
            } else {
                ps.setNull(4, java.sql.Types.DATE);
            }
            
            ps.setInt(5, orderId);
            ps.executeUpdate();
            
            // Add tracking history
            String insertHistory = "INSERT INTO order_tracking (order_id, status, location, description) VALUES (?, ?, ?, ?)";
            PreparedStatement historyPs = con.prepareStatement(insertHistory);
            historyPs.setInt(1, orderId);
            historyPs.setString(2, status);
            historyPs.setString(3, location);
            historyPs.setString(4, description);
            historyPs.executeUpdate();
            
            con.close();
            
            response.sendRedirect("../track-order?orderNumber=" + request.getParameter("orderNumber") + "&updated=true");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("../track-order?error=true");
        }
    }
}
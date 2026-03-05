package com.timezone.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.timezone.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("login.html");
            return;
        }
        
        String email = (String) session.getAttribute("userEmail");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Check if new passwords match
        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect("profile?tab=password&error=nomatch");
            return;
        }
        
        // Check password strength (at least 8 chars)
        if (newPassword.length() < 8) {
            response.sendRedirect("profile?tab=password&error=weak");
            return;
        }
        
        try {
            Connection con = DBConnection.getConnection();
            
            // Verify current password
            String checkQuery = "SELECT * FROM users WHERE email = ? AND password = ?";
            PreparedStatement checkPs = con.prepareStatement(checkQuery);
            checkPs.setString(1, email);
            checkPs.setString(2, currentPassword); // In production, use hashing!
            
            ResultSet rs = checkPs.executeQuery();
            
            if (rs.next()) {
                // Update password
                String updateQuery = "UPDATE users SET password = ? WHERE email = ?";
                PreparedStatement updatePs = con.prepareStatement(updateQuery);
                updatePs.setString(1, newPassword);
                updatePs.setString(2, email);
                
                int result = updatePs.executeUpdate();
                
                if (result > 0) {
                    response.sendRedirect("profile?tab=password&success=updated");
                } else {
                    response.sendRedirect("profile?tab=password&error=true");
                }
                
            } else {
                response.sendRedirect("profile?tab=password&error=wrong");
            }
            
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("profile?tab=password&error=true");
        }
    }
}
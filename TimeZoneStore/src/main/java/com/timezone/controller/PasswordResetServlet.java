package com.timezone.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.UUID;

import com.timezone.util.DBConnection;
import com.timezone.util.EmailUtility;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/reset-password")
public class PasswordResetServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String token = request.getParameter("token");
        
        if (token != null && !token.isEmpty()) {
            // Verify token is valid
            try {
                Connection con = DBConnection.getConnection();
                String query = "SELECT * FROM password_resets WHERE token = ? AND expiry > NOW() AND used = 0";
                PreparedStatement ps = con.prepareStatement(query);
                ps.setString(1, token);
                ResultSet rs = ps.executeQuery();
                
                if (rs.next()) {
                    // Token is valid - show reset form
                    request.setAttribute("token", token);
                    request.getRequestDispatcher("reset-password-form.jsp").forward(request, response);
                } else {
                    // Token invalid or expired
                    response.sendRedirect("forgot-password.jsp?error=invalid");
                }
                
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("forgot-password.jsp?error=true");
            }
        } else {
            // No token - show request form
            response.sendRedirect("forgot-password.jsp");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("request".equals(action)) {
            // Handle password reset request
            String email = request.getParameter("email");
            
            try {
                Connection con = DBConnection.getConnection();
                
                // Check if email exists
                String checkQuery = "SELECT id, name FROM users WHERE email = ?";
                PreparedStatement checkPs = con.prepareStatement(checkQuery);
                checkPs.setString(1, email);
                ResultSet rs = checkPs.executeQuery();
                
                if (rs.next()) {
                    // Generate reset token
                    String token = UUID.randomUUID().toString();
                    int userId = rs.getInt("id");
                    String userName = rs.getString("name");
                    
                    // First, invalidate any existing unused tokens for this user
                    String invalidateQuery = "UPDATE password_resets SET used = 1 WHERE user_id = ? AND used = 0";
                    PreparedStatement invalidatePs = con.prepareStatement(invalidateQuery);
                    invalidatePs.setInt(1, userId);
                    invalidatePs.executeUpdate();
                    
                    // Save new token to database
                    String insertToken = "INSERT INTO password_resets (user_id, token, expiry) VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 1 HOUR))";
                    PreparedStatement tokenPs = con.prepareStatement(insertToken);
                    tokenPs.setInt(1, userId);
                    tokenPs.setString(2, token);
                    tokenPs.executeUpdate();
                    
                    // Generate reset link - FIXED VERSION
                    String scheme = request.getScheme(); // http
                    String serverName = request.getServerName(); // localhost
                    int serverPort = request.getServerPort(); // 8080 or whatever
                    String contextPath = request.getContextPath(); // /TimeZoneStore
                    
                    // Build the URL properly
                    String resetLink = scheme + "://" + serverName;
                    if (serverPort != 80 && serverPort != 443) {
                        resetLink += ":" + serverPort;
                    }
                    resetLink += contextPath + "/reset-password?token=" + token;
                    
                    // Debug output
                    System.out.println("=== PASSWORD RESET LINK ===");
                    System.out.println("Full Reset Link: " + resetLink);
                    System.out.println("Copy this link to test: " + resetLink);
                    
                    // Send reset email
                    String subject = "Password Reset Request - TimeZone Watches";
                    String htmlContent = EmailUtility.getPasswordResetEmailTemplate(userName, resetLink);
                    
                    boolean emailSent = EmailUtility.sendEmail(email, subject, htmlContent);
                    
                    if (emailSent) {
                        response.sendRedirect("forgot-password.jsp?sent=true");
                    } else {
                        response.sendRedirect("forgot-password.jsp?error=true");
                    }
                } else {
                    response.sendRedirect("forgot-password.jsp?error=notfound");
                }
                
                con.close();
                
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("forgot-password.jsp?error=true");
            }
            
        } else if ("reset".equals(action)) {
            // Handle password reset
            String token = request.getParameter("token");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            
            if (!newPassword.equals(confirmPassword)) {
                response.sendRedirect("reset-password-form.jsp?token=" + token + "&error=mismatch");
                return;
            }
            
            try {
                Connection con = DBConnection.getConnection();
                
                // Verify token
                String verifyQuery = "SELECT user_id FROM password_resets WHERE token = ? AND expiry > NOW() AND used = 0";
                PreparedStatement verifyPs = con.prepareStatement(verifyQuery);
                verifyPs.setString(1, token);
                ResultSet rs = verifyPs.executeQuery();
                
                if (rs.next()) {
                    int userId = rs.getInt("user_id");
                    
                    // Update password (in production, hash this!)
                    String updateQuery = "UPDATE users SET password = ? WHERE id = ?";
                    PreparedStatement updatePs = con.prepareStatement(updateQuery);
                    updatePs.setString(1, newPassword);
                    updatePs.setInt(2, userId);
                    updatePs.executeUpdate();
                    
                    // Mark token as used
                    String markUsed = "UPDATE password_resets SET used = 1 WHERE token = ?";
                    PreparedStatement markPs = con.prepareStatement(markUsed);
                    markPs.setString(1, token);
                    markPs.executeUpdate();
                    
                    response.sendRedirect("login.html?reset=success");
                } else {
                    response.sendRedirect("forgot-password.jsp?error=invalid");
                }
                
                con.close();
                
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("forgot-password.jsp?error=true");
            }
        }
    }
}
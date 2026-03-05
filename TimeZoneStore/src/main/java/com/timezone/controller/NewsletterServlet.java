package com.timezone.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

import com.timezone.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/newsletter")
public class NewsletterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        HttpSession session = request.getSession();
        
        if (email == null || email.trim().isEmpty()) {
            session.setAttribute("newsletterStatus", "error");
            response.sendRedirect(request.getHeader("Referer"));
            return;
        }
        
        Connection con = null;
        
        try {
            con = DBConnection.getConnection();
            
            // Check if email already exists
            String checkQuery = "SELECT * FROM newsletter_subscribers WHERE email = ?";
            PreparedStatement checkPs = con.prepareStatement(checkQuery);
            checkPs.setString(1, email);
            ResultSet rs = checkPs.executeQuery();
            
            if (rs.next()) {
                // Email already subscribed
                session.setAttribute("newsletterStatus", "exists");
            } else {
                // Insert new subscriber
                String insertQuery = "INSERT INTO newsletter_subscribers (email, subscribed_at, status) VALUES (?, ?, ?)";
                PreparedStatement insertPs = con.prepareStatement(insertQuery);
                insertPs.setString(1, email);
                insertPs.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
                insertPs.setString(3, "active");
                
                int result = insertPs.executeUpdate();
                
                if (result > 0) {
                    session.setAttribute("newsletterStatus", "success");
                    
                    // Optional: Send welcome email to subscriber
                    // You can implement this later
                } else {
                    session.setAttribute("newsletterStatus", "error");
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("newsletterStatus", "error");
        } finally {
            try {
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        // Redirect back to the page they came from
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/");
        }
    }
}
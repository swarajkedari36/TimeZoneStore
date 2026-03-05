package com.timezone.controller.admin;

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

@WebServlet("/admin/login")
public class AdminLoginServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // If already logged in as admin, redirect to dashboard
        if (session != null && session.getAttribute("adminId") != null) {
            response.sendRedirect("dashboard");
            return;
        }
        
        request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            response.sendRedirect("login?error=missing");
            return;
        }
        
        try {
            Connection con = DBConnection.getConnection();
            
            String query = "SELECT * FROM admins WHERE username = ? AND password = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, password); // In production, use password hashing!
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                // Update last login
                String updateQuery = "UPDATE admins SET last_login = ? WHERE id = ?";
                PreparedStatement updatePs = con.prepareStatement(updateQuery);
                updatePs.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
                updatePs.setInt(2, rs.getInt("id"));
                updatePs.executeUpdate();
                
             // Create admin session
                HttpSession session = request.getSession();
                session.setAttribute("adminId", rs.getInt("id"));
                session.setAttribute("adminUsername", rs.getString("username"));
                session.setAttribute("adminName", rs.getString("full_name"));
                session.setAttribute("adminRole", rs.getString("role"));
                session.setAttribute("isAdmin", true); // 👈 ADD THIS LINE
                
                response.sendRedirect("dashboard");
            } else {
                response.sendRedirect("login?error=invalid");
            }
            
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login?error=true");
        }
    }
}
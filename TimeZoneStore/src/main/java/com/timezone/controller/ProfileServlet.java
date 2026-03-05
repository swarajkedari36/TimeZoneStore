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

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("login.html");
            return;
        }
        
        String email = (String) session.getAttribute("userEmail");
        
        try {
            Connection con = DBConnection.getConnection();
            
            String query = "SELECT id, name, email, phone, created_at FROM users WHERE email = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, email);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                request.setAttribute("userId", rs.getInt("id"));
                request.setAttribute("name", rs.getString("name"));
                request.setAttribute("email", rs.getString("email"));
                request.setAttribute("phone", rs.getString("phone"));
                request.setAttribute("createdAt", rs.getTimestamp("created_at"));
            }
            
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("login.html");
            return;
        }
        
        String email = (String) session.getAttribute("userEmail");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        
        try {
            Connection con = DBConnection.getConnection();
            
            String query = "UPDATE users SET name = ?, phone = ? WHERE email = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setString(3, email);
            
            int result = ps.executeUpdate();
            
            con.close();
            
            if (result > 0) {
                response.sendRedirect("profile?success=updated");
            } else {
                response.sendRedirect("profile?error=true");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("profile?error=true");
        }
    }
}
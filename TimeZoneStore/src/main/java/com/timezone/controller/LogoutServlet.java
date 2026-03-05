package com.timezone.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get session if exists
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Invalidate session (remove all attributes)
            session.invalidate();
            System.out.println("User logged out, session invalidated");
        }
        
        // Redirect to login page
        response.sendRedirect("login.html");
    }
    
    // Handle POST requests as well
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
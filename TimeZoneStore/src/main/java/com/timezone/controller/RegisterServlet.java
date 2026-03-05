package com.timezone.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.timezone.dao.UserDAO;
import com.timezone.model.User;
import com.timezone.util.EmailUtility;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        System.out.println("=== Registration Attempt ===");
        System.out.println("Name: " + name);
        System.out.println("Email: " + email);
        System.out.println("Password: " + password); // Debug only - remove in production

        User user = new User(name, email, password);

        UserDAO dao = new UserDAO();
        boolean status = dao.registerUser(user);

        if (status) {
            System.out.println("✅ User registered successfully in database");
            
            // Send welcome email
            try {
                String subject = "Welcome to TimeZone Watches!";
                String htmlContent = EmailUtility.getWelcomeEmailTemplate(name);
                
                boolean emailSent = EmailUtility.sendEmail(email, subject, htmlContent);
                if (emailSent) {
                    System.out.println("✅ Welcome email sent to: " + email);
                } else {
                    System.out.println("❌ Failed to send welcome email");
                }
            } catch (Exception e) {
                System.out.println("❌ Email error: " + e.getMessage());
                e.printStackTrace();
            }
            
            response.sendRedirect("login.html?registered=true");
        } else {
            System.out.println("❌ User registration FAILED in database");
            response.sendRedirect("register.html?error=true");
        }
    }
}
package com.timezone.controller.admin;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/logout")
public class AdminLogoutServlet extends HttpServlet {
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
	    
	    HttpSession session = request.getSession(false);
	    
	    if (session != null) {
	        session.removeAttribute("adminId");
	        session.removeAttribute("adminUsername");
	        session.removeAttribute("adminName");
	        session.removeAttribute("adminRole");
	        session.removeAttribute("isAdmin"); // 👈 ADD THIS LINE
	        session.invalidate();
	    }
	    
	    response.sendRedirect("login");
	}
}
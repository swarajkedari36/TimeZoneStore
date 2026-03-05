/*
 * package com.timezone.controller;
 * 
 * import java.io.IOException; import java.sql.PreparedStatement; import
 * java.sql.ResultSet; import java.util.List;
 * 
 * import jakarta.servlet.ServletException; import
 * jakarta.servlet.annotation.WebServlet; import jakarta.servlet.http.*;
 * 
 * import com.sun.jdi.connect.spi.Connection; import com.timezone.dao.WatchDAO;
 * import com.timezone.model.Watch; import com.timezone.util.DBConnection;
 * 
 * @WebServlet("/products") public class ProductServlet extends HttpServlet {
 * 
 * protected void doGet(HttpServletRequest request, HttpServletResponse
 * response) throws ServletException, IOException {
 * 
 * HttpSession session = request.getSession(false);
 * 
 * // If user not logged in → redirect to login if (session == null ||
 * session.getAttribute("userEmail") == null) {
 * response.sendRedirect("login.html"); return; }
 * 
 * WatchDAO dao = new WatchDAO(); List<Watch> watches = dao.getAllWatches();
 * 
 * request.setAttribute("watchList", watches); int cartCount = 0;
 * 
 * try { Connection con = (Connection) DBConnection.getConnection();
 * 
 * String countQuery =
 * "SELECT COUNT(*) FROM cart c JOIN users u ON c.user_id=u.id WHERE u.email=?";
 * PreparedStatement ps = ((java.sql.Connection)
 * con).prepareStatement(countQuery); ps.setString(1, (String)
 * session.getAttribute("userEmail"));
 * 
 * ResultSet rs = ps.executeQuery(); if(rs.next()){ cartCount = rs.getInt(1); }
 * 
 * con.close(); } catch(Exception e){ e.printStackTrace(); }
 * 
 * request.setAttribute("cartCount", cartCount);
 * 
 * 
 * 
 * request.getRequestDispatcher("products.jsp").forward(request, response); } }
 */

package com.timezone.controller;

import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import com.timezone.dao.WatchDAO;
import com.timezone.model.Watch;
import com.timezone.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // If user not logged in → redirect to login
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("login.html");
            return;
        }

        WatchDAO dao = new WatchDAO();
        List<Watch> watches = dao.getAllWatches();

        request.setAttribute("watchList", watches);
        
        // Get unique categories for filter display (optional)
        java.util.Set<String> categories = new java.util.HashSet<>();
        for (Watch w : watches) {
            if (w.getCategory() != null && !w.getCategory().isEmpty()) {
                categories.add(w.getCategory());
            }
        }
        request.setAttribute("categories", categories);

        int cartCount = 0;
        try {
            java.sql.Connection con = DBConnection.getConnection();
            String countQuery = "SELECT COUNT(*) FROM cart c JOIN users u ON c.user_id=u.id WHERE u.email=?";
            PreparedStatement ps = con.prepareStatement(countQuery);
            ps.setString(1, (String) session.getAttribute("userEmail"));
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                cartCount = rs.getInt(1);
            }
            con.close();
        } catch(Exception e){
            e.printStackTrace();
        }

        request.setAttribute("cartCount", cartCount);
        request.getRequestDispatcher("products.jsp").forward(request, response);
    }
}
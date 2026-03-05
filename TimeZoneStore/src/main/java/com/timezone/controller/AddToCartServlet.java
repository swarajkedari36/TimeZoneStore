//package com.timezone.controller;
//
//import java.io.IOException;
//import java.util.ArrayList;
//import java.util.List;
//
//import com.timezone.dao.WatchDAO;
//import com.timezone.model.Watch;
//
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//
//@WebServlet("/addToCart")
//public class AddToCartServlet extends HttpServlet {
//
////    protected void doGet(HttpServletRequest request, HttpServletResponse response)
////            throws ServletException, IOException {
////
////        HttpSession session = request.getSession(false);
////
////        if (session == null || session.getAttribute("userEmail") == null) {
////            response.sendRedirect("login.html");
////            return;
////        }
////
////        String email = (String) session.getAttribute("userEmail");
////        int watchId = Integer.parseInt(request.getParameter("id"));
////
////        try {
////            Connection con = DBConnection.getConnection();
////
////            // Get user id from email
////            String getUser = "SELECT id FROM users WHERE email=?";
////            PreparedStatement ps1 = con.prepareStatement(getUser);
////            ps1.setString(1, email);
////
////            var rs = ps1.executeQuery();
////            int userId = 0;
////
////            if (rs.next()) {
////                userId = rs.getInt("id");
////            }
////
////            // Insert into cart
////            String insertCart = "INSERT INTO cart(user_id, watch_id) VALUES(?,?)";
////            PreparedStatement ps2 = con.prepareStatement(insertCart);
////            ps2.setInt(1, userId);
////            ps2.setInt(2, watchId);
////
////            ps2.executeUpdate();
////
////            con.close();
////
////        } catch (Exception e) {
////            e.printStackTrace();
////        }
////
////        response.sendRedirect("products?added=true");
////    }
////	protected void doPost(HttpServletRequest request, HttpServletResponse response)
////			throws ServletException, IOException {
////
////		int productId = Integer.parseInt(request.getParameter("id"));
////
////		WatchDAO dao = new WatchDAO();
////		Watch product = dao.getWatchById(productId);
////
////		HttpSession session = request.getSession();
////
////		List<Watch> cart = (List<Watch>) session.getAttribute("cart");
////
////		if (cart == null) {
////			cart = new ArrayList<>();
////		}
////
////		boolean exists = false;
////
////		for (Watch w : cart) {
////			if (w.getId() == productId) {
////				w.setQuantity(w.getQuantity() + 1);
////				exists = true;
////				break;
////			}
////		}
////
////		if (!exists) {
////			product.setQuantity(1);
////			cart.add(product);
////		}
////
////		session.setAttribute("cart", cart);
////
////		response.sendRedirect("products?added=true");
////	}
////}
//	
//	
//	protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        
//        System.out.println("AddToCartServlet: doPost called"); // Debug log
//        
//        try {
//            int productId = Integer.parseInt(request.getParameter("id"));
//            System.out.println("Product ID: " + productId); // Debug log
//
//            WatchDAO dao = new WatchDAO();
//            Watch product = dao.getWatchById(productId);
//
//            if (product == null) {
//                System.out.println("Product not found!"); // Debug log
//                response.sendRedirect("products?error=notfound");
//                return;
//            }
//
//            HttpSession session = request.getSession();
//            List<Watch> cart = (List<Watch>) session.getAttribute("cart");
//
//            if (cart == null) {
//                cart = new ArrayList<>();
//                System.out.println("New cart created"); // Debug log
//            }
//
//            boolean exists = false;
//
//            for (Watch w : cart) {
//                if (w.getId() == productId) {
//                    w.setQuantity(w.getQuantity() + 1);
//                    exists = true;
//                    System.out.println("Increased quantity for product: " + productId); // Debug log
//                    break;
//                }
//            }
//
//            if (!exists) {
//                product.setQuantity(1);
//                cart.add(product);
//                System.out.println("Added new product to cart: " + productId); // Debug log
//            }
//
//            session.setAttribute("cart", cart);
//            
//            // Print cart size for debugging
//            System.out.println("Cart size now: " + cart.size());
//            
//            response.sendRedirect("products?added=true");
//            
//        } catch (Exception e) {
//            e.printStackTrace();
//            response.sendRedirect("products?error=true");
//        }
//    }
//    


package com.timezone.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.timezone.dao.WatchDAO;
import com.timezone.model.Watch;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/addToCart")
public class AddToCartServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("AddToCartServlet: doPost called"); // Debug log

        try {
            // Get product ID from request
            int productId = Integer.parseInt(request.getParameter("id"));
            System.out.println("Product ID: " + productId); // Debug log

            // Get product from database
            WatchDAO dao = new WatchDAO();
            Watch product = dao.getWatchById(productId);
            
            // Check if product exists
            if (product == null) {
                System.out.println("Product not found!"); // Debug log
                response.sendRedirect("products?error=notfound");
                return;
            }

            // Get session and cart
            HttpSession session = request.getSession();
            List<Watch> cart = (List<Watch>) session.getAttribute("cart");

            // Create new cart if it doesn't exist
            if (cart == null) {
                cart = new ArrayList<>();
                System.out.println("New cart created"); // Debug log
            }

            // Check if product already exists in cart
            boolean exists = false;
            for (Watch w : cart) {
                if (w.getId() == productId) {
                    w.setQuantity(w.getQuantity() + 1);
                    exists = true;
                    System.out.println("Increased quantity for product: " + productId); // Debug log
                    break;
                }
            }

            // If product doesn't exist in cart, add it
            if (!exists) {
                product.setQuantity(1);
                cart.add(product);
                System.out.println("Added new product to cart: " + productId); // Debug log
            }

            // Save cart back to session
            session.setAttribute("cart", cart);
            
            // Print cart size for debugging
            System.out.println("Cart size now: " + cart.size());
            
            // Redirect back to products page with success message
            response.sendRedirect("products?added=true");
            
        } catch (NumberFormatException e) {
            System.out.println("Invalid product ID format");
            e.printStackTrace();
            response.sendRedirect("products?error=invalid");
        } catch (Exception e) {
            System.out.println("Error adding to cart");
            e.printStackTrace();
            response.sendRedirect("products?error=true");
        }
    }
    
    // Also handle GET requests (redirect to POST)
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
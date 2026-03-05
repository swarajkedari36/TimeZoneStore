package com.timezone.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.timezone.model.Watch;
import com.timezone.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("login.html");
            return;
        }

        String email = (String) session.getAttribute("userEmail");

        List<Watch> cartItems = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();

            String query = "SELECT w.* FROM watches w " +
                    "JOIN cart c ON w.id = c.watch_id " +
                    "JOIN users u ON u.id = c.user_id " +
                    "WHERE u.email=?";

            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                // FIXED: Using the 7-parameter constructor
                Watch w = new Watch(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("brand"),
                        rs.getDouble("price"),
                        rs.getString("image"),
                        rs.getString("description"),
                        rs.getString("category") // Adding category parameter
                );

                cartItems.add(w);
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("cartList", cartItems);
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }
}
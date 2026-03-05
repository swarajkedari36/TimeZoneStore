package com.timezone.controller;

import java.io.IOException;
import java.util.List;

import com.timezone.model.Watch;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/decrease")
public class DecreaseQuantityServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        HttpSession session = request.getSession();
        List<Watch> cart = (List<Watch>) session.getAttribute("cart");

        if (cart != null) {
            for (Watch w : cart) {
                if (w.getId() == id) {
                    // Extra safety: only decrease if quantity > 1
                    if (w.getQuantity() > 1) {
                        w.setQuantity(w.getQuantity() - 1);
                    } else {
                        // If quantity is 1, maybe remove from cart?
                        // cart.remove(w); // Uncomment if you want to remove when reaching 0
                    }
                    break;
                }
            }
            session.setAttribute("cart", cart); // Resave to session (optional but safe)
        }

        response.sendRedirect("cart.jsp");
    }
}
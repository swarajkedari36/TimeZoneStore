package com.timezone.controller;

import java.io.IOException;
import java.util.List;

import com.timezone.model.Watch;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/increase")
public class IncreaseQuantityServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        HttpSession session = request.getSession();
        List<Watch> cart = (List<Watch>) session.getAttribute("cart");

        if (cart != null) {
            for (Watch w : cart) {
                if (w.getId() == id) {
                    w.setQuantity(w.getQuantity() + 1);
                    break;
                }
            }
        }

        response.sendRedirect("cart.jsp");
    }
}
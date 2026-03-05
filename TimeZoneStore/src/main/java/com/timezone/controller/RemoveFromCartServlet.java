package com.timezone.controller;

import java.io.IOException;
import java.util.List;

import com.timezone.model.Watch;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/remove")
public class RemoveFromCartServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        HttpSession session = request.getSession();
        List<Watch> cart = (List<Watch>) session.getAttribute("cart");

        if (cart != null) {
            cart.removeIf(w -> w.getId() == id);
        }

        response.sendRedirect("cart.jsp");
    }
}
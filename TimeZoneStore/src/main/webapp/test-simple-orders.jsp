<%@ page import="java.util.*, com.timezone.model.Order, com.timezone.model.Watch" %>
<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    
    if (orders == null) {
        out.println("<h2>No orders attribute found!</h2>");
    } else if (orders.isEmpty()) {
        out.println("<h2>Orders list is empty!</h2>");
    } else {
        out.println("<h2>Found " + orders.size() + " order(s)</h2>");
        for (Order o : orders) {
            out.println("<h3>Order: " + o.getOrderNumber() + "</h3>");
            out.println("Status: " + o.getStatus() + "<br>");
            out.println("Total: ₹" + o.getTotalAmount() + "<br>");
            
            List<Watch> items = o.getItems();
            if (items != null && !items.isEmpty()) {
                out.println("<h4>Items:</h4>");
                for (Watch w : items) {
                    out.println(" - " + w.getName() + " x" + w.getQuantity() + 
                               " = ₹" + (w.getPrice() * w.getQuantity()) + "<br>");
                }
            } else {
                out.println("<p style='color:red'>No items in this order!</p>");
            }
            out.println("<hr>");
        }
    }
%>
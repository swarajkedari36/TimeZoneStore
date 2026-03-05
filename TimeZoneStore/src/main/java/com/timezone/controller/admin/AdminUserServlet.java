package com.timezone.controller.admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.timezone.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if admin is logged in
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        String id = request.getParameter("id");
        
        try {
            Connection con = DBConnection.getConnection();
            
            // View single user details
            if ("view".equals(action) && id != null) {
                Map<String, Object> user = getUserById(con, Integer.parseInt(id));
                List<Map<String, Object>> userOrders = getUserOrders(con, Integer.parseInt(id));
                request.setAttribute("user", user);
                request.setAttribute("userOrders", userOrders);
                con.close();
                request.getRequestDispatcher("/admin/user-detail.jsp").forward(request, response);
                return;
            }
            
            // Toggle user status (active/blocked)
            if ("toggle".equals(action) && id != null) {
                toggleUserStatus(con, Integer.parseInt(id));
                response.sendRedirect("users?toggled=true");
                return;
            }
            
            // Get search parameter
            String search = request.getParameter("search");
            
            // Get all users
            List<Map<String, Object>> users = getUsers(con, search);
            
            // Get user statistics
            int totalUsers = getTotalUsers(con);
            int activeUsers = getActiveUsers(con);
            int newUsersThisMonth = getNewUsersThisMonth(con);
            
            request.setAttribute("users", users);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("activeUsers", activeUsers);
            request.setAttribute("newUsersThisMonth", newUsersThisMonth);
            request.setAttribute("search", search);
            
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            Connection con = DBConnection.getConnection();
            
            if ("update".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");
                
                updateUser(con, userId, name, email, phone);
                response.sendRedirect("users?action=view&id=" + userId + "&updated=true");
            }
            
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("users?error=true");
        }
    }
    
    private List<Map<String, Object>> getUsers(Connection con, String search) throws Exception {
        List<Map<String, Object>> users = new ArrayList<>();
        
        StringBuilder query = new StringBuilder(
            "SELECT id, name, email, phone, created_at, " +
            "(SELECT COUNT(*) FROM orders WHERE user_id = users.id) as order_count " +
            "FROM users WHERE 1=1"
        );
        
        List<Object> params = new ArrayList<>();
        
        if (search != null && !search.trim().isEmpty()) {
            query.append(" AND (name LIKE ? OR email LIKE ?)");
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }
        
        query.append(" ORDER BY id DESC");
        
        PreparedStatement ps = con.prepareStatement(query.toString());
        
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
        
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            Map<String, Object> user = new HashMap<>();
            user.put("id", rs.getInt("id"));
            user.put("name", rs.getString("name"));
            user.put("email", rs.getString("email"));
            user.put("phone", rs.getString("phone"));
            user.put("createdAt", rs.getTimestamp("created_at"));
            user.put("orderCount", rs.getInt("order_count"));
            users.add(user);
        }
        
        return users;
    }
    
    private Map<String, Object> getUserById(Connection con, int userId) throws Exception {
        Map<String, Object> user = new HashMap<>();
        
        String query = "SELECT id, name, email, phone, created_at FROM users WHERE id = ?";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            user.put("id", rs.getInt("id"));
            user.put("name", rs.getString("name"));
            user.put("email", rs.getString("email"));
            user.put("phone", rs.getString("phone"));
            user.put("createdAt", rs.getTimestamp("created_at"));
        }
        
        return user;
    }
    
    private List<Map<String, Object>> getUserOrders(Connection con, int userId) throws Exception {
        List<Map<String, Object>> orders = new ArrayList<>();
        
        String query = "SELECT id, order_number, total_amount, status, order_date FROM orders WHERE user_id = ? ORDER BY order_date DESC";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            Map<String, Object> order = new HashMap<>();
            order.put("id", rs.getInt("id"));
            order.put("orderNumber", rs.getString("order_number"));
            order.put("totalAmount", rs.getDouble("total_amount"));
            order.put("status", rs.getString("status"));
            order.put("orderDate", rs.getTimestamp("order_date"));
            orders.add(order);
        }
        
        return orders;
    }
    
    private void toggleUserStatus(Connection con, int userId) throws Exception {
        // You can add a 'status' column to users table if needed
        // For now, this is a placeholder
        String query = "UPDATE users SET status = IF(status = 'active', 'blocked', 'active') WHERE id = ?";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setInt(1, userId);
        ps.executeUpdate();
    }
    
    private void updateUser(Connection con, int userId, String name, String email, String phone) throws Exception {
        String query = "UPDATE users SET name = ?, email = ?, phone = ? WHERE id = ?";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setString(1, name);
        ps.setString(2, email);
        ps.setString(3, phone);
        ps.setInt(4, userId);
        ps.executeUpdate();
    }
    
    private int getTotalUsers(Connection con) throws Exception {
        String query = "SELECT COUNT(*) as count FROM users";
        PreparedStatement ps = con.prepareStatement(query);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            return rs.getInt("count");
        }
        return 0;
    }
    
    private int getActiveUsers(Connection con) throws Exception {
        // You can add a 'status' column to users table if needed
        String query = "SELECT COUNT(*) as count FROM users WHERE 1=1";
        PreparedStatement ps = con.prepareStatement(query);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            return rs.getInt("count");
        }
        return 0;
    }
    
    private int getNewUsersThisMonth(Connection con) throws Exception {
        String query = "SELECT COUNT(*) as count FROM users WHERE MONTH(created_at) = MONTH(CURRENT_DATE()) AND YEAR(created_at) = YEAR(CURRENT_DATE())";
        PreparedStatement ps = con.prepareStatement(query);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            return rs.getInt("count");
        }
        return 0;
    }
}
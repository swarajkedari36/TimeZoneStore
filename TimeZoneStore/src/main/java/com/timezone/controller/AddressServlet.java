package com.timezone.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.timezone.model.Address;
import com.timezone.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/addresses")
public class AddressServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("login.html");
            return;
        }
        
        String email = (String) session.getAttribute("userEmail");
        String action = request.getParameter("action");
        
        try {
            Connection con = DBConnection.getConnection();
            
            // Get user ID
            int userId = getUserId(con, email);
            
            if ("delete".equals(action)) {
                int addressId = Integer.parseInt(request.getParameter("id"));
                deleteAddress(con, addressId);
                response.sendRedirect("addresses?deleted=true");
                return;
            } else if ("edit".equals(action)) {
                int addressId = Integer.parseInt(request.getParameter("id"));
                Address address = getAddressById(con, addressId);
                request.setAttribute("address", address);
                request.setAttribute("editMode", true);
            } else if ("new".equals(action)) {
                request.setAttribute("editMode", false);
            }
            
            // Get all addresses for this user
            List<Address> addresses = getAddressesByUserId(con, userId);
            request.setAttribute("addresses", addresses);
            
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("addresses.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("login.html");
            return;
        }
        
        String email = (String) session.getAttribute("userEmail");
        String action = request.getParameter("action");
        
        try {
            Connection con = DBConnection.getConnection();
            int userId = getUserId(con, email);
            
            if ("add".equals(action) || "edit".equals(action)) {
                String addressType = request.getParameter("addressType");
                String fullName = request.getParameter("fullName");
                String phone = request.getParameter("phone");
                String addressLine1 = request.getParameter("addressLine1");
                String addressLine2 = request.getParameter("addressLine2");
                String city = request.getParameter("city");
                String state = request.getParameter("state");
                String pincode = request.getParameter("pincode");
                String isDefault = request.getParameter("isDefault");
                
                if ("add".equals(action)) {
                    addAddress(con, userId, addressType, fullName, phone, addressLine1, 
                              addressLine2, city, state, pincode, isDefault != null);
                    response.sendRedirect("addresses?added=true");
                } else {
                    int addressId = Integer.parseInt(request.getParameter("id"));
                    updateAddress(con, addressId, addressType, fullName, phone, addressLine1,
                                 addressLine2, city, state, pincode, isDefault != null);
                    response.sendRedirect("addresses?updated=true");
                }
            }
            
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addresses?error=true");
        }
    }
    
    private int getUserId(Connection con, String email) throws Exception {
        String query = "SELECT id FROM users WHERE email = ?";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setString(1, email);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            return rs.getInt("id");
        }
        return 0;
    }
    
    private List<Address> getAddressesByUserId(Connection con, int userId) throws Exception {
        List<Address> addresses = new ArrayList<>();
        String query = "SELECT * FROM addresses WHERE user_id = ? ORDER BY is_default DESC, id DESC";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            Address addr = new Address();
            addr.setId(rs.getInt("id"));
            addr.setUserId(rs.getInt("user_id"));
            addr.setAddressType(rs.getString("address_type"));
            addr.setFullName(rs.getString("full_name"));
            addr.setPhone(rs.getString("phone"));
            addr.setAddressLine1(rs.getString("address_line1"));
            addr.setAddressLine2(rs.getString("address_line2"));
            addr.setCity(rs.getString("city"));
            addr.setState(rs.getString("state"));
            addr.setPincode(rs.getString("pincode"));
            addr.setDefault(rs.getBoolean("is_default"));
            addresses.add(addr);
        }
        
        return addresses;
    }
    
    private Address getAddressById(Connection con, int addressId) throws Exception {
        String query = "SELECT * FROM addresses WHERE id = ?";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setInt(1, addressId);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            Address addr = new Address();
            addr.setId(rs.getInt("id"));
            addr.setUserId(rs.getInt("user_id"));
            addr.setAddressType(rs.getString("address_type"));
            addr.setFullName(rs.getString("full_name"));
            addr.setPhone(rs.getString("phone"));
            addr.setAddressLine1(rs.getString("address_line1"));
            addr.setAddressLine2(rs.getString("address_line2"));
            addr.setCity(rs.getString("city"));
            addr.setState(rs.getString("state"));
            addr.setPincode(rs.getString("pincode"));
            addr.setDefault(rs.getBoolean("is_default"));
            return addr;
        }
        return null;
    }
    
    private void addAddress(Connection con, int userId, String addressType, String fullName,
                           String phone, String line1, String line2, String city,
                           String state, String pincode, boolean isDefault) throws Exception {
        
        if (isDefault) {
            // Remove default from other addresses
            String resetDefault = "UPDATE addresses SET is_default = FALSE WHERE user_id = ?";
            PreparedStatement resetPs = con.prepareStatement(resetDefault);
            resetPs.setInt(1, userId);
            resetPs.executeUpdate();
        }
        
        String query = "INSERT INTO addresses (user_id, address_type, full_name, phone, " +
                      "address_line1, address_line2, city, state, pincode, is_default) " +
                      "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setInt(1, userId);
        ps.setString(2, addressType);
        ps.setString(3, fullName);
        ps.setString(4, phone);
        ps.setString(5, line1);
        ps.setString(6, line2);
        ps.setString(7, city);
        ps.setString(8, state);
        ps.setString(9, pincode);
        ps.setBoolean(10, isDefault);
        
        ps.executeUpdate();
    }
    
    private void updateAddress(Connection con, int addressId, String addressType, String fullName,
                              String phone, String line1, String line2, String city,
                              String state, String pincode, boolean isDefault) throws Exception {
        
        if (isDefault) {
            // Get user_id first
            String getUser = "SELECT user_id FROM addresses WHERE id = ?";
            PreparedStatement getUserPs = con.prepareStatement(getUser);
            getUserPs.setInt(1, addressId);
            ResultSet rs = getUserPs.executeQuery();
            
            if (rs.next()) {
                int userId = rs.getInt("user_id");
                // Remove default from other addresses
                String resetDefault = "UPDATE addresses SET is_default = FALSE WHERE user_id = ? AND id != ?";
                PreparedStatement resetPs = con.prepareStatement(resetDefault);
                resetPs.setInt(1, userId);
                resetPs.setInt(2, addressId);
                resetPs.executeUpdate();
            }
        }
        
        String query = "UPDATE addresses SET address_type=?, full_name=?, phone=?, " +
                      "address_line1=?, address_line2=?, city=?, state=?, pincode=?, is_default=? " +
                      "WHERE id=?";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setString(1, addressType);
        ps.setString(2, fullName);
        ps.setString(3, phone);
        ps.setString(4, line1);
        ps.setString(5, line2);
        ps.setString(6, city);
        ps.setString(7, state);
        ps.setString(8, pincode);
        ps.setBoolean(9, isDefault);
        ps.setInt(10, addressId);
        
        ps.executeUpdate();
    }
    
    private void deleteAddress(Connection con, int addressId) throws Exception {
        String query = "DELETE FROM addresses WHERE id = ?";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setInt(1, addressId);
        ps.executeUpdate();
    }
}
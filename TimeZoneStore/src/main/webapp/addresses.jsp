<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.timezone.model.Address" %>
<%
    List<Address> addresses = (List<Address>) request.getAttribute("addresses");
    Boolean editMode = (Boolean) request.getAttribute("editMode");
    Address editAddress = (Address) request.getAttribute("address");
    
    String added = request.getParameter("added");
    String updated = request.getParameter("updated");
    String deleted = request.getParameter("deleted");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Addresses - TimeZone</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            background: url('images/bg.jpg') no-repeat center center fixed;
            background-size: cover;
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            position: relative;
        }
        
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            z-index: 0;
        }
        
        .container {
            position: relative;
            z-index: 1;
            padding: 40px 20px;
        }
        
        /* Navbar */
        .navbar {
            background: rgba(0, 0, 0, 0.8);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255,255,255,0.1);
            padding: 1rem 0;
            margin-bottom: 40px;
            border-radius: 0 0 20px 20px;
        }
        
        .navbar-brand {
            font-size: 1.8rem;
            font-weight: 600;
            color: #fff !important;
            text-decoration: none;
        }
        
        .navbar-brand span {
            color: #c9a959;
        }
        
        .nav-links a {
            color: white;
            text-decoration: none;
            margin-left: 25px;
            transition: color 0.3s;
        }
        
        .nav-links a:hover {
            color: #c9a959;
        }
        
        /* Page Header */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 20px;
        }
        
        .page-header h1 {
            color: #fff;
            font-size: 32px;
            font-weight: 600;
        }
        
        .page-header h1 i {
            color: #c9a959;
            margin-right: 10px;
        }
        
        .add-btn {
            background: #c9a959;
            color: #000;
            padding: 12px 25px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }
        
        .add-btn:hover {
            background: #d4b468;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(201, 169, 89, 0.3);
            color: #000;
        }
        
        /* Messages */
        .success-message {
            background: rgba(40, 167, 69, 0.15);
            border: 1px solid rgba(40, 167, 69, 0.3);
            border-radius: 15px;
            padding: 15px 20px;
            margin-bottom: 25px;
            color: #28a745;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .error-message {
            background: rgba(220, 53, 69, 0.15);
            border: 1px solid rgba(220, 53, 69, 0.3);
            border-radius: 15px;
            padding: 15px 20px;
            margin-bottom: 25px;
            color: #ff6b6b;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        /* Address Grid */
        .addresses-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        
        /* Address Card */
        .address-card {
            background: rgba(30, 30, 30, 0.6);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 25px;
            transition: all 0.3s;
            position: relative;
        }
        
        .address-card:hover {
            transform: translateY(-5px);
            border-color: #c9a959;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        }
        
        .default-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: #c9a959;
            color: #000;
            padding: 5px 12px;
            border-radius: 50px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .address-type {
            display: inline-block;
            background: rgba(201, 169, 89, 0.15);
            color: #c9a959;
            padding: 5px 15px;
            border-radius: 50px;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 15px;
            border: 1px solid rgba(201, 169, 89, 0.3);
        }
        
        .address-details {
            color: #fff;
            margin-bottom: 20px;
        }
        
        .address-details p {
            margin-bottom: 8px;
            display: flex;
            align-items: flex-start;
            gap: 10px;
            color: rgba(255, 255, 255, 0.9);
        }
        
        .address-details i {
            color: #c9a959;
            width: 20px;
            margin-top: 3px;
        }
        
        .address-actions {
            display: flex;
            gap: 10px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            padding-top: 20px;
        }
        
        .edit-btn, .delete-btn {
            flex: 1;
            padding: 10px;
            border-radius: 10px;
            text-align: center;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
        }
        
        .edit-btn {
            background: rgba(255, 255, 255, 0.1);
            color: #fff;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .edit-btn:hover {
            background: #c9a959;
            color: #000;
        }
        
        .delete-btn {
            background: rgba(220, 53, 69, 0.1);
            color: #ff6b6b;
            border: 1px solid rgba(220, 53, 69, 0.3);
        }
        
        .delete-btn:hover {
            background: #dc3545;
            color: #fff;
        }
        
        /* Address Form */
        .address-form-container {
            background: rgba(30, 30, 30, 0.6);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 30px;
            margin-top: 30px;
        }
        
        .form-title {
            color: #fff;
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .form-title i {
            color: #c9a959;
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group.full-width {
            grid-column: span 2;
        }
        
        .form-label {
            color: #fff;
            font-weight: 500;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .form-label i {
            color: #c9a959;
            width: 20px;
        }
        
        .form-control, .form-select {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            padding: 12px 15px;
            color: #fff;
            width: 100%;
            transition: all 0.3s;
        }
        
        .form-control:focus, .form-select:focus {
            outline: none;
            border-color: #c9a959;
            background: rgba(255, 255, 255, 0.15);
        }
        
        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.4);
        }
        
        .form-select option {
            background: #333;
            color: #fff;
        }
        
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #fff;
        }
        
        .checkbox-group input[type="checkbox"] {
            width: 18px;
            height: 18px;
            accent-color: #c9a959;
        }
        
        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }
        
        .submit-btn {
            background: #c9a959;
            color: #000;
            border: none;
            border-radius: 12px;
            padding: 12px 30px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .submit-btn:hover {
            background: #d4b468;
            transform: translateY(-2px);
        }
        
        .cancel-btn {
            background: transparent;
            color: #fff;
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            padding: 12px 30px;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .cancel-btn:hover {
            background: rgba(255, 255, 255, 0.1);
            border-color: #c9a959;
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: rgba(30, 30, 30, 0.4);
            border-radius: 20px;
            border: 1px dashed rgba(255, 255, 255, 0.2);
        }
        
        .empty-state i {
            font-size: 60px;
            color: #c9a959;
            margin-bottom: 20px;
            opacity: 0.7;
        }
        
        .empty-state h3 {
            color: #fff;
            font-size: 24px;
            margin-bottom: 10px;
        }
        
        .empty-state p {
            color: rgba(255, 255, 255, 0.6);
            margin-bottom: 25px;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .form-group.full-width {
                grid-column: span 1;
            }
            
            .addresses-grid {
                grid-template-columns: 1fr;
            }
            
            .page-header {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar">
    <div class="container">
        <a class="navbar-brand" href="products">
            ⌚ Time<span>Zone</span>
        </a>
        <div class="nav-links">
            <a href="products"><i class="fas fa-store"></i> Shop</a>
            <a href="cart.jsp"><i class="fas fa-shopping-bag"></i> Cart</a>
            <a href="orders"><i class="fas fa-box"></i> Orders</a>
            <a href="profile"><i class="fas fa-user"></i> Profile</a>
            <a href="wishlist"><i class="fas fa-heart"></i> Wishlist</a>
        </div>
    </div>
</nav>

<div class="container">
    <!-- Page Header -->
    <div class="page-header">
        <h1>
            <i class="fas fa-map-marker-alt"></i> My Addresses
        </h1>
        <a href="addresses?action=new" class="add-btn">
            <i class="fas fa-plus"></i> Add New Address
        </a>
    </div>
    
    <!-- Success/Error Messages -->
    <% if ("true".equals(added)) { %>
        <div class="success-message">
            <i class="fas fa-check-circle"></i>
            Address added successfully!
        </div>
    <% } %>
    
    <% if ("true".equals(updated)) { %>
        <div class="success-message">
            <i class="fas fa-check-circle"></i>
            Address updated successfully!
        </div>
    <% } %>
    
    <% if ("true".equals(deleted)) { %>
        <div class="success-message">
            <i class="fas fa-check-circle"></i>
            Address deleted successfully!
        </div>
    <% } %>
    
    <% if ("true".equals(error)) { %>
        <div class="error-message">
            <i class="fas fa-exclamation-circle"></i>
            An error occurred. Please try again.
        </div>
    <% } %>
    
    <!-- Addresses Grid -->
    <% if (addresses != null && !addresses.isEmpty()) { %>
        <div class="addresses-grid">
            <% for (Address addr : addresses) { %>
                <div class="address-card">
                    <% if (addr.isDefault()) { %>
                        <span class="default-badge">DEFAULT</span>
                    <% } %>
                    
                    <span class="address-type">
                        <i class="fas fa-<%= addr.getAddressType().toLowerCase().equals("home") ? "home" : "briefcase" %>"></i>
                        <%= addr.getAddressType() %>
                    </span>
                    
                    <div class="address-details">
                        <p><i class="fas fa-user"></i> <%= addr.getFullName() %></p>
                        <p><i class="fas fa-phone"></i> <%= addr.getPhone() %></p>
                        <p><i class="fas fa-map-pin"></i> <%= addr.getAddressLine1() %></p>
                        <% if (addr.getAddressLine2() != null && !addr.getAddressLine2().isEmpty()) { %>
                            <p><i class="fas fa-map-pin"></i> <%= addr.getAddressLine2() %></p>
                        <% } %>
                        <p><i class="fas fa-city"></i> <%= addr.getCity() %>, <%= addr.getState() %> - <%= addr.getPincode() %></p>
                    </div>
                    
                    <div class="address-actions">
                        <a href="addresses?action=edit&id=<%= addr.getId() %>" class="edit-btn">
                            <i class="fas fa-edit"></i> Edit
                        </a>
                        <a href="addresses?action=delete&id=<%= addr.getId() %>" 
                           class="delete-btn" 
                           onclick="return confirm('Are you sure you want to delete this address?')">
                            <i class="fas fa-trash"></i> Delete
                        </a>
                    </div>
                </div>
            <% } %>
        </div>
    <% } else if (editMode == null || !editMode) { %>
        <div class="empty-state">
            <i class="fas fa-map-marker-alt"></i>
            <h3>No Addresses Saved</h3>
            <p>You haven't added any delivery addresses yet.</p>
            <a href="addresses?action=new" class="add-btn">
                <i class="fas fa-plus"></i> Add Your First Address
            </a>
        </div>
    <% } %>
    
    <!-- Address Form (shown when adding/editing) -->
    <% if (editMode != null) { %>
        <div class="address-form-container">
            <div class="form-title">
                <i class="fas fa-<%= editMode ? "edit" : "plus-circle" %>"></i>
                <%= editMode ? "Edit Address" : "Add New Address" %>
            </div>
            
            <form action="addresses" method="post">
                <input type="hidden" name="action" value="<%= editMode ? "edit" : "add" %>">
                <% if (editMode && editAddress != null) { %>
                    <input type="hidden" name="id" value="<%= editAddress.getId() %>">
                <% } %>
                
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">
                            <i class="fas fa-tag"></i> Address Type
                        </label>
                        <select name="addressType" class="form-select" required>
                            <option value="Home" <%= (editAddress != null && "Home".equals(editAddress.getAddressType())) ? "selected" : "" %>>Home</option>
                            <option value="Work" <%= (editAddress != null && "Work".equals(editAddress.getAddressType())) ? "selected" : "" %>>Work</option>
                            <option value="Other" <%= (editAddress != null && "Other".equals(editAddress.getAddressType())) ? "selected" : "" %>>Other</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">
                            <i class="fas fa-user"></i> Full Name
                        </label>
                        <input type="text" name="fullName" class="form-control" 
                               value="<%= editAddress != null ? editAddress.getFullName() : "" %>" 
                               placeholder="Enter full name" required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">
                            <i class="fas fa-phone"></i> Phone Number
                        </label>
                        <input type="tel" name="phone" class="form-control" 
                               value="<%= editAddress != null ? editAddress.getPhone() : "" %>" 
                               placeholder="Enter phone number" required>
                    </div>
                    
                    <div class="form-group full-width">
                        <label class="form-label">
                            <i class="fas fa-map-pin"></i> Address Line 1
                        </label>
                        <input type="text" name="addressLine1" class="form-control" 
                               value="<%= editAddress != null ? editAddress.getAddressLine1() : "" %>" 
                               placeholder="House/Flat number, Building name" required>
                    </div>
                    
                    <div class="form-group full-width">
                        <label class="form-label">
                            <i class="fas fa-map-pin"></i> Address Line 2 (Optional)
                        </label>
                        <input type="text" name="addressLine2" class="form-control" 
                               value="<%= editAddress != null && editAddress.getAddressLine2() != null ? editAddress.getAddressLine2() : "" %>" 
                               placeholder="Area, Landmark">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">
                            <i class="fas fa-city"></i> City
                        </label>
                        <input type="text" name="city" class="form-control" 
                               value="<%= editAddress != null ? editAddress.getCity() : "" %>" 
                               placeholder="City" required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">
                            <i class="fas fa-map"></i> State
                        </label>
                        <input type="text" name="state" class="form-control" 
                               value="<%= editAddress != null ? editAddress.getState() : "" %>" 
                               placeholder="State" required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">
                            <i class="fas fa-mail-bulk"></i> Pincode
                        </label>
                        <input type="text" name="pincode" class="form-control" 
                               value="<%= editAddress != null ? editAddress.getPincode() : "" %>" 
                               placeholder="Pincode" required>
                    </div>
                    
                    <div class="form-group">
                        <div class="checkbox-group">
                            <input type="checkbox" name="isDefault" id="isDefault" 
                                   <%= (editAddress != null && editAddress.isDefault()) ? "checked" : "" %>>
                            <label for="isDefault">Set as default address</label>
                        </div>
                    </div>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="submit-btn">
                        <i class="fas fa-save"></i> <%= editMode ? "Update Address" : "Save Address" %>
                    </button>
                    <a href="addresses" class="cancel-btn">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                </div>
            </form>
        </div>
    <% } %>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Auto-hide messages after 3 seconds
    setTimeout(function() {
        document.querySelectorAll('.success-message, .error-message').forEach(msg => {
            msg.style.transition = 'opacity 0.5s';
            msg.style.opacity = '0';
            setTimeout(() => msg.remove(), 500);
        });
    }, 3000);
</script>

</body>
</html>
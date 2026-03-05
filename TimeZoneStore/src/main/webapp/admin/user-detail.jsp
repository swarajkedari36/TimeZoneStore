<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%
    Map<String, Object> user = (Map<String, Object>) request.getAttribute("user");
    List<Map<String, Object>> userOrders = (List<Map<String, Object>>) request.getAttribute("userOrders");
    String updated = request.getParameter("updated");
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
    SimpleDateFormat dateOnlyFormat = new SimpleDateFormat("yyyy-MM-dd");
%>
<!DOCTYPE html>
<html>
<head>
    <title>User Details - TimeZone Admin</title>
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
            background: #1a1a1a;
            font-family: 'Inter', sans-serif;
        }
        
        /* Sidebar */
        .sidebar {
            position: fixed;
            left: 0;
            top: 0;
            bottom: 0;
            width: 260px;
            background: #222;
            border-right: 1px solid rgba(255,255,255,0.1);
            padding: 20px;
            overflow-y: auto;
        }
        
        .sidebar-brand {
            font-size: 24px;
            font-weight: 600;
            color: #fff;
            text-decoration: none;
            display: block;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        
        .sidebar-brand span {
            color: #c9a959;
        }
        
        .sidebar-menu {
            list-style: none;
            padding: 0;
        }
        
        .sidebar-menu li {
            margin-bottom: 5px;
        }
        
        .sidebar-menu a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 15px;
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            border-radius: 10px;
            transition: all 0.3s;
        }
        
        .sidebar-menu a:hover, .sidebar-menu a.active {
            background: #c9a959;
            color: #000;
        }
        
        .sidebar-menu a i {
            width: 20px;
        }
        
        /* Main Content */
        .main-content {
            margin-left: 260px;
            padding: 30px;
        }
        
        /* Header */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        
        .header h1 {
            color: #fff;
            font-size: 28px;
            font-weight: 600;
        }
        
        .back-btn {
            background: transparent;
            color: #fff;
            padding: 10px 20px;
            border-radius: 50px;
            text-decoration: none;
            border: 1px solid rgba(255,255,255,0.2);
            transition: all 0.3s;
        }
        
        .back-btn:hover {
            border-color: #c9a959;
            color: #c9a959;
        }
        
        /* Messages */
        .success-message {
            background: rgba(40, 167, 69, 0.15);
            border: 1px solid rgba(40, 167, 69, 0.3);
            border-radius: 10px;
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
            border-radius: 10px;
            padding: 15px 20px;
            margin-bottom: 25px;
            color: #ff6b6b;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        /* User Profile */
        .profile-card {
            background: #222;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            display: flex;
            gap: 30px;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .profile-avatar {
            width: 100px;
            height: 100px;
            background: #c9a959;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #000;
            font-size: 40px;
            font-weight: 600;
        }
        
        .profile-info {
            flex: 1;
        }
        
        .profile-name {
            color: #fff;
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .profile-email {
            color: #c9a959;
            font-size: 16px;
            margin-bottom: 10px;
        }
        
        .profile-meta {
            display: flex;
            gap: 30px;
            flex-wrap: wrap;
        }
        
        .meta-item {
            display: flex;
            align-items: center;
            gap: 8px;
            color: rgba(255,255,255,0.7);
            font-size: 14px;
        }
        
        .meta-item i {
            color: #c9a959;
        }
        
        /* Edit Form */
        .edit-card {
            background: #222;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
        }
        
        .edit-title {
            color: #fff;
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 20px;
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-label {
            color: rgba(255,255,255,0.7);
            font-size: 13px;
            margin-bottom: 5px;
            display: block;
        }
        
        .form-control {
            width: 100%;
            padding: 10px 12px;
            background: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 8px;
            color: #fff;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #c9a959;
        }
        
        .save-btn {
            padding: 12px 30px;
            background: #c9a959;
            color: #000;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 15px;
        }
        
        .save-btn:hover {
            background: #d4b468;
        }
        
        /* Orders Table */
        .orders-table {
            background: #222;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            padding: 20px;
            margin-top: 30px;
            overflow-x: auto;
        }
        
        .section-title {
            color: #fff;
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 20px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        th {
            text-align: left;
            padding: 12px;
            color: #c9a959;
            font-weight: 600;
            border-bottom: 2px solid #3a3a3a;
            background: #1e1e1e;
        }
        
        td {
            padding: 12px;
            color: #fff;
            border-bottom: 1px solid #3a3a3a;
        }
        
        .status-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 50px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .status-Processing { background: rgba(255,193,7,0.2); color: #ffc107; }
        .status-Confirmed { background: rgba(0,123,255,0.2); color: #007bff; }
        .status-Shipped { background: rgba(40,167,69,0.2); color: #28a745; }
        .status-Delivered { background: rgba(40,167,69,0.2); color: #28a745; }
        
        .view-order-btn {
            padding: 4px 10px;
            background: rgba(201,169,89,0.1);
            color: #c9a959;
            border: 1px solid rgba(201,169,89,0.3);
            border-radius: 5px;
            text-decoration: none;
            font-size: 12px;
        }
        
        .view-order-btn:hover {
            background: #c9a959;
            color: #000;
        }
        
        .empty-state {
            text-align: center;
            padding: 30px;
            color: rgba(255,255,255,0.5);
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <a href="dashboard" class="sidebar-brand">
            Time<span>Zone</span> Admin
        </a>
        
        <ul class="sidebar-menu">
            <li><a href="dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
            <li><a href="products"><i class="fas fa-clock"></i> Products</a></li>
            <li><a href="orders"><i class="fas fa-shopping-bag"></i> Orders</a></li>
            <li><a href="users" class="active"><i class="fas fa-users"></i> Users</a></li>
            <li><a href="reviews"><i class="fas fa-star"></i> Reviews</a></li>
            <li><a href="reports"><i class="fas fa-chart-bar"></i> Reports</a></li>
            <li style="margin-top: 30px;"><a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>
    
    <!-- Main Content -->
    <div class="main-content">
        <div class="header">
            <h1>User Details</h1>
            <a href="users" class="back-btn">
                <i class="fas fa-arrow-left me-2"></i> Back to Users
            </a>
        </div>
        
        <% if ("true".equals(updated)) { %>
            <div class="success-message">
                <i class="fas fa-check-circle"></i>
                User information updated successfully!
            </div>
        <% } %>
        
        <% if (user != null) { %>
            <!-- User Profile -->
            <div class="profile-card">
                <div class="profile-avatar">
                    <%= ((String)user.get("name")).charAt(0) %>
                </div>
                <div class="profile-info">
                    <div class="profile-name"><%= user.get("name") %></div>
                    <div class="profile-email"><%= user.get("email") %></div>
                    <div class="profile-meta">
                        <div class="meta-item">
                            <i class="fas fa-calendar"></i>
                            Joined: <%= dateFormat.format(user.get("createdAt")) %>
                        </div>
                        <div class="meta-item">
                            <i class="fas fa-shopping-bag"></i>
                            Total Orders: <%= userOrders != null ? userOrders.size() : 0 %>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Edit User Form -->
            <div class="edit-card">
                <div class="edit-title">
                    <i class="fas fa-edit me-2"></i> Edit User Information
                </div>
                <form action="users" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="userId" value="<%= user.get("id") %>">
                    
                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label">Full Name</label>
                            <input type="text" name="name" class="form-control" 
                                   value="<%= user.get("name") %>" required>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Email</label>
                            <input type="email" name="email" class="form-control" 
                                   value="<%= user.get("email") %>" required>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Phone</label>
                            <input type="text" name="phone" class="form-control" 
                                   value="<%= user.get("phone") != null ? user.get("phone") : "" %>">
                        </div>
                    </div>
                    
                    <button type="submit" class="save-btn">
                        <i class="fas fa-save me-2"></i> Save Changes
                    </button>
                </form>
            </div>
            
            <!-- User Orders -->
            <div class="orders-table">
                <div class="section-title">
                    <i class="fas fa-shopping-bag me-2"></i> Order History
                </div>
                
                <% if (userOrders != null && !userOrders.isEmpty()) { %>
                    <table>
                        <thead>
                            <tr>
                                <th>Order #</th>
                                <th>Date</th>
                                <th>Total</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Map<String, Object> order : userOrders) { %>
                                <tr>
                                    <td><%= order.get("orderNumber") %></td>
                                    <td><%= dateFormat.format(order.get("orderDate")) %></td>
                                    <td>₹ <%= String.format("%,d", (int)((Double)order.get("totalAmount")).doubleValue()) %></td>
                                    <td>
                                        <span class="status-badge status-<%= order.get("status") %>">
                                            <%= order.get("status") %>
                                        </span>
                                    </td>
                                    <td>
                                        <a href="orders?action=view&id=<%= order.get("id") %>" class="view-order-btn">
                                            <i class="fas fa-eye me-1"></i> View
                                        </a>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } else { %>
                    <div class="empty-state">
                        <i class="fas fa-box-open"></i>
                        <p>This user hasn't placed any orders yet.</p>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>
</body>
</html>
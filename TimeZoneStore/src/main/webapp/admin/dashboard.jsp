<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%
    Map<String, Object> stats = (Map<String, Object>) request.getAttribute("stats");
    List<Map<String, Object>> recentOrders = (List<Map<String, Object>>) request.getAttribute("recentOrders");
    Map<String, Integer> ordersByStatus = (Map<String, Integer>) request.getAttribute("ordersByStatus");
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - TimeZone</title>
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
        
        .admin-info {
            display: flex;
            align-items: center;
            gap: 20px;
            color: #fff;
        }
        
        .admin-avatar {
            width: 45px;
            height: 45px;
            background: #c9a959;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #000;
            font-weight: 600;
            font-size: 18px;
        }
        
        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: #222;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 15px;
            padding: 25px;
            transition: transform 0.3s;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            border-color: #c9a959;
        }
        
        .stat-icon {
            width: 50px;
            height: 50px;
            background: rgba(201, 169, 89, 0.1);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 15px;
        }
        
        .stat-icon i {
            font-size: 24px;
            color: #c9a959;
        }
        
        .stat-label {
            color: rgba(255,255,255,0.5);
            font-size: 14px;
            margin-bottom: 5px;
        }
        
        .stat-value {
            color: #fff;
            font-size: 32px;
            font-weight: 600;
        }
        
        .stat-sub {
            color: #c9a959;
            font-size: 14px;
            margin-top: 5px;
        }
        
        /* Recent Orders */
        .recent-orders {
            background: #222;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
        }
        
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .section-header h2 {
            color: #fff;
            font-size: 20px;
            font-weight: 600;
        }
        
        .view-all {
            color: #c9a959;
            text-decoration: none;
            font-size: 14px;
        }
        
        .table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .table th {
            text-align: left;
            padding: 12px;
            color: rgba(255,255,255,0.5);
            font-weight: 500;
            font-size: 13px;
            text-transform: uppercase;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        
        .table td {
            padding: 12px;
            color: #fff;
            border-bottom: 1px solid rgba(255,255,255,0.05);
        }
        
        .status-badge {
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 12px;
            font-weight: 500;
            display: inline-block;
        }
        
        .status-processing { background: rgba(255,193,7,0.2); color: #ffc107; }
        .status-confirmed { background: rgba(0,123,255,0.2); color: #007bff; }
        .status-shipped { background: rgba(40,167,69,0.2); color: #28a745; }
        .status-delivered { background: rgba(40,167,69,0.2); color: #28a745; }
        .status-cancelled { background: rgba(220,53,69,0.2); color: #dc3545; }
        
        .action-btn {
            padding: 5px 12px;
            background: rgba(201,169,89,0.1);
            color: #c9a959;
            border: 1px solid rgba(201,169,89,0.3);
            border-radius: 5px;
            text-decoration: none;
            font-size: 12px;
            transition: all 0.3s;
        }
        
        .action-btn:hover {
            background: #c9a959;
            color: #000;
        }
        
        /* Quick Actions */
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        
        .action-card {
            background: #222;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .action-card:hover {
            border-color: #c9a959;
            transform: translateY(-3px);
        }
        
        .action-card i {
            font-size: 30px;
            color: #c9a959;
            margin-bottom: 10px;
        }
        
        .action-card h3 {
            color: #fff;
            font-size: 16px;
            margin-bottom: 5px;
        }
        
        .action-card p {
            color: rgba(255,255,255,0.5);
            font-size: 12px;
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
            <li><a href="dashboard" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
            <li><a href="products"><i class="fas fa-clock"></i> Products</a></li>
            <li><a href="orders"><i class="fas fa-shopping-bag"></i> Orders</a></li>
            <li><a href="users"><i class="fas fa-users"></i> Users</a></li>
            <li><a href="reviews"><i class="fas fa-star"></i> Reviews</a></li>
            <li><a href="reports"><i class="fas fa-chart-bar"></i> Reports</a></li>
            <li style="margin-top: 30px;"><a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>
    
    <!-- Main Content -->
    <div class="main-content">
        <!-- Header -->
        <div class="header">
            <h1>Dashboard</h1>
            <div class="admin-info">
                <span>Welcome, <%= session.getAttribute("adminName") != null ? session.getAttribute("adminName") : "Admin" %></span>
                <div class="admin-avatar">
                    <%= session.getAttribute("adminName") != null ? ((String)session.getAttribute("adminName")).charAt(0) : "A" %>
                </div>
            </div>
        </div>
        
      <!-- Stats Cards -->
<div class="stats-grid">
    <div class="stat-card">
        <div class="stat-icon">
            <i class="fas fa-clock"></i>
        </div>
        <div class="stat-label">Total Products</div>
        <div class="stat-value"><%= stats != null && stats.get("totalProducts") != null ? stats.get("totalProducts") : 0 %></div>
        <div class="stat-sub">+12 this month</div>
    </div>
    
    <div class="stat-card">
        <div class="stat-icon">
            <i class="fas fa-shopping-bag"></i>
        </div>
        <div class="stat-label">Total Orders</div>
        <div class="stat-value"><%= stats != null && stats.get("totalOrders") != null ? stats.get("totalOrders") : 0 %></div>
        <div class="stat-sub"><%= ordersByStatus != null && ordersByStatus.get("Processing") != null ? ordersByStatus.get("Processing") : 0 %> pending</div>
    </div>
    
    <div class="stat-card">
        <div class="stat-icon">
            <i class="fas fa-users"></i>
        </div>
        <div class="stat-label">Total Users</div>
        <div class="stat-value"><%= stats != null && stats.get("totalUsers") != null ? stats.get("totalUsers") : 0 %></div>
        <div class="stat-sub">+5 new this week</div>
    </div>
    
    <div class="stat-card">
        <div class="stat-icon">
            <i class="fas fa-rupee-sign"></i>
        </div>
        <div class="stat-label">Total Revenue</div>
        <div class="stat-value">
            ₹ <% 
                if (stats != null && stats.get("totalRevenue") != null) {
                    Double revenue = (Double) stats.get("totalRevenue");
                    out.print(String.format("%,d", revenue.intValue()));
                } else {
                    out.print("0");
                }
            %>
        </div>
        <div class="stat-sub">+18% vs last month</div>
    </div>
</div>

<!-- Recent Orders -->
<div class="recent-orders" style="background: #2a2a2a; border: 1px solid #3a3a3a; border-radius: 15px; padding: 25px; margin-bottom: 30px;">
    <div class="section-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
        <h2 style="color: #fff; font-size: 20px; font-weight: 600; margin: 0;">Recent Orders</h2>
        <a href="orders" style="color: #c9a959; text-decoration: none; font-size: 14px;">
            View All <i class="fas fa-arrow-right ms-1"></i>
        </a>
    </div>
    
    <div style="overflow-x: auto;">
        <table style="width: 100%; border-collapse: collapse;">
            <thead>
                <tr style="background: #1e1e1e;">
                    <th style="padding: 15px; text-align: left; color: #c9a959; font-weight: 600; border-bottom: 2px solid #3a3a3a;">Order #</th>
                    <th style="padding: 15px; text-align: left; color: #c9a959; font-weight: 600; border-bottom: 2px solid #3a3a3a;">Customer</th>
                    <th style="padding: 15px; text-align: left; color: #c9a959; font-weight: 600; border-bottom: 2px solid #3a3a3a;">Date</th>
                    <th style="padding: 15px; text-align: left; color: #c9a959; font-weight: 600; border-bottom: 2px solid #3a3a3a;">Total</th>
                    <th style="padding: 15px; text-align: left; color: #c9a959; font-weight: 600; border-bottom: 2px solid #3a3a3a;">Status</th>
                    <th style="padding: 15px; text-align: left; color: #c9a959; font-weight: 600; border-bottom: 2px solid #3a3a3a;">Action</th>
                </tr>
            </thead>
            <tbody>
                <% if (recentOrders != null && !recentOrders.isEmpty()) { %>
                    <% for (Map<String, Object> order : recentOrders) { %>
                        <tr style="border-bottom: 1px solid #3a3a3a;">
                            <td style="padding: 15px; color: #fff;"><%= order.get("orderNumber") %></td>
                            <td style="padding: 15px; color: #fff;"><%= order.get("email") %></td>
                            <td style="padding: 15px; color: #fff;"><%= dateFormat.format(order.get("orderDate")) %></td>
                            <td style="padding: 15px; color: #c9a959; font-weight: 600;">
                                ₹ <% 
                                    Double amount = (Double) order.get("totalAmount");
                                    out.print(String.format("%,d", amount.intValue()));
                                %>
                            </td>
                            <td style="padding: 15px;">
                                <span style="display: inline-block; padding: 5px 12px; border-radius: 50px; font-size: 12px; font-weight: 500; 
                                    <% if ("Processing".equals(order.get("status"))) { %>
                                        background: rgba(255,193,7,0.2); color: #ffc107; border: 1px solid rgba(255,193,7,0.3);
                                    <% } else if ("Confirmed".equals(order.get("status"))) { %>
                                        background: rgba(0,123,255,0.2); color: #007bff; border: 1px solid rgba(0,123,255,0.3);
                                    <% } else if ("Shipped".equals(order.get("status"))) { %>
                                        background: rgba(40,167,69,0.2); color: #28a745; border: 1px solid rgba(40,167,69,0.3);
                                    <% } else if ("Delivered".equals(order.get("status"))) { %>
                                        background: rgba(40,167,69,0.2); color: #28a745; border: 1px solid rgba(40,167,69,0.3);
                                    <% } else { %>
                                        background: rgba(108,117,125,0.2); color: #6c757d; border: 1px solid rgba(108,117,125,0.3);
                                    <% } %>">
                                    <%= order.get("status") %>
                                </span>
                            </td>
                            <td style="padding: 15px;">
                                <a href="orders?id=<%= order.get("id") %>" style="display: inline-block; padding: 5px 12px; background: rgba(201,169,89,0.1); color: #c9a959; border: 1px solid rgba(201,169,89,0.3); border-radius: 5px; text-decoration: none; font-size: 12px; transition: all 0.3s;">
                                    <i class="fas fa-eye me-1"></i> View
                                </a>
                            </td>
                        </tr>
                    <% } %>
                <% } else { %>
                    <tr>
                        <td colspan="6" style="text-align: center; color: rgba(255,255,255,0.5); padding: 30px;">
                            <i class="fas fa-box-open" style="font-size: 40px; margin-bottom: 10px; display: block;"></i>
                            No orders found
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>
        
        <!-- Quick Actions -->
        <h2 style="color: #fff; font-size: 20px; margin-bottom: 15px;">Quick Actions</h2>
        <div class="quick-actions">
            <a href="products?action=new" class="action-card">
                <i class="fas fa-plus-circle"></i>
                <h3>Add Product</h3>
                <p>Create new watch listing</p>
            </a>
            
            <a href="orders?status=processing" class="action-card">
                <i class="fas fa-clock"></i>
                <h3>Process Orders</h3>
                <p><%= ordersByStatus != null && ordersByStatus.get("Processing") != null ? ordersByStatus.get("Processing") : 0 %> orders pending</p>
            </a>
            
            <a href="users" class="action-card">
                <i class="fas fa-users"></i>
                <h3>Manage Users</h3>
                <p>View and manage customers</p>
            </a>
            
            <a href="reports" class="action-card">
                <i class="fas fa-chart-line"></i>
                <h3>View Reports</h3>
                <p>Sales analytics & insights</p>
            </a>
        </div>
    </div>
</body>
</html>
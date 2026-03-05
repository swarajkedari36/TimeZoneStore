<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.timezone.model.Order, java.text.SimpleDateFormat" %>
<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    Integer totalOrders = (Integer) request.getAttribute("totalOrders");
    Integer pendingOrders = (Integer) request.getAttribute("pendingOrders");
    Integer shippedOrders = (Integer) request.getAttribute("shippedOrders");
    Integer deliveredOrders = (Integer) request.getAttribute("deliveredOrders");
    
    String selectedStatus = (String) request.getAttribute("selectedStatus");
    String fromDate = (String) request.getAttribute("fromDate");
    String toDate = (String) request.getAttribute("toDate");
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Orders - TimeZone Admin</title>
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
        
        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: #222;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            padding: 20px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .stat-card:hover, .stat-card.active {
            border-color: #c9a959;
            transform: translateY(-2px);
        }
        
        .stat-label {
            color: rgba(255,255,255,0.5);
            font-size: 14px;
            margin-bottom: 5px;
        }
        
        .stat-value {
            color: #fff;
            font-size: 28px;
            font-weight: 600;
        }
        
        
       /* Filter Section Enhanced */
.filter-section {
    background: #2a2a2a; /* Darker background */
    border: 1px solid #3a3a3a;
    border-radius: 12px;
    padding: 25px;
    margin-bottom: 30px;
    box-shadow: 0 4px 6px rgba(0,0,0,0.3);
}

.filter-title {
    color: #c9a959; /* Gold color */
    font-size: 18px;
    font-weight: 600;
    margin-bottom: 20px;
    border-bottom: 1px solid #3a3a3a;
    padding-bottom: 10px;
}

.filter-label {
    color: #c9a959; /* Gold color for labels */
    font-size: 13px;
    font-weight: 500;
    margin-bottom: 8px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.filter-control {
    width: 100%;
    padding: 12px 15px;
    background: #1e1e1e; /* Darker input background */
    border: 1px solid #3a3a3a;
    border-radius: 8px;
    color: #ffffff; /* White text */
    font-size: 14px;
    transition: all 0.3s;
}

.filter-control:focus {
    outline: none;
    border-color: #c9a959;
    background: #2a2a2a;
    box-shadow: 0 0 0 2px rgba(201,169,89,0.2);
}

.filter-control option {
    background: #1e1e1e;
    color: #ffffff;
    padding: 10px;
}

.filter-btn {
    padding: 12px 25px;
    background: #c9a959;
    color: #000000; /* Black text on gold */
    border: none;
    border-radius: 8px;
    font-weight: 600;
    font-size: 14px;
    cursor: pointer;
    transition: all 0.3s;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    height: 45px;
}

.filter-btn:hover {
    background: #d4b468;
    transform: translateY(-2px);
    box-shadow: 0 4px 10px rgba(201,169,89,0.3);
}

.reset-btn {
    padding: 12px 25px;
    background: transparent;
    color: #ffffff;
    border: 1px solid #3a3a3a;
    border-radius: 8px;
    font-weight: 500;
    text-decoration: none;
    transition: all 0.3s;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    height: 45px;
}

.reset-btn:hover {
    border-color: #c9a959;
    color: #c9a959;
    background: rgba(201,169,89,0.1);
}
        .reset-btn {
            padding: 10px 25px;
            background: transparent;
            color: #fff;
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 8px;
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .reset-btn:hover {
            border-color: #c9a959;
            color: #c9a959;
        }
        
        /* Orders Table */
        .orders-table {
            background: #222;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            padding: 20px;
            overflow-x: auto;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        th {
            text-align: left;
            padding: 15px;
            color: #c9a959;
            font-weight: 600;
            border-bottom: 2px solid #3a3a3a;
            background: #1e1e1e;
        }
        
        td {
            padding: 15px;
            color: #fff;
            border-bottom: 1px solid #3a3a3a;
        }
        
        tr:hover {
            background: rgba(255,255,255,0.05);
        }
        
        .status-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 50px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .status-Processing { background: rgba(255,193,7,0.2); color: #ffc107; border: 1px solid rgba(255,193,7,0.3); }
        .status-Confirmed { background: rgba(0,123,255,0.2); color: #007bff; border: 1px solid rgba(0,123,255,0.3); }
        .status-Shipped { background: rgba(40,167,69,0.2); color: #28a745; border: 1px solid rgba(40,167,69,0.3); }
        .status-Delivered { background: rgba(40,167,69,0.2); color: #28a745; border: 1px solid rgba(40,167,69,0.3); }
        .status-Cancelled { background: rgba(220,53,69,0.2); color: #dc3545; border: 1px solid rgba(220,53,69,0.3); }
        
        .view-btn {
            display: inline-block;
            padding: 6px 15px;
            background: rgba(201,169,89,0.1);
            color: #c9a959;
            border: 1px solid rgba(201,169,89,0.3);
            border-radius: 5px;
            text-decoration: none;
            font-size: 13px;
            transition: all 0.3s;
        }
        
        .view-btn:hover {
            background: #c9a959;
            color: #000;
        }
        
        .empty-state {
            text-align: center;
            padding: 50px;
            color: rgba(255,255,255,0.5);
        }
        
        .empty-state i {
            font-size: 60px;
            margin-bottom: 20px;
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
            <li><a href="orders" class="active"><i class="fas fa-shopping-bag"></i> Orders</a></li>
            <li><a href="users"><i class="fas fa-users"></i> Users</a></li>
            <li><a href="reviews"><i class="fas fa-star"></i> Reviews</a></li>
            <li><a href="reports"><i class="fas fa-chart-bar"></i> Reports</a></li>
            <li style="margin-top: 30px;"><a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>
    
    <!-- Main Content -->
    <div class="main-content">
        <div class="header">
            <h1>Manage Orders</h1>
        </div>
        
        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card <%= (selectedStatus == null || "All".equals(selectedStatus)) ? "active" : "" %>" onclick="filterByStatus('All')">
                <div class="stat-label">Total Orders</div>
                <div class="stat-value"><%= totalOrders != null ? totalOrders : 0 %></div>
            </div>
            <div class="stat-card <%= "Processing".equals(selectedStatus) ? "active" : "" %>" onclick="filterByStatus('Processing')">
                <div class="stat-label">Pending</div>
                <div class="stat-value"><%= pendingOrders != null ? pendingOrders : 0 %></div>
            </div>
            <div class="stat-card <%= "Shipped".equals(selectedStatus) ? "active" : "" %>" onclick="filterByStatus('Shipped')">
                <div class="stat-label">Shipped</div>
                <div class="stat-value"><%= shippedOrders != null ? shippedOrders : 0 %></div>
            </div>
            <div class="stat-card <%= "Delivered".equals(selectedStatus) ? "active" : "" %>" onclick="filterByStatus('Delivered')">
                <div class="stat-label">Delivered</div>
                <div class="stat-value"><%= deliveredOrders != null ? deliveredOrders : 0 %></div>
            </div>
        </div>
        
        <!-- Filter Section -->
        <div class="filter-section">
            <div class="filter-title">Filter Orders</div>
            <form class="filter-form" action="orders" method="get">
                <div class="filter-group">
                    <div class="filter-label">Status</div>
                    <select name="status" class="filter-control">
                        <option value="All">All Status</option>
                        <option value="Processing" <%= "Processing".equals(selectedStatus) ? "selected" : "" %>>Processing</option>
                        <option value="Confirmed" <%= "Confirmed".equals(selectedStatus) ? "selected" : "" %>>Confirmed</option>
                        <option value="Shipped" <%= "Shipped".equals(selectedStatus) ? "selected" : "" %>>Shipped</option>
                        <option value="Delivered" <%= "Delivered".equals(selectedStatus) ? "selected" : "" %>>Delivered</option>
                        <option value="Cancelled" <%= "Cancelled".equals(selectedStatus) ? "selected" : "" %>>Cancelled</option>
                    </select>
                </div>
                <div class="filter-group">
                    <div class="filter-label">From Date</div>
                    <input type="date" name="fromDate" class="filter-control" value="<%= fromDate != null ? fromDate : "" %>">
                </div>
                <div class="filter-group">
                    <div class="filter-label">To Date</div>
                    <input type="date" name="toDate" class="filter-control" value="<%= toDate != null ? toDate : "" %>">
                </div>
                <button type="submit" class="filter-btn">
                    <i class="fas fa-search me-2"></i> Apply Filters
                </button>
                <a href="orders" class="reset-btn">
                    <i class="fas fa-redo me-2"></i> Reset
                </a>
            </form>
        </div>
        
        <!-- Orders Table -->
        <div class="orders-table">
            <% if (orders != null && !orders.isEmpty()) { %>
                <table>
                    <thead>
                        <tr>
                            <th>Order #</th>
                            <th>Customer</th>
                            <th>Date</th>
                            <th>Total</th>
                            <th>Status</th>
                            <th>Tracking</th>
                            <th>Action</th>
                        </tr>
                    </thead>
       <tbody>
    <%
        List<Order> ordersList = (List<Order>) request.getAttribute("orders");
        if (ordersList != null && !ordersList.isEmpty()) {
            for (Order orderItem : ordersList) {
    %>
        <tr>
            <td><%= orderItem.getOrderNumber() %></td>
            <td>
                <%= orderItem.getCustomerName() != null ? orderItem.getCustomerName() : "N/A" %>
                <div style="font-size: 12px; color: rgba(255,255,255,0.5);">
                    <%= orderItem.getCustomerEmail() != null ? orderItem.getCustomerEmail() : "" %>
                </div>
            </td>
            <td><%= dateFormat.format(orderItem.getOrderDate()) %></td>
            <td>₹ <%= String.format("%,d", (int)orderItem.getTotalAmount()) %></td>
            <td>
                <span style="display: inline-block; padding: 5px 12px; border-radius: 50px; font-size: 12px; font-weight: 500; 
                    <% if ("Processing".equals(orderItem.getStatus())) { %>
                        background: rgba(255,193,7,0.2); color: #ffc107; border: 1px solid rgba(255,193,7,0.3);
                    <% } else if ("Confirmed".equals(orderItem.getStatus())) { %>
                        background: rgba(0,123,255,0.2); color: #007bff; border: 1px solid rgba(0,123,255,0.3);
                    <% } else if ("Shipped".equals(orderItem.getStatus())) { %>
                        background: rgba(40,167,69,0.2); color: #28a745; border: 1px solid rgba(40,167,69,0.3);
                    <% } else if ("Delivered".equals(orderItem.getStatus())) { %>
                        background: rgba(40,167,69,0.2); color: #28a745; border: 1px solid rgba(40,167,69,0.3);
                    <% } else if ("Cancelled".equals(orderItem.getStatus())) { %>
                        background: rgba(220,53,69,0.2); color: #dc3545; border: 1px solid rgba(220,53,69,0.3);
                    <% } else { %>
                        background: rgba(108,117,125,0.2); color: #6c757d; border: 1px solid rgba(108,117,125,0.3);
                    <% } %>">
                    <%= orderItem.getStatus() %>
                </span>
            </td>
            <td>
                <% if (orderItem.getTrackingNumber() != null) { %>
                    <span style="color: #c9a959;"><%= orderItem.getTrackingNumber() %></span>
                <% } else { %>
                    <span style="color: rgba(255,255,255,0.3);">Not assigned</span>
                <% } %>
            </td>
            <td>
                <a href="orders?action=view&id=<%= orderItem.getId() %>" class="view-btn">
                    <i class="fas fa-eye me-1"></i> View
                </a>
            </td>
        </tr>
    <%
            }
        } else {
    %>
        <tr>
            <td colspan="7" style="text-align: center; padding: 30px; color: rgba(255,255,255,0.5);">
                <i class="fas fa-box-open" style="font-size: 40px; margin-bottom: 10px; display: block;"></i>
                No orders found
            </td>
        </tr>
    <%
        }
    %>
</tbody>
                </table>
            <% } else { %>
                <div class="empty-state">
                    <i class="fas fa-shopping-bag"></i>
                    <h3>No Orders Found</h3>
                    <p>There are no orders matching your criteria.</p>
                </div>
            <% } %>
        </div>
    </div>
    
    <script>
        function filterByStatus(status) {
            window.location.href = 'orders?status=' + status;
        }
    </script>
</body>
</html>
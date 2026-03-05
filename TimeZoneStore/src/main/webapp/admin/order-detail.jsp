<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.timezone.model.Order, com.timezone.model.Watch, com.timezone.model.TrackingHistory, java.text.SimpleDateFormat" %>
<%
    Order order = (Order) request.getAttribute("order");
    String updated = request.getParameter("updated");
    String error = request.getParameter("error");
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
    SimpleDateFormat dateOnlyFormat = new SimpleDateFormat("yyyy-MM-dd");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Order Details - TimeZone Admin</title>
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
        
        /* Order Info Grid */
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .info-card {
            background: #222;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            padding: 20px;
        }
        
        .info-title {
            color: #c9a959;
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .info-row {
            display: flex;
            margin-bottom: 10px;
        }
        
        .info-label {
            width: 100px;
            color: rgba(255,255,255,0.5);
            font-size: 13px;
        }
        
        .info-value {
            flex: 1;
            color: #fff;
            font-size: 14px;
        }
        
         /* Status Badge */
        .status-badge {
            display: inline-block;
            padding: 6px 15px;
            border-radius: 50px;
            font-size: 13px;
            font-weight: 500;
        }
        
        .status-Processing { background: rgba(255,193,7,0.2); color: #ffc107; border: 1px solid rgba(255,193,7,0.3); }
        .status-Confirmed { background: rgba(0,123,255,0.2); color: #007bff; border: 1px solid rgba(0,123,255,0.3); }
        .status-Shipped { background: rgba(40,167,69,0.2); color: #28a745; border: 1px solid rgba(40,167,69,0.3); }
        .status-Delivered { background: rgba(40,167,69,0.2); color: #28a745; border: 1px solid rgba(40,167,69,0.3); }
        
        /* Update Form */
        .update-card {
            background: #222;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 30px;
        }
        
        .update-title {
            color: #fff;
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 20px;
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
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
        
        .form-control option {
            background: #333;
            color: #fff;
        }
        
        .update-btn {
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
        
        .update-btn:hover {
            background: #d4b468;
        }
        
        /* Order Items */
        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        
        .items-table th {
            text-align: left;
            padding: 12px;
            color: #c9a959;
            font-weight: 600;
            border-bottom: 2px solid #3a3a3a;
            background: #1e1e1e;
        }
        
        .items-table td {
            padding: 12px;
            color: #fff;
            border-bottom: 1px solid #3a3a3a;
        }
        
        .item-image {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 8px;
            border: 2px solid #c9a959;
        }
        
        /* Tracking Timeline */
        .timeline {
            margin-top: 20px;
        }
        
        .timeline-item {
            display: flex;
            gap: 15px;
            padding: 15px;
            border-left: 2px solid #c9a959;
            margin-left: 20px;
            position: relative;
            margin-bottom: 15px;
        }
        
        .timeline-item::before {
            content: '';
            width: 10px;
            height: 10px;
            background: #c9a959;
            border-radius: 50%;
            position: absolute;
            left: -6px;
            top: 20px;
        }
        
        .timeline-time {
            min-width: 150px;
            color: rgba(255,255,255,0.5);
            font-size: 13px;
        }
        
        .timeline-status {
            color: #c9a959;
            font-weight: 600;
            margin-bottom: 3px;
        }
        
        .timeline-desc {
            color: #fff;
            font-size: 14px;
        }
        
        .timeline-location {
            color: rgba(255,255,255,0.5);
            font-size: 12px;
            margin-top: 5px;
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
            <h1>Order Details - <%= order != null ? order.getOrderNumber() : "" %></h1>
            <a href="orders" class="back-btn">
                <i class="fas fa-arrow-left me-2"></i> Back to Orders
            </a>
        </div>
        
        <% if ("true".equals(updated)) { %>
            <div class="success-message">
                <i class="fas fa-check-circle"></i>
                Order updated successfully!
            </div>
        <% } %>
        
        <% if ("true".equals(error)) { %>
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i>
                Error updating order. Please try again.
            </div>
        <% } %>
        
        <% if (order != null) { %>
            <!-- Order Information Grid -->
            <div class="info-grid">
                <!-- Order Details -->
                <div class="info-card">
                    <div class="info-title">
                        <i class="fas fa-shopping-bag"></i> Order Details
                    </div>
                    <div class="info-row">
                        <div class="info-label">Order #</div>
                        <div class="info-value"><%= order.getOrderNumber() %></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Date</div>
                        <div class="info-value"><%= dateFormat.format(order.getOrderDate()) %></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Status</div>
                        <div class="info-value">
                            <span class="status-badge status-<%= order.getStatus() %>">
                                <%= order.getStatus() %>
                            </span>
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Total</div>
                        <div class="info-value">₹ <%= String.format("%,d", (int)order.getTotalAmount()) %></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Payment</div>
                        <div class="info-value"><%= order.getPaymentMethod() != null ? order.getPaymentMethod() : "Credit Card" %></div>
                    </div>
                </div>
                
                <!-- Customer Details -->
                <div class="info-card">
                    <div class="info-title">
                        <i class="fas fa-user"></i> Customer Details
                    </div>
                    <div class="info-row">
                        <div class="info-label">Name</div>
                        <div class="info-value"><%= order.getCustomerName() != null ? order.getCustomerName() : "N/A" %></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Email</div>
                        <div class="info-value"><%= order.getCustomerEmail() %></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Phone</div>
                        <div class="info-value"><%= order.getCustomerPhone() != null ? order.getCustomerPhone() : "N/A" %></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Address</div>
                        <div class="info-value"><%= order.getShippingAddress() != null ? order.getShippingAddress() : "N/A" %></div>
                    </div>
                </div>
                
                <!-- Tracking Details -->
                <div class="info-card">
                    <div class="info-title">
                        <i class="fas fa-truck"></i> Tracking Details
                    </div>
                    <div class="info-row">
                        <div class="info-label">Tracking #</div>
                        <div class="info-value"><%= order.getTrackingNumber() != null ? order.getTrackingNumber() : "Not assigned" %></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Carrier</div>
                        <div class="info-value"><%= order.getShippingCarrier() != null ? order.getShippingCarrier() : "Standard" %></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Est. Delivery</div>
                        <div class="info-value">
                            <%= order.getEstimatedDelivery() != null ? dateOnlyFormat.format(order.getEstimatedDelivery()) : "TBD" %>
                        </div>
                    </div>
                    <% if (order.getDeliveredDate() != null) { %>
                    <div class="info-row">
                        <div class="info-label">Delivered</div>
                        <div class="info-value"><%= dateFormat.format(order.getDeliveredDate()) %></div>
                    </div>
                    <% } %>
                </div>
            </div>
            
            <!-- Update Order Status Form -->
            <div class="update-card">
                <div class="update-title">
                    <i class="fas fa-edit me-2"></i> Update Order Status & Tracking
                </div>
                <form action="orders" method="post">
                    <input type="hidden" name="action" value="updateStatus">
                    <input type="hidden" name="orderId" value="<%= order.getId() %>">
                    
                    <%-- <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label">Status</label>
                            <select name="status" class="form-control">
                                <option value="Processing" <%= "Processing".equals(order.getStatus()) ? "selected" : "" %>>Processing</option>
                                <option value="Confirmed" <%= "Confirmed".equals(order.getStatus()) ? "selected" : "" %>>Confirmed</option>
                                <option value="Shipped" <%= "Shipped".equals(order.getStatus()) ? "selected" : "" %>>Shipped</option>
                                <option value="Delivered" <%= "Delivered".equals(order.getStatus()) ? "selected" : "" %>>Delivered</option>
                                <option value="Cancelled" <%= "Cancelled".equals(order.getStatus()) ? "selected" : "" %>>Cancelled</option>
                            </select>
                        </div> --%>
                        <div class="info-row">
    <div class="info-label">Status</div>
    <div class="info-value">
        <span style="display: inline-block; padding: 6px 15px; border-radius: 50px; font-size: 13px; font-weight: 500; 
            <% if ("Processing".equals(order.getStatus())) { %>
                background: rgba(255,193,7,0.2); color: #ffc107; border: 1px solid rgba(255,193,7,0.3);
            <% } else if ("Confirmed".equals(order.getStatus())) { %>
                background: rgba(0,123,255,0.2); color: #007bff; border: 1px solid rgba(0,123,255,0.3);
            <% } else if ("Shipped".equals(order.getStatus())) { %>
                background: rgba(40,167,69,0.2); color: #28a745; border: 1px solid rgba(40,167,69,0.3);
            <% } else if ("Delivered".equals(order.getStatus())) { %>
                background: rgba(40,167,69,0.2); color: #28a745; border: 1px solid rgba(40,167,69,0.3);
            <% } else if ("Cancelled".equals(order.getStatus())) { %>
                background: rgba(220,53,69,0.2); color: #dc3545; border: 1px solid rgba(220,53,69,0.3);
            <% } else { %>
                background: rgba(108,117,125,0.2); color: #6c757d; border: 1px solid rgba(108,117,125,0.3);
            <% } %>">
            <%= order.getStatus() %>
        </span>
    </div>
</div>
                        <div class="form-group">
                            <label class="form-label">Tracking Number</label>
                            <input type="text" name="trackingNumber" class="form-control" 
                                   value="<%= order.getTrackingNumber() != null ? order.getTrackingNumber() : "" %>"
                                   placeholder="e.g., 1Z999AA10123456784">
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Carrier</label>
                            <select name="carrier" class="form-control">
                                <option value="">Select Carrier</option>
                                <option value="FedEx" <%= "FedEx".equals(order.getShippingCarrier()) ? "selected" : "" %>>FedEx</option>
                                <option value="UPS" <%= "UPS".equals(order.getShippingCarrier()) ? "selected" : "" %>>UPS</option>
                                <option value="DHL" <%= "DHL".equals(order.getShippingCarrier()) ? "selected" : "" %>>DHL</option>
                                <option value="USPS" <%= "USPS".equals(order.getShippingCarrier()) ? "selected" : "" %>>USPS</option>
                                <option value="India Post" <%= "India Post".equals(order.getShippingCarrier()) ? "selected" : "" %>>India Post</option>
                                <option value="Delhivery" <%= "Delhivery".equals(order.getShippingCarrier()) ? "selected" : "" %>>Delhivery</option>
                                <option value="Blue Dart" <%= "Blue Dart".equals(order.getShippingCarrier()) ? "selected" : "" %>>Blue Dart</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Estimated Delivery</label>
                            <input type="date" name="estimatedDelivery" class="form-control"
                                   value="<%= order.getEstimatedDelivery() != null ? dateOnlyFormat.format(order.getEstimatedDelivery()) : "" %>">
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Current Location (Optional)</label>
                            <input type="text" name="location" class="form-control" 
                                   placeholder="e.g., Mumbai Distribution Center">
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Update Description</label>
                            <input type="text" name="description" class="form-control" 
                                   placeholder="e.g., Order has been shipped">
                        </div>
                    </div>
                    
                    <button type="submit" class="update-btn">
                        <i class="fas fa-save me-2"></i> Update Order
                    </button>
                </form>
            </div>
            
            <!-- Order Items -->
            <div class="update-card">
                <div class="update-title">
                    <i class="fas fa-box me-2"></i> Order Items
                </div>
                <table class="items-table">
                    <thead>
                        <tr>
                            <th>Image</th>
                            <th>Product</th>
                            <th>Brand</th>
                            <th>Price</th>
                            <th>Quantity</th>
                            <th>Subtotal</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Watch item : order.getItems()) { %>
                            <tr>
                                <td>
                                    <img src="<%= request.getContextPath() %>/images/<%= item.getImage() %>" 
                                         alt="<%= item.getName() %>" 
                                         class="item-image"
                                         onerror="this.src='<%= request.getContextPath() %>/images/placeholder.jpg'">
                                </td>
                                <td><%= item.getName() %></td>
                                <td><%= item.getBrand() %></td>
                                <td>₹ <%= String.format("%,d", (int)item.getPrice()) %></td>
                                <td><%= item.getQuantity() %></td>
                                <td>₹ <%= String.format("%,d", (int)(item.getPrice() * item.getQuantity())) %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            
     <!-- Tracking Timeline -->
<% if (order.getTrackingHistory() != null && !order.getTrackingHistory().isEmpty()) { %>
    <div class="update-card">
        <div class="update-title">
            <i class="fas fa-history me-2"></i> Tracking History
        </div>
        <div class="timeline">
            <% for (Order.TrackingHistory th : order.getTrackingHistory()) { %>
                <div class="timeline-item">
                    <div class="timeline-time"><%= dateFormat.format(th.getCreatedAt()) %></div>
                    <div>
                        <div class="timeline-status"><%= th.getStatus() %></div>
                        <div class="timeline-desc"><%= th.getDescription() != null ? th.getDescription() : "" %></div>
                        <% if (th.getLocation() != null && !th.getLocation().isEmpty()) { %>
                            <div class="timeline-location">
                                <i class="fas fa-map-marker-alt me-1"></i> <%= th.getLocation() %>
                            </div>
                        <% } %>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
<% } %>

<% } else { %>
    <div class="error-message">
        <i class="fas fa-exclamation-circle"></i>
        Order not found.
    </div>
<% } %>
</body>
</html>
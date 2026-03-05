<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.timezone.model.Watch" %>
<%
    List<Watch> products = (List<Watch>) request.getAttribute("products");
    String added = request.getParameter("added");
    String updated = request.getParameter("updated");
    String deleted = request.getParameter("deleted");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Products - TimeZone Admin</title>
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
        
        .add-btn {
            background: #c9a959;
            color: #000;
            padding: 12px 25px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s;
        }
        
        .add-btn:hover {
            background: #d4b468;
            transform: translateY(-2px);
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
        
        /* Products Table */
        .products-table {
            background: #222;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 15px;
            padding: 25px;
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
        
        .product-image {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 10px;
            border: 2px solid #c9a959;
        }
        
        .category-badge {
            background: rgba(201,169,89,0.2);
            color: #c9a959;
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .action-btns {
            display: flex;
            gap: 10px;
        }
        
        .edit-btn {
            background: rgba(0,123,255,0.1);
            color: #007bff;
            border: 1px solid rgba(0,123,255,0.3);
            padding: 6px 12px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 13px;
            transition: all 0.3s;
        }
        
        .edit-btn:hover {
            background: #007bff;
            color: #fff;
        }
        
        .delete-btn {
            background: rgba(220,53,69,0.1);
            color: #dc3545;
            border: 1px solid rgba(220,53,69,0.3);
            padding: 6px 12px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 13px;
            transition: all 0.3s;
        }
        
        .delete-btn:hover {
            background: #dc3545;
            color: #fff;
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
            <li><a href="products" class="active"><i class="fas fa-clock"></i> Products</a></li>
            <li><a href="orders"><i class="fas fa-shopping-bag"></i> Orders</a></li>
            <li><a href="users"><i class="fas fa-users"></i> Users</a></li>
            <li><a href="reviews"><i class="fas fa-star"></i> Reviews</a></li>
            <li><a href="reports"><i class="fas fa-chart-bar"></i> Reports</a></li>
            <li style="margin-top: 30px;"><a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>
    
    <!-- Main Content -->
    <div class="main-content">
        <div class="header">
            <h1>Manage Products</h1>
            <a href="product-form.jsp?action=new" class="add-btn">
                <i class="fas fa-plus"></i> Add New Product
            </a>
        </div>
        
        <!-- Messages -->
        <% if ("true".equals(added)) { %>
            <div class="success-message">
                <i class="fas fa-check-circle"></i>
                Product added successfully!
            </div>
        <% } %>
        
        <% if ("true".equals(updated)) { %>
            <div class="success-message">
                <i class="fas fa-check-circle"></i>
                Product updated successfully!
            </div>
        <% } %>
        
        <% if ("true".equals(deleted)) { %>
            <div class="success-message">
                <i class="fas fa-check-circle"></i>
                Product deleted successfully!
            </div>
        <% } %>
        
        <% if ("true".equals(error)) { %>
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i>
                An error occurred. Please try again.
            </div>
        <% } %>
        
        <!-- Products Table -->
        <div class="products-table">
            <% if (products != null && !products.isEmpty()) { %>
                <table>
                    <thead>
                        <tr>
                            <th>Image</th>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Brand</th>
                            <th>Price</th>
                            <th>Category</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Watch watch : products) { %>
                            <tr>
                                <td>
                                    <img src="<%= request.getContextPath() %>/images/<%= watch.getImage() %>" 
                                         alt="<%= watch.getName() %>" 
                                         class="product-image"
                                         onerror="this.src='<%= request.getContextPath() %>/images/placeholder.jpg'">
                                </td>
                                <td>#<%= watch.getId() %></td>
                                <td><%= watch.getName() %></td>
                                <td><%= watch.getBrand() %></td>
                                <td>₹ <%= String.format("%,d", (int)watch.getPrice()) %></td>
                                <td><span class="category-badge"><%= watch.getCategory() %></span></td>
                                <td>
                                    <div class="action-btns">
                                        <a href="products?action=edit&id=<%= watch.getId() %>" class="edit-btn">
                                            <i class="fas fa-edit"></i> Edit
                                        </a>
                                        <a href="products?action=delete&id=<%= watch.getId() %>" 
                                           class="delete-btn"
                                           onclick="return confirm('Are you sure you want to delete this product?')">
                                            <i class="fas fa-trash"></i> Delete
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <div class="empty-state">
                    <i class="fas fa-clock"></i>
                    <h3>No Products Found</h3>
                    <p>Click "Add New Product" to create your first watch listing.</p>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>
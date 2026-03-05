<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.timezone.model.Watch" %>
<%
    Watch watch = (Watch) request.getAttribute("watch");
    boolean editMode = request.getAttribute("editMode") != null && (boolean) request.getAttribute("editMode");
    
    // Debug output to console (check Eclipse console)
    if (editMode) {
        System.out.println("Edit Mode: true");
        if (watch != null) {
            System.out.println("Watch ID: " + watch.getId());
            System.out.println("Watch Name: " + watch.getName());
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= editMode ? "Edit" : "Add" %> Product - TimeZone Admin</title>
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
        
        /* Form */
        .form-container {
            background: #222;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 15px;
            padding: 30px;
            max-width: 800px;
        }
        
        .form-group {
            margin-bottom: 25px;
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
        
        .form-control {
            width: 100%;
            padding: 12px 15px;
            background: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 10px;
            color: #fff;
            font-size: 15px;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #c9a959;
            background: rgba(255,255,255,0.15);
        }
        
        .form-control::placeholder {
            color: rgba(255,255,255,0.4);
        }
        
        select.form-control {
            cursor: pointer;
        }
        
        select.form-control option {
            background: #333;
            color: #fff;
        }
        
        .image-preview {
            margin-top: 15px;
            padding: 20px;
            background: rgba(0,0,0,0.3);
            border-radius: 10px;
            text-align: center;
            border: 2px dashed rgba(255,255,255,0.2);
        }
        
        .image-preview img {
            max-width: 200px;
            max-height: 200px;
            object-fit: contain;
            border-radius: 10px;
            border: 2px solid #c9a959;
        }
        
        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        
        .submit-btn {
            padding: 14px 30px;
            background: #c9a959;
            color: #000;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .submit-btn:hover {
            background: #d4b468;
            transform: translateY(-2px);
        }
        
        .cancel-btn {
            padding: 14px 30px;
            background: transparent;
            color: #fff;
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 10px;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .cancel-btn:hover {
            border-color: #c9a959;
            color: #c9a959;
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
            <h1><%= editMode ? "Edit Product" : "Add New Product" %></h1>
            <a href="products" class="back-btn">
                <i class="fas fa-arrow-left me-2"></i> Back to Products
            </a>
        </div>
        
        <div class="form-container">
            <form action="products" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="<%= editMode ? "edit" : "add" %>">
                <% if (editMode && watch != null) { %>
                    <input type="hidden" name="id" value="<%= watch.getId() %>">
                <% } %>
                
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-tag"></i> Product Name
                    </label>
                    <input type="text" name="name" class="form-control" 
                           value="<%= editMode && watch != null ? watch.getName() : "" %>" 
                           placeholder="e.g., Classic Silver" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-building"></i> Brand
                    </label>
                    <input type="text" name="brand" class="form-control" 
                           value="<%= editMode && watch != null ? watch.getBrand() : "" %>" 
                           placeholder="e.g., Titan, Casio, Rolex" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-rupee-sign"></i> Price (₹)
                    </label>
                    <input type="number" name="price" class="form-control" 
                           value="<%= editMode && watch != null ? watch.getPrice() : "" %>" 
                           placeholder="e.g., 4999" step="0.01" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-list"></i> Category
                    </label>
                    <select name="category" class="form-control" required>
                        <option value="">Select Category</option>
                        <option value="Luxury" <%= editMode && watch != null && "Luxury".equals(watch.getCategory()) ? "selected" : "" %>>Luxury</option>
                        <option value="Sport" <%= editMode && watch != null && "Sport".equals(watch.getCategory()) ? "selected" : "" %>>Sport</option>
                        <option value="Diver" <%= editMode && watch != null && "Diver".equals(watch.getCategory()) ? "selected" : "" %>>Diver</option>
                        <option value="Chronograph" <%= editMode && watch != null && "Chronograph".equals(watch.getCategory()) ? "selected" : "" %>>Chronograph</option>
                        <option value="Smart" <%= editMode && watch != null && "Smart".equals(watch.getCategory()) ? "selected" : "" %>>Smart</option>
                        <option value="Dress" <%= editMode && watch != null && "Dress".equals(watch.getCategory()) ? "selected" : "" %>>Dress</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-image"></i> Product Image
                    </label>
                    <input type="file" name="image" class="form-control" accept="image/*" 
                           <%= !editMode ? "required" : "" %>>
                    
                    <% if (editMode && watch != null && watch.getImage() != null) { %>
                        <div class="image-preview">
                            <p style="color: rgba(255,255,255,0.5); margin-bottom: 10px;">Current Image:</p>
                            <img src="<%= request.getContextPath() %>/images/<%= watch.getImage() %>" 
                                 alt="Current product image"
                                 onerror="this.src='<%= request.getContextPath() %>/images/placeholder.jpg'">
                        </div>
                    <% } %>
                </div>
                
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-align-left"></i> Description
                    </label>
                    <textarea name="description" class="form-control" rows="5" 
                              placeholder="Enter product description..." required><%= editMode && watch != null ? watch.getDescription() : "" %></textarea>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="submit-btn">
                        <i class="fas fa-save"></i> <%= editMode ? "Update Product" : "Save Product" %>
                    </button>
                    <a href="products" class="cancel-btn">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.timezone.model.Watch" %>
<%
    List<Watch> wishlist = (List<Watch>) request.getAttribute("wishlist");
    String added = request.getParameter("added");
    String removed = request.getParameter("removed");
    String cleared = request.getParameter("cleared");
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Wishlist - TimeZone</title>
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
        
        .clear-btn {
            background: rgba(220, 53, 69, 0.1);
            color: #ff6b6b;
            padding: 10px 20px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s;
            border: 1px solid rgba(220, 53, 69, 0.3);
        }
        
        .clear-btn:hover {
            background: #dc3545;
            color: #fff;
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
        
        /* Wishlist Grid */
        .wishlist-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        
        /* Wishlist Card */
        .wishlist-card {
            background: rgba(30, 30, 30, 0.6);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            overflow: hidden;
            transition: all 0.3s;
            position: relative;
        }
        
        .wishlist-card:hover {
            transform: translateY(-5px);
            border-color: #c9a959;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        }
        
        /* Wishlist Badge */
        .wishlist-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: #c9a959;
            color: #000;
            width: 35px;
            height: 35px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            z-index: 2;
            cursor: pointer;
            transition: all 0.3s;
            border: none;
        }
        
        .wishlist-badge:hover {
            transform: scale(1.1);
            background: #ff6b6b;
        }
        
        /* Product Image */
        .product-image {
            height: 250px;
            padding: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(0, 0, 0, 0.3);
        }
        
        .product-image img {
            max-height: 200px;
            max-width: 100%;
            object-fit: contain;
            transition: transform 0.3s;
        }
        
        .wishlist-card:hover .product-image img {
            transform: scale(1.05);
        }
        
        /* Product Details */
        .product-details {
            padding: 20px;
            border-top: 1px solid rgba(255,255,255,0.1);
        }
        
        .product-brand {
            color: #c9a959;
            font-size: 14px;
            font-weight: 500;
            text-transform: uppercase;
            margin-bottom: 5px;
        }
        
        .product-name {
            color: #fff;
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        .product-price {
            color: #fff;
            font-size: 22px;
            font-weight: 600;
            margin-bottom: 15px;
        }
        
        .product-price small {
            color: rgba(255,255,255,0.5);
            font-size: 14px;
            font-weight: 400;
        }
        
        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 10px;
        }
        
        .add-to-cart-btn {
            flex: 2;
            background: #c9a959;
            color: #000;
            border: none;
            border-radius: 10px;
            padding: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .add-to-cart-btn:hover {
            background: #d4b468;
            transform: translateY(-2px);
        }
        
        .remove-btn {
            flex: 1;
            background: rgba(220, 53, 69, 0.1);
            color: #ff6b6b;
            border: 1px solid rgba(220, 53, 69, 0.3);
            border-radius: 10px;
            padding: 12px;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .remove-btn:hover {
            background: #dc3545;
            color: #fff;
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 80px 20px;
            background: rgba(30, 30, 30, 0.4);
            border-radius: 20px;
            border: 1px dashed rgba(255, 255, 255, 0.2);
        }
        
        .empty-state i {
            font-size: 80px;
            color: #c9a959;
            margin-bottom: 20px;
            opacity: 0.7;
        }
        
        .empty-state h2 {
            color: #fff;
            font-size: 32px;
            margin-bottom: 15px;
        }
        
        .empty-state p {
            color: rgba(255, 255, 255, 0.6);
            font-size: 18px;
            margin-bottom: 30px;
        }
        
        .shop-now-btn {
            background: #c9a959;
            color: #000;
            padding: 15px 40px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            display: inline-block;
            transition: all 0.3s;
        }
        
        .shop-now-btn:hover {
            background: #d4b468;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(201, 169, 89, 0.3);
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .wishlist-grid {
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
            <a href="addresses"><i class="fas fa-map-marker-alt"></i> Addresses</a>
        </div>
    </div>
</nav>

<div class="container">
    <!-- Page Header -->
    <div class="page-header">
        <h1>
            <i class="fas fa-heart"></i> My Wishlist
        </h1>
        <% if (wishlist != null && !wishlist.isEmpty()) { %>
            <a href="wishlist?action=clear" class="clear-btn" 
               onclick="return confirm('Clear all items from wishlist?')">
                <i class="fas fa-trash-alt"></i> Clear Wishlist
            </a>
        <% } %>
    </div>
    
    <!-- Success Messages -->
    <% if ("true".equals(added)) { %>
        <div class="success-message">
            <i class="fas fa-check-circle"></i>
            Item added to wishlist!
        </div>
    <% } %>
    
    <% if ("true".equals(removed)) { %>
        <div class="success-message">
            <i class="fas fa-check-circle"></i>
            Item removed from wishlist.
        </div>
    <% } %>
    
    <% if ("true".equals(cleared)) { %>
        <div class="success-message">
            <i class="fas fa-check-circle"></i>
            Wishlist cleared successfully.
        </div>
    <% } %>
    
    <!-- Wishlist Items -->
    <% if (wishlist != null && !wishlist.isEmpty()) { %>
        <div class="wishlist-grid">
            <% for (Watch watch : wishlist) { %>
                <div class="wishlist-card">
                    <!-- Remove button -->
                    <a href="wishlist?action=remove&id=<%= watch.getQuantity() %>" 
                       class="wishlist-badge"
                       onclick="return confirm('Remove from wishlist?')">
                        <i class="fas fa-times"></i>
                    </a>
                    
                    <!-- Product Image -->
                    <div class="product-image">
                        <img src="<%= request.getContextPath() %>/images/<%= watch.getImage() %>" 
                             alt="<%= watch.getName() %>"
                             onerror="this.src='<%= request.getContextPath() %>/images/placeholder.jpg'">
                    </div>
                    
                    <!-- Product Details -->
                    <div class="product-details">
                        <div class="product-brand"><%= watch.getBrand() %></div>
                        <h3 class="product-name"><%= watch.getName() %></h3>
                        <div class="product-price">
                            ₹ <%= String.format("%,d", (int)watch.getPrice()) %>
                        </div>
                        
                        <!-- Action Buttons -->
                        <div class="action-buttons">
                            <form action="addToCart" method="post" style="flex: 2;">
                                <input type="hidden" name="id" value="<%= watch.getId() %>">
                                <button type="submit" class="add-to-cart-btn">
                                    <i class="fas fa-shopping-cart"></i> Add to Cart
                                </button>
                            </form>
                            <a href="products" class="remove-btn">
                                <i class="fas fa-eye"></i>
                            </a>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    <% } else { %>
        <!-- Empty State -->
        <div class="empty-state">
            <i class="fas fa-heart-broken"></i>
            <h2>Your Wishlist is Empty</h2>
            <p>Save your favorite watches and find them here!</p>
            <a href="products" class="shop-now-btn">
                <i class="fas fa-store me-2"></i> Browse Watches
            </a>
        </div>
    <% } %>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Auto-hide messages after 3 seconds
    setTimeout(function() {
        document.querySelectorAll('.success-message').forEach(msg => {
            msg.style.transition = 'opacity 0.5s';
            msg.style.opacity = '0';
            setTimeout(() => msg.remove(), 500);
        });
    }, 3000);
</script>

</body>
</html>
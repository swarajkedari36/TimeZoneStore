<%@ page import="java.util.*, com.timezone.model.Order, com.timezone.model.Watch, java.text.SimpleDateFormat"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - TimeZone</title>
    
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
            background: url('<%=request.getContextPath()%>/images/bg.jpg') no-repeat center center fixed;
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
            z-index: -1;
        }
        
        /* Navbar */
        .navbar {
            background: rgba(0, 0, 0, 0.8);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255,255,255,0.1);
            padding: 1rem 0;
        }
        
        .navbar-brand {
            font-size: 1.8rem;
            font-weight: 600;
            color: #fff !important;
        }
        
        .navbar-brand span {
            color: #c9a959;
        }
        
        /* Orders Container */
        .orders-container {
            padding: 40px 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .page-header {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .page-header h1 {
            font-size: 42px;
            font-weight: 600;
            color: #fff;
            margin-bottom: 10px;
        }
        
        .page-header p {
            color: rgba(255,255,255,0.7);
            font-size: 18px;
        }
        
        /* Order Card */
        .order-card {
            background: rgba(30, 30, 30, 0.7);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 20px;
            margin-bottom: 30px;
            overflow: hidden;
        }
        
        .order-header {
            background: rgba(0, 0, 0, 0.5);
            padding: 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .order-number {
            font-size: 18px;
            font-weight: 600;
            color: #c9a959;
        }
        
        .order-number span {
            color: #fff;
            font-weight: 400;
            margin-left: 10px;
        }
        
        .order-status {
            padding: 5px 15px;
            border-radius: 50px;
            font-weight: 500;
            font-size: 14px;
        }
        
        .status-delivered {
            background: rgba(40, 167, 69, 0.2);
            color: #28a745;
            border: 1px solid rgba(40, 167, 69, 0.3);
        }
        
        .status-processing {
            background: rgba(255, 193, 7, 0.2);
            color: #ffc107;
            border: 1px solid rgba(255, 193, 7, 0.3);
        }
        
        .status-shipped {
            background: rgba(0, 123, 255, 0.2);
            color: #007bff;
            border: 1px solid rgba(0, 123, 255, 0.3);
        }
        
        .order-body {
            padding: 20px;
        }
        
        .order-info {
            display: flex;
            gap: 30px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        
        .info-item {
            color: rgba(255,255,255,0.8);
        }
        
        .info-item i {
            color: #c9a959;
            margin-right: 8px;
            width: 20px;
        }
        
        /* Order Items */
        .order-items {
            border-top: 1px solid rgba(255,255,255,0.1);
            padding-top: 20px;
        }
        
        .items-title {
            font-size: 16px;
            font-weight: 600;
            color: #fff;
            margin-bottom: 15px;
        }
        
        .item-row {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 10px 0;
            border-bottom: 1px solid rgba(255,255,255,0.05);
        }
        
        .item-row:last-child {
            border-bottom: none;
        }
        
        .item-image {
            width: 60px;
            height: 60px;
            border-radius: 10px;
            object-fit: cover;
            border: 2px solid rgba(201, 169, 89, 0.3);
        }
        
        .item-details {
            flex: 1;
        }
        
        .item-name {
            color: #fff;
            font-weight: 500;
            margin-bottom: 5px;
        }
        
        .item-meta {
            color: rgba(255,255,255,0.5);
            font-size: 14px;
        }
        
        .item-price {
            color: #c9a959;
            font-weight: 600;
        }
        
        .order-total {
            margin-top: 20px;
            text-align: right;
            font-size: 18px;
            font-weight: 600;
            color: #c9a959;
            padding-top: 15px;
            border-top: 1px solid rgba(255,255,255,0.1);
        }
        
        /* Empty State */
        .empty-orders {
            text-align: center;
            padding: 80px 20px;
            background: rgba(30, 30, 30, 0.5);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            border: 1px solid rgba(255,255,255,0.1);
        }
        
        .empty-orders i {
            font-size: 80px;
            color: #c9a959;
            margin-bottom: 20px;
            opacity: 0.7;
        }
        
        .empty-orders h2 {
            font-size: 32px;
            color: #fff;
            margin-bottom: 15px;
        }
        
        .empty-orders p {
            color: rgba(255,255,255,0.7);
            margin-bottom: 30px;
        }
        
        .btn-shop {
            background: #c9a959;
            color: #000;
            padding: 12px 30px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            display: inline-block;
            transition: all 0.3s;
        }
        
        .btn-shop:hover {
            background: #d4b468;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(201, 169, 89, 0.3);
            color: #000;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .order-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .order-info {
                gap: 15px;
            }
        }
        /* Track Order Button */
.track-order-btn {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    background: rgba(201, 169, 89, 0.15);
    color: #c9a959;
    padding: 10px 25px;
    border-radius: 50px;
    text-decoration: none;
    font-weight: 500;
    border: 1px solid rgba(201, 169, 89, 0.3);
    transition: all 0.3s;
}

.track-order-btn:hover {
    background: #c9a959;
    color: #000;
    transform: translateX(5px);
}

.track-order-btn i:last-child {
    transition: transform 0.3s;
}

.track-order-btn:hover i:last-child {
    transform: translateX(5px);
}

/* Different status colors for tracking */
.tracking-processing { color: #ffc107; }
.tracking-shipped { color: #007bff; }
.tracking-delivered { color: #28a745; }
        /* Footer Styles */
.footer {
    background: rgba(10, 10, 10, 0.95);
    backdrop-filter: blur(10px);
    border-top: 1px solid rgba(201, 169, 89, 0.3);
    padding: 60px 0 20px;
    margin-top: 60px;
    color: #fff;
    position: relative;
    z-index: 10;
}

.footer::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 1px;
    background: linear-gradient(90deg, transparent, #c9a959, transparent);
}

.footer-content {
    display: grid;
    grid-template-columns: 2fr 1fr 1fr 1.5fr;
    gap: 40px;
    margin-bottom: 50px;
}

.footer-section h3, .footer-section h4 {
    color: #fff;
    margin-bottom: 20px;
    position: relative;
    padding-bottom: 10px;
}

.footer-section h3 {
    font-size: 1.8rem;
    font-weight: 600;
    letter-spacing: -0.5px;
}

.footer-section h3 span {
    color: #c9a959;
}

.footer-section h4 {
    font-size: 1.2rem;
    font-weight: 500;
}

.footer-section h4::after {
    content: '';
    position: absolute;
    bottom: 0;
    left: 0;
    width: 40px;
    height: 2px;
    background: #c9a959;
}

.footer-brand {
    margin-bottom: 15px;
}

.footer-tagline {
    color: #c9a959;
    font-size: 14px;
    font-weight: 500;
    margin-bottom: 15px;
    letter-spacing: 0.5px;
}

.footer-description {
    color: rgba(255, 255, 255, 0.6);
    font-size: 14px;
    line-height: 1.6;
    margin-bottom: 20px;
}

/* Social Links */
.social-links {
    display: flex;
    gap: 15px;
}

.social-link {
    width: 36px;
    height: 36px;
    background: rgba(201, 169, 89, 0.1);
    border: 1px solid rgba(201, 169, 89, 0.3);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #c9a959;
    transition: all 0.3s;
    text-decoration: none;
}

.social-link:hover {
    background: #c9a959;
    color: #000;
    transform: translateY(-3px);
}

/* Footer Links */
.footer-links {
    list-style: none;
    padding: 0;
}

.footer-links li {
    margin-bottom: 12px;
}

.footer-links a {
    color: rgba(255, 255, 255, 0.7);
    text-decoration: none;
    transition: all 0.3s;
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 14px;
}

.footer-links a i {
    font-size: 12px;
    color: #c9a959;
    transition: transform 0.3s;
}

.footer-links a:hover {
    color: #c9a959;
    transform: translateX(5px);
}

.footer-links a:hover i {
    transform: translateX(3px);
}

/* Contact Info */
.contact-info {
    list-style: none;
    padding: 0;
}

.contact-info li {
    color: rgba(255, 255, 255, 0.7);
    margin-bottom: 15px;
    display: flex;
    align-items: flex-start;
    gap: 10px;
    font-size: 14px;
    line-height: 1.5;
}

.contact-info li i {
    color: #c9a959;
    width: 20px;
    margin-top: 3px;
}

/* Newsletter */
.newsletter {
    text-align: center;
    padding: 40px 0;
    border-top: 1px solid rgba(255, 255, 255, 0.1);
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    margin-bottom: 30px;
}

.newsletter h4 {
    color: #fff;
    font-size: 1.3rem;
    margin-bottom: 10px;
}

.newsletter p {
    color: rgba(255, 255, 255, 0.6);
    margin-bottom: 20px;
}

.newsletter-form {
    display: flex;
    max-width: 500px;
    margin: 0 auto;
    gap: 10px;
}

.newsletter-form input {
    flex: 1;
    padding: 12px 20px;
    border: 1px solid rgba(255, 255, 255, 0.2);
    background: rgba(255, 255, 255, 0.05);
    border-radius: 50px;
    color: #fff;
    font-size: 14px;
    transition: all 0.3s;
}

.newsletter-form input:focus {
    outline: none;
    border-color: #c9a959;
    background: rgba(255, 255, 255, 0.1);
}

.newsletter-form input::placeholder {
    color: rgba(255, 255, 255, 0.4);
}

.newsletter-form button {
    padding: 12px 30px;
    background: #c9a959;
    color: #000;
    border: none;
    border-radius: 50px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s;
}

.newsletter-form button:hover {
    background: #d4b468;
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(201, 169, 89, 0.3);
}

/* Footer Bottom */
.footer-bottom {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 20px;
    color: rgba(255, 255, 255, 0.5);
    font-size: 13px;
}

.copyright a {
    color: rgba(255, 255, 255, 0.6);
    text-decoration: none;
    transition: color 0.3s;
}

.copyright a:hover {
    color: #c9a959;
}

.payment-methods {
    display: flex;
    gap: 15px;
    font-size: 24px;
}

.payment-methods i {
    color: rgba(255, 255, 255, 0.4);
    transition: color 0.3s;
}

.payment-methods i:hover {
    color: #c9a959;
}

/* Responsive */
@media (max-width: 992px) {
    .footer-content {
        grid-template-columns: repeat(2, 1fr);
    }
}

@media (max-width: 768px) {
    .footer-content {
        grid-template-columns: 1fr;
        gap: 30px;
    }
    
    .newsletter-form {
        flex-direction: column;
    }
    
    .footer-bottom {
        flex-direction: column;
        text-align: center;
    }
    
    .payment-methods {
        justify-content: center;
    }
}
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar">
    <div class="container">
        <a class="navbar-brand" href="<%=request.getContextPath()%>/products">
            ⌚ Time<span>Zone</span>
        </a>
        <div>
            <a href="<%=request.getContextPath()%>/products" class="text-white text-decoration-none me-4">
                <i class="fas fa-store me-1"></i> Shop
            </a>
            <a href="<%=request.getContextPath()%>/cart.jsp" class="text-white text-decoration-none me-4">
                <i class="fas fa-shopping-bag me-1"></i> Cart
            </a>
            <%
    List<Watch> cart = (List<Watch>) session.getAttribute("cart");
    int cartItemCount = 0;
    
    if (cart != null) {
        cartItemCount = cart.size();
    }
%>
            <a href="<%=request.getContextPath()%>/orders" class="text-white text-decoration-none">
                <i class="fas fa-box me-1"></i> My Orders
            </a>
        </div>
    </div>
</nav>

<div class="orders-container">
    <div class="page-header">
        <h1>My Orders</h1>
        <p>Track and manage your watch orders</p>
    </div>
    
    <% if (orders != null && !orders.isEmpty()) { %>
        <% for (Order order : orders) { %>
            <div class="order-card">
                <div class="order-header">
                    <div class="order-number">
                        Order #<span><%= order.getOrderNumber() %></span>
                    </div>
                    <div class="order-status status-<%= order.getStatus().toLowerCase() %>">
                        <%= order.getStatus() %>
                    </div>
                </div>
                
                <div class="order-body">
                    <div class="order-info">
                        <div class="info-item">
                            <i class="fas fa-calendar"></i>
                            <%= dateFormat.format(order.getOrderDate()) %>
                        </div>
                        <div class="info-item">
                            <i class="fas fa-credit-card"></i>
                            <%= order.getPaymentMethod() != null ? order.getPaymentMethod() : "Credit Card" %>
                        </div>
                        <div class="info-item">
                            <i class="fas fa-map-marker-alt"></i>
                            <%= order.getShippingAddress() != null ? order.getShippingAddress() : "Standard Shipping" %>
                        </div>
                    </div>
                    
                    <div class="order-items">
                        <div class="items-title">Items in this order:</div>
                        <% for (Watch item : order.getItems()) { %>
                            <div class="item-row">
                                <img src="<%= request.getContextPath() %>/images/<%= item.getImage() %>" 
                                     alt="<%= item.getName() %>" 
                                     class="item-image"
                                     onerror="this.src='<%= request.getContextPath() %>/images/placeholder.jpg'">
                                <div class="item-details">
                                    <div class="item-name"><%= item.getName() %></div>
                                    <div class="item-meta"><%= item.getBrand() %> | Qty: <%= item.getQuantity() %></div>
                                </div>
                                <div class="item-price">₹ <%= String.format("%,d", (int)(item.getPrice() * item.getQuantity())) %></div>
                            </div>
                        <% } %>
                        
                        <div class="order-total">
                            Total: ₹ <%= String.format("%,d", (int)order.getTotalAmount()) %>
                        </div>
                         <!-- 👇 TRACK ORDER BUTTON - ADD THIS SECTION 👇 -->
            <div style="margin-top: 20px; text-align: right;">
                <a href="<%=request.getContextPath()%>/track-order?orderNumber=<%= order.getOrderNumber() %>" 
                   class="track-order-btn"
                   style="display: inline-flex; align-items: center; gap: 10px; background: rgba(201, 169, 89, 0.15); color: #c9a959; padding: 10px 25px; border-radius: 50px; text-decoration: none; font-weight: 500; border: 1px solid rgba(201, 169, 89, 0.3); transition: all 0.3s;">
                    <i class="fas fa-truck"></i> Track Order
                    <i class="fas fa-arrow-right" style="font-size: 12px;"></i>
                </a>
            </div>
                    </div>
                </div>
            </div>
        <% } %>
    <% } else { %>
        <div class="empty-orders">
            <i class="fas fa-box-open"></i>
            <h2>No Orders Yet</h2>
            <p>You haven't placed any orders yet. Start shopping to see your orders here!</p>
            <a href="<%=request.getContextPath()%>/products" class="btn-shop">
                <i class="fas fa-shopping-bag me-2"></i>Start Shopping
            </a>
        </div>
    <% } %>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<!-- Footer -->
<footer class="footer">
    <div class="container">
        <div class="footer-content">
            <!-- Brand Section -->
            <div class="footer-section">
                <h3 class="footer-brand">
                    ⌚ Time<span>Zone</span>
                </h3>
                <p class="footer-tagline">Timeless Elegance, Precision Crafted</p>
                <p class="footer-description">
                    Discover our collection of premium watches crafted for style & precision. 
                    Each timepiece tells a unique story.
                </p>
                <div class="social-links">
                    <a href="#" class="social-link"><i class="fab fa-instagram"></i></a>
                    <a href="#" class="social-link"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="social-link"><i class="fab fa-twitter"></i></a>
                    <a href="#" class="social-link"><i class="fab fa-youtube"></i></a>
                </div>
            </div>

            <!-- Quick Links -->
            <div class="footer-section">
                <h4>Quick Links</h4>
                <ul class="footer-links">
                    <li><a href="<%=request.getContextPath()%>/products"><i class="fas fa-chevron-right"></i> Shop</a></li>
                    <li><a href="<%=request.getContextPath()%>/cart.jsp"><i class="fas fa-chevron-right"></i> Cart</a></li>
                    <li><a href="<%=request.getContextPath()%>/orders"><i class="fas fa-chevron-right"></i> My Orders</a></li>
                    <!-- 👇 NEW PROFILE LINK ADDED HERE 👇 -->
                    <li><a href="<%=request.getContextPath()%>/profile"><i class="fas fa-chevron-right"></i> My Profile</a></li>
                    <!-- 👇 NEW WISHLIST LINK ADDED HERE 👇 -->
                    <li><a href="<%=request.getContextPath()%>/wishlist"><i class="fas fa-chevron-right"></i> Wishlist</a></li>
                    <!-- In Quick Links section -->
<li><a href="<%=request.getContextPath()%>/track-order"><i class="fas fa-chevron-right"></i> Track Order</a></li>
                </ul>
            </div>

            <!-- Categories -->
            <div class="footer-section">
                <h4>Categories</h4>
                <ul class="footer-links">
                    <li><a href="#"><i class="fas fa-chevron-right"></i> Luxury</a></li>
                    <li><a href="#"><i class="fas fa-chevron-right"></i> Sport</a></li>
                    <li><a href="#"><i class="fas fa-chevron-right"></i> Diver</a></li>
                    <li><a href="#"><i class="fas fa-chevron-right"></i> Chronograph</a></li>
                    <li><a href="#"><i class="fas fa-chevron-right"></i> Smart</a></li>
                    <li><a href="#"><i class="fas fa-chevron-right"></i> Dress</a></li>
                </ul>
            </div>

            <!-- Contact Info -->
            <div class="footer-section">
                <h4>Contact Us</h4>
                <ul class="contact-info">
                    <li><i class="fas fa-map-marker-alt"></i> 123 Watch Tower, Pune, India</li>
                    <li><i class="fas fa-phone"></i> +91 98765 43210</li>
                    <li><i class="fas fa-envelope"></i> contact.timezonewatches@gmail.com</li>
                    <li><i class="fas fa-clock"></i> Mon - Sat: 10AM - 8PM</li>
                </ul>
            </div>
        </div>

        <!-- Newsletter Section -->
        <div class="newsletter">
            <h4>Subscribe to Our Newsletter</h4>
            <p>Get updates about new collections and special offers</p>
            <form class="newsletter-form" action="#" method="post">
                <input type="email" placeholder="Your email address" required>
                <button type="submit">Subscribe</button>
            </form>
        </div>

        <!-- Bottom Bar -->
        <div class="footer-bottom">
            <div class="copyright">
                &copy; 2026 TimeZone. All rights reserved. | <a href="#">Privacy Policy</a> | <a href="#">Terms of Service</a>
            </div>
            <div class="payment-methods">
                <i class="fab fa-cc-visa"></i>
                <i class="fab fa-cc-mastercard"></i>
                <i class="fab fa-cc-amex"></i>
                <i class="fab fa-cc-paypal"></i>
                <i class="fab fa-google-pay"></i>
                <i class="fab fa-apple-pay"></i>
            </div>
        </div>
    </div>
    <!-- Admin Quick Access (Hidden) -->
<div style="text-align: center; margin-top: 10px; opacity: 0.15; font-size: 10px;">
    <a href="<%=request.getContextPath()%>/admin/login" style="color: #666; text-decoration: none;" title="Admin Access">
        <i class="fas fa-tools"></i> ⚙️
    </a>
</div>
</footer>
</body>
</html>
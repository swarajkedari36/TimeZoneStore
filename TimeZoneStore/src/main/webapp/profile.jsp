<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    String success = request.getParameter("success");
    String error = request.getParameter("error");
    
    Integer userId = (Integer) request.getAttribute("userId");
    String name = (String) request.getAttribute("name");
    String email = (String) request.getAttribute("email");
    String phone = (String) request.getAttribute("phone");
    java.util.Date createdAt = (java.util.Date) request.getAttribute("createdAt");
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Profile - TimeZone</title>
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
        }
        
        .navbar-brand span {
            color: #c9a959;
        }
        
        /* Profile Card */
        .profile-card {
            background: rgba(20, 20, 20, 0.6);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 30px;
            padding: 40px;
            max-width: 800px;
            margin: 0 auto;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
        }
        
        .profile-header {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .profile-avatar {
            width: 120px;
            height: 120px;
            background: rgba(201, 169, 89, 0.2);
            border: 3px solid #c9a959;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
        }
        
        .profile-avatar i {
            font-size: 50px;
            color: #c9a959;
        }
        
        .profile-header h2 {
            color: #fff;
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .profile-header p {
            color: rgba(255,255,255,0.6);
            font-size: 14px;
        }
        
        .member-since {
            background: rgba(255,255,255,0.05);
            padding: 8px 20px;
            border-radius: 50px;
            display: inline-block;
            color: #c9a959;
            font-size: 13px;
            margin-top: 10px;
        }
        
        /* Navigation Tabs */
        .profile-tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            padding-bottom: 20px;
            flex-wrap: wrap;
        }
        
        .tab-btn {
            background: transparent;
            border: none;
            color: rgba(255,255,255,0.6);
            padding: 10px 20px;
            border-radius: 50px;
            font-weight: 500;
            transition: all 0.3s;
            cursor: pointer;
        }
        
        .tab-btn i {
            margin-right: 8px;
        }
        
        .tab-btn:hover, .tab-btn.active {
            background: #c9a959;
            color: #000;
        }
        
        /* Tab Content */
        .tab-content {
            display: none;
        }
        
        .tab-content.active {
            display: block;
        }
        
        /* Form Styles */
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
            background: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 15px;
            padding: 12px 20px;
            color: #fff;
            margin-bottom: 20px;
        }
        
        .form-control:focus {
            background: rgba(255,255,255,0.15);
            border-color: #c9a959;
            outline: none;
            color: #fff;
        }
        
        .form-control[readonly] {
            background: rgba(255,255,255,0.05);
            cursor: not-allowed;
        }
        
        .save-btn {
            background: #c9a959;
            color: #000;
            border: none;
            border-radius: 15px;
            padding: 12px 30px;
            font-weight: 600;
            width: 100%;
            transition: all 0.3s;
        }
        
        .save-btn:hover {
            background: #d4b468;
            transform: translateY(-2px);
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
        
        /* Responsive */
        @media (max-width: 768px) {
            .profile-card {
                padding: 30px 20px;
            }
            
            .profile-tabs {
                justify-content: center;
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
        <div>
            <a href="products" class="text-white text-decoration-none me-4">
                <i class="fas fa-store"></i> Shop
            </a>
            <a href="cart.jsp" class="text-white text-decoration-none me-4">
                <i class="fas fa-shopping-bag"></i> Cart
            </a>
            <a href="orders" class="text-white text-decoration-none me-4">
                <i class="fas fa-box"></i> Orders
            </a>
            <a href="wishlist" class="text-white text-decoration-none">
                <i class="fas fa-heart"></i> Wishlist
            </a>
        </div>
    </div>
</nav>

<div class="container">
    <div class="profile-card">
        
        <!-- Success/Error Messages -->
        <% if ("updated".equals(success)) { %>
            <div class="success-message">
                <i class="fas fa-check-circle"></i>
                Profile updated successfully!
            </div>
        <% } %>
        
        <% if ("true".equals(error)) { %>
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i>
                Error updating profile. Please try again.
            </div>
        <% } %>
        
        <!-- Profile Header -->
        <div class="profile-header">
            <div class="profile-avatar">
                <i class="fas fa-user"></i>
            </div>
            <h2><%= name != null ? name : "User" %></h2>
            <p><%= email %></p>
            <div class="member-since">
                <i class="fas fa-calendar-alt me-2"></i>
                Member since <%= createdAt != null ? dateFormat.format(createdAt) : "N/A" %>
            </div>
        </div>
        
        <!-- Navigation Tabs -->
        <div class="profile-tabs">
            <button class="tab-btn active" onclick="showTab('profile')">
                <i class="fas fa-user"></i> Profile
            </button>
            <button class="tab-btn" onclick="showTab('password')">
                <i class="fas fa-lock"></i> Change Password
            </button>
            <button class="tab-btn" onclick="showTab('addresses')">
                <i class="fas fa-map-marker-alt"></i> Addresses
            </button>
        </div>
        
        <!-- Profile Tab -->
        <div id="profile-tab" class="tab-content active">
            <form action="profile" method="post">
                <div class="mb-3">
                    <label class="form-label">
                        <i class="fas fa-user"></i> Full Name
                    </label>
                    <input type="text" name="name" class="form-control" 
                           value="<%= name != null ? name : "" %>" required>
                </div>
                
                <div class="mb-3">
                    <label class="form-label">
                        <i class="fas fa-envelope"></i> Email Address
                    </label>
                    <input type="email" class="form-control" 
                           value="<%= email != null ? email : "" %>" readonly>
                </div>
                
                <div class="mb-3">
                    <label class="form-label">
                        <i class="fas fa-phone"></i> Phone Number
                    </label>
                    <input type="tel" name="phone" class="form-control" 
                           value="<%= phone != null ? phone : "" %>" 
                           placeholder="Enter your phone number">
                </div>
                
                <button type="submit" class="save-btn">
                    <i class="fas fa-save me-2"></i> Save Changes
                </button>
            </form>
        </div>
        
        <!-- Change Password Tab -->
        <div id="password-tab" class="tab-content">
            <form action="change-password" method="post">
                <div class="mb-3">
                    <label class="form-label">
                        <i class="fas fa-lock"></i> Current Password
                    </label>
                    <input type="password" name="currentPassword" class="form-control" required>
                </div>
                
                <div class="mb-3">
                    <label class="form-label">
                        <i class="fas fa-lock"></i> New Password
                    </label>
                    <input type="password" name="newPassword" class="form-control" required>
                </div>
                
                <div class="mb-3">
                    <label class="form-label">
                        <i class="fas fa-lock"></i> Confirm New Password
                    </label>
                    <input type="password" name="confirmPassword" class="form-control" required>
                </div>
                
                <button type="submit" class="save-btn">
                    <i class="fas fa-key me-2"></i> Update Password
                </button>
            </form>
        </div>
        
        <!-- Addresses Tab -->
        <div id="addresses-tab" class="tab-content">
            <div style="text-align: center; margin-bottom: 20px;">
                <a href="addresses?action=new" class="save-btn" style="display: inline-block; width: auto; padding: 10px 25px;">
                    <i class="fas fa-plus me-2"></i> Add New Address
                </a>
            </div>
            
            <div style="color: rgba(255,255,255,0.6); text-align: center; padding: 30px;">
                <i class="fas fa-map-marker-alt" style="font-size: 50px; color: #c9a959; margin-bottom: 15px;"></i>
                <p>Your saved addresses will appear here.</p>
                <p style="font-size: 14px;">Click "Add New Address" to get started.</p>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function showTab(tabName) {
        // Hide all tabs
        document.getElementById('profile-tab').classList.remove('active');
        document.getElementById('password-tab').classList.remove('active');
        document.getElementById('addresses-tab').classList.remove('active');
        
        // Remove active class from all buttons
        document.querySelectorAll('.tab-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        
        // Show selected tab
        document.getElementById(tabName + '-tab').classList.add('active');
        
        // Add active class to clicked button
        event.target.classList.add('active');
    }
    
    // Check URL for tab parameter
    const urlParams = new URLSearchParams(window.location.search);
    const tab = urlParams.get('tab');
    if (tab === 'password') {
        showTab('password');
    } else if (tab === 'addresses') {
        showTab('addresses');
    }
</script>
<%-- <!-- Footer -->
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
                </p>\
        
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
                    <li><a href="#"><i class="fas fa-chevron-right"></i> Track Order</a></li>
                </ul>
            </div>
            </div>
              </div>
        --%>
</body>
</html>
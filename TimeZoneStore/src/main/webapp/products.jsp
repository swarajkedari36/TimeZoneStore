
<%@ page import="java.util.*, com.timezone.model.Watch"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>TimeZone - Premium Watch Collection</title>

<!-- Bootstrap 5 -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<!-- Font Awesome -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<!-- Google Fonts -->
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
	rel="stylesheet">

<style>
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	background: url('<%=request.getContextPath()%>/images/bg.jpg') no-repeat
		center center fixed;
	background-size: cover;
	font-family: 'Inter', sans-serif;
	min-height: 100vh;
}
/* Navbar Links */
.nav-link {
    color: white;
    text-decoration: none;
    padding: 8px 15px;
    border-radius: 50px;
    transition: all 0.3s;
    font-weight: 500;
}

.nav-link:hover {
    background: rgba(255,255,255,0.1);
    color: #c9a959;
}

/* Dropdown Styles */
.dropdown-content {
    box-shadow: 0 10px 30px rgba(0,0,0,0.3);
    animation: fadeIn 0.3s ease;
}

.dropdown-content a:hover {
    background: rgba(201, 169, 89, 0.1);
    color: #c9a959 !important;
}

@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translateY(-10px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* Cart Badge */
.cart-badge {
    background: #c9a959;
    color: #000;
    border-radius: 50%;
    padding: 2px 6px;
    font-size: 12px;
    margin-left: 5px;
}
/* Glass Navbar */
.navbar {
	background: rgba(0, 0, 0, 0.8);
	backdrop-filter: blur(10px);
	border-bottom: 1px solid rgba(255, 255, 255, 0.1);
	padding: 1rem 0;
}

.navbar-brand {
	font-size: 1.8rem;
	font-weight: 600;
	letter-spacing: -0.5px;
	color: #fff !important;
}

.navbar-brand span {
	color: #c9a959;
}

.nav-btn {
	padding: 8px 20px;
	border-radius: 50px;
	font-weight: 500;
	transition: all 0.3s;
}

.cart-btn {
	background: rgba(201, 169, 89, 0.1);
	border: 1px solid rgba(201, 169, 89, 0.3);
	color: #c9a959 !important;
	margin-right: 10px;
}

.cart-btn:hover {
	background: #c9a959;
	color: #000 !important;
}

.logout-btn {
	background: rgba(255, 255, 255, 0.1);
	border: 1px solid rgba(255, 255, 255, 0.2);
	color: #fff !important;
}

.logout-btn:hover {
	background: rgba(255, 255, 255, 0.2);
}

/* Hero Section */
.hero-section {
	text-align: center;
	padding: 60px 20px 40px;
	color: #fff;
}

.hero-section h1 {
	font-size: 48px;
	font-weight: 600;
	margin-bottom: 15px;
	text-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
}

.hero-section p {
	font-size: 18px;
	opacity: 0.9;
	max-width: 600px;
	margin: 0 auto;
}

/* Filter Section */
.filter-section {
	background: rgba(255, 255, 255, 0.08);
	backdrop-filter: blur(12px);
	border: 1px solid rgba(255, 255, 255, 0.1);
	border-radius: 50px;
	padding: 15px 25px;
	margin: 30px auto 40px;
	max-width: 800px;
	display: flex;
	justify-content: center;
	gap: 20px;
	flex-wrap: wrap;
}

.filter-btn {
	background: transparent;
	border: none;
	color: rgba(255, 255, 255, 0.6);
	padding: 8px 20px;
	border-radius: 30px;
	font-weight: 500;
	transition: all 0.3s;
	cursor: pointer;
}

.filter-btn:hover, .filter-btn.active {
	background: #c9a959;
	color: #000;
}

/* Products Container */
.products-container {
	padding: 20px 20px 60px;
	max-width: 1400px;
	margin: 0 auto;
}

/* Product Card */
.product-card {
	background: rgba(255, 255, 255, 0.08);
	backdrop-filter: blur(12px);
	border: 1px solid rgba(255, 255, 255, 0.1);
	border-radius: 20px;
	overflow: hidden;
	transition: all 0.4s ease;
	height: 100%;
	position: relative;
}

.product-card:hover {
	transform: translateY(-10px);
	border-color: rgba(201, 169, 89, 0.3);
	box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
}

/* Product Badge */
.product-badge {
	position: absolute;
	top: 15px;
	left: 15px;
	background: #c9a959;
	color: #000;
	padding: 5px 12px;
	border-radius: 50px;
	font-size: 12px;
	font-weight: 600;
	z-index: 1;
}

/* Image Container */
.product-image {
	height: 250px;
	padding: 20px;
	display: flex;
	align-items: center;
	justify-content: center;
	background: rgba(0, 0, 0, 0.2);
}

.product-image img {
	max-height: 200px;
	max-width: 100%;
	object-fit: contain;
	transition: transform 0.4s ease;
}

.product-card:hover .product-image img {
	transform: scale(1.05);
}

/* Product Details */
.product-details {
	padding: 20px;
	border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.product-brand {
	color: #c9a959;
	font-size: 14px;
	font-weight: 500;
	text-transform: uppercase;
	letter-spacing: 1px;
	margin-bottom: 5px;
}

.product-name {
	color: #fff;
	font-size: 18px;
	font-weight: 600;
	margin-bottom: 10px;
}

.product-description {
	color: rgba(255, 255, 255, 0.6);
	font-size: 14px;
	line-height: 1.5;
	margin-bottom: 15px;
	display: -webkit-box;
	-webkit-line-clamp: 2;
	-webkit-box-orient: vertical;
	overflow: hidden;
}

/* Price Section */
.price-section {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin: 15px 0;
}

.product-price {
	color: #fff;
	font-size: 24px;
	font-weight: 600;
}

.product-price small {
	color: rgba(255, 255, 255, 0.5);
	font-size: 14px;
	font-weight: 400;
}

/* Add to Cart Button */
.add-to-cart-btn {
	width: 100%;
	background: transparent;
	border: 1px solid rgba(201, 169, 89, 0.3);
	color: #c9a959;
	padding: 12px;
	border-radius: 12px;
	font-weight: 600;
	font-size: 15px;
	transition: all 0.3s;
	cursor: pointer;
}

.add-to-cart-btn:hover {
	background: #c9a959;
	color: #000;
	transform: translateY(-2px);
}

.add-to-cart-btn i {
	margin-right: 8px;
}

/* Loading State */
.loading {
	text-align: center;
	color: #fff;
	padding: 50px;
}

/* Toast Notification */
.toast-container {
	position: fixed;
	top: 100px;
	right: 20px;
	z-index: 1100;
}

.custom-toast {
	background: rgba(0, 0, 0, 0.9);
	backdrop-filter: blur(10px);
	border: 1px solid #c9a959;
	border-radius: 12px;
	color: #fff;
	padding: 15px 25px;
	min-width: 300px;
}

/* No Products Message */
.no-products-message {
	text-align: center;
	color: #fff;
	padding: 60px 20px;
	background: rgba(255, 255, 255, 0.05);
	backdrop-filter: blur(10px);
	border-radius: 20px;
	border: 1px solid rgba(255, 255, 255, 0.1);
}

.no-products-message i {
	font-size: 80px;
	color: #c9a959;
	margin-bottom: 20px;
	opacity: 0.7;
}

.no-products-message h3 {
	font-size: 28px;
	margin-bottom: 10px;
}

.no-products-message p {
	color: rgba(255, 255, 255, 0.6);
	font-size: 16px;
}

/* Responsive */
@media ( max-width : 768px) {
	.hero-section h1 {
		font-size: 32px;
	}
	.filter-section {
		border-radius: 20px;
		padding: 15px;
	}
	.product-image {
		height: 200px;
	}
}

body {
	background: url('<%=request.getContextPath()%>/images/bg.jpg') no-repeat
		center center fixed;
	background-size: cover;
	font-family: 'Inter', sans-serif;
	min-height: 100vh;
	position: relative;
}

/* Dark overlay to make text readable */
body::before {
	content: '';
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.6);
	/* Dark overlay - adjust opacity as needed */
	z-index: -1;
}

/* Make all text brighter */
body {
	color: #ffffff;
}

/* Ensure cards have enough contrast */
.product-card {
	background: rgba(0, 0, 0, 0.6); /* Darker card background */
	backdrop-filter: blur(8px);
	border: 1px solid rgba(255, 255, 255, 0.15);
}

/* Make "Free Shipping" more visible */
.price-section small {
	color: #c9a959 !important; /* Gold color */
	font-weight: 500;
	background: rgba(0, 0, 0, 0.5);
	padding: 4px 8px;
	border-radius: 20px;
}
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

/* /* Newsletter */
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
 */
 /* Newsletter Section Enhancements */
.newsletter {
    text-align: center;
    padding: 40px 30px;
    background: linear-gradient(135deg, rgba(201,169,89,0.1) 0%, rgba(0,0,0,0.2) 100%);
    border-radius: 20px;
    margin: 40px 0;
    border: 1px solid rgba(201,169,89,0.2);
}

.newsletter h4 {
    color: #fff;
    font-size: 24px;
    font-weight: 600;
    margin-bottom: 10px;
}

.newsletter h4::after {
    content: '';
    display: block;
    width: 60px;
    height: 3px;
    background: #c9a959;
    margin: 15px auto;
    border-radius: 3px;
}

.newsletter p {
    color: rgba(255,255,255,0.7);
    font-size: 16px;
    margin-bottom: 25px;
}

.newsletter-input-group {
    display: flex;
    max-width: 500px;
    margin: 0 auto;
    gap: 10px;
}

.newsletter-input-group .form-control {
    flex: 1;
    padding: 15px 20px;
    background: rgba(255,255,255,0.1);
    border: 1px solid rgba(255,255,255,0.2);
    border-radius: 50px;
    color: #fff;
    font-size: 15px;
    transition: all 0.3s;
}

.newsletter-input-group .form-control:focus {
    outline: none;
    border-color: #c9a959;
    background: rgba(255,255,255,0.15);
    box-shadow: 0 0 0 3px rgba(201,169,89,0.1);
}

.newsletter-input-group .form-control::placeholder {
    color: rgba(255,255,255,0.4);
}

.newsletter-submit-btn {
    padding: 15px 30px;
    background: #c9a959;
    color: #000;
    border: none;
    border-radius: 50px;
    font-weight: 600;
    font-size: 15px;
    cursor: pointer;
    transition: all 0.3s;
    display: flex;
    align-items: center;
    gap: 8px;
    white-space: nowrap;
}

.newsletter-submit-btn:hover {
    background: #d4b468;
    transform: translateY(-2px);
    box-shadow: 0 5px 20px rgba(201,169,89,0.3);
}

.newsletter-submit-btn i {
    font-size: 14px;
}

.newsletter-privacy {
    display: block;
    color: rgba(255,255,255,0.4);
    font-size: 12px;
    margin-top: 15px;
}

.newsletter-success {
    background: rgba(40,167,69,0.15);
    border: 1px solid rgba(40,167,69,0.3);
    border-radius: 10px;
    padding: 12px 20px;
    margin-bottom: 20px;
    color: #28a745;
    display: flex;
    align-items: center;
    gap: 10px;
    max-width: 500px;
    margin-left: auto;
    margin-right: auto;
    animation: slideDown 0.5s ease;
}

.newsletter-error {
    background: rgba(220,53,69,0.15);
    border: 1px solid rgba(220,53,69,0.3);
    border-radius: 10px;
    padding: 12px 20px;
    margin-bottom: 20px;
    color: #dc3545;
    display: flex;
    align-items: center;
    gap: 10px;
    max-width: 500px;
    margin-left: auto;
    margin-right: auto;
    animation: slideDown 0.5s ease;
}

.newsletter-info {
    background: rgba(0,123,255,0.15);
    border: 1px solid rgba(0,123,255,0.3);
    border-radius: 10px;
    padding: 12px 20px;
    margin-bottom: 20px;
    color: #007bff;
    display: flex;
    align-items: center;
    gap: 10px;
    max-width: 500px;
    margin-left: auto;
    margin-right: auto;
    animation: slideDown 0.5s ease;
}

@keyframes slideDown {
    from {
        opacity: 0;
        transform: translateY(-20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@media (max-width: 576px) {
    .newsletter-input-group {
        flex-direction: column;
    }
    
    .newsletter-submit-btn {
        justify-content: center;
    }
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
@media ( max-width : 992px) {
	.footer-content {
		grid-template-columns: repeat(2, 1fr);
	}
}

@media ( max-width : 768px) {
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
/* Wishlist Button */
.wishlist-btn {
	flex: 1;
	display: flex;
	align-items: center;
	justify-content: center;
	background: rgba(255, 255, 255, 0.1);
	border: 1px solid rgba(255, 255, 255, 0.2);
	border-radius: 12px;
	color: #ff6b6b;
	text-decoration: none;
	transition: all 0.3s;
	height: 48px; /* Match add to cart button height */
}

.wishlist-btn:hover {
	background: #ff6b6b;
	color: #fff;
	transform: translateY(-2px);
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
        <div class="nav-links" style="display: flex; align-items: center; gap: 20px;">
            <a href="<%=request.getContextPath()%>/products" class="nav-link">
                <i class="fas fa-store"></i> Shop
            </a>
            <a href="<%=request.getContextPath()%>/cart.jsp" class="nav-link">
                <i class="fas fa-shopping-bag"></i> Cart 
                <%
    List<Watch> cart = (List<Watch>) session.getAttribute("cart");
    int cartItemCount = 0;
    
    if (cart != null) {
        cartItemCount = cart.size();
    }
%>
                <span class="cart-badge" style="background: #c9a959; color: #000; border-radius: 50%; padding: 2px 6px; font-size: 12px; margin-left: 5px;">
                   <%= cartItemCount > 0 ? cartItemCount : 0 %>
                </span>
            </a>
            <a href="<%=request.getContextPath()%>/orders" class="nav-link">
                <i class="fas fa-box"></i> Orders
            </a>
         <!-- Profile Dropdown -->
<div class="dropdown" style="position: relative; display: inline-block;">
    <button class="nav-link" style="background: none; border: none; cursor: pointer;" onclick="toggleDropdown()">
        <i class="fas fa-user-circle" style="font-size: 24px;"></i>
    </button>
    <div id="profileDropdown" class="dropdown-content" style="display: none; position: absolute; right: 0; background: rgba(20,20,20,0.95); backdrop-filter: blur(10px); min-width: 200px; border-radius: 15px; border: 1px solid rgba(255,255,255,0.1); padding: 10px 0; z-index: 1000;">
        <a href="<%=request.getContextPath()%>/profile" style="display: flex; align-items: center; gap: 10px; padding: 12px 20px; color: white; text-decoration: none; transition: background 0.3s;">
            <i class="fas fa-user" style="color: #c9a959; width: 20px;"></i> My Profile
        </a>
        <a href="<%=request.getContextPath()%>/addresses" style="display: flex; align-items: center; gap: 10px; padding: 12px 20px; color: white; text-decoration: none; transition: background 0.3s;">
            <i class="fas fa-map-marker-alt" style="color: #c9a959; width: 20px;"></i> Addresses
        </a>
        <a href="<%=request.getContextPath()%>/wishlist" style="display: flex; align-items: center; gap: 10px; padding: 12px 20px; color: white; text-decoration: none; transition: background 0.3s;">
            <i class="fas fa-heart" style="color: #c9a959; width: 20px;"></i> Wishlist
        </a>
        
        <!-- 👇 ADMIN LINK - ONLY VISIBLE TO ADMINS 👇 -->
        <%
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin != null && isAdmin) {
        %>
            <div style="height: 1px; background: rgba(255,255,255,0.1); margin: 10px 0;"></div>
            <a href="<%=request.getContextPath()%>/admin/dashboard" style="display: flex; align-items: center; gap: 10px; padding: 12px 20px; color: #c9a959; text-decoration: none; transition: background 0.3s; font-weight: 600;">
                <i class="fas fa-tachometer-alt" style="color: #c9a959; width: 20px;"></i> Admin Dashboard
            </a>
        <%
        }
        %>
        
        <div style="height: 1px; background: rgba(255,255,255,0.1); margin: 10px 0;"></div>
        <a href="<%=request.getContextPath()%>/logout" style="display: flex; align-items: center; gap: 10px; padding: 12px 20px; color: #ff6b6b; text-decoration: none; transition: background 0.3s;">
            <i class="fas fa-sign-out-alt" style="width: 20px;"></i> Logout
        </a>
    </div>
</div>
        </div>
    </div>
</nav>

<!-- Dropdown Toggle Script -->
<script>
    function toggleDropdown() {
        var dropdown = document.getElementById('profileDropdown');
        if (dropdown.style.display === 'none' || dropdown.style.display === '') {
            dropdown.style.display = 'block';
        } else {
            dropdown.style.display = 'none';
        }
    }

    // Close dropdown when clicking outside
    window.onclick = function(event) {
        if (!event.target.matches('.nav-link') && !event.target.closest('.nav-link')) {
            var dropdown = document.getElementById('profileDropdown');
            if (dropdown && dropdown.style.display === 'block') {
                dropdown.style.display = 'none';
            }
        }
    }
</script>

	<!-- Hero Section -->
	<div class="hero-section">
		<div class="container">
			<h1>Discover Timeless Elegance</h1>
			<p>Premium watches crafted for style & precision. Each timepiece
				tells a unique story.</p>
		</div>
	</div>

	<!-- Filter Section - DYNAMIC based on actual categories in database -->
	<div class="container">
		<div class="filter-section" id="filterSection">
			<button class="filter-btn active" data-filter="all">All
				Watches</button>

			<%
			// Get unique categories from your watch list
			List<Watch> watchList = (List<Watch>) request.getAttribute("watchList");
			java.util.Set<String> uniqueCategories = new java.util.LinkedHashSet<>();

			if (watchList != null) {
				for (Watch w : watchList) {
					if (w.getCategory() != null && !w.getCategory().trim().isEmpty()) {
				uniqueCategories.add(w.getCategory());
					}
				}
			}

			// Display filter buttons for each unique category
			for (String category : uniqueCategories) {
			%>
			<button class="filter-btn" data-filter="<%=category.toLowerCase()%>">
				<%=category%>
			</button>
			<%
			}
			%>
		</div>
	</div>


	<!-- Products Section -->
	<div class="products-container">
		<div class="container">
			<div class="row g-4">
				<!-- Make sure this row class is here -->
				<%
				if (watchList != null && !watchList.isEmpty()) {
					for (Watch w : watchList) {
						String category = w.getCategory() != null ? w.getCategory().toLowerCase() : "uncategorized";
				%>
				<div class="col-lg-3 col-md-6 col-sm-6">
					<!-- Make sure these column classes are here -->
					<div class="product-card">
						<!-- Product Badge -->
						<div class="product-badge">
							<%=w.getCategory() != null ? w.getCategory() : "Premium"%>
						</div>

						
						<!-- Product Image (make it clickable) -->
						<a href="product?id=<%=w.getId()%>" style="text-decoration: none;">
							<div class="product-image">
								<img
									src="<%=request.getContextPath()%>/images/<%=w.getImage()%>"
									alt="<%=w.getName()%>"
									onerror="this.src='<%=request.getContextPath()%>/images/placeholder.jpg'">
							</div>
						</a>
						<!-- Product Details -->
						<div class="product-details">
							<div class="product-brand"><%=w.getBrand() != null ? w.getBrand() : "TimeZone"%></div>
							<a href="product?id=<%=w.getId()%>"
								style="text-decoration: none;">
								<h3 class="product-name"><%=w.getName()%></h3>
							</a>
							<p class="product-description"><%=w.getDescription() != null ? w.getDescription() : "Elegant timepiece"%></p>

							<!-- Price Section -->
							<div class="price-section">
								<span class="product-price">₹ <%=String.format("%,d", (int) w.getPrice())%></span>
								<small>Free Shipping</small>
							</div>

							<!-- Add to Cart Form -->
							<form action="<%=request.getContextPath()%>/addToCart"
								method="post">
								<input type="hidden" name="id" value="<%=w.getId()%>">
								<button type="submit" class="add-to-cart-btn">
									<i class="fas fa-shopping-cart"></i> Add to Cart
								</button>
							</form>
							<!-- Wishlist Button (takes 1/3 of the space) -->
							<a
								href="<%=request.getContextPath()%>/wishlist?action=add&watchId=<%=w.getId()%>"
								class="wishlist-btn"
								style="flex: 1; display: flex; align-items: center; justify-content: center; background: rgba(255, 255, 255, 0.1); border: 1px solid rgba(255, 255, 255, 0.2); border-radius: 12px; color: #ff6b6b; text-decoration: none; transition: all 0.3s;"
								onmouseover="this.style.background='#ff6b6b'; this.style.color='#fff';"
								onmouseout="this.style.background='rgba(255, 255, 255, 0.1)'; this.style.color='#ff6b6b';">
								<i class="fas fa-heart"></i>
							</a>
						</div>
					</div>
				</div>
				<%
				}
				} else {
				%>
				<div class="col-12">
					<div class="no-products-message">
						<i class="fas fa-clock"></i>
						<h3>No Watches Found</h3>
						<p>Check back soon for new arrivals</p>
					</div>
				</div>
				<%
				}
				%>
			</div>
			<!-- Close row -->
		</div>
	</div>
	<!-- Toast Notification -->
	<div class="toast-container">
		<div id="cartToast" class="custom-toast toast" role="alert">
			<div class="d-flex align-items-center">
				<i class="fas fa-check-circle text-success me-2"></i>
				<div class="toast-body">Watch added to cart successfully!</div>
				<button type="button" class="btn-close btn-close-white ms-auto"
					data-bs-dismiss="toast"></button>
			</div>
		</div>
	</div>

	<!-- Bootstrap JS -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

	<script>
    // Filter functionality
    document.addEventListener('DOMContentLoaded', function() {
        const filterButtons = document.querySelectorAll('.filter-btn');
        const productItems = document.querySelectorAll('.product-item');
        
        filterButtons.forEach(button => {
            button.addEventListener('click', function() {
                // Update active state
                filterButtons.forEach(btn => btn.classList.remove('active'));
                this.classList.add('active');
                
                const filterValue = this.getAttribute('data-filter');
                
                productItems.forEach(item => {
                    if (filterValue === 'all' || item.getAttribute('data-category') === filterValue) {
                        item.style.display = 'block';
                    } else {
                        item.style.display = 'none';
                    }
                });
                
                // Check if any products are visible after filtering
                const visibleProducts = Array.from(productItems).filter(item => item.style.display !== 'none');
                
                // Remove existing no products message if any
                const existingMessage = document.getElementById('noProductsMessage');
                if (existingMessage) {
                    existingMessage.remove();
                }
                
                // Show "no products" message if nothing is visible
                if (visibleProducts.length === 0) {
                    const productsRow = document.getElementById('productsRow');
                    const noProductsDiv = document.createElement('div');
                    noProductsDiv.id = 'noProductsMessage';
                    noProductsDiv.className = 'col-12';
                    noProductsDiv.innerHTML = `
                        <div class="no-products-message">
                            <i class="fas fa-clock"></i>
                            <h3>No Watches in this Category</h3>
                            <p>Try selecting a different category</p>
                        </div>
                    `;
                    productsRow.appendChild(noProductsDiv);
                }
            });
        });
    });

    // Toast notification
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('added') === 'true') {
        const toastElement = document.getElementById('cartToast');
        const toast = new bootstrap.Toast(toastElement, { delay: 2500 });
        toast.show();
        
        // Remove query parameter from URL
        window.history.replaceState({}, document.title, window.location.pathname);
    }
    
    // Add animation on add to cart
/*     document.querySelectorAll('.add-to-cart-btn').forEach(btn => {
        btn.addEventListener('click', function(e) {
            const originalText = this.innerHTML;
            this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Adding...';
            this.disabled = true;
            
            // Form will submit normally
            setTimeout(() => {
                this.innerHTML = originalText;
                this.disabled = false;
            }, 1000);
        });
    }); */
 // Simple add to cart - no animations that might interfere
    document.querySelectorAll('.add-to-cart-form').forEach(form => {
        form.addEventListener('submit', function() {
            // Just show a quick visual feedback
            const button = this.querySelector('button');
            button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Adding...';
            button.disabled = true;
            
            // Don't prevent default - let form submit naturally
            // Don't re-enable - page will refresh
            return true;
        });
    });
</script>

	<!-- Debug info (remove in production) -->
	<%
	if (watchList == null) {
	%>
	<div class="container mt-3">
		<div class="alert alert-warning">No watch list found in request
			attribute. Check if servlet is setting "watchList" attribute.</div>
	</div>
	<%
	}
	%>
	<!-- <script>
    // Ensure form submission works
    document.addEventListener('DOMContentLoaded', function() {
        const addToCartForms = document.querySelectorAll('.add-to-cart-form');
        
        addToCartForms.forEach(form => {
            form.addEventListener('submit', function(e) {
                // Optional: Add loading state
                const button = this.querySelector('button');
                const originalText = button.innerHTML;
                button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Adding...';
                button.disabled = true;
                
                // Let the form submit normally
                // Don't call e.preventDefault()
                
                // Re-enable after 2 seconds (in case of error)
                setTimeout(() => {
                    button.innerHTML = originalText;
                    button.disabled = false;
                }, 2000);
            });
        });
    });

    // Check URL parameters for errors
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('error') === 'true') {
        alert('Error adding item to cart. Please try again.');
    } else if (urlParams.get('added') === 'true') {
        // Show toast
        const toastElement = document.getElementById('cartToast');
        if (toastElement) {
            const toast = new bootstrap.Toast(toastElement, { delay: 2500 });
            toast.show();
        }
    }
</script> -->
	<script>
    // Ensure form submission works
    document.addEventListener('DOMContentLoaded', function() {
        const addToCartForms = document.querySelectorAll('.add-to-cart-form');
        
        addToCartForms.forEach(form => {
            form.addEventListener('submit', function(e) {
                // Optional: Add loading state
                const button = this.querySelector('button');
                const originalText = button.innerHTML;
                button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Adding...';
                button.disabled = true;
                
                // Let the form submit normally
                // Don't call e.preventDefault()
                
                // Re-enable after 2 seconds (in case of error)
                setTimeout(() => {
                    button.innerHTML = originalText;
                    button.disabled = false;
                }, 2000);
            });
        });
    });

    // Check URL parameters for errors - USE EXISTING urlParams
    if (typeof urlParams !== 'undefined') {
        if (urlParams.get('error') === 'true') {
            alert('Error adding item to cart. Please try again.');
        }
    }
</script>
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
					<p class="footer-description">Discover our collection of
						premium watches crafted for style & precision. Each timepiece
						tells a unique story.</p>
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
						<li><a href="<%=request.getContextPath()%>/products"><i
								class="fas fa-chevron-right"></i> Shop</a></li>
						<li><a href="<%=request.getContextPath()%>/cart.jsp"><i
								class="fas fa-chevron-right"></i> Cart</a></li>
						<li><a href="<%=request.getContextPath()%>/orders"><i
								class="fas fa-chevron-right"></i> My Orders</a></li>
						<!-- 👇 NEW PROFILE LINK ADDED HERE 👇 -->
						<li><a href="<%=request.getContextPath()%>/profile"><i
								class="fas fa-chevron-right"></i> My Profile</a></li>
						<!-- 👇 NEW WISHLIST LINK ADDED HERE 👇 -->
						<li><a href="<%=request.getContextPath()%>/wishlist"><i
								class="fas fa-chevron-right"></i> Wishlist</a></li>
						<!-- In Quick Links section -->
<li><a href="<%=request.getContextPath()%>/track-order"><i class="fas fa-chevron-right"></i> Track Order</a></li>
					</ul>
				</div>
				<!-- Categories -->
				<div class="footer-section">
					<h4>Categories</h4>
					<ul class="footer-links">
						<li><a href="#"><i class="fas fa-chevron-right"></i>
								Luxury</a></li>
						<li><a href="#"><i class="fas fa-chevron-right"></i>
								Sport</a></li>
						<li><a href="#"><i class="fas fa-chevron-right"></i>
								Diver</a></li>
						<li><a href="#"><i class="fas fa-chevron-right"></i>
								Chronograph</a></li>
						<li><a href="#"><i class="fas fa-chevron-right"></i>
								Smart</a></li>
						<li><a href="#"><i class="fas fa-chevron-right"></i>
								Dress</a></li>
					</ul>
				</div>

				<!-- Contact Info -->
				<div class="footer-section">
					<h4>Contact Us</h4>
					<ul class="contact-info">
						<li><i class="fas fa-map-marker-alt"></i> 123 Watch Tower,
							Pune, India</li>
						<li><i class="fas fa-phone"></i> +91 98765 43210</li>
						<li><i class="fas fa-envelope"></i> contact.timezonewatches@gmail.com</li>
						<li><i class="fas fa-clock"></i> Mon - Sat: 10AM - 8PM</li>
					</ul>
				</div>
			</div>

			<!-- Newsletter Section -->
			<!-- <div class="newsletter">
				<h4>Subscribe to Our Newsletter</h4>
				<p>Get updates about new collections and special offers</p>
				<form class="newsletter-form" action="#" method="post">
					<input type="email" placeholder="Your email address" required>
					<button type="submit">Subscribe</button>
				</form>
			</div> -->
			<!-- Newsletter Section -->
<div class="newsletter">
    <h4>Subscribe to Our Newsletter</h4>
    <p>Get updates about new collections and special offers</p>
    
    <% 
    String newsletterStatus = (String) session.getAttribute("newsletterStatus");
    if ("success".equals(newsletterStatus)) { 
        session.removeAttribute("newsletterStatus");
    %>
        <div class="newsletter-success">
            <i class="fas fa-check-circle"></i> Thank you for subscribing!
        </div>
    <% } else if ("error".equals(newsletterStatus)) { 
        session.removeAttribute("newsletterStatus");
    %>
        <div class="newsletter-error">
            <i class="fas fa-exclamation-circle"></i> Subscription failed. Please try again.
        </div>
    <% } else if ("exists".equals(newsletterStatus)) { 
        session.removeAttribute("newsletterStatus");
    %>
        <div class="newsletter-info">
            <i class="fas fa-info-circle"></i> This email is already subscribed.
        </div>
    <% } %>
    
    <form class="newsletter-form" action="<%= request.getContextPath() %>/newsletter" method="post" onsubmit="return validateNewsletterForm()">
        <div class="newsletter-input-group">
            <input type="email" name="email" id="newsletterEmail" class="form-control" placeholder="Your email address" required>
            <button type="submit" class="newsletter-submit-btn">
                <i class="fas fa-paper-plane"></i> Subscribe
            </button>
        </div>
        <small class="newsletter-privacy">We respect your privacy. Unsubscribe at any time.</small>
    </form>
</div>

			<!-- Bottom Bar -->
			<div class="footer-bottom">
				<div class="copyright">
					&copy; 2026 TimeZone. All rights reserved. | <a href="#">Privacy
						Policy</a> | <a href="#">Terms of Service</a>
				</div>
				<div class="payment-methods">
					<i class="fab fa-cc-visa"></i> <i class="fab fa-cc-mastercard"></i>
					<i class="fab fa-cc-amex"></i> <i class="fab fa-cc-paypal"></i> <i
						class="fab fa-google-pay"></i> <i class="fab fa-apple-pay"></i>
				</div>
			</div>
		</div>
		<!-- Admin Quick Access (Hidden) -->
<div style="text-align: center; margin-top: 10px; opacity: 0.35; font-size: 20px;">
    <a href="<%=request.getContextPath()%>/admin/login" style="color: #666; text-decoration: none;" title="Admin Access">
        <i class="fas fa-tools"></i> ⚙️
    </a>
</div>
	</footer>
	<script>
function validateNewsletterForm() {
    var email = document.getElementById('newsletterEmail').value;
    var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    
    if (!emailRegex.test(email)) {
        alert('Please enter a valid email address');
        return false;
    }
    return true;
}
</script>
</body>
</html>
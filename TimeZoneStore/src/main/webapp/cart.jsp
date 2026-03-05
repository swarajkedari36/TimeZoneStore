<%-- <%@ page import="java.util.*, com.timezone.model.Watch"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Your Cart - TimeZone</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
body {
	background: url('<%=request.getContextPath()%>/images/bg.jpg') no-repeat
		center center fixed;
	background-size: cover;
	font-family: 'Segoe UI', sans-serif;
}

.glass {
	background: rgba(255, 255, 255, 0.15);
	backdrop-filter: blur(12px);
	border-radius: 20px;
	padding: 40px;
	box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
}

.cart-table img {
	height: 80px;
	object-fit: cover;
	border-radius: 10px;
}

.table th {
	background-color: rgba(255, 255, 255, 0.2);
}

.summary-card {
	position: sticky;
	top: 100px;
	background: rgba(255, 255, 255, 0.2);
	backdrop-filter: blur(10px);
	border-radius: 15px;
	padding: 25px;
}

.checkout-btn {
	width: 100%;
	padding: 12px;
	font-weight: 600;
	border-radius: 10px;
}
</style>
</head>

<body>

	<div class="container mt-5 mb-5">
		<div class="glass">

			<h2 class="text-center text-dark mb-4">Your Premium Cart</h2>

			<%
			List<Watch> list = (List<Watch>) session.getAttribute("cart");
			double total = 0;

			if (list == null || list.isEmpty()) {
			%>

			
 <div style="text-align:center; padding:100px 20px; max-width:500px; margin:0 auto; font-family:-apple-system,BlinkMacSystemFont,sans-serif;">
    <!-- Elegant watch icon -->
    <div style="font-size:90px; margin-bottom:20px; color:#333;">⌚</div>
    
    <h2 style="font-size:28px; font-weight:400; color:#222; margin-bottom:12px;">Your Cart is Empty</h2>
    
    <p style="color:#ffffff;">Time waits for you to get your perfect piece.</p>
    </p>
     <!-- Button only version -->
    <div>
        <a href="products" style="background:#222; color:white; padding:14px 40px; border-radius:30px; text-decoration:none; font-weight:500; font-size:15px; display:inline-block; border:none; box-shadow:0 2px 8px rgba(0,0,0,0.1);">
            Browse Watches
        </a>
    </div>
			<%
			} else {
			%>

			<div class="row">

				<!-- LEFT SIDE : CART ITEMS -->
				<div class="col-lg-8">

					<table
						class="table table-bordered cart-table text-center align-middle">
						<thead>
							<tr>
								<th>Product</th>
								<th>Name</th>
								<th>Price</th>
								<th>Quantity</th>
								<th>Subtotal</th>
								<th>Remove</th>
							</tr>
						</thead>
						<tbody>


							<%
							for (Watch w : list) {

								int quantity = w.getQuantity();
								double subtotal = w.getPrice() * quantity;
								total += subtotal;
							%>


							<tr>
								<td><img
									src="<%=request.getContextPath()%>/images/<%=w.getImage()%>">
								</td>

								<td><%=w.getName()%></td>

								<td>₹ <%=w.getPrice()%></td>

								<td>
									<form action="decrease" method="post" style="display: inline;">
										<input type="hidden" name="id" value="<%=w.getId()%>">
										<button type="submit"
											<%=w.getQuantity() == 1 ? "disabled" : ""%>>-</button>
									</form> <span style="margin: 0 10px;"> <%=w.getQuantity()%>
								</span>

									<form action="increase" method="post" style="display: inline;">
										<input type="hidden" name="id" value="<%=w.getId()%>">
										<button type="submit" class="btn btn-sm btn-outline-dark">+</button>
									</form>
								</td>
								<!-- ✅ Subtotal -->
								<td>₹ <%=w.getPrice() * w.getQuantity()%>
								</td>
								<td>
									<form action="remove" method="post">
										<input type="hidden" name="id" value="<%=w.getId()%>">
										<button type="submit" class="btn btn-sm btn-danger">
											Remove</button>
									</form>
								</td>

							</tr>

							<%
							}
							%>

						</tbody>
					</table>

				</div>


				<!-- RIGHT SIDE : SUMMARY -->
				<div class="col-lg-4">

					<div class="summary-card shadow">

						<h5 class="mb-3">Order Summary</h5>

						<hr>

						<p class="d-flex justify-content-between">
							<span>Total Items</span> <span><%=list.size()%></span>
						</p>

						<p class="d-flex justify-content-between fw-bold fs-5">
							<span>Total Amount</span> <span>₹ <%=total%></span>
						</p>

						<hr>

						<a href="checkout.jsp" class="btn btn-dark checkout-btn">
							Proceed to Checkout </a> <a href="products"
							class="btn btn-outline-dark mt-2 checkout-btn"> Continue
							Shopping </a>

					</div>

				</div>

			</div>

			<%
			}
			%>

		</div>
	</div>

</body>
</html> --%>



<%@ page import="java.util.*, com.timezone.model.Watch"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Your Cart - TimeZone Watches</title>

<!-- Bootstrap 5 -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<!-- Font Awesome for icons -->
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
    background: url('<%=request.getContextPath()%>/images/bg.jpg') no-repeat center center fixed;
    background-size: cover;
    font-family: 'Inter', sans-serif;
    min-height: 100vh;
    color: #fff;
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
    background: rgba(0, 0, 0, 0.7);
    z-index: -1;
}

/* Navbar styling */
.navbar {
    background: rgba(0, 0, 0, 0.8);
    backdrop-filter: blur(10px);
    padding: 1rem 0;
    border-bottom: 1px solid rgba(255,255,255,0.1);
    position: relative;
    z-index: 10;
}

.navbar-brand {
    font-size: 1.8rem;
    font-weight: 600;
    letter-spacing: -0.5px;
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

/* Main container */
.cart-container {
    padding: 40px 20px;
    max-width: 1400px;
    margin: 0 auto;
    position: relative;
    z-index: 10;
}

/* Glass card effect */
.glass-card {
    background: rgba(20, 20, 20, 0.6);
    backdrop-filter: blur(12px);
    border: 1px solid rgba(255, 255, 255, 0.15);
    border-radius: 24px;
    padding: 30px;
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.5);
}

/* Empty cart styling */
.empty-cart {
    text-align: center;
    padding: 60px 20px;
}

.empty-cart-icon {
    font-size: 120px;
    color: #c9a959;
    margin-bottom: 20px;
    animation: float 3s ease-in-out infinite;
    opacity: 0.9;
}

@keyframes float {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-10px); }
}

.empty-cart h2 {
    font-size: 36px;
    font-weight: 400;
    margin-bottom: 15px;
    color: #fff;
    text-shadow: 0 2px 5px rgba(0,0,0,0.3);
}

.empty-cart p {
    font-size: 18px;
    color: rgba(255,255,255,0.9);
    margin-bottom: 30px;
    max-width: 400px;
    margin-left: auto;
    margin-right: auto;
    font-weight: 400;
}

.browse-btn {
    background: #c9a959;
    color: #000;
    padding: 15px 45px;
    border-radius: 50px;
    text-decoration: none;
    font-weight: 600;
    font-size: 16px;
    display: inline-block;
    border: none;
    transition: all 0.3s;
    letter-spacing: 0.5px;
}

.browse-btn:hover {
    background: #d4b468;
    transform: translateY(-2px);
    box-shadow: 0 10px 25px rgba(201, 169, 89, 0.4);
    color: #000;
}

/* Cart header */
.cart-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 30px;
    padding-bottom: 20px;
    border-bottom: 1px solid rgba(255,255,255,0.2);
}

.cart-header h2 {
    font-size: 28px;
    font-weight: 500;
    color: #fff;
    margin: 0;
    text-shadow: 0 2px 4px rgba(0,0,0,0.3);
}

.cart-header h2 i {
    color: #c9a959;
    margin-right: 10px;
}

.item-count {
    background: rgba(201, 169, 89, 0.2);
    padding: 8px 16px;
    border-radius: 50px;
    color: #c9a959;
    font-size: 14px;
    font-weight: 500;
    border: 1px solid rgba(201, 169, 89, 0.3);
    backdrop-filter: blur(5px);
}

/* Table styling */
.cart-table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0 15px;
}

.cart-table th {
    color: rgba(255,255,255,0.8);
    font-weight: 500;
    font-size: 14px;
    text-transform: uppercase;
    letter-spacing: 1px;
    padding: 0 15px 10px;
    border: none;
    background: transparent;
}

.cart-table td {
    padding: 20px 15px;
    background: rgba(30, 30, 30, 0.7);
    border: none;
    vertical-align: middle;
    color: #fff;
    backdrop-filter: blur(5px);
}

.cart-table tr td:first-child {
    border-radius: 15px 0 0 15px;
}

.cart-table tr td:last-child {
    border-radius: 0 15px 15px 0;
}

/* Product image */
.product-img {
    width: 100px;
    height: 100px;
    object-fit: cover;
    border-radius: 12px;
    border: 2px solid rgba(201, 169, 89, 0.3);
    box-shadow: 0 5px 15px rgba(0,0,0,0.3);
}

/* Product name */
.product-name {
    font-weight: 500;
    color: #fff;
    font-size: 16px;
}

/* Price styling */
.price {
    color: #c9a959;
    font-weight: 600;
    font-size: 18px;
    text-shadow: 0 2px 4px rgba(0,0,0,0.3);
}

/* Quantity controls */
.quantity-control {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
}

.qty-btn {
    width: 35px;
    height: 35px;
    border-radius: 50%;
    border: 1px solid rgba(255,255,255,0.3);
    background: rgba(0, 0, 0, 0.5);
    color: #fff;
    font-size: 18px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.2s;
    backdrop-filter: blur(5px);
}

.qty-btn:hover:not(:disabled) {
    background: #c9a959;
    border-color: #c9a959;
    color: #000;
}

.qty-btn:disabled {
    opacity: 0.3;
    cursor: not-allowed;
}

.qty-value {
    font-size: 18px;
    font-weight: 500;
    min-width: 30px;
    text-align: center;
    color: #fff;
    background: rgba(0,0,0,0.3);
    padding: 5px 10px;
    border-radius: 20px;
}

/* Remove button */
.remove-btn {
    background: rgba(255, 99, 99, 0.2);
    border: 1px solid rgba(255, 99, 99, 0.4);
    color: #ff6b6b;
    width: 35px;
    height: 35px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s;
    backdrop-filter: blur(5px);
}

.remove-btn:hover {
    background: #ff6b6b;
    border-color: #ff6b6b;
    color: #000;
}

/* Summary card */
.summary-card {
    background: rgba(20, 20, 20, 0.7);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(255,255,255,0.15);
    border-radius: 20px;
    padding: 25px;
    position: sticky;
    top: 100px;
    box-shadow: 0 15px 30px rgba(0,0,0,0.4);
}

.summary-title {
    font-size: 20px;
    font-weight: 500;
    margin-bottom: 20px;
    color: #fff;
}

.summary-row {
    display: flex;
    justify-content: space-between;
    margin-bottom: 15px;
    color: rgba(255,255,255,0.9);
}

.summary-total {
    display: flex;
    justify-content: space-between;
    font-size: 20px;
    font-weight: 600;
    color: #c9a959;
    margin: 20px 0;
    padding-top: 15px;
    border-top: 1px solid rgba(255,255,255,0.2);
}

.checkout-btn {
    width: 100%;
    padding: 14px;
    background: #c9a959;
    color: #000;
    border: none;
    border-radius: 12px;
    font-weight: 600;
    font-size: 16px;
    margin-bottom: 10px;
    transition: all 0.3s;
    text-decoration: none;
    display: inline-block;
    text-align: center;
}

.checkout-btn:hover {
    background: #d4b468;
    transform: translateY(-2px);
    box-shadow: 0 5px 20px rgba(201, 169, 89, 0.4);
    color: #000;
}

.continue-btn {
    width: 100%;
    padding: 14px;
    background: rgba(0, 0, 0, 0.5);
    color: #fff;
    border: 1px solid rgba(255,255,255,0.2);
    border-radius: 12px;
    font-weight: 500;
    transition: all 0.3s;
    backdrop-filter: blur(5px);
    text-decoration: none;
    display: inline-block;
    text-align: center;
    margin-top: 10px;
}

.continue-btn:hover {
    background: rgba(255,255,255,0.15);
    border-color: #c9a959;
    color: #c9a959;
}

/* Brand badges */
.brand-badges {
    display: flex;
    justify-content: center;
    gap: 30px;
    margin-top: 30px;
    opacity: 0.7;
}

.brand-badges span {
    color: rgba(255,255,255,0.8);
    font-size: 14px;
    font-weight: 500;
    letter-spacing: 1px;
    background: rgba(0,0,0,0.3);
    padding: 5px 15px;
    border-radius: 30px;
    backdrop-filter: blur(5px);
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
    
    .cart-table td {
        padding: 15px 10px;
    }
    
    .product-img {
        width: 60px;
        height: 60px;
    }
    
    .empty-cart h2 {
        font-size: 28px;
    }
    
    .cart-header {
        flex-direction: column;
        gap: 15px;
        text-align: center;
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
            <div class="nav-links">
                <a href="<%=request.getContextPath()%>/products">
                    <i class="fas fa-store me-1"></i> Shop
                </a> 
                <a href="<%=request.getContextPath()%>/cart.jsp">
                    <i class="fas fa-shopping-bag me-1"></i> Cart
                </a>
                <a href="<%=request.getContextPath()%>/profile">
                    <i class="fas fa-user me-1"></i> Profile
                </a>
                <a href="<%=request.getContextPath()%>/wishlist">
                    <i class="fas fa-heart me-1"></i> Wishlist
                </a>
            </div>
        </div>
    </nav>

    <div class="cart-container">
        <%
        List<Watch> cartItems = (List<Watch>) session.getAttribute("cart");
        double total = 0;
        
        if (cartItems == null || cartItems.isEmpty()) {
        %>
            <!-- Empty Cart State -->
            <div class="glass-card empty-cart">
                <div class="empty-cart-icon">
                    <i class="far fa-clock"></i>
                </div>
                <h2>Your Cart is Empty</h2>
                <p>Time waits for you to find your perfect timepiece.</p>
                <a href="<%=request.getContextPath()%>/products" class="browse-btn"> 
                    <i class="fas fa-eye me-2"></i>Browse Collection
                </a>

                <!-- Brand Badges -->
                <div class="brand-badges">
                    <span>ROLEX</span> 
                    <span>OMEGA</span> 
                    <span>TAG HEUER</span> 
                    <span>SEIKO</span>
                </div>
            </div>
        <%
        } else {
        %>
            <!-- Cart with Items -->
            <div class="glass-card">
                <!-- Cart Header -->
                <div class="cart-header">
                    <h2>
                        <i class="fas fa-shopping-bag"></i> Your Premium Cart
                    </h2>
                    <span class="item-count"> 
                        <i class="fas fa-clock me-2"></i><%= cartItems.size() %>
                        <%= cartItems.size() == 1 ? "Item" : "Items" %>
                    </span>
                </div>

                <div class="row">
                    <!-- Cart Items -->
                    <div class="col-lg-8">
                        <table class="cart-table">
                            <thead>
                                <tr>
                                    <th>Product</th>
                                    <th>Name</th>
                                    <th>Price</th>
                                    <th>Quantity</th>
                                    <th>Subtotal</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                for (Watch w : cartItems) {
                                    int quantity = w.getQuantity();
                                    double subtotal = w.getPrice() * quantity;
                                    total += subtotal;
                                %>
                                <tr>
                                    <td><img
                                        src="<%=request.getContextPath()%>/images/<%=w.getImage()%>"
                                        class="product-img" alt="<%=w.getName()%>"></td>
                                    <td><span class="product-name"><%=w.getName()%></span></td>
                                    <td><span class="price">₹ <%=String.format("%,d", (int) w.getPrice())%></span>
                                    </td>
                                    <td>
                                        <div class="quantity-control">
                                            <form action="decrease" method="post" style="display: inline;">
                                                <input type="hidden" name="id" value="<%=w.getId()%>">
                                                <button type="submit" class="qty-btn"
                                                    <%=w.getQuantity() == 1 ? "disabled" : ""%>>
                                                    <i class="fas fa-minus"></i>
                                                </button>
                                            </form>
                                            <span class="qty-value"><%=w.getQuantity()%></span>
                                            <form action="increase" method="post" style="display: inline;">
                                                <input type="hidden" name="id" value="<%=w.getId()%>">
                                                <button type="submit" class="qty-btn">
                                                    <i class="fas fa-plus"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                    <td><span class="price">₹ <%=String.format("%,d", (int) subtotal)%></span>
                                    </td>
                                    <td>
                                        <form action="remove" method="post">
                                            <input type="hidden" name="id" value="<%=w.getId()%>">
                                            <button type="submit" class="remove-btn">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                                <%
                                }
                                %>
                            </tbody>
                        </table>
                    </div>

                    <!-- Order Summary -->
                    <div class="col-lg-4">
                        <div class="summary-card">
                            <h3 class="summary-title">Order Summary</h3>

                            <div class="summary-row">
                                <span>Total Items:</span> <span><%=cartItems.size()%></span>
                            </div>

                            <div class="summary-row">
                                <span>Shipping:</span> <span>Free</span>
                            </div>

                            <div class="summary-total">
                                <span>Total:</span> <span>₹ <%=String.format("%,d", (int) total)%></span>
                            </div>

                            <form action="checkout" method="post">
                                <button type="submit" class="checkout-btn">
                                    <i class="fas fa-lock me-2"></i>Proceed to Checkout
                                </button>
                            </form>
                            
                            <a href="<%=request.getContextPath()%>/products" class="continue-btn">
                                <i class="fas fa-arrow-left me-2"></i>Continue Shopping
                            </a>

                            <!-- Secure Payment Badge -->
                            <div style="text-align: center; margin-top: 20px;">
                                <small style="color: rgba(255, 255, 255, 0.4);"> 
                                    <i class="fas fa-shield-alt me-1"></i> Secure Payment
                                </small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        <%
        }
        %>
    </div>

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
                        <li><a href="<%=request.getContextPath()%>/profile"><i class="fas fa-chevron-right"></i> My Profile</a></li>
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
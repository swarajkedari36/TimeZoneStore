<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.util.*, com.timezone.model.Order, com.timezone.model.Watch, com.timezone.model.TrackingHistory, java.text.SimpleDateFormat"%>
<%
Order order = (Order) request.getAttribute("order");
String error = (String) request.getAttribute("error");
Integer progress = (Integer) request.getAttribute("progress");

SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
SimpleDateFormat dateOnlyFormat = new SimpleDateFormat("dd MMM yyyy");
%>
<!DOCTYPE html>
<html>
<head>
<title>Track Order - TimeZone</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

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
	border-bottom: 1px solid rgba(255, 255, 255, 0.1);
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
	margin-bottom: 30px;
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

/* Search Card */
.search-card {
	background: rgba(30, 30, 30, 0.6);
	backdrop-filter: blur(10px);
	border: 1px solid rgba(255, 255, 255, 0.1);
	border-radius: 20px;
	padding: 30px;
	margin-bottom: 30px;
}

.search-title {
	color: #fff;
	font-size: 20px;
	font-weight: 600;
	margin-bottom: 20px;
}

.search-form {
	display: flex;
	gap: 15px;
}

.search-input {
	flex: 1;
	padding: 15px 20px;
	background: rgba(255, 255, 255, 0.1);
	border: 1px solid rgba(255, 255, 255, 0.2);
	border-radius: 15px;
	color: #fff;
	font-size: 16px;
}

.search-input:focus {
	outline: none;
	border-color: #c9a959;
	background: rgba(255, 255, 255, 0.15);
}

.search-input::placeholder {
	color: rgba(255, 255, 255, 0.4);
}

.search-btn {
	padding: 15px 30px;
	background: #c9a959;
	color: #000;
	border: none;
	border-radius: 15px;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.3s;
}

.search-btn:hover {
	background: #d4b468;
	transform: translateY(-2px);
}

/* Error Message */
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

/* Tracking Card */
.tracking-card {
	background: rgba(30, 30, 30, 0.6);
	backdrop-filter: blur(10px);
	border: 1px solid rgba(255, 255, 255, 0.1);
	border-radius: 20px;
	padding: 30px;
	margin-top: 30px;
}

.order-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 30px;
	flex-wrap: wrap;
	gap: 20px;
}

.order-number {
	font-size: 24px;
	font-weight: 600;
	color: #c9a959;
}

.order-status {
	padding: 8px 20px;
	border-radius: 50px;
	font-weight: 600;
	font-size: 14px;
}

.status-processing {
	background: rgba(255, 193, 7, 0.2);
	color: #ffc107;
	border: 1px solid rgba(255, 193, 7, 0.3);
}

.status-confirmed {
	background: rgba(0, 123, 255, 0.2);
	color: #007bff;
	border: 1px solid rgba(0, 123, 255, 0.3);
}

.status-shipped {
	background: rgba(40, 167, 69, 0.2);
	color: #28a745;
	border: 1px solid rgba(40, 167, 69, 0.3);
}

.status-delivered {
	background: rgba(40, 167, 69, 0.2);
	color: #28a745;
	border: 1px solid rgba(40, 167, 69, 0.3);
}

/* Progress Bar */
.tracking-progress {
	margin: 40px 0;
	position: relative;
}

.progress-steps {
	display: flex;
	justify-content: space-between;
	margin-bottom: 10px;
}

.step {
	text-align: center;
	color: rgba(255, 255, 255, 0.5);
	font-size: 14px;
	position: relative;
	z-index: 2;
}

.step.active {
	color: #c9a959;
	font-weight: 600;
}

.progress-bar-container {
	height: 6px;
	background: rgba(255, 255, 255, 0.1);
	border-radius: 3px;
	position: relative;
	margin: 20px 0;
}

.progress-bar-fill {
	height: 100%;
	background: #c9a959;
	border-radius: 3px;
	transition: width 0.5s ease;
}

/* Tracking Info Grid */
.info-grid {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
	gap: 20px;
	margin: 30px 0;
	padding: 20px;
	background: rgba(0, 0, 0, 0.3);
	border-radius: 15px;
}

.info-item {
	color: #fff;
}

.info-label {
	color: rgba(255, 255, 255, 0.5);
	font-size: 12px;
	text-transform: uppercase;
	margin-bottom: 5px;
}

.info-value {
	font-size: 16px;
	font-weight: 600;
	color: #c9a959;
}

/* Tracking Timeline */
.timeline {
	margin-top: 40px;
}

.timeline-title {
	color: #fff;
	font-size: 18px;
	font-weight: 600;
	margin-bottom: 20px;
}

.timeline-item {
	display: flex;
	gap: 20px;
	padding: 20px;
	border-left: 2px solid #c9a959;
	margin-left: 20px;
	position: relative;
	margin-bottom: 20px;
}

.timeline-item::before {
	content: '';
	width: 12px;
	height: 12px;
	background: #c9a959;
	border-radius: 50%;
	position: absolute;
	left: -7px;
	top: 24px;
}

.timeline-time {
	min-width: 120px;
	color: rgba(255, 255, 255, 0.5);
	font-size: 14px;
}

.timeline-content {
	flex: 1;
}

.timeline-status {
	color: #c9a959;
	font-weight: 600;
	margin-bottom: 5px;
}

.timeline-desc {
	color: rgba(255, 255, 255, 0.8);
	font-size: 14px;
}

.timeline-location {
	color: rgba(255, 255, 255, 0.5);
	font-size: 12px;
	margin-top: 5px;
}

/* Order Items */
.order-items {
	margin-top: 30px;
	border-top: 1px solid rgba(255, 255, 255, 0.1);
	padding-top: 30px;
}

.items-title {
	color: #fff;
	font-size: 18px;
	font-weight: 600;
	margin-bottom: 20px;
}

.item-row {
	display: flex;
	align-items: center;
	gap: 15px;
	padding: 15px;
	background: rgba(0, 0, 0, 0.2);
	border-radius: 12px;
	margin-bottom: 10px;
}

.item-image {
	width: 60px;
	height: 60px;
	border-radius: 10px;
	object-fit: cover;
}

.item-details {
	flex: 1;
}

.item-name {
	color: #fff;
	font-weight: 500;
}

.item-meta {
	color: rgba(255, 255, 255, 0.5);
	font-size: 13px;
}

.item-price {
	color: #c9a959;
	font-weight: 600;
}

/* Responsive */
@media ( max-width : 768px) {
	.search-form {
		flex-direction: column;
	}
	.order-header {
		flex-direction: column;
		align-items: flex-start;
	}
	.timeline-item {
		flex-direction: column;
		gap: 10px;
	}
	.info-grid {
		grid-template-columns: 1fr;
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
				<a href="<%=request.getContextPath()%>/products"><i
					class="fas fa-store"></i> Shop</a> <a
					href="<%=request.getContextPath()%>/cart.jsp"><i
					class="fas fa-shopping-bag"></i> Cart</a> <a
					href="<%=request.getContextPath()%>/orders"><i
					class="fas fa-box"></i> Orders</a> <a
					href="<%=request.getContextPath()%>/profile"><i
					class="fas fa-user"></i> Profile</a> <a
					href="<%=request.getContextPath()%>/wishlist"><i
					class="fas fa-heart"></i> Wishlist</a>
			</div>
		</div>
	</nav>

	<div class="container">
		<div class="page-header">
			<h1>
				<i class="fas fa-truck"></i> Track Your Order
			</h1>
		</div>

		<!-- Search Form -->
		<div class="search-card">
			<div class="search-title">Enter your order number</div>
			<form class="search-form" action="track-order" method="get">
				<input type="text" name="orderNumber" class="search-input"
					placeholder="e.g., TZ-0D275727"
					value="<%=request.getParameter("orderNumber") != null ? request.getParameter("orderNumber") : ""%>"
					required>
				<button type="submit" class="search-btn">
					<i class="fas fa-search"></i> Track Order
				</button>
			</form>
		</div>

		<%
		if (error != null) {
		%>
		<div class="error-message">
			<i class="fas fa-exclamation-circle"></i>
			<%=error%>
		</div>
		<%
		}
		%>

		<%
		if (order != null) {
		%>
		<!-- Tracking Results -->
		<div class="tracking-card">
			<div class="order-header">
				<div>
					<div class="order-number">
						Order #<%=order.getOrderNumber()%></div>
					<div
						style="color: rgba(255, 255, 255, 0.5); font-size: 14px; margin-top: 5px;">
						Placed on
						<%=dateFormat.format(order.getOrderDate())%>
					</div>
				</div>
				<div
					class="order-status status-<%=order.getTrackingStatus().toLowerCase().replace(" ", "")%>">
					<i
						class="fas fa-<%=order.getTrackingStatus().equals("Delivered") ? "check-circle" : "clock"%> me-2"></i>
					<%=order.getTrackingStatus() != null ? order.getTrackingStatus() : "Processing"%>
				</div>
			</div>

			<!-- Progress Bar -->
			<div class="tracking-progress">
				<div class="progress-steps">
					<span class="step <%=progress >= 20 ? "active" : ""%>">Processing</span>
					<span class="step <%=progress >= 40 ? "active" : ""%>">Confirmed</span>
					<span class="step <%=progress >= 60 ? "active" : ""%>">Shipped</span>
					<span class="step <%=progress >= 80 ? "active" : ""%>">Out
						for Delivery</span> <span
						class="step <%=progress >= 100 ? "active" : ""%>">Delivered</span>
				</div>
				<div class="progress-bar-container">
					<div class="progress-bar-fill" style="width: <%=progress%>%;"></div>
				</div>
			</div>

			<!-- Tracking Info -->
			<div class="info-grid">
				<div class="info-item">
					<div class="info-label">Tracking Number</div>
					<div class="info-value"><%=order.getTrackingNumber() != null ? order.getTrackingNumber() : "Not yet assigned"%></div>
				</div>
				<div class="info-item">
					<div class="info-label">Carrier</div>
					<div class="info-value"><%=order.getShippingCarrier() != null ? order.getShippingCarrier() : "Standard Shipping"%></div>
				</div>
				<div class="info-item">
					<div class="info-label">Estimated Delivery</div>
					<div class="info-value">
						<%=order.getEstimatedDelivery() != null ? dateOnlyFormat.format(order.getEstimatedDelivery()) : "To be updated"%>
					</div>
				</div>
				<div class="info-item">
					<div class="info-label">Shipping Address</div>
					<div class="info-value"><%=order.getShippingAddress() != null ? order.getShippingAddress() : "Address on file"%></div>
				</div>
			</div>

			<!-- Tracking Timeline -->
			<%
			if (order.getTrackingHistory() != null && !order.getTrackingHistory().isEmpty()) {
			%>
			<div class="timeline">
				<div class="timeline-title">Tracking History</div>
				<%
				for (Order.TrackingHistory th : order.getTrackingHistory()) {
				%>
				<div class="timeline-item">
					<div class="timeline-time"><%=dateFormat.format(th.getCreatedAt())%></div>
					<div class="timeline-content">
						<div class="timeline-status"><%=th.getStatus()%></div>
						<div class="timeline-desc"><%=th.getDescription()%></div>
						<%
						if (th.getLocation() != null && !th.getLocation().isEmpty()) {
						%>
						<div class="timeline-location">
							<i class="fas fa-map-marker-alt me-1"></i>
							<%=th.getLocation()%>
						</div>
						<%
						}
						%>
					</div>
				</div>
				<%
				}
				%>
			</div>
			<%
			}
			%>

			<!-- Order Items -->
			<div class="order-items">
				<div class="items-title">Items in this order</div>
				<%
				for (Watch item : order.getItems()) {
				%>
				<div class="item-row">
					<img
						src="<%=request.getContextPath()%>/images/<%=item.getImage()%>"
						alt="<%=item.getName()%>" class="item-image"
						onerror="this.src='<%=request.getContextPath()%>/images/placeholder.jpg'">
					<div class="item-details">
						<div class="item-name"><%=item.getName()%></div>
						<div class="item-meta"><%=item.getBrand()%>
							| Qty:
							<%=item.getQuantity()%></div>
					</div>
					<div class="item-price">
						₹
						<%=String.format("%,d", (int) (item.getPrice() * item.getQuantity()))%></div>
				</div>
				<%
				}
				%>
			</div>
		</div>
		<%
		}
		%>
	</div>

	<!-- Bootstrap JS -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
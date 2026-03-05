<%-- <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Order Confirmed</title>
</head>
<body style="text-align:center; padding:100px; font-family:Arial;">

    <h1>🎉 Order Placed Successfully!</h1>
    <p>Thank you for shopping with TimeZone Store.</p>

    <a href="products.jsp">
        <button style="padding:10px 20px;">
            Shop More
        </button>
    </a>

</body>
</html> --%>


<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.timezone.model.Watch"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Order Confirmed - TimeZone</title>

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
	background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)),
		url('<%=request.getContextPath()%>/images/bg.jpg') no-repeat center
		center fixed;
	background-size: cover;
	font-family: 'Inter', sans-serif;
	min-height: 100vh;
	display: flex;
	align-items: center;
	justify-content: center;
	color: #fff;
}

/* Glass Card Effect */
.success-card {
	background: rgba(255, 255, 255, 0.08);
	backdrop-filter: blur(12px);
	border: 1px solid rgba(255, 255, 255, 0.1);
	border-radius: 30px;
	padding: 60px 40px;
	max-width: 600px;
	width: 90%;
	margin: 20px;
	box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
	text-align: center;
	animation: fadeInUp 0.8s ease-out;
}

@
keyframes fadeInUp {from { opacity:0;
	transform: translateY(30px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}

/* Success Icon Animation */
.success-icon {
	font-size: 100px;
	color: #c9a959;
	margin-bottom: 30px;
	animation: scaleIn 0.6s ease-out, float 3s ease-in-out infinite;
}

@
keyframes scaleIn {from { transform:scale(0);
	opacity: 0;
}

to {
	transform: scale(1);
	opacity: 1;
}

}
@
keyframes float { 0%, 100% {
	transform: translateY(0);
}

50
%
{
transform
:
translateY(
-10px
);
}
}

/* Checkmark Circle */
.checkmark-circle {
	width: 120px;
	height: 120px;
	background: rgba(201, 169, 89, 0.15);
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	margin: 0 auto 30px;
	border: 2px solid #c9a959;
	animation: pulse 2s infinite;
}

@
keyframes pulse { 0% {
	box-shadow: 0 0 0 0 rgba(201, 169, 89, 0.4);
}

70
%
{
box-shadow
:
0
0
0
15px
rgba(
201
,
169
,
89
,
0
);
}
100
%
{
box-shadow
:
0
0
0
0
rgba(
201
,
169
,
89
,
0
);
}
}
.checkmark-circle i {
	font-size: 60px;
	color: #c9a959;
}

/* Order Status */
.order-status {
	margin: 30px 0;
	padding: 20px;
	background: rgba(255, 255, 255, 0.05);
	border-radius: 20px;
	border: 1px solid rgba(255, 255, 255, 0.1);
}

.status-item {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 10px 0;
	border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.status-item:last-child {
	border-bottom: none;
}

.status-label {
	color: rgba(255, 255, 255, 0.6);
	font-size: 14px;
	font-weight: 500;
	text-transform: uppercase;
	letter-spacing: 1px;
}

.status-value {
	color: #c9a959;
	font-weight: 600;
	font-size: 16px;
}

/* Headings */
h1 {
	font-size: 42px;
	font-weight: 600;
	margin-bottom: 15px;
	color: #fff;
	letter-spacing: -0.5px;
}

.order-message {
	font-size: 18px;
	color: rgba(255, 255, 255, 0.8);
	margin-bottom: 30px;
	line-height: 1.6;
}

.order-number {
	background: rgba(201, 169, 89, 0.1);
	padding: 12px 25px;
	border-radius: 50px;
	display: inline-block;
	margin-bottom: 25px;
	border: 1px dashed #c9a959;
	font-size: 18px;
}

.order-number span {
	color: #c9a959;
	font-weight: 600;
	margin-left: 10px;
	letter-spacing: 2px;
}

/* Buttons */
.btn-group {
	display: flex;
	gap: 15px;
	justify-content: center;
	margin-top: 40px;
	flex-wrap: wrap;
}

.btn-shop {
	background: #c9a959;
	color: #000;
	padding: 15px 40px;
	border-radius: 50px;
	text-decoration: none;
	font-weight: 600;
	font-size: 16px;
	display: inline-flex;
	align-items: center;
	justify-content: center;
	gap: 10px;
	transition: all 0.3s;
	border: none;
	cursor: pointer;
	min-width: 200px;
}

.btn-shop:hover {
	background: #d4b468;
	transform: translateY(-3px);
	box-shadow: 0 10px 25px rgba(201, 169, 89, 0.3);
	color: #000;
}

.btn-view-order {
	background: transparent;
	color: #fff;
	padding: 15px 40px;
	border-radius: 50px;
	text-decoration: none;
	font-weight: 500;
	font-size: 16px;
	display: inline-flex;
	align-items: center;
	justify-content: center;
	gap: 10px;
	transition: all 0.3s;
	border: 1px solid rgba(255, 255, 255, 0.2);
	min-width: 200px;
}

.btn-view-order:hover {
	background: rgba(255, 255, 255, 0.1);
	border-color: #c9a959;
	color: #c9a959;
	transform: translateY(-3px);
}

/* Delivery Info */
.delivery-info {
	margin-top: 30px;
	padding: 20px;
	background: rgba(0, 0, 0, 0.2);
	border-radius: 15px;
	border: 1px solid rgba(255, 255, 255, 0.05);
}

.delivery-info i {
	color: #c9a959;
	margin-right: 10px;
}

.delivery-info p {
	color: rgba(255, 255, 255, 0.7);
	font-size: 14px;
	margin: 0;
}

/* Confetti Animation */
.confetti {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	pointer-events: none;
	z-index: 0;
}

.confetti-piece {
	position: absolute;
	width: 10px;
	height: 20px;
	background: #c9a959;
	opacity: 0.6;
	animation: confettiFall 5s linear infinite;
}

@
keyframes confettiFall { 0% {
	transform: translateY(-100%) rotate(0deg);
	opacity: 0.6;
}

100
%
{
transform
:
translateY(
100vh
)
rotate(
720deg
);
opacity
:
0;
}
}

/* Responsive */
@media ( max-width : 768px) {
	.success-card {
		padding: 40px 20px;
	}
	h1 {
		font-size: 32px;
	}
	.btn-group {
		flex-direction: column;
	}
	.btn-shop, .btn-view-order {
		width: 100%;
	}
}
</style>
</head>
<body>
	<!-- Confetti Effect (optional) -->
	<div class="confetti" id="confetti"></div>

	<div class="success-card">
		<!-- Success Icon with Checkmark -->
		<div class="checkmark-circle">
			<i class="fas fa-check"></i>
		</div>

		<!-- Main Heading -->
		<h1>Order Confirmed! 🎉</h1>

		<!-- Order Number (you can make this dynamic) -->
		<div class="order-number">
			<i class="fas fa-receipt"></i> <span>#TZ-<%=new java.util.Random().nextInt(100000)%></span>
		</div>

		<!-- Success Message -->
		<p class="order-message">
			Thank you for shopping with TimeZone Store.<br> Your order has
			been placed successfully and will be processed shortly.
		</p>

		<!-- Order Status Summary -->
		<div class="order-status">
			<div class="status-item">
				<span class="status-label"><i class="fas fa-clock me-2"></i>Order
					Status</span> <span class="status-value">Confirmed</span>
			</div>
			<div class="status-item">
				<span class="status-label"><i class="fas fa-truck me-2"></i>Delivery</span>
				<span class="status-value">3-5 Business Days</span>
			</div>
			<div class="status-item">
				<span class="status-label"><i class="fas fa-credit-card me-2"></i>Payment</span>
				<span class="status-value">Success</span>
			</div>
		</div>

		<!-- Delivery Information -->
		<div class="delivery-info">
			<p>
				<i class="fas fa-envelope"></i> A confirmation email has been sent
				to your registered email address.
			</p>
			<p class="mt-2">
				<i class="fas fa-map-marker-alt"></i> Track your order in the "My
				Orders" section.
			</p>
		</div>

		<!-- Action Buttons -->
		<div class="btn-group">
			<a href="<%=request.getContextPath()%>/products" class="btn-shop">
				<i class="fas fa-shopping-bag"></i> Continue Shopping
			</a> <a href="<%=request.getContextPath()%>/orders"
				class="btn-view-order"> <i class="fas fa-box"></i> View Orders
			</a>
		</div>

		<!-- Back to Home Link (optional) -->
		<%--  <div style="margin-top: 30px;">
            <a href="<%=request.getContextPath()%>/index.jsp" style="color: rgba(255,255,255,0.5); text-decoration: none; font-size: 14px;">
                <i class="fas fa-arrow-left me-1"></i> Back to Home
            </a>
        </div>
    </div> --%>

		<!-- Bootstrap JS -->
		<script
			src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

		<!-- Confetti Animation Script (optional) -->
		<script>
			// Create confetti pieces
			function createConfetti() {
				const confettiContainer = document.getElementById('confetti');
				if (!confettiContainer)
					return;

				for (let i = 0; i < 50; i++) {
					const confetti = document.createElement('div');
					confetti.className = 'confetti-piece';

					// Random properties
					confetti.style.left = Math.random() * 100 + '%';
					confetti.style.animationDelay = Math.random() * 5 + 's';
					confetti.style.animationDuration = (Math.random() * 3 + 2)
							+ 's';
					confetti.style.background = `hsl(${Math.random() * 60 + 30}, 80%, 60%)`;
					confetti.style.width = Math.random() * 10 + 5 + 'px';
					confetti.style.height = Math.random() * 15 + 10 + 'px';

					confettiContainer.appendChild(confetti);
				}
			}

			// Run on page load
			window.onload = function() {
				createConfetti();
			};
		</script>
</body>
</html>
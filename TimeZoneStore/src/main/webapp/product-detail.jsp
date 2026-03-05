<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.timezone.model.Watch, com.timezone.model.Review, java.text.SimpleDateFormat" %>
<%
    Watch watch = (Watch) request.getAttribute("watch");
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    Double avgRating = (Double) request.getAttribute("avgRating");
    int[] ratingSummary = (int[]) request.getAttribute("ratingSummary");
    int totalReviews = (int) request.getAttribute("totalReviews");
    Boolean hasReviewed = (Boolean) request.getAttribute("hasReviewed");
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
    
    String reviewAdded = request.getParameter("review");
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= watch != null ? watch.getName() : "Product Details" %> - TimeZone</title>
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
        
        /* Product Card */
        .product-detail-card {
            background: rgba(30, 30, 30, 0.6);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 30px;
            padding: 40px;
            margin-bottom: 40px;
        }
        
        .product-image-container {
            text-align: center;
            padding: 30px;
            background: rgba(0, 0, 0, 0.3);
            border-radius: 20px;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .product-image-container img {
            max-width: 100%;
            max-height: 400px;
            object-fit: contain;
        }
        
        .product-info {
            color: #fff;
        }
        
        .product-brand {
            color: #c9a959;
            font-size: 18px;
            font-weight: 600;
            text-transform: uppercase;
            margin-bottom: 10px;
        }
        
        .product-name {
            font-size: 36px;
            font-weight: 600;
            margin-bottom: 20px;
        }
        
        .product-price {
            font-size: 42px;
            font-weight: 700;
            color: #c9a959;
            margin-bottom: 20px;
        }
        
        .product-price small {
            font-size: 16px;
            color: rgba(255,255,255,0.5);
            font-weight: 400;
        }
        
        .product-description {
            color: rgba(255,255,255,0.8);
            font-size: 16px;
            line-height: 1.8;
            margin-bottom: 30px;
        }
        
        /* Rating Summary */
        .rating-summary {
            background: rgba(255,255,255,0.05);
            border-radius: 20px;
            padding: 30px;
            margin: 30px 0;
        }
        
        .average-rating {
            text-align: center;
            padding: 20px;
            border-right: 1px solid rgba(255,255,255,0.1);
        }
        
        .average-rating .big-number {
            font-size: 64px;
            font-weight: 700;
            color: #c9a959;
            line-height: 1;
        }
        
        .average-rating .stars {
            font-size: 20px;
            color: #c9a959;
            margin: 10px 0;
        }
        
        .average-rating .total {
            color: rgba(255,255,255,0.5);
            font-size: 14px;
        }
        
        .rating-bars {
            padding: 20px;
        }
        
        .rating-row {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 12px;
        }
        
        .rating-label {
            width: 60px;
            color: #fff;
        }
        
        .rating-bar-container {
            flex: 1;
            height: 10px;
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
            overflow: hidden;
        }
        
        .rating-bar {
            height: 100%;
            background: #c9a959;
            border-radius: 10px;
        }
        
        .rating-count {
            width: 50px;
            color: rgba(255,255,255,0.6);
            font-size: 14px;
        }
        
        /* Reviews Section */
        .reviews-section {
            background: rgba(30, 30, 30, 0.6);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 30px;
            padding: 40px;
        }
        
        .section-title {
            color: #fff;
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .section-title i {
            color: #c9a959;
        }
        
        /* Review Form */
        .review-form {
            background: rgba(255,255,255,0.05);
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 40px;
        }
        
        .star-rating {
            display: flex;
            flex-direction: row-reverse;
            justify-content: flex-end;
            gap: 5px;
            margin-bottom: 20px;
        }
        
        .star-rating input {
            display: none;
        }
        
        .star-rating label {
            font-size: 30px;
            color: rgba(255,255,255,0.3);
            cursor: pointer;
            transition: color 0.2s;
        }
        
        .star-rating label:hover,
        .star-rating label:hover ~ label,
        .star-rating input:checked ~ label {
            color: #c9a959;
        }
        
        .form-control {
            background: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 15px;
            padding: 15px;
            color: #fff;
            margin-bottom: 20px;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #c9a959;
            background: rgba(255,255,255,0.15);
        }
        
        .submit-btn {
            background: #c9a959;
            color: #000;
            border: none;
            border-radius: 15px;
            padding: 12px 30px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .submit-btn:hover {
            background: #d4b468;
            transform: translateY(-2px);
        }
        
        /* Review Card */
        .review-card {
            background: rgba(255,255,255,0.03);
            border-radius: 20px;
            padding: 25px;
            margin-bottom: 20px;
            border: 1px solid rgba(255,255,255,0.05);
        }
        
        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .reviewer-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .reviewer-avatar {
            width: 50px;
            height: 50px;
            background: rgba(201, 169, 89, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #c9a959;
            font-size: 20px;
            border: 2px solid #c9a959;
        }
        
        .reviewer-name {
            color: #fff;
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .review-date {
            color: rgba(255,255,255,0.4);
            font-size: 12px;
        }
        
        .review-rating {
            color: #c9a959;
            font-size: 16px;
        }
        
        .review-text {
            color: rgba(255,255,255,0.9);
            font-size: 15px;
            line-height: 1.6;
            margin: 15px 0;
        }
        
        .review-actions {
            display: flex;
            gap: 20px;
            border-top: 1px solid rgba(255,255,255,0.05);
            padding-top: 15px;
        }
        
        .helpful-btn {
            background: transparent;
            border: none;
            color: rgba(255,255,255,0.5);
            cursor: pointer;
            transition: color 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .helpful-btn:hover {
            color: #c9a959;
        }
        
        .helpful-btn.active {
            color: #c9a959;
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
        
        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        
        .add-to-cart-btn {
            flex: 2;
            background: #c9a959;
            color: #000;
            border: none;
            border-radius: 15px;
            padding: 15px;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .add-to-cart-btn:hover {
            background: #d4b468;
            transform: translateY(-2px);
        }
        
        .wishlist-btn {
            flex: 1;
            background: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 15px;
            color: #ff6b6b;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            transition: all 0.3s;
        }
        
        .wishlist-btn:hover {
            background: #ff6b6b;
            color: #fff;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .product-detail-card {
                padding: 20px;
            }
            
            .product-name {
                font-size: 28px;
            }
            
            .product-price {
                font-size: 32px;
            }
            
            .average-rating {
                border-right: none;
                border-bottom: 1px solid rgba(255,255,255,0.1);
                margin-bottom: 20px;
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
            <a href="wishlist"><i class="fas fa-heart"></i> Wishlist</a>
        </div>
    </div>
</nav>

<div class="container">
    <% if (watch != null) { %>
    
    <!-- Product Detail Card -->
    <div class="product-detail-card">
        <div class="row">
            <div class="col-lg-5 mb-4 mb-lg-0">
                <div class="product-image-container">
                    <img src="<%= request.getContextPath() %>/images/<%= watch.getImage() %>" 
                         alt="<%= watch.getName() %>"
                         onerror="this.src='<%= request.getContextPath() %>/images/placeholder.jpg'">
                </div>
            </div>
            <div class="col-lg-7">
                <div class="product-info">
                    <div class="product-brand"><%= watch.getBrand() %></div>
                    <h1 class="product-name"><%= watch.getName() %></h1>
                    
                    <div class="product-price">
                        ₹ <%= String.format("%,d", (int)watch.getPrice()) %>
                        <small>Free Shipping</small>
                    </div>
                    
                    <p class="product-description"><%= watch.getDescription() %></p>
                    
                    <!-- Action Buttons -->
                    <div class="action-buttons">
                        <form action="addToCart" method="post" style="flex: 2;">
                            <input type="hidden" name="id" value="<%= watch.getId() %>">
                            <button type="submit" class="add-to-cart-btn">
                                <i class="fas fa-shopping-cart"></i> Add to Cart
                            </button>
                        </form>
                        <a href="wishlist?action=add&watchId=<%= watch.getId() %>" class="wishlist-btn">
                            <i class="fas fa-heart"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Rating Summary -->
    <% if (totalReviews > 0) { %>
    <div class="rating-summary">
        <div class="row align-items-center">
            <div class="col-md-4">
                <div class="average-rating">
                    <div class="big-number"><%= String.format("%.1f", avgRating) %></div>
                    <div class="stars">
                        <% for (int i = 1; i <= 5; i++) { %>
                            <% if (i <= Math.round(avgRating)) { %>
                                <i class="fas fa-star"></i>
                            <% } else { %>
                                <i class="far fa-star"></i>
                            <% } %>
                        <% } %>
                    </div>
                    <div class="total"><%= totalReviews %> <%= totalReviews == 1 ? "Review" : "Reviews" %></div>
                </div>
            </div>
            <div class="col-md-8">
                <div class="rating-bars">
                    <% for (int i = 5; i >= 1; i--) { 
                        int count = ratingSummary != null && ratingSummary.length > i ? ratingSummary[i] : 0;
                        int percentage = totalReviews > 0 ? (count * 100 / totalReviews) : 0;
                    %>
                    <div class="rating-row">
                        <div class="rating-label"><%= i %> <i class="fas fa-star" style="color: #c9a959; font-size: 12px;"></i></div>
                        <div class="rating-bar-container">
                            <div class="rating-bar" style="width: <%= percentage %>%"></div>
                        </div>
                        <div class="rating-count"><%= count %></div>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
    <% } %>
    
    <!-- Reviews Section -->
    <div class="reviews-section">
        <div class="section-title">
            <i class="fas fa-star"></i>
            Customer Reviews
        </div>
        
        <!-- Review Form -->
        <% if (!hasReviewed) { %>
        <div class="review-form">
            <h4 style="color: #fff; margin-bottom: 20px;">Write a Review</h4>
            <form action="review" method="post">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="watchId" value="<%= watch.getId() %>">
                
                <div class="star-rating">
                    <input type="radio" name="rating" id="star5" value="5" required>
                    <label for="star5"><i class="fas fa-star"></i></label>
                    <input type="radio" name="rating" id="star4" value="4">
                    <label for="star4"><i class="fas fa-star"></i></label>
                    <input type="radio" name="rating" id="star3" value="3">
                    <label for="star3"><i class="fas fa-star"></i></label>
                    <input type="radio" name="rating" id="star2" value="2">
                    <label for="star2"><i class="fas fa-star"></i></label>
                    <input type="radio" name="rating" id="star1" value="1">
                    <label for="star1"><i class="fas fa-star"></i></label>
                </div>
                
                <textarea name="reviewText" class="form-control" rows="4" 
                          placeholder="Share your experience with this watch..." required></textarea>
                
                <button type="submit" class="submit-btn">
                    <i class="fas fa-paper-plane"></i> Submit Review
                </button>
            </form>
        </div>
        <% } %>
        
        <!-- Success/Error Messages -->
        <% if ("added".equals(reviewAdded)) { %>
            <div class="success-message">
                <i class="fas fa-check-circle"></i>
                Thank you! Your review has been submitted.
            </div>
        <% } else if ("error".equals(reviewAdded)) { %>
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i>
                Error submitting review. Please try again.
            </div>
        <% } %>
        
        <!-- Reviews List -->
        <% if (reviews != null && !reviews.isEmpty()) { %>
            <div style="margin-top: 30px;">
                <% for (Review review : reviews) { %>
                <div class="review-card">
                    <div class="review-header">
                        <div class="reviewer-info">
                            <div class="reviewer-avatar">
                                <%= review.getUserName() != null ? review.getUserName().substring(0,1).toUpperCase() : "U" %>
                            </div>
                            <div>
                                <div class="reviewer-name"><%= review.getUserName() %></div>
                                <div class="review-date"><%= dateFormat.format(review.getCreatedAt()) %></div>
                            </div>
                        </div>
                        <div class="review-rating">
                            <% for (int i = 1; i <= 5; i++) { %>
                                <% if (i <= review.getRating()) { %>
                                    <i class="fas fa-star"></i>
                                <% } else { %>
                                    <i class="far fa-star"></i>
                                <% } %>
                            <% } %>
                        </div>
                    </div>
                    
                    <div class="review-text">
                        <%= review.getReviewText() %>
                    </div>
                    
                    <div class="review-actions">
                        <form action="review" method="post" style="display: inline;">
                            <input type="hidden" name="action" value="helpful">
                            <input type="hidden" name="reviewId" value="<%= review.getId() %>">
                            <input type="hidden" name="watchId" value="<%= watch.getId() %>">
                            <input type="hidden" name="helpful" value="<%= !review.isUserHelpful() %>">
                            <button type="submit" class="helpful-btn <%= review.isUserHelpful() ? "active" : "" %>">
                                <i class="fas fa-thumbs-up"></i>
                                Helpful (<%= review.getHelpfulCount() %>)
                            </button>
                        </form>
                    </div>
                </div>
                <% } %>
            </div>
        <% } else { %>
            <div style="text-align: center; padding: 60px 20px; color: rgba(255,255,255,0.5);">
                <i class="fas fa-comment" style="font-size: 50px; margin-bottom: 20px;"></i>
                <h4 style="color: #fff;">No Reviews Yet</h4>
                <p>Be the first to review this watch!</p>
            </div>
        <% } %>
    </div>
    
    <% } else { %>
        <div style="text-align: center; padding: 100px; color: #fff;">
            <i class="fas fa-exclamation-circle" style="font-size: 60px; color: #c9a959; margin-bottom: 20px;"></i>
            <h2>Product Not Found</h2>
            <p>The watch you're looking for doesn't exist.</p>
            <a href="products" class="submit-btn" style="display: inline-block; margin-top: 20px;">Browse Watches</a>
        </div>
    <% } %>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Auto-hide messages after 3 seconds
    setTimeout(function() {
        document.querySelectorAll('.success-message, .error-message').forEach(msg => {
            msg.style.transition = 'opacity 0.5s';
            msg.style.opacity = '0';
            setTimeout(() => msg.remove(), 500);
        });
    }, 3000);
</script>

</body>
</html>
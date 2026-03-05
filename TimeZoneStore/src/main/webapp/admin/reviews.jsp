<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%
    List<Map<String, Object>> reviews = (List<Map<String, Object>>) request.getAttribute("reviews");
    Integer pendingReviews = (Integer) request.getAttribute("pendingReviews");
    Integer approvedReviews = (Integer) request.getAttribute("approvedReviews");
    Integer rejectedReviews = (Integer) request.getAttribute("rejectedReviews");
    List<Map<String, Object>> watches = (List<Map<String, Object>>) request.getAttribute("watches");
    
    String selectedStatus = (String) request.getAttribute("selectedStatus");
    String selectedWatchId = (String) request.getAttribute("selectedWatchId");
    String selectedRating = (String) request.getAttribute("selectedRating");
    
    String approved = request.getParameter("approved");
    String rejected = request.getParameter("rejected");
    String deleted = request.getParameter("deleted");
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Reviews - TimeZone Admin</title>
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
        
        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: #222;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            padding: 20px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .stat-card:hover, .stat-card.active {
            border-color: #c9a959;
            transform: translateY(-2px);
        }
        
        .stat-label {
            color: rgba(255,255,255,0.5);
            font-size: 14px;
            margin-bottom: 5px;
        }
        
        .stat-value {
            color: #fff;
            font-size: 28px;
            font-weight: 600;
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
        
        /* Filter Section */
        /* .filter-section {
            background: #222;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
        }
        
        .filter-title {
            color: #c9a959;
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 15px;
        }
        
        .filter-form {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            align-items: flex-end;
        }
        
        .filter-group {
            flex: 1;
            min-width: 150px;
        }
        
        .filter-label {
            color: rgba(255,255,255,0.5);
            font-size: 12px;
            margin-bottom: 5px;
        }
        
        .filter-control {
            width: 100%;
            padding: 10px 12px;
            background: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 8px;
            color: #fff;
        }
        
        .filter-control:focus {
            outline: none;
            border-color: #c9a959;
        }
        
        .filter-btn {
            padding: 10px 25px;
            background: #c9a959;
            color: #000;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .filter-btn:hover {
            background: #d4b468;
        }
        
        .reset-btn {
            padding: 10px 25px;
            background: transparent;
            color: #fff;
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 8px;
            text-decoration: none;
            transition: all 0.3s;
        }
         */
           /* Filter Section Enhanced */
.filter-section {
    background: #2a2a2a; /* Darker background */
    border: 1px solid #3a3a3a;
    border-radius: 12px;
    padding: 25px;
    margin-bottom: 30px;
    box-shadow: 0 4px 6px rgba(0,0,0,0.3);
}

.filter-title {
    color: #c9a959; /* Gold color */
    font-size: 18px;
    font-weight: 600;
    margin-bottom: 20px;
    border-bottom: 1px solid #3a3a3a;
    padding-bottom: 10px;
}

.filter-label {
    color: #c9a959; /* Gold color for labels */
    font-size: 13px;
    font-weight: 500;
    margin-bottom: 8px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.filter-control {
    width: 100%;
    padding: 12px 15px;
    background: #1e1e1e; /* Darker input background */
    border: 1px solid #3a3a3a;
    border-radius: 8px;
    color: #ffffff; /* White text */
    font-size: 14px;
    transition: all 0.3s;
}

.filter-control:focus {
    outline: none;
    border-color: #c9a959;
    background: #2a2a2a;
    box-shadow: 0 0 0 2px rgba(201,169,89,0.2);
}

.filter-control option {
    background: #1e1e1e;
    color: #ffffff;
    padding: 10px;
}

.filter-btn {
    padding: 12px 25px;
    background: #c9a959;
    color: #000000; /* Black text on gold */
    border: none;
    border-radius: 8px;
    font-weight: 600;
    font-size: 14px;
    cursor: pointer;
    transition: all 0.3s;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    height: 45px;
}

.filter-btn:hover {
    background: #d4b468;
    transform: translateY(-2px);
    box-shadow: 0 4px 10px rgba(201,169,89,0.3);
}
         
        .reset-btn:hover {
            border-color: #c9a959;
            color: #c9a959;
        }
        
        /* Reviews Table */
        .reviews-table {
            background: #222;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            padding: 20px;
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
            vertical-align: top;
        }
        
        tr:hover {
            background: rgba(255,255,255,0.05);
        }
        
        .review-product {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .product-image {
            width: 40px;
            height: 40px;
            object-fit: cover;
            border-radius: 5px;
            border: 1px solid #c9a959;
        }
        
        .stars {
            color: #c9a959;
            font-size: 12px;
            margin-bottom: 5px;
        }
        
        .review-text {
            color: rgba(255,255,255,0.9);
            font-size: 14px;
            line-height: 1.5;
            margin: 10px 0;
            max-width: 300px;
        }
        
        .user-info {
            font-size: 13px;
        }
        
        .user-name {
            color: #c9a959;
            font-weight: 600;
        }
        
        .user-email {
            color: rgba(255,255,255,0.5);
            font-size: 11px;
        }
        
        .status-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 50px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-pending {
            background: rgba(255,193,7,0.2);
            color: #ffc107;
            border: 1px solid rgba(255,193,7,0.3);
        }
        
        .status-approved {
            background: rgba(40,167,69,0.2);
            color: #28a745;
            border: 1px solid rgba(40,167,69,0.3);
        }
        
        .status-rejected {
            background: rgba(220,53,69,0.2);
            color: #dc3545;
            border: 1px solid rgba(220,53,69,0.3);
        }
        
        .action-buttons {
            display: flex;
            gap: 5px;
            flex-wrap: wrap;
        }
        
        .action-btn {
            padding: 5px 10px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 12px;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 3px;
        }
        
        .approve-btn {
            background: rgba(40,167,69,0.1);
            color: #28a745;
            border: 1px solid rgba(40,167,69,0.3);
        }
        
        .approve-btn:hover {
            background: #28a745;
            color: #fff;
        }
        
        .reject-btn {
            background: rgba(255,193,7,0.1);
            color: #ffc107;
            border: 1px solid rgba(255,193,7,0.3);
        }
        
        .reject-btn:hover {
            background: #ffc107;
            color: #000;
        }
        
        .delete-btn {
            background: rgba(220,53,69,0.1);
            color: #dc3545;
            border: 1px solid rgba(220,53,69,0.3);
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
            <li><a href="products"><i class="fas fa-clock"></i> Products</a></li>
            <li><a href="orders"><i class="fas fa-shopping-bag"></i> Orders</a></li>
            <li><a href="users"><i class="fas fa-users"></i> Users</a></li>
            <li><a href="reviews" class="active"><i class="fas fa-star"></i> Reviews</a></li>
            <li><a href="reports"><i class="fas fa-chart-bar"></i> Reports</a></li>
            <li style="margin-top: 30px;"><a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>
    
    <!-- Main Content -->
    <div class="main-content">
        <div class="header">
            <h1>Manage Reviews</h1>
        </div>
        
        <!-- Success Messages -->
        <% if ("true".equals(approved)) { %>
            <div class="success-message">
                <i class="fas fa-check-circle"></i>
                Review approved successfully!
            </div>
        <% } %>
        
        <% if ("true".equals(rejected)) { %>
            <div class="success-message">
                <i class="fas fa-check-circle"></i>
                Review rejected successfully!
            </div>
        <% } %>
        
        <% if ("true".equals(deleted)) { %>
            <div class="success-message">
                <i class="fas fa-check-circle"></i>
                Review deleted successfully!
            </div>
        <% } %>
        
        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card <%= ("pending".equals(selectedStatus) || selectedStatus == null) ? "active" : "" %>" onclick="filterByStatus('pending')">
                <div class="stat-label">Pending</div>
                <div class="stat-value"><%= pendingReviews != null ? pendingReviews : 0 %></div>
            </div>
            <div class="stat-card <%= "approved".equals(selectedStatus) ? "active" : "" %>" onclick="filterByStatus('approved')">
                <div class="stat-label">Approved</div>
                <div class="stat-value"><%= approvedReviews != null ? approvedReviews : 0 %></div>
            </div>
            <div class="stat-card <%= "rejected".equals(selectedStatus) ? "active" : "" %>" onclick="filterByStatus('rejected')">
                <div class="stat-label">Rejected</div>
                <div class="stat-value"><%= rejectedReviews != null ? rejectedReviews : 0 %></div>
            </div>
        </div>
        
        <!-- Filter Section -->
        <div class="filter-section">
            <div class="filter-title">Filter Reviews</div>
            <form class="filter-form" action="reviews" method="get">
                <div class="filter-group">
                    <div class="filter-label">Status</div>
                    <select name="status" class="filter-control">
                        <option value="all">All Status</option>
                        <option value="pending" <%= "pending".equals(selectedStatus) ? "selected" : "" %>>Pending</option>
                        <option value="approved" <%= "approved".equals(selectedStatus) ? "selected" : "" %>>Approved</option>
                        <option value="rejected" <%= "rejected".equals(selectedStatus) ? "selected" : "" %>>Rejected</option>
                    </select>
                </div>
                <div class="filter-group">
                    <div class="filter-label">Watch</div>
                    <select name="watchId" class="filter-control">
                        <option value="all">All Watches</option>
                        <% if (watches != null) {
                            for (Map<String, Object> watch : watches) { %>
                                <option value="<%= watch.get("id") %>" 
                                    <%= String.valueOf(watch.get("id")).equals(selectedWatchId) ? "selected" : "" %>>
                                    <%= watch.get("name") %>
                                </option>
                        <% } } %>
                    </select>
                </div>
                <div class="filter-group">
                    <div class="filter-label">Rating</div>
                    <select name="rating" class="filter-control">
                        <option value="all">All Ratings</option>
                        <option value="5" <%= "5".equals(selectedRating) ? "selected" : "" %>>5 Stars</option>
                        <option value="4" <%= "4".equals(selectedRating) ? "selected" : "" %>>4 Stars</option>
                        <option value="3" <%= "3".equals(selectedRating) ? "selected" : "" %>>3 Stars</option>
                        <option value="2" <%= "2".equals(selectedRating) ? "selected" : "" %>>2 Stars</option>
                        <option value="1" <%= "1".equals(selectedRating) ? "selected" : "" %>>1 Star</option>
                    </select>
                </div>
                <button type="submit" class="filter-btn">
                    <i class="fas fa-search me-2"></i> Apply Filters
                </button>
                <a href="reviews" class="reset-btn">
                    <i class="fas fa-redo me-2"></i> Reset
                </a>
            </form>
        </div>
        
        <!-- Reviews Table -->
        <div class="reviews-table">
            <% if (reviews != null && !reviews.isEmpty()) { %>
                <table>
                    <thead>
                        <tr>
                            <th>Product</th>
                            <th>Review</th>
                            <th>User</th>
                            <th>Rating</th>
                            <th>Date</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Map<String, Object> review : reviews) { %>
                            <tr>
                                <td>
                                    <div class="review-product">
                                        <img src="<%= request.getContextPath() %>/images/<%= review.get("watchImage") %>" 
                                             alt="<%= review.get("watchName") %>" 
                                             class="product-image"
                                             onerror="this.src='<%= request.getContextPath() %>/images/placeholder.jpg'">
                                        <span><%= review.get("watchName") %></span>
                                    </div>
                                </td>
                                <td>
                                    <div class="stars">
                                        <% for (int i = 1; i <= 5; i++) { %>
                                            <% if (i <= (Integer)review.get("rating")) { %>
                                                <i class="fas fa-star"></i>
                                            <% } else { %>
                                                <i class="far fa-star"></i>
                                            <% } %>
                                        <% } %>
                                    </div>
                                    <div class="review-text">
                                        <%= review.get("reviewText") %>
                                    </div>
                                </td>
                                <td>
                                    <div class="user-info">
                                        <div class="user-name"><%= review.get("userName") %></div>
                                        <div class="user-email"><%= review.get("userEmail") %></div>
                                    </div>
                                </td>
                                <td><%= review.get("rating") %> ★</td>
                                <td><%= dateFormat.format(review.get("createdAt")) %></td>
                                <td>
                                    <span class="status-badge status-<%= review.get("status") %>">
                                        <%= review.get("status") %>
                                    </span>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <% if (!"approved".equals(review.get("status"))) { %>
                                            <a href="reviews?action=approve&id=<%= review.get("id") %>" 
                                               class="action-btn approve-btn"
                                               onclick="return confirm('Approve this review?')">
                                                <i class="fas fa-check"></i> Approve
                                            </a>
                                        <% } %>
                                        <% if (!"rejected".equals(review.get("status"))) { %>
                                            <a href="reviews?action=reject&id=<%= review.get("id") %>" 
                                               class="action-btn reject-btn"
                                               onclick="return confirm('Reject this review?')">
                                                <i class="fas fa-times"></i> Reject
                                            </a>
                                        <% } %>
                                        <a href="reviews?action=delete&id=<%= review.get("id") %>" 
                                           class="action-btn delete-btn"
                                           onclick="return confirm('Are you sure you want to delete this review? This action cannot be undone.')">
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
                    <i class="fas fa-star"></i>
                    <h3>No Reviews Found</h3>
                    <p>There are no reviews matching your criteria.</p>
                </div>
            <% } %>
        </div>
    </div>
    
    <script>
        function filterByStatus(status) {
            window.location.href = 'reviews?status=' + status;
        }
    </script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%
    List<Map<String, Object>> users = (List<Map<String, Object>>) request.getAttribute("users");
    Integer totalUsers = (Integer) request.getAttribute("totalUsers");
    Integer activeUsers = (Integer) request.getAttribute("activeUsers");
    Integer newUsersThisMonth = (Integer) request.getAttribute("newUsersThisMonth");
    String search = (String) request.getAttribute("search");
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Users - TimeZone Admin</title>
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
            transition: all 0.3s;
        }
        
        .stat-card:hover {
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
        
        /* Search Section */
        .search-section {
            background: #222;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
        }
        
        .search-form {
            display: flex;
            gap: 15px;
        }
        
        .search-input {
            flex: 1;
            padding: 12px 15px;
            background: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 8px;
            color: #fff;
            font-size: 14px;
        }
        
        .search-input:focus {
            outline: none;
            border-color: #c9a959;
        }
        
        .search-btn {
            padding: 12px 25px;
            background: #c9a959;
            color: #000;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .search-btn:hover {
            background: #d4b468;
        }
        
        .reset-btn {
            padding: 12px 25px;
            background: transparent;
            color: #fff;
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 8px;
            text-decoration: none;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
        }
        
        .reset-btn:hover {
            border-color: #c9a959;
            color: #c9a959;
        }
        
        /* Users Table */
        .users-table {
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
        }
        
        tr:hover {
            background: rgba(255,255,255,0.05);
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            background: #c9a959;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #000;
            font-weight: 600;
            font-size: 16px;
        }
        
        .order-count {
            background: rgba(201,169,89,0.2);
            color: #c9a959;
            padding: 4px 8px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .view-btn {
            display: inline-block;
            padding: 6px 15px;
            background: rgba(201,169,89,0.1);
            color: #c9a959;
            border: 1px solid rgba(201,169,89,0.3);
            border-radius: 5px;
            text-decoration: none;
            font-size: 13px;
            transition: all 0.3s;
        }
        
        .view-btn:hover {
            background: #c9a959;
            color: #000;
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
            <li><a href="users" class="active"><i class="fas fa-users"></i> Users</a></li>
            <li><a href="reviews"><i class="fas fa-star"></i> Reviews</a></li>
            <li><a href="reports"><i class="fas fa-chart-bar"></i> Reports</a></li>
            <li style="margin-top: 30px;"><a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>
    
    <!-- Main Content -->
    <div class="main-content">
        <div class="header">
            <h1>Manage Users</h1>
        </div>
        
        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-label">Total Users</div>
                <div class="stat-value"><%= totalUsers != null ? totalUsers : 0 %></div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Active Users</div>
                <div class="stat-value"><%= activeUsers != null ? activeUsers : 0 %></div>
            </div>
            <div class="stat-card">
                <div class="stat-label">New This Month</div>
                <div class="stat-value"><%= newUsersThisMonth != null ? newUsersThisMonth : 0 %></div>
            </div>
        </div>
        
        <!-- Search Section -->
        <div class="search-section">
            <form class="search-form" action="users" method="get">
                <input type="text" name="search" class="search-input" 
                       placeholder="Search by name or email..." 
                       value="<%= search != null ? search : "" %>">
                <button type="submit" class="search-btn">
                    <i class="fas fa-search me-2"></i> Search
                </button>
                <% if (search != null && !search.isEmpty()) { %>
                    <a href="users" class="reset-btn">
                        <i class="fas fa-times me-2"></i> Clear
                    </a>
                <% } %>
            </form>
        </div>
        
        <!-- Users Table -->
        <div class="users-table">
            <% if (users != null && !users.isEmpty()) { %>
                <table>
                    <thead>
                        <tr>
                            <th></th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Joined</th>
                            <th>Orders</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Map<String, Object> user : users) { %>
                            <tr>
                                <td>
                                    <div class="user-avatar">
                                        <%= ((String)user.get("name")).charAt(0) %>
                                    </div>
                                </td>
                                <td><%= user.get("name") %></td>
                                <td><%= user.get("email") %></td>
                                <td><%= user.get("phone") != null ? user.get("phone") : "N/A" %></td>
                                <td><%= dateFormat.format(user.get("createdAt")) %></td>
                                <td>
                                    <span class="order-count"><%= user.get("orderCount") %> orders</span>
                                </td>
                                <td>
                                    <a href="users?action=view&id=<%= user.get("id") %>" class="view-btn">
                                        <i class="fas fa-eye me-1"></i> View
                                    </a>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <div class="empty-state">
                    <i class="fas fa-users"></i>
                    <h3>No Users Found</h3>
                    <p><%= search != null ? "No users match your search." : "No users have registered yet." %></p>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>
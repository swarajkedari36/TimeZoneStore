<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%
    String period = (String) request.getAttribute("period");
    Map<String, Object> salesData = (Map<String, Object>) request.getAttribute("salesData");
    List<Map<String, Object>> topProducts = (List<Map<String, Object>>) request.getAttribute("topProducts");
    List<Map<String, Object>> salesByCategory = (List<Map<String, Object>>) request.getAttribute("salesByCategory");
    List<Map<String, Object>> orderStatusDistribution = (List<Map<String, Object>>) request.getAttribute("orderStatusDistribution");
    Map<String, Object> summaryStats = (Map<String, Object>) request.getAttribute("summaryStats");
    
    SimpleDateFormat currencyFormat = new SimpleDateFormat("#,##0");
    
    // Build chart data as strings manually
    StringBuilder salesLabels = new StringBuilder("[");
    StringBuilder salesRevenue = new StringBuilder("[");
    StringBuilder salesOrders = new StringBuilder("[");
    
    if (salesData != null) {
        List<String> labels = (List<String>) salesData.get("labels");
        List<Double> revenueData = (List<Double>) salesData.get("salesData");
        List<Integer> orderData = (List<Integer>) salesData.get("orderCounts");
        
        if (labels != null) {
            for (int i = 0; i < labels.size(); i++) {
                if (i > 0) {
                    salesLabels.append(",");
                    salesRevenue.append(",");
                    salesOrders.append(",");
                }
                salesLabels.append("'").append(labels.get(i)).append("'");
                salesRevenue.append(revenueData.get(i));
                salesOrders.append(orderData.get(i));
            }
        }
    }
    salesLabels.append("]");
    salesRevenue.append("]");
    salesOrders.append("]");
    
    // Category chart data
    StringBuilder categoryLabels = new StringBuilder("[");
    StringBuilder categoryData = new StringBuilder("[");
    if (salesByCategory != null) {
        for (int i = 0; i < salesByCategory.size(); i++) {
            if (i > 0) {
                categoryLabels.append(",");
                categoryData.append(",");
            }
            categoryLabels.append("'").append(salesByCategory.get(i).get("name")).append("'");
            categoryData.append(salesByCategory.get(i).get("totalRevenue"));
        }
    }
    categoryLabels.append("]");
    categoryData.append("]");
    
    // Status chart data
    StringBuilder statusLabels = new StringBuilder("[");
    StringBuilder statusData = new StringBuilder("[");
    if (orderStatusDistribution != null) {
        for (int i = 0; i < orderStatusDistribution.size(); i++) {
            if (i > 0) {
                statusLabels.append(",");
                statusData.append(",");
            }
            statusLabels.append("'").append(orderStatusDistribution.get(i).get("status")).append("'");
            statusData.append(orderStatusDistribution.get(i).get("count"));
        }
    }
    statusLabels.append("]");
    statusData.append("]");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Sales Reports - TimeZone Admin</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    
    <style>
        /* Keep your existing styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            background: #1a1a1a;
            font-family: 'Inter', sans-serif;
        }
        
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
        
        .main-content {
            margin-left: 260px;
            padding: 30px;
        }
        
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
        
        .period-selector {
            display: flex;
            gap: 10px;
        }
        
        .period-btn {
            padding: 8px 20px;
            background: transparent;
            color: #fff;
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 50px;
            text-decoration: none;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .period-btn:hover, .period-btn.active {
            background: #c9a959;
            color: #000;
            border-color: #c9a959;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
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
        
        .stat-sub {
            color: #c9a959;
            font-size: 14px;
            margin-top: 5px;
        }
        
        .chart-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .chart-card {
            background: #222;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            padding: 20px;
        }
        
        .chart-title {
            color: #c9a959;
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 20px;
        }
        
        .chart-container {
            height: 300px;
            position: relative;
        }
        
        .products-table {
            background: #222;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
            overflow-x: auto;
        }
        
        .section-title {
            color: #c9a959;
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 20px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        th {
            text-align: left;
            padding: 12px;
            color: #c9a959;
            font-weight: 600;
            border-bottom: 2px solid #3a3a3a;
            background: #1e1e1e;
        }
        
        td {
            padding: 12px;
            color: #fff;
            border-bottom: 1px solid #3a3a3a;
        }
        
        .product-image {
            width: 40px;
            height: 40px;
            object-fit: cover;
            border-radius: 5px;
            border: 1px solid #c9a959;
        }
        
        .rank-1 { color: #c9a959; font-weight: 600; }
        .rank-2 { color: #c0c0c0; font-weight: 600; }
        .rank-3 { color: #cd7f32; font-weight: 600; }
        
        .category-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }
        
        .category-item {
            background: rgba(255,255,255,0.05);
            border-radius: 10px;
            padding: 15px;
            text-align: center;
        }
        
        .category-name {
            color: #c9a959;
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        .category-revenue {
            color: #fff;
            font-size: 18px;
            font-weight: 600;
        }
        
        .category-sold {
            color: rgba(255,255,255,0.5);
            font-size: 12px;
        }
    </style>
</head>
<body>
    <!-- Sidebar (same as before) -->
    <div class="sidebar">
        <a href="dashboard" class="sidebar-brand">
            Time<span>Zone</span> Admin
        </a>
        <ul class="sidebar-menu">
            <li><a href="dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
            <li><a href="products"><i class="fas fa-clock"></i> Products</a></li>
            <li><a href="orders"><i class="fas fa-shopping-bag"></i> Orders</a></li>
            <li><a href="users"><i class="fas fa-users"></i> Users</a></li>
            <li><a href="reviews"><i class="fas fa-star"></i> Reviews</a></li>
            <li><a href="reports" class="active"><i class="fas fa-chart-bar"></i> Reports</a></li>
            <li style="margin-top: 30px;"><a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>
    
    <!-- Main Content -->
    <div class="main-content">
        <div class="header">
            <h1>Sales Reports & Analytics</h1>
            <div class="period-selector">
                <a href="reports?period=week" class="period-btn <%= "week".equals(period) ? "active" : "" %>">Week</a>
                <a href="reports?period=month" class="period-btn <%= "month".equals(period) || period == null ? "active" : "" %>">Month</a>
                <a href="reports?period=year" class="period-btn <%= "year".equals(period) ? "active" : "" %>">Year</a>
                <a href="reports?period=all" class="period-btn <%= "all".equals(period) ? "active" : "" %>">All Time</a>
            </div>
        </div>
        
        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-label">Total Revenue</div>
                <div class="stat-value">₹ <%= summaryStats != null && summaryStats.get("totalRevenue") != null ? 
                    String.format("%,d", (int)((Double)summaryStats.get("totalRevenue")).doubleValue()) : 0 %></div>
                <div class="stat-sub">All time sales</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Total Orders</div>
                <div class="stat-value"><%= summaryStats != null && summaryStats.get("totalOrders") != null ? 
                    summaryStats.get("totalOrders") : 0 %></div>
                <div class="stat-sub">Completed orders</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Average Order Value</div>
                <div class="stat-value">₹ <%= summaryStats != null && summaryStats.get("averageOrderValue") != null ? 
                    String.format("%,d", (int)((Double)summaryStats.get("averageOrderValue")).doubleValue()) : 0 %></div>
                <div class="stat-sub">Per order</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Today's Revenue</div>
                <div class="stat-value">₹ <%= summaryStats != null && summaryStats.get("todayRevenue") != null ? 
                    String.format("%,d", (int)((Double)summaryStats.get("todayRevenue")).doubleValue()) : 0 %></div>
                <div class="stat-sub"><%= summaryStats != null && summaryStats.get("monthRevenue") != null ? 
                    "Monthly: ₹ " + String.format("%,d", (int)((Double)summaryStats.get("monthRevenue")).doubleValue()) : "" %></div>
            </div>
        </div>
        
        <!-- Sales Chart -->
        <div class="chart-card">
            <div class="chart-title">Sales Overview</div>
            <div class="chart-container">
                <canvas id="salesChart"></canvas>
            </div>
        </div>
        
        <!-- Charts Row -->
        <div class="chart-row">
            <div class="chart-card">
                <div class="chart-title">Sales by Category</div>
                <div class="chart-container">
                    <canvas id="categoryChart"></canvas>
                </div>
            </div>
            <div class="chart-card">
                <div class="chart-title">Order Status Distribution</div>
                <div class="chart-container">
                    <canvas id="statusChart"></canvas>
                </div>
            </div>
        </div>
        
        <!-- Top Selling Products -->
        <div class="products-table">
            <div class="section-title">Top Selling Products</div>
            <table>
                <thead>
                    <tr>
                        <th>Rank</th>
                        <th>Product</th>
                        <th>Units Sold</th>
                        <th>Revenue</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (topProducts != null && !topProducts.isEmpty()) { 
                        int rank = 1;
                        for (Map<String, Object> product : topProducts) { %>
                            <tr>
                                <td><span class="rank-<%= rank <= 3 ? String.valueOf(rank) : "normal" %>">#<%= rank %></span></td>
                                <td>
                                    <div style="display: flex; align-items: center; gap: 10px;">
                                        <img src="<%= request.getContextPath() %>/images/<%= product.get("image") %>" 
                                             alt="<%= product.get("name") %>" 
                                             class="product-image"
                                             onerror="this.src='<%= request.getContextPath() %>/images/placeholder.jpg'">
                                        <span><%= product.get("name") %></span>
                                    </div>
                                </td>
                                <td><%= product.get("totalSold") %></td>
                                <td>₹ <%= String.format("%,d", (int)((Double)product.get("totalRevenue")).doubleValue()) %></td>
                            </tr>
                    <%      rank++;
                        } 
                    } else { %>
                        <tr><td colspan="4" style="text-align: center; padding: 30px; color: rgba(255,255,255,0.5);">No sales data available</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    
    <script>
        // Sales Chart - using manually built strings
        new Chart(document.getElementById('salesChart'), {
            type: 'line',
            data: {
                labels: <%= salesLabels.toString() %>,
                datasets: [{
                    label: 'Revenue (₹)',
                    data: <%= salesRevenue.toString() %>,
                    borderColor: '#c9a959',
                    backgroundColor: 'rgba(201, 169, 89, 0.1)',
                    tension: 0.4,
                    fill: true
                }, {
                    label: 'Orders',
                    data: <%= salesOrders.toString() %>,
                    borderColor: '#28a745',
                    backgroundColor: 'rgba(40, 167, 69, 0.1)',
                    tension: 0.4,
                    fill: true,
                    yAxisID: 'y1'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { labels: { color: '#fff' } } },
                scales: {
                    x: { ticks: { color: '#fff' }, grid: { color: 'rgba(255,255,255,0.1)' } },
                    y: { ticks: { color: '#c9a959' }, grid: { color: 'rgba(255,255,255,0.1)' } },
                    y1: { ticks: { color: '#28a745' }, grid: { drawOnChartArea: false } }
                }
            }
        });
        
        // Category Chart
        new Chart(document.getElementById('categoryChart'), {
            type: 'doughnut',
            data: {
                labels: <%= categoryLabels.toString() %>,
                datasets: [{
                    data: <%= categoryData.toString() %>,
                    backgroundColor: ['#c9a959', '#28a745', '#007bff', '#dc3545', '#ffc107', '#17a2b8']
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { labels: { color: '#fff' } } }
            }
        });
        
        // Status Chart
        new Chart(document.getElementById('statusChart'), {
            type: 'bar',
            data: {
                labels: <%= statusLabels.toString() %>,
                datasets: [{
                    label: 'Number of Orders',
                    data: <%= statusData.toString() %>,
                    backgroundColor: '#c9a959'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { labels: { color: '#fff' } } },
                scales: {
                    x: { ticks: { color: '#fff' }, grid: { color: 'rgba(255,255,255,0.1)' } },
                    y: { ticks: { color: '#fff' }, grid: { color: 'rgba(255,255,255,0.1)' } }
                }
            }
        });
    </script>
</body>
</html>
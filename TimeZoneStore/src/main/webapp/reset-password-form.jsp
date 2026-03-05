<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String token = request.getParameter("token");
    if (token == null || token.isEmpty()) {
        response.sendRedirect("forgot-password.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Reset Password - TimeZone</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        body {
            background: url('images/bg.jpg') no-repeat center center fixed;
            background-size: cover;
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
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
        
        .reset-container {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 450px;
            padding: 20px;
        }
        
        .glass-card {
            background: rgba(20, 20, 20, 0.6);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 30px;
            padding: 40px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
        }
        
        .brand {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .brand h2 {
            color: #fff;
            font-size: 32px;
            font-weight: 600;
        }
        
        .brand h2 span {
            color: #c9a959;
        }
        
        .form-title {
            color: #fff;
            font-size: 24px;
            font-weight: 500;
            margin-bottom: 10px;
            text-align: center;
        }
        
        .form-subtitle {
            color: rgba(255,255,255,0.6);
            font-size: 14px;
            text-align: center;
            margin-bottom: 30px;
        }
        
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
        }
        
        .form-control {
            background: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 12px;
            padding: 14px 20px;
            color: #fff;
            width: 100%;
            margin-bottom: 20px;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #c9a959;
            background: rgba(255,255,255,0.15);
        }
        
        .reset-btn {
            width: 100%;
            padding: 14px;
            background: #c9a959;
            color: #000;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
        }
        
        .reset-btn:hover {
            background: #d4b468;
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(201, 169, 89, 0.3);
        }
        
        .alert {
            padding: 15px;
            border-radius: 12px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .alert-danger {
            background: rgba(220, 53, 69, 0.15);
            border: 1px solid rgba(220, 53, 69, 0.3);
            color: #ff6b6b;
        }
    </style>
</head>
<body>
    <div class="reset-container">
        <div class="glass-card">
            <div class="brand">
                <h2>Time<span>Zone</span></h2>
            </div>
            
            <div class="form-title">Create New Password</div>
            <div class="form-subtitle">Enter your new password below</div>
            
            <% if ("mismatch".equals(request.getParameter("error"))) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    Passwords do not match.
                </div>
            <% } %>
            
            <form action="reset-password" method="post">
                <input type="hidden" name="action" value="reset">
                <input type="hidden" name="token" value="<%= token %>">
                
                <div>
                    <label class="form-label">
                        <i class="fas fa-lock"></i> New Password
                    </label>
                    <input type="password" name="newPassword" class="form-control" 
                           placeholder="Enter new password" required>
                </div>
                
                <div>
                    <label class="form-label">
                        <i class="fas fa-lock"></i> Confirm Password
                    </label>
                    <input type="password" name="confirmPassword" class="form-control" 
                           placeholder="Confirm new password" required>
                </div>
                
                <button type="submit" class="reset-btn">
                    <i class="fas fa-key me-2"></i>Reset Password
                </button>
            </form>
        </div>
    </div>
</body>
</html>
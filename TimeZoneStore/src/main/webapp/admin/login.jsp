<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Login - TimeZone</title>
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
            background: linear-gradient(135deg, #1a1a1a 0%, #2a2a2a 100%);
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .login-container {
            width: 100%;
            max-width: 400px;
            padding: 20px;
        }
        
        .login-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
        }
        
        .brand {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .brand h2 {
            color: #fff;
            font-size: 28px;
            font-weight: 600;
        }
        
        .brand h2 span {
            color: #c9a959;
        }
        
        .brand p {
            color: rgba(255,255,255,0.5);
            font-size: 14px;
            margin-top: 5px;
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
            padding: 12px 15px;
            color: #fff;
            width: 100%;
            margin-bottom: 20px;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #c9a959;
            background: rgba(255,255,255,0.15);
        }
        
        .login-btn {
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
        
        .login-btn:hover {
            background: #d4b468;
            transform: translateY(-2px);
        }
        
        .error-message {
            background: rgba(220, 53, 69, 0.15);
            border: 1px solid rgba(220, 53, 69, 0.3);
            border-radius: 10px;
            padding: 12px 15px;
            margin-bottom: 20px;
            color: #ff6b6b;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .back-link {
            text-align: center;
            margin-top: 20px;
        }
        
        .back-link a {
            color: rgba(255,255,255,0.5);
            text-decoration: none;
            font-size: 14px;
            transition: color 0.3s;
        }
        
        .back-link a:hover {
            color: #c9a959;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-card">
            <div class="brand">
                <h2>Time<span>Zone</span></h2>
                <p>Admin Dashboard</p>
            </div>
            
            <% if ("invalid".equals(request.getParameter("error"))) { %>
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i>
                    Invalid username or password
                </div>
            <% } else if ("missing".equals(request.getParameter("error"))) { %>
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i>
                    Please enter username and password
                </div>
            <% } else if ("true".equals(request.getParameter("error"))) { %>
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i>
                    An error occurred. Please try again.
                </div>
            <% } %>
            
            <form action="login" method="post">
                <div>
                    <label class="form-label">
                        <i class="fas fa-user"></i> Username
                    </label>
                    <input type="text" name="username" class="form-control" required>
                </div>
                
                <div>
                    <label class="form-label">
                        <i class="fas fa-lock"></i> Password
                    </label>
                    <input type="password" name="password" class="form-control" required>
                </div>
                
                <button type="submit" class="login-btn">
                    <i class="fas fa-sign-in-alt me-2"></i>Login to Dashboard
                </button>
            </form>
            
            <div class="back-link">
                <a href="<%=request.getContextPath()%>/products">
                    <i class="fas fa-arrow-left me-1"></i> Back to Store
                </a>
            </div>
        </div>
    </div>
</body>
</html>
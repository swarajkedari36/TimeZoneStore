<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Forgot Password - TimeZone</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: #1a1a1a; font-family: 'Inter', sans-serif; display: flex; align-items: center; justify-content: center; height: 100vh; }
        .reset-card { background: #222; border-radius: 15px; padding: 40px; max-width: 400px; width: 90%; border: 1px solid #3a3a3a; }
        h2 { color: #c9a959; margin-bottom: 20px; }
        .form-control { background: #333; border: 1px solid #3a3a3a; color: #fff; padding: 12px; }
        .form-control:focus { border-color: #c9a959; outline: none; }
        .btn-reset { background: #c9a959; color: #000; border: none; padding: 12px; width: 100%; border-radius: 8px; font-weight: 600; }
        .btn-reset:hover { background: #d4b468; }
        .alert { padding: 12px; border-radius: 8px; margin-bottom: 20px; }
        .alert-success { background: rgba(40,167,69,0.2); color: #28a745; border: 1px solid rgba(40,167,69,0.3); }
        .alert-danger { background: rgba(220,53,69,0.2); color: #dc3545; border: 1px solid rgba(220,53,69,0.3); }
    </style>
</head>
<body>
    <div class="reset-card">
        <h2 class="text-center">Forgot Password?</h2>
        <p style="color: #aaa; text-align: center; margin-bottom: 30px;">Enter your email and we'll send you a reset link</p>
        
        <% if ("true".equals(request.getParameter("sent"))) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle me-2"></i>Reset link sent! Check your email.
            </div>
        <% } %>
        
        <% if ("notfound".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle me-2"></i>Email not found.
            </div>
        <% } %>
        
        <form action="reset-password" method="post">
            <input type="hidden" name="action" value="request">
            <div class="mb-3">
                <input type="email" name="email" class="form-control" placeholder="Enter your email" required>
            </div>
            <button type="submit" class="btn-reset">Send Reset Link</button>
        </form>
        
        <p class="text-center mt-3">
            <a href="login.html" style="color: #c9a959; text-decoration: none;">Back to Login</a>
        </p>
    </div>
</body>
</html>